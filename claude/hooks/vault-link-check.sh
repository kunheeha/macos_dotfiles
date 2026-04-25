#!/bin/sh
# Stop hook — flag broken Obsidian wikilinks in vault files modified this session.
# Runs the Python checker over .md files git sees as changed (tracked-modified + untracked).

vault="$HOME/Notes"
[ -d "$vault/.git" ] || exit 0

# Collect modified + untracked .md files (vault-relative paths)
files=$({
    git -C "$vault" diff --name-only HEAD 2>/dev/null
    git -C "$vault" ls-files --others --exclude-standard 2>/dev/null
} | grep '\.md$' | sort -u)

[ -z "$files" ] && exit 0

# Run checker. Filenames in this vault are kebab-case (no spaces).
result=$(echo "$files" | xargs python3 "$HOME/.claude/hooks/vault-link-check.py" 2>/dev/null)

[ -z "$result" ] && exit 0

msg=$(printf "Broken wikilinks in vault files modified this session — fix before stopping.\n\n%s\n\nObsidian rules: links resolve by basename or full path from vault root; '../' relative paths don't work; index files are <topic>_index.md so link as [[foo_index]] not [[foo]]; case-sensitive." "$result")

jq -n --arg m "$msg" '{feedback: $m}'
