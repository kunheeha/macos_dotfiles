# Global Claude Code Preferences

## Persistent Memory
I maintain a knowledge vault at ~/Notes/ that serves as persistent memory across all Claude sessions.
- At session start: read ~/Notes/Claude/_WorkContext.md for current priorities, blockers, and context
- At session end: if substantive work occurred, update ~/Notes/Claude/_WorkContext.md and append to ~/Notes/Claude/SessionLogs/YYYY-MM.md
- For domain knowledge: read ~/Notes/Work/Systems/<service>.md
- For project context: read ~/Notes/Work/Projects/<project>/
- For people context: read ~/Notes/Work/Context/people.md
- For full vault navigation: read ~/Notes/_Index.md

## Communication Style
- Be technically precise and direct
- Don't hedge on things you're confident about
- If I push back, ground your response in actual system architecture, not theoretical concerns
- Prefer structured, decision-oriented output for meeting prep and design work

## Workflow
- MVP-first: simplest correct solution, iterate later
- Don't over-specify — flag open questions but don't block on them
- When reviewing code, focus on correctness and architectural fit over style (linters handle style)
- Use Code Search MCP to find prior art before implementing new patterns
- Use GDrive MCP for RFC and design doc context

## Code
- Java/Scala stack — follow existing patterns in whatever repo we're in
- Always run tests after making changes
- Format before committing (spotless for Java/Scala, scalafmt for Scala-only)

## Git
- Conventional commits: feat:, fix:, refactor:, docs:, test:
- Don't amend published commits
- Don't force push to shared branches

## Project Layout
- Active repos: ~/Projects/ (bare repos with git worktrees)
- Reference repos: ~/References/ (normal checkouts, read-only context)
- Knowledge vault: ~/Notes/ (Obsidian, session memory)
