# Global Claude Code Preferences

## Persistent Memory — Behavioral Contract
I maintain a knowledge vault at ~/Notes/ that serves as persistent memory across all Claude sessions. The vault is always writable regardless of your CWD — use absolute paths.

### Session Start (MANDATORY)
1. Read ~/Notes/Claude/_WorkContext.md for current priorities, blockers, and context
2. Read ~/Notes/Planning/today.md for today's plan
3. If the `updated` timestamp in _WorkContext.md is >3 days old, it may be stale — check Slack, Calendar, and recent git logs to refresh before proceeding

### During Session — Vault Update Triggers
You MUST update ~/Notes/Claude/_WorkContext.md when ANY of these happen during the session. Do it inline as you work, not deferred to session end:

| Trigger | What to update |
|---------|---------------|
| Task completed or meaningfully progressed | "Active Focus" — update the item's state and next step |
| Blocker resolved | "Blockers" — strikethrough the resolved blocker |
| New blocker discovered | "Blockers" — add it |
| Decision made (design, architectural, process) | "Recent Decisions" — add one-liner with rationale |
| Open question answered | "Open Questions" — strikethrough it |
| New system/architecture knowledge learned | ~/Notes/Work/Systems/<service>.md — update or create |
| Project-specific decision or status change | ~/Notes/Work/Projects/<project>/ — update relevant note |

Update rules:
- Surgical edits only — update the relevant section, don't rewrite the whole file
- Always bump the `updated:` field in frontmatter to current datetime
- Keep _WorkContext.md under ~60 lines. Move completed/historical detail to project notes.
- **NEVER leave content only in the conversation.** If you draft a message, review, reply, analysis, or any artifact, write it to a vault note immediately (e.g., `Claude/Digests/` or relevant project folder). Conversations are ephemeral — future sessions cannot access them. References like "draft ready in this session" or "see conversation above" are useless to future sessions and are NOT acceptable.

### Session End (MANDATORY)
When the session is ending:
1. Update "Active Focus" items that changed during this session
2. Set "Next Session Priorities" based on what's most important next
3. Append a session entry to ~/Notes/Claude/SessionLogs/YYYY-MM.md

### Reference Locations
- Domain knowledge: ~/Notes/Work/Systems/<service>.md
- Project context: ~/Notes/Work/Projects/<project>/
- People context: ~/Notes/Work/Context/people.md
- Full vault navigation: ~/Notes/vault_index.md

## Vault Conventions (when writing to ~/Notes/)
- Every note has YAML frontmatter: `id` (kebab-case), `aliases`, `tags` (domain/X, type/X, status/X), `created`, `updated`
- Status tags: `status/active`, `status/blocked`, `status/done`, `status/draft`, `status/archived`, `status/superseded`, `status/under-review`
- Always bump the `updated:` field when modifying a note
- Internal links use `[[wikilinks]]` — link to related notes, not orphan them
- Filenames are kebab-case
- Each folder has a `<topic>_index.md` (MOC) — update it when adding new notes
- System knowledge goes in `Work/Systems/`, project work in `Work/Projects/<name>/`, people info in `Work/Context/people.md`
- When creating a new project folder, create a `<project-name>_index.md` inside it
- Read ~/Notes/CLAUDE.md for the full vault protocol if doing extensive vault work

## Communication Style
- Be concise. Don't narrate actions, don't summarise what you just did.
- Be technically precise and direct
- Don't hedge on things you're confident about
- If I push back, ground your response in actual system architecture, not theoretical concerns
- Prefer structured, decision-oriented output for meeting prep and design work

## Workflow
- MVP-first: simplest correct solution, iterate later
- Don't over-specify — flag open questions but don't block on them
- When reviewing code, focus on correctness and architectural fit over style (linters handle style)
- Code review format: `L<line>: <severity> <problem>. <fix>.` — one finding per line. Severity: 🔴 bug, 🟡 risk, 🔵 nit, ❓ q. No throat-clearing. Full explanation only for security findings and architectural disagreements.
- "Review the changes" means READ THE ACTUAL SOURCE FILES and understand them. It does NOT mean run an automated code review skill or post comments on PRs.
- Never post PR comments, reviews, or any GitHub-visible actions unless explicitly asked.
- **STOP. Git metadata is not code.** `git log`, `git diff --stat`, `git show --stat`, and commit messages tell you about committed history. They tell you NOTHING about uncommitted work, unstaged files, or what actually exists on a branch. You have gotten this wrong multiple times — concluding code "doesn't exist" because you didn't see it in the commit log, when it was sitting right there uncommitted. Before making ANY claim about what a branch contains or doesn't contain: run `git status`, grep for the feature, read the actual files. No exceptions. No shortcuts. If you catch yourself about to say "this branch has no X" based on git log output alone, you are about to be wrong.
- Before claiming something is unaddressed or broken, verify by reading the current file state. Diffs and agent summaries are not substitutes for reading source files.
- Use Code Search MCP to find prior art before implementing new patterns
- Use GDrive MCP for RFC and design doc context

## Code
- Java/Scala stack — follow existing patterns in whatever repo we're in
- Always run tests after making changes
- Format before committing (spotless for Java/Scala, scalafmt for Scala-only)

## Git
- Conventional commits: `<type>(<scope>): <imperative summary>` — scope optional
- Types: feat, fix, refactor, perf, docs, test, chore, build, ci, style, revert
- Subject ≤50 chars (hard cap 72). Imperative mood. No trailing period. No AI attribution.
- Body only when why isn't obvious: breaking changes, security fixes, migrations, linked issues. Why over what — diff says what.
- Don't amend published commits
- Don't force push to shared branches
- **Worktrees in bare repos:** use `git worktree add <path>` or `git worktree add -b <branch> <path>` to create a worktree with a new branch directly — do NOT check out master/main first. `git worktree add <path>` creates a branch named after the path component from HEAD; `-b` lets you name it explicitly. Only use `git worktree add <path> <existing-branch>` when you actually need to check out an existing branch. This applies only to bare repo setups (~/Projects/).

## Project Layout
- Active repos: ~/Projects/ (bare repos with git worktrees)
- Reference repos: ~/References/ (normal checkouts, read-only context)
- Knowledge vault: ~/Notes/ (Obsidian, session memory)

## Dotfiles & Config
All config files live in `~/dots/` (git-tracked dotfiles repo). Files in their expected locations (e.g., `~/.claude/`, `~/.zshrc`) are **symlinks** pointing into `~/dots/`. Always edit the real file in `~/dots/`, never write directly to the symlink target location.

Key Claude Code paths:
- `~/dots/claude/CLAUDE.md` → symlinked at `~/.claude/CLAUDE.md`
- `~/dots/claude/settings.json` → symlinked at `~/.claude/settings.json`
- `~/dots/claude/commands/` → symlinked at `~/.claude/commands/`
  - `today.md` — `/today` skill (daily focus plan)
  - `eod.md` — `/eod` skill (end of day wrap-up)
  - `caveman.md` — `/caveman` skill (toggle terse caveman output)
- `~/dots/claude/hooks/` → symlinked at `~/.claude/hooks/`
  - `caveman-detect.sh` — auto-activates caveman mode when prompt contains "ooga booga"
  - `vault-context.sh` — injects vault note paths when working in ~/Projects/ repos (system docs + project notes discovered by name matching)

If you need to find or modify a config file, check `~/dots/` first.
