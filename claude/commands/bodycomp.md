# Body Composition Check

Morning body composition check-in. Logs weight, body fat %, nutrition, and training plan for the day. Evaluates progress toward the 12-week goal (< 12% BF by end of cycle).

## Step 1: Read context (in parallel)

- `~/Notes/Personal/Training/body-log-2026.md` — the body composition log
- `~/Notes/Planning/12week/plan-mar-may-2026.md` — check `current-week` frontmatter to calculate weeks remaining (cycle ends week 12)

## Step 2: Collect today's data

Use AskUserQuestion to ask:
1. **Morning weight (kg)** — required
2. **Body fat %** — optional. Ask which method:
   - **Navy method** (high confidence): ask for waist circumference (cm, at navel, relaxed) and neck circumference (cm, just below larynx). Calculate using the **metric** formula: `BF% = 495 / (1.0324 - 0.19077 × log10(waist - neck) + 0.15456 × log10(height)) - 450` (round to 1 decimal). All inputs are in cm. Height is stored in `body-log-2026.md` frontmatter as `height-cm`. Log WITHOUT `~` prefix. Record raw measurements in Notes as `Navy: W=XXcm N=XXcm`.
   - **DEXA scan** (high confidence): log WITHOUT `~` prefix. Note `DEXA` in Notes.
   - **Scale / bioimpedance** (low confidence): log WITH `~` prefix.
   - **Skip**: log as `—`.
3. **Yesterday's macros** — protein (g), carbs (g), fat (g). The user tracks these daily so they should have the numbers.
4. **Yesterday's calories from tracker** — ask for both numbers (the tracker shows each directly; user shouldn't have to do arithmetic):
   - **Total calories consumed** (kcal eaten yesterday)
   - **Total calories burnt** (TDEE + exercise, as the tracker estimates)

   **Compute the deficit using the Bash tool, not mental arithmetic.** Run `echo $(( <consumed> - <burnt> ))` — negative result = deficit, positive = surplus. This matches the existing log convention. LLM arithmetic is reliable but not guaranteed; shell arithmetic is deterministic and zero-cost.

   Before writing to the log, echo the three numbers back to the user for a one-line sanity check, e.g.: *"Consumed 2150, burnt 2540 → deficit -390. Log this?"* — then log only after confirmation (or proceed silently if the numbers look sane and the user is doing the check themselves).
5. **Did you train yesterday?** If yes, what type: weights / weights+cardio / cardio. If no, log as rest. This captures *completed* training, not plans — avoids logging intent that may not happen.
6. **Notes** — optional

Then:
- Append a new row to the table in `body-log-2026.md` with today's date and the collected values (weight, BF%, notes). Leave the Trained and Type columns as `—` on today's row — they will be filled in by tomorrow's /bodycomp or by /eod.
- **Update yesterday's row** with the training data (Trained, Type) from question 5. If yesterday's row already has training data filled in, confirm with the user before overwriting.
- Use `—` for BF% if not provided.
- **High confidence** (no `~` prefix): Navy method, DEXA, or calipers with consistent technique.
- **Low confidence** (`~` prefix): bioimpedance scales, rough estimates.
- For Navy method: record raw measurements in Notes column as `Navy: W=XXcm N=XXcm` for traceability.
- Nutrition columns: Cal, P (g), C (g), F (g), Deficit. Use `—` if not provided. Cal is computed from macros: `P×4 + C×4 + F×9` (round to nearest integer). Deficit is a signed integer (negative = deficit, positive = surplus).
- Update the `updated:` field in frontmatter to today's date

**Note on nutrition timing**: The macro/deficit entry logged on a given date reflects *that day's* intake. Since this runs in the morning, the data collected is for yesterday — update yesterday's row if it has `—` in nutrition columns. The user can always update today's nutrition at /eod.

## Step 3: Evaluate progress

Parse all rows from the log table and calculate the following. Present results to the user.

### Trend

**Measurement-noise reality check.** A 1cm waist swing on Navy = ~0.7% BF. Never anchor a verdict on a single day's reading. Require ≥14-day rolling means for any rate claim, and prefer linear regression over a 1-week-vs-1-week delta (which is dominated by noise — a single noisy week on either end can flip a +0.1%/wk recomp into a -0.4%/wk "AHEAD" hallucination).

**Bioimpedance exclusion.** Once ≥14 high-confidence entries (Navy/DEXA, no `~` prefix) exist, **exclude all `~` entries from trend and projection calculations entirely** — bioimpedance has been observed ~3% off from Navy taken within days, large enough to corrupt any regression. If <14 high-confidence entries exist, fall back to weight trend + nutrition adherence as primary signals and say so explicitly.

