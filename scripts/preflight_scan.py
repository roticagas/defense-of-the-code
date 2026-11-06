#!/usr/bin/env python3
"""
Preflight scanner for ORACLE & EARTHSHAKER:
1. Detects tracked (staged/unstaged) and untracked changed files. Supports --base <ref> for branch/PR diffs,
   and automatically falls back to the latest commit (HEAD~1..HEAD) if the working tree is clean.
2. Optionally dumps a unified diff snapshot (--dump-diff <path>) so read-only subagents can inspect exact changes.
3. Detects Leaf-Node Utility files importing from domain/service/db layers (Law 3: Fan-Out > 0).
4. Flags verbose function/method names on newly added/modified lines as soft hints (Law 5: ~2-3 lexeme guideline),
   automatically skipping unit test files and test_* methods.

Note: --base compares committed history only (<base>...HEAD) plus untracked files;
uncommitted edits to tracked files are not included in that mode.
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

FUNC_PATTERN = re.compile(
    r"^\s*(?:"
    # Keyword declarations: Python def, JS/TS function, Go/Swift func (incl. receivers), Kotlin fun, Rust fn
    r"(?:(?:export|default|pub(?:\([^)]*\))?|async|suspend|override|open|inline|unsafe|const|static"
    r"|private|public|protected|internal)\s+)*"
    r"(?:def|function\*?|func|fun|fn)\s+(?:\([^)]*\)\s*)?(?:<[^>]*>\s*)?(?:[A-Za-z_][\w.]*\.)?"
    r"([a-zA-Z_][a-zA-Z0-9_]*)\s*[<(]"
    r"|"
    # Modifier-prefixed methods: Java, C#, Dart, TS classes
    r"(?:(?:public|private|protected|internal|static|final|override|virtual|synchronized|async|abstract)\s+)+"
    r"(?:[a-zA-Z_][a-zA-Z0-9_<>,.\[\]?]*\s+)?([a-zA-Z_][a-zA-Z0-9_]*)\s*\("
    r"|"
    # Arrow functions: JS/TS
    r"(?:export\s+)?(?:const|let|var)\s+([a-zA-Z_$][\w$]*)\s*=\s*(?:async\s+)?"
    r"(?:\([^)]*\)|[a-zA-Z_$][\w$]*)\s*(?::\s*[^=]+)?=>"
    r"|"
    # Unmodified typed methods: `void` or PascalCase return type (Java package-private, Dart, C#)
    r"(?:void|[A-Z]\w*(?:<[^>]*>)?\??)\s+([a-z_][a-zA-Z0-9_]*)\s*\("
    r")"
)

IGNORED_KEYWORDS = {
    "if", "for", "while", "switch", "catch", "return", "super", "this", "new",
    "sizeof", "typeof", "delete", "await", "yield",
}
IGNORED_PREFIXES = {"get", "set", "is", "has", "can", "should", "on", "to", "from"}

FORBIDDEN_UTIL_IMPORTS = re.compile(
    # Android framework imports (e.g. `android.view.View`) are platform APIs, not domain layers.
    r"^(?!\s*import\s+androidx?\.)"
    r"(?:\s*(?:import|from|#include)\b|.*\brequire\s*\(|.*\bimport\s*\().*"
    r"(?:^|[/._\s\"'])(?:services?|controllers?|repositor(?:y|ies)|daos?|stores?|blocs?|views?|handlers?|usecases?)(?:$|[/._\s\"';])",
    re.IGNORECASE,
)

# Case-sensitive on purpose: `FooTest.java` is a test, `Latest.java` / `Contest.java` are not.
TEST_SUFFIX_RE = re.compile(r"(?:_test\.\w+|_spec\.rb|(?:Test|Tests|Spec)\.(?:java|kt|cs|swift|scala|groovy))$")

HUNK_HEADER_RE = re.compile(r"^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@")


def main() -> None:
    parser = argparse.ArgumentParser(description="Preflight scanner for Defense of the Code")
    parser.add_argument("files", nargs="*", help="Optional target files to scan")
    parser.add_argument("--base", dest="base_ref", help="Compare against a base branch/ref (e.g., main, origin/develop)")
    parser.add_argument("--dump-diff", dest="dump_diff", help="Write unified diff snapshot to this file path")
    args = parser.parse_args()

    diff_ref = "HEAD"
    if args.files:
        targets = [Path(arg) for arg in args.files if Path(arg).is_file()]
        changed_lines: dict[Path, set[int] | None] = {p: None for p in targets}
        mode_label = "explicit CLI files"
    else:
        targets, changed_lines, diff_ref, mode_label = collect_changed_targets(args.base_ref)

    if not targets:
        print("No target files detected via working tree, latest commit (HEAD~1..HEAD), or CLI args.")
        sys.exit(0)

    if args.dump_diff:
        dump_unified_diff(Path(args.dump_diff), targets, changed_lines, diff_ref)

    total_changed = count_changed_lines(targets, changed_lines)
    print(
        f"=== Preflight Scan on {len(targets)} file(s) [{mode_label} | ~{total_changed} changed line(s)] ==="
    )
    scan_version_hazards(targets)
    for target in targets:
        print(f" * {target} [{format_line_ranges(changed_lines.get(target))}]")
        scan_file(target, changed_lines.get(target))


def collect_changed_targets(base_ref: str | None = None) -> tuple[list[Path], dict[Path, set[int] | None], str, str]:
    if base_ref:
        if not run_git(["merge-base", base_ref, "HEAD"]).strip():
            sys.exit(
                f"Error: no merge base between '{base_ref}' and HEAD. "
                f"Check the ref exists locally (e.g. origin/{base_ref}) and the clone is not shallow."
            )
        diff_ref = f"{base_ref}...HEAD"
        mode_label = f"branch diff ({diff_ref})"
        tracked_out = run_git(["diff", "--name-only", diff_ref])
        untracked_out = run_git(["ls-files", "--others", "--exclude-standard"])
    else:
        tracked_out = run_git(["diff", "--name-only", "HEAD"])
        diff_ref = "HEAD"
        mode_label = "working tree (HEAD)"

        if not tracked_out.strip():
            tracked_out = run_git(["diff", "--name-only", "--cached"])
            if tracked_out.strip():
                diff_ref = "--cached"
                mode_label = "staged (--cached)"

        untracked_out = run_git(["ls-files", "--others", "--exclude-standard"])

        if not tracked_out.strip() and not untracked_out.strip():
            tracked_out = run_git(["diff", "--name-only", "HEAD~1", "HEAD"])
            if tracked_out.strip():
                diff_ref = "HEAD~1..HEAD"
                mode_label = "latest commit (HEAD~1..HEAD)"

    files: list[Path] = []
    seen: set[Path] = set()
    changed_lines: dict[Path, set[int] | None] = {}

    for line in tracked_out.splitlines():
        p = Path(line.strip())
        if p.is_file() and p not in seen:
            seen.add(p)
            files.append(p)
            changed_lines[p] = parse_modified_lines(p, diff_ref)

    for line in untracked_out.splitlines():
        p = Path(line.strip())
        if p.is_file() and p not in seen:
            seen.add(p)
            files.append(p)
            changed_lines[p] = None

    return files, changed_lines, diff_ref, mode_label


def run_git(args: list[str]) -> str:
    try:
        # quotePath=false keeps non-ASCII (e.g. Thai) file names unescaped so Path() can find them.
        return subprocess.check_output(
            ["git", "-c", "core.quotePath=false", *args], text=True, stderr=subprocess.DEVNULL
        )
    except Exception:
        return ""


def parse_modified_lines(path: Path, diff_ref: str) -> set[int] | None:
    diff_out = run_git(["diff", "-U0", diff_ref, "--", str(path)])

    if not diff_out.strip():
        return None

    lines: set[int] = set()
    for raw in diff_out.splitlines():
        m = HUNK_HEADER_RE.match(raw)
        if m:
            start = int(m.group(1))
            count = int(m.group(2)) if m.group(2) is not None else 1
            if count > 0:
                lines.update(range(start, start + count))
    return lines


def dump_unified_diff(
    out_path: Path, files: list[Path], changed_lines: dict[Path, set[int] | None], diff_ref: str
) -> None:
    chunks: list[str] = []
    for p in files:
        if changed_lines.get(p) is not None:
            file_diff = run_git(["diff", diff_ref, "--", str(p)])
            if file_diff.strip():
                chunks.append(file_diff)
        elif p.is_file():
            try:
                content = p.read_text(encoding="utf-8", errors="ignore")
                numbered = "\n".join(
                    f"+{i}: {line}" for i, line in enumerate(content.splitlines(), start=1)
                )
                chunks.append(f"diff --git a/{p} b/{p}\nnew/full file\n--- /dev/null\n+++ b/{p}\n{numbered}\n")
            except Exception:
                pass

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text("\n".join(chunks) if chunks else "No diff detected.\n", encoding="utf-8")
    print(f"Diff snapshot written to: {out_path}")


def count_changed_lines(files: list[Path], changed_lines: dict[Path, set[int] | None]) -> int:
    total = 0
    for p in files:
        lines = changed_lines.get(p)
        if lines is not None:
            total += len(lines)
        elif p.is_file():
            try:
                total += len(p.read_text(encoding="utf-8", errors="ignore").splitlines())
            except Exception:
                pass
    return total


def format_line_ranges(line_nums: set[int] | None) -> str:
    if line_nums is None:
        return "all lines (new/explicit file)"
    if not line_nums:
        return "deletions only"
    sorted_nums = sorted(line_nums)
    ranges: list[str] = []
    start = prev = sorted_nums[0]
    for n in sorted_nums[1:]:
        if n == prev + 1:
            prev = n
        else:
            ranges.append(f"L{start}-L{prev}" if start != prev else f"L{start}")
            start = prev = n
    ranges.append(f"L{start}-L{prev}" if start != prev else f"L{start}")
    return ", ".join(ranges)


def scan_version_hazards(files: list[Path]) -> None:
    legacy_files: list[str] = []
    gate_files: list[str] = []

    for p in files:
        parts_lower = [part.lower() for part in p.parts]
        name_lower = p.name.lower()
        path_str = str(p).lower()

        is_legacy = (
            "legacy" in parts_lower
            or any("legacy" in part for part in parts_lower)
            or "/v1/" in path_str
            or name_lower.startswith("legacy")
        )
        is_gate = (
            any(
                k in parts_lower or any(k in part for part in parts_lower)
                for k in ("security", "auth", "filters", "middleware", "interceptors", "guards")
            )
            or name_lower in ("routes", "application.conf")
            or "jwt" in name_lower
        )

        if is_legacy and len(legacy_files) < 3:
            legacy_files.append(str(p))
        if is_gate and len(gate_files) < 3:
            gate_files.append(str(p))

    if legacy_files and gate_files:
        print(
            "\n[CROSS-VERSION HAZARD SIGNAL] Detected edits touching BOTH legacy/v1 components "
            f"({', '.join(legacy_files)}) AND shared gatekeeper/security components "
            f"({', '.join(gate_files)}).\n"
            " -> MANDATORY INVARIANT: Verify that shared gatekeepers/ActionBuilders do NOT leak modern "
            "error envelopes (e.g. 401/403/500 ApiResponse) into legacy wire contracts. "
            "Assemble BREWMASTER & EARTHSHAKER with priority on Legacy Error Envelope Isolation.\n"
        )


def scan_file(path: Path, active_lines: set[int] | None) -> None:
    try:
        lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    except Exception:
        return

    is_util = any(
        part.lower() in {"util", "utils", "utility", "utilities", "common", "helper", "helpers"}
        for part in path.parts
    )
    skip_naming = is_test_file(path)

    for idx, line in enumerate(lines, start=1):
        if active_lines is not None and idx not in active_lines:
            continue

        if is_util and FORBIDDEN_UTIL_IMPORTS.search(line):
            print(
                f"[LAW-3 VIOLATION] {path}:{idx} -> Utility file imports business/state layer: {line.strip()}"
            )

        if skip_naming:
            continue

        match = FUNC_PATTERN.search(line)
        if match:
            func_name = next((g for g in match.groups() if g), None)
            if not func_name or func_name in IGNORED_KEYWORDS:
                continue
            if func_name.startswith("__") and func_name.endswith("__"):
                continue
            if func_name.lower().startswith("test_"):
                continue

            words = split_words(func_name)
            core_words = (
                words[1:]
                if len(words) > 1 and words[0].lower() in IGNORED_PREFIXES
                else words
            )

            if len(core_words) > 3:
                print(
                    f"[LAW-5 HINT] {path}:{idx} -> '{func_name}' has {len(core_words)} core words "
                    f"({'/'.join(core_words)}). Target is ~2-3 words if it can be shortened without losing domain clarity."
                )


def is_test_file(path: Path) -> bool:
    name_lower = path.name.lower()
    parts_lower = {p.lower() for p in path.parts}
    if parts_lower & {"test", "tests", "__tests__", "spec", "specs"}:
        return True
    return (
        name_lower.startswith("test_")
        or TEST_SUFFIX_RE.search(path.name) is not None
        or ".test." in name_lower
        or ".spec." in name_lower
    )


def split_words(identifier: str) -> list[str]:
    cleaned = identifier.strip("_")
    if not cleaned:
        return []
    if "_" in cleaned:
        return [w for w in cleaned.split("_") if w]
    return re.findall(r"[A-Z]?[a-z]+|[A-Z]+(?=[A-Z]|$)|[0-9]+", cleaned)


if __name__ == "__main__":
    main()
