#!/usr/bin/env python3
"""Check vault files for broken Obsidian wikilinks.

Args: paths of files to check (absolute or vault-relative).
Output: one line per broken link, format `<rel-path>:<line>: [[target]]`.
Exit 0 if all clean, 1 if any broken.
"""
import sys
import re
from pathlib import Path

VAULT = Path.home() / "Notes"
WIKI_RE = re.compile(r'\[\[([^\]|#^]+)(?:#[^\]|]*)?(?:\|[^\]]*)?\]\]')

# Files where wikilinks are illustrative syntax, not real links
SKIP_FILES = {
    VAULT / "CLAUDE.md",
    VAULT / "Claude" / "Digests" / "obsidian-claude-setup-prompt.md",
}
SKIP_DIRS = (
    VAULT / "Archive",
    VAULT / ".obsidian",
    VAULT / ".git",
)


def build_index():
    paths, basenames = set(), set()
    for p in VAULT.rglob('*.md'):
        if any(part in ('.obsidian', '.git') for part in p.parts):
            continue
        rel = p.relative_to(VAULT).with_suffix('')
        paths.add(str(rel))
        basenames.add(rel.name)
    return paths, basenames


def check(path, paths, basenames):
    broken = []
    try:
        with open(path, encoding='utf-8') as f:
            for lineno, line in enumerate(f, 1):
                for m in WIKI_RE.finditer(line):
                    target = m.group(1).strip().removesuffix('.md')
                    if not target:
                        continue
                    if target in paths:
                        continue
                    if '/' not in target and target in basenames:
                        continue
                    broken.append((lineno, target))
    except (OSError, UnicodeDecodeError):
        pass
    return broken


def should_skip(p):
    if p in SKIP_FILES:
        return True
    return any(p == d or d in p.parents for d in SKIP_DIRS)


def main():
    if len(sys.argv) < 2:
        return 0
    paths_idx, basenames_idx = build_index()
    any_broken = False
    for arg in sys.argv[1:]:
        p = Path(arg)
        if not p.is_absolute():
            p = (VAULT / p).resolve()
        if not p.exists() or p.suffix != '.md' or should_skip(p):
            continue
        broken = check(p, paths_idx, basenames_idx)
        if broken:
            any_broken = True
            try:
                rel = p.relative_to(VAULT)
            except ValueError:
                rel = p
            for lineno, target in broken:
                print(f"{rel}:{lineno}: [[{target}]]")
    return 1 if any_broken else 0


if __name__ == "__main__":
    sys.exit(main())