- **Weight 7-day average**: average of the last 7 weight entries.
- **Weight rate of change**: linear regression slope over all weight entries within the cycle (kg/week). Bioimpedance scales report weight reliably even when BF% is noisy, so weight regression can use all entries.
- **BF% rate of change**: linear regression slope over all high-confidence (non-`~`) BF% entries within the cycle (% per week). Minimum 14 data points. If fewer than 14, do not produce a rate claim — note "trend signal too weak — fewer than 14 Navy/DEXA readings; rely on weight trend + nutrition adherence."
- **Cycle-start anchor**: report `BF% at first high-confidence reading of cycle (date) → today (date)`, total change, weeks elapsed, and average %/week over that window. This is the most stable framing for a 12-week cycle and should be presented before any short-window number.
- Use the Bash tool (e.g. `python3 -c "..."` with `numpy.polyfit` or a manual least-squares calc) for regression slopes. Do not eyeball.
- If fewer than 7 days of weight data exist, show raw values and note: "Trends available after 1 week of data"

### Projection

Compute **two independent projections** and compare them. The verdict is only allowed to claim a precise outcome if both projections agree. This guardrail exists because regression-based projection over short, noisy windows has historically produced overconfident "AHEAD" verdicts that contradict the energy-balance reality.

- Calculate weeks remaining: `12 - current-week` (from the plan frontmatter) + fraction of current week remaining.
- **Projection 1 — Regression-based**: `current_7day_BF% + (regression_slope × weeks_remaining)`. Only valid if ≥14 high-confidence entries exist.
- **Projection 2 — Physics-based (energy balance)**:
  - `expected_fat_loss_kg = (avg_daily_deficit × days_remaining) / 7700`  (treat avg_daily_deficit as a positive number; e.g. -250 cal/day → use 250)
  - `expected_BF%_drop = (expected_fat_loss_kg × 0.8 / current_weight_kg) × 100`  (the 0.8 factor assumes 80% of fat-loss-equivalent kcal goes to fat and 20% to LBM, which is standard for moderate cuts; if weight is rising or flat over 2+ weeks, treat as recomp and use 1.0)
  - `physics_projection = current_BF% - expected_BF%_drop`
  - Use the Bash tool to compute, not mental arithmetic.
- **Cross-check (REQUIRED)**: if the two projections disagree by **>2× in the magnitude of BF%-drop predicted**, flag the verdict as **UNCERTAIN** and report both numbers with the divergence explained. Common causes: tracker overestimates deficit, short-window regression dominated by measurement noise, or recomp masking actual fat loss in the BF% signal. Do NOT pick one and hide the other.
- Also project weight using its regression slope.

**Weight is a guardrail, not a target.** Use weight trend to detect:
  - **Muscle loss risk**: weight dropping > 0.5–1% of bodyweight/week (~0.3–0.6kg/week at ~64kg) while in a deficit — suggest slowing the cut.
  - **Insufficient deficit**: weight rising or flat over 2+ weeks while in a stated deficit — either the deficit estimate is wrong (TDEE off) or recomp is consuming it. Compare physics projection to regression projection: if physics says fat is being lost but BF% regression doesn't show it, the measurement noise floor is hiding it.
  - **Ideal signal**: weight stable or slowly decreasing while training is consistent = likely recomposition.

**Verdict (apply to both projections; verdict tracks the worse of the two unless flagged UNCERTAIN):**
- **AHEAD**: both projections land >0.5% below target (e.g., ≤11.5% for a <12% goal).
- **ON TRACK**: at least one projection lands at-or-below target, and the other is within 0.3% above.
- **AT RISK**: best projection misses target by ≤0.3%.
- **BEHIND**: both projections miss target by >0.3%.
- **UNCERTAIN**: the two projections disagree by >2× in predicted BF% drop. Report both and explain the divergence rather than picking one.
- **INSUFFICIENT DATA**: <14 high-confidence BF% entries. Rely on weight trend + nutrition adherence and say so.

Include weight observations (muscle loss risk, deficit adequacy) in the recommendation section, not the verdict.

### Nutrition analysis

From the log's nutrition columns, calculate:
- **Average daily calories** over the last 7 days (skip `—` entries)
- **Average daily protein** over the last 7 days
- **Macro split**: average % of calories from protein / carbs / fat
- **Calorie trend**: are daily calories consistent, trending up, or trending down?
- **Protein adequacy**: for body recomposition at ~64kg, target is roughly 1.6–2.2g/kg = 102–141g protein/day. Flag if below this range.

#### Deficit analysis

