# Weekly Plan — Sunday Evening Preview

Retrospect the week just ended and plan the week ahead. Writes to `~/Notes/Planning/week.md` as the weekly strategic plan that `/today` reads for daily context.

## Step 0: Check day + scope

Determine the current weekday:
- **If today is Sunday:** proceed normally. The upcoming week (Mon-Sun) is the target.
- **If today is Mon-Sat:** ask the user:
  > "Today isn't Sunday. Is this weekly plan for:
  > 1. **The rest of this week** (starting today → Sun <date>), or
  > 2. **Next week** (specify Monday's date)?"

  Wait for the user's answer.
  - If "rest of this week": scope is today through Sunday.
  - If "next week": user provides the Monday start date. Acknowledge this is a **draft/idea** plan because the current week isn't over — the next Sunday `/week` run should re-run to properly flesh it out based on how this week actually lands.

Record the chosen scope as `<week-start>` → `<week-end>` for the rest of the steps.

## Step 1: Gather context (read all in parallel)

- `~/Notes/Claude/_WorkContext.md` — current priorities, blockers, Next Session Priorities
- `~/Notes/Planning/soon.md` — backlog including Personal section (buffer block candidates)
- `~/Notes/Planning/today.md` — today's scratchpad for any ad-hoc items
- `~/Notes/Planning/week.md` — the previous week plan if it exists (to preserve ad-hoc items)
- `~/Notes/Planning/12week/goals-mar-may.md` — quarter goal categories
- The active 12-week plan in `~/Notes/Planning/12week/plan-*.md` — check `current-week` frontmatter; read both the week-just-ended and the week-ahead sections
- `~/Notes/Planning/12week/weekly-routine.md` — the default time-block pattern (Swedish breakfast, FP 18:30-20:00, Sat study day, Sun off)
- `~/Notes/Planning/breakout-ideas.md` — rotating pool of 2h+ active-rest activities. **If missing, create it with template (see Step 7).**
- `~/Notes/Claude/SessionLogs/YYYY-MM.md` — session entries from the week that just ended
- `~/Notes/CareerDev/CareerLog/careerlog-2026.md` — significant entries logged during the week
- Run `git -C ~/Notes log --since="<week-start - 7 days>" --until="<week-start>" --oneline` — commits from the week just ended
- Google Calendar MCP: fetch events for `<week-start>` through `<week-end>` on the primary calendar

## Step 2: Retrospective — week just ended

Skip this step if the chosen scope is "rest of this week" (there's no just-ended week to review).

Otherwise, build a concise retrospective from git log, SessionLogs, careerlog, and the 12-week plan's week-just-ended section:

- **What was planned** — this-week-just-ended items from the 12-week plan
- **What got done** — categorize each as done / progressed / not touched
- **Completion %** — rough percentage of planned items done or meaningfully progressed
- **Unplanned major work** — significant items that happened but weren't on the plan (pull from SessionLogs)
- **Notable careerlog entries** — anything added this week

Keep it tight — this is signal, not essay.

## Step 3: Goal trajectory

Same shape as `/eod`'s goal trajectory section, but over the 7-day window. For each goal category in `goals-mar-may.md`:
- 🟢 **On track** / 🟡 **At risk** / 🔴 **Behind** / 🟣 **Ahead** / ⚫ **Blocked**
- One-line why

If running mid-week (scope = "rest of this week"), trajectory uses the week-ending context — don't simulate a retrospective.

## Step 4: Weekly rollover of the 12-week plan

If a full week ended (scope includes a completed prior week):
- In the active `plan-*.md`, check off completed items in the week-just-ended section with `[x]`
- For incomplete items still relevant, mark them carried to the week-ahead section (add to its list, keep context)
- Items planned but never started need a decision — flag these back to the user: carry forward, drop, or rescope?
- Bump `current-week` frontmatter by 1 (if rolling to next week)
- Bump `updated` frontmatter to today's date

Ask the user before bumping `current-week` and before making any rescope decisions.

## Step 5: Calendar analysis for the week ahead

Build a table — **each day Mon through Sun** for the chosen week:

| Day | Date | Meetings (within 08:00–16:00) | Deep-work blocks (≥45min) | Short gaps (<45min) | Notable |
|-----|------|-------------------------------|---------------------------|---------------------|---------|
| Mon | ... | ... | ... | ... | ... |
| ... | ... | ... | ... | ... | ... |

Rules:
- Only include calendar events within working hours 08:00–16:00 for weekdays.
- Lunch 11:00–12:00 is always blocked — do not schedule work.
- "Notable" flags recurring anchors (1:1s, Pangolins fika, Pangolins standup) or unusual days (Meeting Free Friday, holidays, travel).
- Weekends: list events but treat as optional / flexible.

Aggregate:
- **Total deep-work time this week** (sum of deep-work blocks across weekdays)
- **Days with protected deep-work** (e.g. Tuesday has a 2h morning free)
- **Days that are meeting-heavy** (little deep work possible — push focus work away from these)

## Step 6: Day-by-day plan

Assign focuses to each weekday using this priority order:
1. **12-week plan week-ahead focus area** — the plan marks a focus for each week. This area gets the best deep-work block of the week.
2. **Carried items** — anything rolled forward from last week
3. **_WorkContext.md Next Session Priorities** — unresolved items
4. **Deadline-anchored items** — deadlines falling within the week or imminent after
5. **Unblocking work** — items that clear other people or future work

Shape the plan around the **weekly routine**:
- **Weekday defaults (per `weekly-routine.md`):**
  - 07:00–07:30 Swedish 15-20 min at breakfast
  - 08:00–16:00 work
  - 16:00–17:30 gym (4-5×/week)
  - 18:30–20:00 FP in Scala (protect ruthlessly — the 1-1.5h block is what makes 2 chapters/week possible)
- **Saturday:** study day — FP deep block 2-3 hrs mid-day
- **Sunday:** light day — no obligations, errands + social, FP only if wanted

For each day give 2-4 suggested focuses with `[[wikilinks]]` to the relevant vault note. Order by best-fit time block. Sample shape:

```
**Monday** — Week's first deep block
- Morning 08:00-10:30 → Pitch 2+3 scoping [[pitches-preservation]]
- 10:30-11:00 → Pangolins standup
- 14:00-16:00 → DataBoost doc for Rob [[instance-classification]]
- 18:30-20:00 → FP Ch 1 review
```

## Step 7: Buffer blocks — personal/admin assignment

**Buffer blocks = outside working hours, for quick personal/admin tasks.** Examples: weekday evenings 20:00+, weekend mornings, Sunday afternoon errands.

From `~/Notes/Planning/soon.md` Personal section, pull all open items. Assign each to a specific buffer slot across the week:
- Quick admin (RSVPs, form sends, online orders) → batch into one evening
- Price/deadline-urgent → earliest slot
- Research/drafting (e.g. "draft TPR report") → longer block, maybe Sunday afternoon
- Spread load — don't stack all personal admin on one night

Respect "Sunday is genuinely off" per the routine — use Sunday only for items the user *wants* to do on Sunday (like a long draft or errands).

Output shape:
```
### Buffer blocks
- **Mon 20:00+** — RSVP school reunion, RSVP wedding, razor blades (batched admin, ~20min)
- **Tue 20:00+** — FP Ch 2 catch-up
- **Wed 20:00+** — free / rest
- **Thu 20:00+** — workplace benefits check
- **Fri evening** — free
- **Sat morning** — AXA form, haircut booking
- **Sun afternoon** — TPR pension draft (longer task)
```

## Step 8: Breakout block

**Breakout block = at least 2 hours per week of active rest.** Reading a book, watching a film, game, walk, cooking — not work, not admin, not learning goals.

Defaults per the routine: **Sunday afternoon** is the most natural candidate.

From `~/Notes/Planning/breakout-ideas.md`:
- **If file doesn't exist, create it with this template first:**

```markdown
---
id: breakout-ideas
aliases: [Breakout Ideas, Weekly Active Rest]
tags: [status/active, type/planning]
created: <today>
updated: <today>
---

# Breakout Ideas

Pool of 2h+ active-rest activities. `/week` picks one each Sunday for the week ahead.
Add new ideas to **Pool**. Skill picks one and moves it to **Used** with date.

## Pool (unused)
- [ ] <add ideas here>

## Used
```

- Read the Pool section. Pick **one** item, ideally one that fits the week's shape (e.g. if week ahead is heavy, pick a lighter activity; if week ahead is quiet, pick something bigger like a full film).
- Propose the pick to the user: *"Breakout block: Sun afternoon — <activity>. OK or pick a different one?"*
- After user confirms, move the chosen item from Pool to Used with the date the breakout is scheduled for.
- If Pool is empty or very short (<3 items), prompt the user to add more before proceeding.

## Step 9: Output to user

Present in this order:
1. **Retrospective** (skip if mid-week rest-of-week scope)
2. **Goal trajectory**
3. **Calendar table** for the week ahead
4. **Day-by-day plan**
5. **Buffer block assignments**
6. **Breakout block proposal**
7. **Carried items / at-risk items**

### Tone
- Direct, structured, decision-ready
- Honest about what slipped — no cheerleading
- Force-rank ruthlessly when the week is over-subscribed

### If running mid-week for "next week" scope
Prepend with: *"This is a DRAFT weekly plan because this week isn't over. Re-run `/week` on Sunday to finalise based on how this week actually ends."*

## Step 10: Write to `~/Notes/Planning/week.md`

Preserve any ad-hoc items the user had manually added to the previous `week.md`.

Format:
```markdown
---
id: week
aliases: [Week Plan, This Week]
tags: [status/active, type/planning]
created: 2026-04-18
updated: <today>
week-of: <Monday's date>
---

<!-- This file is managed by the /week skill. -->
<!-- /week writes this Sun evening; /today reads it as context. -->
<!-- Add ad-hoc items during the week as needed. -->

## Week of <Monday's date> (Week <N> of Mar-May 12-week cycle)

### Weekly focus
<primary focus area(s) from the 12-week plan + carried items>

### Calendar overview
<the calendar table>

### Day-by-day plan
<per-day focuses with [[wikilinks]] and time blocks>

### Buffer blocks (outside working hours)
<personal/admin assignments>

### Breakout block
<chosen activity + slot>

### Carried / at-risk
<items rolled forward from last week, flagged items>

### Skip this week
<items explicitly deferred with reason>

## Ad-hoc
<any manual items preserved from prior week.md>
```

## Step 11: Commit

After all updates:

```bash
git -C ~/Notes add -A
git -C ~/Notes commit -m "week: <Monday's date>"
```

If running mid-week for a draft-next-week plan, use commit message `week-draft: <Monday's date>` to distinguish it in the log — the Sunday run will produce the canonical `week: <Monday's date>` commit.
