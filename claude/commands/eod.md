# End of Day Wrap-Up

Review today's progress, update persistent notes, and report on goal trajectory. Working hours are 08:00–16:00 (with occasional overrun to 17:00). This wrap-up typically runs around 16:00.

## Step 1: Gather context (read all in parallel)

- `~/Notes/Claude/_WorkContext.md` — current state
- `~/Notes/Planning/today.md` — the daily plan written by `/today` this morning, plus any ad-hoc items added during the day
- `~/Notes/Planning/soon.md` — backlog and buffer items
- The active 12-week plan file (most recent `plan-*.md` in `~/Notes/Planning/12week/`) — check `current-week` frontmatter field for this week's focus and tasks
- `~/Notes/Planning/12week/goals-mar-may.md` — goal categories
- Run `git -C ~/Notes status` and `git -C ~/Notes diff --name-only` to see what's changed (staged + unstaged + untracked) since the last commit
- Run `git -C ~/Notes log --since="today" --oneline` to see any commits made today by other sessions

### Slack activity
Search Slack to reconstruct today's non-code activity:
1. Use `slack_search_public_and_private` to find messages Kunhee sent today (query: `from:me during:today`)
2. Use `slack_search_public_and_private` to find messages mentioning Kunhee or directed at him (query: `@kunheeh during:today`)
3. For threads that look relevant to Active Focus items (project names, key topics), use `slack_read_thread` to get full context
4. Look for:
   - Decisions communicated or finalized via Slack
   - Blockers raised or resolved in conversation
   - Meeting follow-ups or action items shared
   - PR review requests, approvals, or feedback
   - Questions answered that close Open Questions in _WorkContext.md

## Step 1.5: Body comp check

- Read `~/Notes/Personal/Training/body-log-2026.md`
- Check if there is a row for today's date in the log table
- **If no entry for today**: ask the user for their morning weight (kg), optional BF%, whether they trained today, and training type (weights / weights+cardio / cardio / rest). Append a row to the log table and update the `updated:` frontmatter field. Leave nutrition columns (Cal, P, C, F, Deficit) as `—` — these are always collected by the next morning's /bodycomp.
- **If an entry exists**: check whether the "Trained" and "Type" columns need updating (e.g., user said "weights" this morning but ended up resting, or columns are still `—`). If so, ask: "Your /bodycomp entry says [type] — did that hold?" and update as needed. **Do not ask about nutrition** — Cal, P, C, F, and Deficit for today are collected by tomorrow morning's /bodycomp.
- **If entry is complete and accurate**: skip, no action needed. Do not re-display the body comp evaluation — that was already shown by /bodycomp.

## Step 2: Diff planned vs done

Compare today's plan from `today.md` (the "Focus" section written by `/today`) and the 12-week plan for this week against what was actually completed. Use ALL available evidence:
- Git changes to vault notes (checked-off items, updated notes, file changes)
- Git log of today's vault commits from other sessions
- **Slack messages sent/received today** — decisions, follow-ups, PR activity

Categorize each planned item as:
- **Done** — evidence of completion from any source (vault changes, Slack messages confirming completion, etc.)
- **Progressed** — partially done (e.g., PR pushed but not merged, RFC updated but not shared)
- **Not touched** — no visible progress in any source
- **New** — work that happened today but wasn't on the plan (detected from Slack or vault changes not matching planned items)

When Slack reveals work not visible in the vault (e.g., a decision made in a thread, a blocker resolved via DM), flag it explicitly so it can be captured in Step 4.

## Step 3: Ask the user

Present your assessment of what got done and what didn't, then ask specifically about:
- Items marked "Not touched" — did they make progress not visible in the vault? Should they carry forward or drop?
- Any decisions made today that should be recorded
- Any new blockers or context that came up
- Anything they learned that should go into Systems or Project notes
- **Slack threads that seem important** — present a summary of notable Slack activity and ask which should be captured in the vault
- **Decisions or context from Slack not yet in vault** — if a Slack thread contained a decision relevant to Active Focus, flag it for recording

Wait for the user's response before proceeding to updates.

## Step 4: Update notes

After getting user input, make these updates:

### ~/Notes/Claude/_WorkContext.md
- Refresh "Active Focus" with current state of each workstream
- Update "Blockers" — remove resolved ones, add new ones
- Update "Recent Decisions" if any were made today
- Update "Open Questions" — remove answered, add new
- Set "Next Session Priorities" based on what's most important tomorrow — be specific about what's happening in tomorrow's meetings if known (e.g., "pitching X in refinement", not just "prep for refinement")
- Bump the `updated` field in frontmatter

### ~/Notes/Claude/SessionLogs/YYYY-MM.md
Append a session entry:
```
## YYYY-MM-DD HH:MM
**Focus:** What the session was about
**Key actions:** What was done (bullet points)
**Decisions made:** Any decisions with rationale
**Files changed:** List of vault notes created/updated
**Next:** What should happen next
```

### ~/Notes/Planning/soon.md
- Remove items that are now done
- Add any new items that came up during the day
- Move buffer items that got completed

### ~/Notes/Planning/today.md
Reset to the clean scratchpad template for tomorrow:
```markdown
---
id: today
aliases:
  - Today
  - Daily Tasks
tags:
  - status/active
  - type/planning
created: 2026-03-24
updated: <today's date>
---

<!-- This file is managed by /today and /eod skills. -->
<!-- /today writes the daily plan here each morning. -->
<!-- /eod reads it back to diff planned vs done. -->
<!-- Add ad-hoc items during the day as needed. -->
```

### ~/Notes/Work/Projects/ and ~/Notes/Work/Systems/ (if applicable)
- If Slack activity revealed decisions, status changes, or learnings about specific projects or systems, update the relevant notes

### 12-week plan
- Check off any completed items for this week
- If a task was partially done, leave it unchecked but add a note if helpful

## Step 5: Progress scorecard

After all updates are made, present a progress report:

### This week's scorecard
- Show this week's 12-week plan items as a checklist with status (done/in-progress/not-started)
- Calculate % of this week's items completed
- Flag anything at risk of not getting done this week
- Note how many days are left in the week

### Goal trajectory
For each 12-week goal category (from goals-mar-may.md):
- **On track** — work is progressing as planned
- **At risk** — falling behind, needs attention
- **Blocked** — can't progress without something being resolved
- **Ahead** — ahead of schedule

### Recommendations
- What to prioritize tomorrow based on what didn't get done today and what's at risk for the week
- Whether the current week's plan is realistic given remaining days, or if items should be moved to next week
- Any suggested adjustments to the 12-week plan based on how things are going

### Tone
- Honest, not cheerful — if progress is behind, say so clearly
- Actionable — every observation should connect to what to do about it
- Brief — this is a status report, not an essay

## Step 6: Commit the day's changes

After all updates are complete, stage and commit everything in the vault:

```bash
git -C ~/Notes add -A
git -C ~/Notes commit -m "eod: YYYY-MM-DD"
```

This creates a clean snapshot of the vault at end of day, making it easy to see what changed on any given day via `git log` and `git diff` later.

## Weekly rollover (Fridays or when current-week is about to change)

If today is the last working day of the current plan week:
- Suggest bumping `current-week` in the 12-week plan frontmatter to the next week number
- Move any incomplete items that are still relevant to next week's section
- Note items that were planned but never started — these need a decision: move forward, drop, or rescope