The Deficit column captures the user's app-estimated daily caloric deficit (negative = deficit, positive = surplus). Use this to:
- **Average daily deficit** over the last 7 days (skip `—` entries)
- **Deficit consistency**: are deficit values consistent day-to-day, or highly variable?
- **Cross-check with weight trend**: a sustained -500cal/day deficit should produce ~0.45kg/week loss. Compare the expected weight loss from average deficit to actual weight trend — large discrepancies suggest the deficit estimate or TDEE is off.
- **Deficit adequacy for BF% goal**: estimate whether the current average deficit is sufficient to reach the BF% target by end of cycle, assuming ~7700cal deficit per 1kg of fat lost.
- If deficit data is sparse (<3 entries), note this and rely on weight trend instead.

Correlate nutrition with weight trend:
- If weight is stagnant or rising and deficit is small or positive: suggest increasing the deficit (reduce calories or add cardio)
- If weight is dropping too fast (>1kg/week) and deficit is large (< -700): flag risk of muscle loss, suggest moderating the deficit
- If protein is consistently low: flag this as a priority fix — protein is the most important macro for preserving muscle during a cut
- If calories are inconsistent (high variance day-to-day): note this and suggest more consistency
- Look for patterns: do higher-calorie days or smaller deficits correlate with rest days or training days? Are there specific days of the week that are consistently higher?

### Training frequency

From the log, calculate:
- Training sessions this week so far (Mon–Sun, where Monday is the start of each training week)
- Breakdown: how many were weights, weights+cardio, cardio-only
- Same breakdown for last week
- Consecutive training days without rest (count backward from today)
- Flag if 4+ consecutive days with no rest

### Recommendation

Based on all the above, give a short, direct recommendation covering:

- **Should you train today?** Confirm or suggest a change to today's plan
- **Training type guidance**:
  - If BF% trend is flat or rising and training frequency is adequate: recommend adding more cardio sessions (e.g., tack 15min incline treadmill onto weight sessions)
  - If weight is dropping > 1kg/week: flag possible muscle loss risk, suggest slowing the deficit or ensuring protein intake
  - If training frequency is below 3 sessions/week: flag and recommend a minimum of 4 sessions
  - If consecutive training days >= 4: recommend a rest day
- **Nutrition guidance**:
  - If protein is below target: specific suggestion to increase (e.g., "add a protein shake" or "swap X for a higher-protein option")
  - If calories are too high for the rate of weight loss needed: suggest a specific reduction target
  - If calories are too low and weight is dropping fast: suggest increasing slightly
  - If adherence is inconsistent: flag the pattern and suggest what to watch for
- **What's working**: explicitly call out anything that's going well (e.g., "protein has been consistently above 130g — keep that up")
- **If on track**: confirm current approach and maintain

## Step 4: Output format

Present the evaluation in this format:

```
## Body Comp Check — YYYY-MM-DD

### Today's Entry
Weight: XXkg | BF%: XX% (or —)
Yesterday's macros: P: XXXg | C: XXXg | F: XXXg | Deficit: -XXX

### Cycle Progress (anchor)
First high-confidence reading (YYYY-MM-DD): XX.X% → today (YYYY-MM-DD): XX.X% — change X.X% over X.X weeks (X.XX%/week)

### Trend
Weight: XXkg 7-day avg, ±X.Xkg/week (regression over N entries)
BF%: XX.X% 7-day avg, ±X.XX%/week (regression over N high-confidence entries) — or "trend signal too weak — fewer than 14 Navy/DEXA readings; using weight + nutrition only"
Calories: XXXXcal/day | Protein: XXXg/day (X.Xg/kg) | Avg deficit: -XXX/day

### Projection → Week 12 (end-of-cycle date)
Regression-based: XX.X% [✓/⚠️/✗]
Physics-based (deficit × days ÷ 7700, ×0.8 fat fraction): XX.X% [✓/⚠️/✗]
Verdict: [AHEAD / ON TRACK / AT RISK / BEHIND / UNCERTAIN / INSUFFICIENT DATA]
[If UNCERTAIN: one-line reason for the divergence, e.g. "regression says -1.2% but physics says -0.4% — likely measurement noise dominating short-window slope"]
Weight: XXkg — [stable ✓ / dropping fast ⚠️ / rising ⚠️]

### Training This Week
Sessions: X/5 target | Cardio: X | Rest days: X
Last week: X sessions, X cardio

### Nutrition Insight
[1-2 sentences on what's working or not working with nutrition — patterns, correlations, flags]

### Recommendation
[2-4 sentences covering training + nutrition advice for today and the days ahead]
```

### Tone
- Direct and honest — if behind, say so
- Actionable — every observation connects to what to do
- Brief — this is a morning check-in, not an essay
- Call out what's working, not just what's wrong
