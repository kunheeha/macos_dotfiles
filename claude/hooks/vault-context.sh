#!/bin/sh
# Inject vault context when working in a project repo.
# Runs as UserPromptSubmit hook — reads JSON from stdin.
# Discovers matching vault notes dynamically (no hardcoded project names).

input=$(cat)
cwd=$(pwd)

# Only fire in ~/Projects/
echo "$cwd" | grep -q "$HOME/Projects/" || exit 0

# Extract project name: first dir component after ~/Projects/, strip .git suffix
proj=$(echo "$cwd" | sed "s|$HOME/Projects/||" | cut -d/ -f1 | sed 's/\.git$//')
[ -z "$proj" ] && exit 0

vault_projects="$HOME/Notes/Work/Projects"
vault_systems="$HOME/Notes/Work/Systems"

# Find matching system docs (exact name or name-* prefix)
system_docs=""
if [ -f "$vault_systems/${proj}.md" ]; then
    system_docs="$vault_systems/${proj}.md"
fi
# Also find prefix matches (e.g., padlock-architecture.md for "padlock")
for f in "$vault_systems/${proj}-"*.md; do
    [ -f "$f" ] && system_docs="$system_docs $f"
done

# Find matching project folders (exact name or name-* prefix)
project_dirs=""
for d in "$vault_projects/${proj}" "$vault_projects/${proj}-"*/; do
    [ -d "$d" ] && project_dirs="$project_dirs $d"
done

# Build context message
context=""

if [ -n "$system_docs" ] || [ -n "$project_dirs" ]; then
    # Known project — inject vault pointers
    context="Vault context for '$proj':"

    if [ -n "$system_docs" ]; then
        context="$context System docs:"
        for f in $system_docs; do
            context="$context $f"
        done
        context="$context."
    fi

    if [ -n "$project_dirs" ]; then
        context="$context Project notes:"
        for d in $project_dirs; do
            # Find the index file if it exists
            idx=$(find "$d" -maxdepth 1 -name "*_index.md" 2>/dev/null | head -1)
            if [ -n "$idx" ]; then
                context="$context $idx"
            else
                context="$context $d"
            fi
        done
        context="$context."
    fi
else
    # No vault notes found — could be new project or monorepo sub-project
    if [ -d "$vault_projects" ]; then
        context="No vault notes found matching '$proj'. If this is a new project, consider creating ~/Notes/Work/Projects/$proj/ with a ${proj}_index.md. If working in a monorepo sub-project, check ~/Notes/Claude/_WorkContext.md for the relevant workstream."
    fi
fi

if [ -n "$context" ]; then
    # Escape for JSON
    context=$(echo "$context" | sed 's/"/\\"/g')
    echo "{\"feedback\": \"$context\"}"
fi
