# Daily Focus Plan

Generate a tactical daily plan based on my calendar, current priorities, and 12-week goals, then write it to `~/Notes/Planning/today.md` as the daily scratchpad.

## Step 1: Gather context (read all in parallel)

- `~/Notes/Claude/_WorkContext.md` — current priorities, blockers, open questions, next session priorities
- `~/Notes/Planning/week.md` — the weekly strategic plan written by `/week` on Sunday. Contains a day-by-day focus section, buffer-block allocations, and the breakout block. **If present, this is the primary anchor for today's plan** — use its row for today as the baseline.
- `~/Notes/Planning/today.md` — check for any ad-hoc items the user added manually during the day
- `~/Notes/Planning/soon.md` — backlog of upcoming tasks, buffer/personal items
- `~/Notes/Planning/12week/goals-mar-may.md` — goal categories for the quarter
- The active 12-week plan file linked from `~/Notes/Planning/12week/goals-mar-may.md` or the most recent `plan-*.md` in `~/Notes/Planning/12week/` — check the `current-week` frontmatter field to identify which week we're in and what this week's focus area and tasks are
- Google Calendar MCP: fetch today's events from the primary calendar

### If `week.md` is missing or stale
If `week.md` doesn't exist, or its `week-of` frontmatter is for a week that isn't the current one: proceed without it, and note at the end of the plan that `/week` hasn't been run for this week.

## Step 2: Analyze available time

Working hours are 08:00–16:00 (with occasional overrun to 17:00). Only schedule tasks within this window. Ignore calendar events outside these hours. **Lunch is 11:00–12:00 every day** — treat this as blocked time, never schedule work in this slot.

- List all calendar events with start/end times (within working hours)
- Include lunch (11:00–12:00) as a fixed block when calculating free time
- Calculate free blocks between events
- Identify total deep-work time (blocks >= 45 minutes) vs short gaps (< 45 minutes)
- Note which meetings are relevant to current work (1:1s where you can raise blockers, syncs on active projects, etc.)

## Step 3: Assign tasks to time blocks

**If `week.md` exists and covers the current week:** use its day-specific plan for today as the baseline. Don't re-derive from scratch. The week plan already considered the 12-week plan, Next Session Priorities, and carried items across all 7 days — today's row is the pre-reasoned slice. Your job now is to:
- Reconcile the week-plan-assigned focuses against the *actual* calendar today (meetings may have shifted, deep-work blocks may have compressed)
- Pull in any buffer-block items assigned to today in week.md
- Layer in intraday adjustments from `_WorkContext.md` "Next Session Priorities" that emerged after Sunday
- Note explicitly if today's week-plan row is no longer realistic and something needs to slide

**If `week.md` is missing or stale:** derive from scratch. Prioritize by:
1. **This week's 12-week plan focus area** — the plan marks a focus for each week. Tasks in that area get priority for deep-work blocks.
2. **Unblocking work** — anything that, if done, unblocks others or unblocks future tasks (e.g., pinging someone for a review, sending a message, resolving an open question).
3. **Deadlines and time-sensitivity** — items with hard deadlines or that are at risk if not started today.
4. **Energy-appropriate sizing** — deep creative/coding work goes in long blocks. Admin, comms, reviews, and quick follow-ups go in short gaps between meetings.

Also consider:
- Items from `_WorkContext.md` "Next Session Priorities" that haven't been addressed
- Blockers that could be cleared with a quick Slack message or meeting conversation
- Whether any meetings today are opportunities to advance active work (e.g., raising a question in a 1:1 instead of scheduling a separate meeting)
- Items from `soon.md` that are time-sensitive or could be knocked out in a short gap

## Step 4: Output to user

### Format

1. **Calendar + free time table** — show events and free blocks with durations
2. **Available deep-work time** — total hours/minutes in blocks >= 45 min
3. **Recommended focus areas** — numbered list, each with:
   - What to do — include `[[wikilinks]]` to the most relevant vault note for each item (e.g., the project index, specific RFC, review note, or ticket note). Use the links you encountered while gathering context in Step 1.
   - Which time block to do it in
   - Why it matters (tie to weekly focus, goal, or blocker)
4. **What to skip today** — items from the todo list that don't fit today, and why (wrong week focus, blocked, lower priority)
5. **Meeting strategy** — for any 1:1s or syncs, suggest specific topics to raise that advance active work
6. **Weekly risk check** — if it's mid-week or later, flag any of this week's 12-week plan items that are at risk of not getting done

### Tone
- Direct, structured, decision-ready
- Don't hedge — make clear recommendations
- If there's genuinely too much to fit, say so and force-rank ruthlessly

## Step 5: Write the plan to today.md

After presenting the plan to the user, write it to `~/Notes/Planning/today.md`. This file serves as the daily scratchpad that `/eod` reads back later. Preserve any ad-hoc items the user had already added manually.

The file format:
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

## Plan for <today's date>

### Calendar
<the calendar table>

### Focus
<numbered focus areas with time blocks — each item includes [[wikilinks]] to the relevant vault note>

### Meeting strategy
<talking points for each relevant meeting>

### Skip today
<what to skip and why>

## Ad-hoc
<any items the user added manually, preserved from before>
```
