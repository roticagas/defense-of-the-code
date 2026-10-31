#!/usr/bin/env python3
"""
Preflight scanner for ORACLE & EARTHSHAKER:
1. Detects function/method names exceeding the 3-Word Naming Rule.
2. Detects Bedrock Utility files importing from business/service/db layers (Fan-Out > 0).
"""
import re
import subprocess
import sys
from pathlib import Path

# Matches common function/method declarations across Python, TS/JS, Go, Java/C#/Dart/C:
# Group 1 or Group 2 captures the function identifier.
FUNC_PATTERN = re.compile(
    r"^\s*(?:"
    r"(?:export\s+)?(?:async\s+)?(?:def|function|func)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\("
    r"|"
    r"(?:(?:public|private|protected|internal|static|final|override|virtual|synchronized|async)\s+)+"
    r"(?:[a-zA-Z_][a-zA-Z0-9_<>,.\[\]?]*\s+)?([a-zA-Z_][a-zA-Z0-9_]*)\s*\("
    r")"
)

IGNORED_KEYWORDS = {
    "if", "for", "while", "switch", "catch", "return", "super", "this", "new",
    "sizeof", "typeof", "delete", "await", "yield",
}
IGNORED_PREFIXES = {"get", "set", "is", "has", "can", "should", "on", "to", "from"}

FORBIDDEN_UTIL_IMPORTS = re.compile(
    r"^\s*(?:import|from|require\b|#include).*(?:service|controller|repository|dao|model|store|bloc|view|handler|usecase)",
    re.IGNORECASE,
)


def split_words(identifier: str) -> list[str]:
    cleaned = identifier.strip("_")
    if not cleaned:
        return []
    if "_" in cleaned:
        words = [w for w in cleaned.split("_") if w]
    else:
        words = re.findall(r"[A-Z]?[a-z]+|[A-Z]+(?=[A-Z]|$)|[0-9]+", cleaned)
    return words


def get_changed_files() -> list[Path]:
    try:
        out = subprocess.check_output(
            ["git", "diff", "--name-only", "HEAD"], text=True, stderr=subprocess.DEVNULL
        ).splitlines()
        if not out:
            out = subprocess.check_output(
                ["git", "diff", "--name-only", "--cached"], text=True, stderr=subprocess.DEVNULL
            ).splitlines()
        return [Path(p) for p in out if Path(p).is_file()]
    except Exception:
        return []


def scan_file(path: Path) -> None:
    try:
        lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    except Exception:
        return

    is_util = any(
        part.lower() in {"util", "utils", "utility", "utilities", "common", "helper", "helpers"}
        for part in path.parts
    )

    for idx, line in enumerate(lines, start=1):
        # 1. Check Bedrock Utility Fan-Out Violation (Law 3)
        if is_util and FORBIDDEN_UTIL_IMPORTS.search(line):
            print(
                f"[LAW-3 VIOLATION] {path}:{idx} -> Utility file imports business/state layer: {line.strip()}"
            )

        # 2. Check 3-Word Naming Rule (Law 5)
        match = FUNC_PATTERN.search(line)
        if match:
            func_name = match.group(1) or match.group(2)
            if not func_name or func_name in IGNORED_KEYWORDS:
                continue
            # Skip Python dunder methods like __init__, __str__
            if func_name.startswith("__") and func_name.endswith("__"):
                continue

            words = split_words(func_name)
            # Strip a single standard idiomatic prefix (get_, is_, on_, etc.) when counting core words
            core_words = (
                words[1:]
                if len(words) > 1 and words[0].lower() in IGNORED_PREFIXES
                else words
            )

            if len(core_words) > 3:
                print(
                    f"[LAW-5 WARNING] {path}:{idx} -> '{func_name}' has {len(core_words)} core words "
                    f"({'/'.join(core_words)}) > max 3 words."
                )


if __name__ == "__main__":
    targets = [Path(arg) for arg in sys.argv[1:]] if len(sys.argv) > 1 else get_changed_files()
    if not targets:
        print("No target files detected via git diff or CLI args.")
        sys.exit(0)

    print(f"=== Preflight Scan on {len(targets)} file(s) ===")
    for target in targets:
        scan_file(target)
