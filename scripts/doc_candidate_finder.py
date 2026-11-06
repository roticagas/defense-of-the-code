#!/usr/bin/env python3
"""
Doc & Spec finder for RUBICK:
Lists all documentation, API spec, schema, and environment template files in the repository
so RUBICK can pinpoint exact files that need updating after code changes.
"""
import os
from pathlib import Path

DOC_EXTENSIONS = {".md", ".yaml", ".yml", ".json", ".proto", ".graphql", ".sql"}
DOC_KEYWORDS = {
    "readme", "architecture", "openapi", "swagger", "spec", "schema",
    "env", "config", "docker-compose", "migration", "rfc", "doc",
}
IGNORE_DIRS = {
    ".git", "node_modules", "venv", ".venv", "dist", "build", "target",
    ".idea", ".vscode", ".agents", ".agent", "_agents", "_agent", ".claude",
}


def find_candidate_docs(root: Path) -> list[Path]:
    candidates = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in IGNORE_DIRS]
        for fname in filenames:
            fpath = Path(dirpath) / fname
            rel_path = fpath.relative_to(root)
            lower_name = fname.lower()
            # Match keywords on the repo-relative path only: a root like ~/Documents/ must not match "doc".
            if lower_name.startswith(".env") or (
                fpath.suffix.lower() in DOC_EXTENSIONS
                and any(k in str(rel_path).lower() for k in DOC_KEYWORDS)
            ):
                candidates.append(rel_path)
    return sorted(candidates)


if __name__ == "__main__":
    root_dir = Path.cwd()
    docs = find_candidate_docs(root_dir)
    print(f"=== Found {len(docs)} Spec/Doc/Config candidate(s) in repository ===")
    for doc in docs:
        print(f" - {doc}")
