# Mid-Day Sync

Lightweight sync to keep planning notes aligned with reality. Can be run any time during the day, any number of times. Unlike `/eod`, this does NOT write session logs, update the career log, search Slack, check body comp, produce a scorecard, or commit.

The core job: propagate what's happened so far into `today.md`, `soon.md`, and the 12-week plan so that any Claude Code session (in any repo) sees consistent state.

## Step 1: Gather context (read all in parallel)

- `~/Notes/Claude/_WorkContext.md` — the source of truth for what's changed (other sessions update this as they work)
- `~/Notes/Planning/today.md` — the morning plan from `/today`
- `~/Notes/Planning/soon.md` — backlog items
- The active 12-week plan file (most recent `plan-*.md` in `~/Notes/Planning/12week/`) — this week's section only (use `current-week` frontmatter to find it)

## Step 2: Diff _WorkContext against planning notes

`_WorkContext.md` is updated by every Claude Code session across all repos. The planning notes may be stale. Compare:

1. **Items completed in _WorkContext but not crossed off in today.md** — these need to be marked done
2. **Items completed in _WorkContext but still open in soon.md** — these need to be marked done
3. **Items completed in _WorkContext but still unchecked in the 12-week plan** — these need to be checked off
4. **New work in _WorkContext not on today's plan** — unplanned work that happened
5. **New items in _WorkContext "Next Session Priorities" not in soon.md** — emerging tasks to add
6. **Items struck through in _WorkContext** — verify they're also resolved in the other notes

Don't ask the user what happened — infer it from _WorkContext. Only ask if something is ambiguous (e.g., _WorkContext says "PR open" but you're not sure if that means it was opened today or earlier).

## Step 3: Update notes

### ~/Notes/Planning/today.md
- Cross off completed Focus items with ~~strikethrough~~ and a brief outcome note (e.g., "merged", "4 instances confirmed @ $1.51M/month")
- Add a `### Unplanned work done` section (before Ad-hoc) for work that happened but wasn't on the morning plan
- Add a `### Not done (carried)` section for planned items that won't happen today (only if clearly not going to happen — don't prematurely mark things as carried if there's still time in the day)
- Preserve any existing Ad-hoc items the user added manually
- Do NOT reset the file — that's `/eod`'s job

### ~/Notes/Planning/soon.md
- Mark completed items with strikethrough
- Add new items that emerged during the day (from _WorkContext "Next Session Priorities" or Active Focus changes)
- Do NOT delete items — that cleanup is `/eod`'s job

### 12-week plan (this week's section only)
- Check off `[x]` any items completed today
- Add status annotations to in-progress items (e.g., "PR open", "in review")

### ~/Notes/Claude/_WorkContext.md
- Only touch this if the planning notes reveal something _WorkContext missed (rare — it's usually the most up-to-date)
- Bump `updated:` if you make changes

## Step 4: Report to user

Brief summary of what was synced. Format:

```
**Synced N updates across planning notes.**

Done today:
- <item> (crossed off in today.md, soon.md, 12-week plan)

Still open:
- <item> — <current status>

New/unplanned:
- <item> — added to today.md
```

Keep it short — the user can read the files if they want detail. The value is knowing the sync happened and what moved.
