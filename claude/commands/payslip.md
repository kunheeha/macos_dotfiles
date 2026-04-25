# Payslip Analysis

Analyse a new Spotify payslip in the context of the financial plan, re-project full-year gross income, and recalibrate the pension salary sacrifice target. Writes a per-payslip analysis note to the vault, updates the payslip index table, and adjusts `pension-sacrifice-adjustment.md` if the target changes materially.

Works with ADP-format Spotify payslips at `~/Documents/Personal/*Payslip*.pdf`.

## Step 0: Create the Payslips folder if missing

Ensure `~/Notes/Personal/Payslips/` exists:
```bash
mkdir -p ~/Notes/Personal/Payslips
```

## Step 1: Gather context (read all in parallel)

- `~/Notes/Personal/financial-plan-2026.md` — canonical plan + current FY projection
- `~/Notes/Personal/pension-sacrifice-adjustment.md` — current sacrifice target + staged plan
- `~/Notes/Personal/finances.md` — assets overview
- `~/Notes/Personal/Payslips/payslips_index.md` — prior payslip summary table (if exists; if not, initialise in Step 7)
- `~/Notes/Personal/Payslips/` directory listing — identify prior analysis notes (`YYYY-MM-analysis.md`)
- `~/Documents/Personal/Promotion.pdf` — **only** if this is the first post-promotion payslip (to verify salary uplift matches the letter)

## Step 2: Identify the payslip

1. List PDFs matching `~/Documents/Personal/*Payslip*.pdf` with modification times.
2. Find the newest payslip that does NOT have a corresponding `YYYY-MM-analysis.md` in `~/Notes/Personal/Payslips/`.
3. Confirm with the user: *"Analyse `<filename>`?"* — wait for yes/no.
4. If the user wants a different payslip, ask for the full path.
5. If all payslips have analyses, tell the user and stop.

## Step 3: Parse the payslip

Read the PDF (use `pages` parameter only if >10 pages — rarely needed for 1-page payslips). Extract ALL of the following. Be precise — these numbers drive the recalibration.

### Header
- **Pay Day** (e.g., `24/04/2026`)
- **Tax Month** (1–12; 1 = April of UK tax year, 12 = March)
- **Annual Salary** (base reference, e.g., £65,000 or £71,500)

### Earnings (paid items — cash that hits bank)
- `Salary` — monthly base
- `Bonus Cash Plan` — original grant cash portion
- `EE Pension Sal Sac` — negative (deduction)
- `Incremental Allowance`
- `On Call Weekday`
- `On Call Weekend`
- `RSU Benefit net Settled` — net RSU cash after sell-to-cover (when vest occurs)
- `Live Music Gross` — if present (ad-hoc)
- `Net Payment` — if present (ad-hoc)
- **Any other earnings line** — log as "new earnings type" and flag

### Notional earnings (shown but NOT paid — benefit-in-kind for tax only; prefix `*`)
- `*Cashplan Medical Benefit`
- `*Food Allowance`
- `*Private Dental Benefit`
- `*Private Medical Benefit`
- `*RSU Benefit` — gross RSU vesting value (before sell-to-cover) — counts toward taxable income and £100k threshold

### Deductions
- `Tax` (Code 1257L)
- `NI (Category A)`
- `Student Loan` / `Postgraduate Loan` — if present
- **Total Deductions**

### Summary
- **Total Earnings** (paid only)
- **Net pay** (Amount paid)

### Running Totals — Tax Year to Date (TYTD) (critical for projection)
- `Gross Pay` TYTD (all employments)
- `Taxable Pay` TYTD (all employments)
- `Tax` TYTD
- **This Employment**: Gross Pay, Taxable Pay, Tax
- **Previous Employment**: Taxable Pay, Tax (if present)
- `Employee's NI` TYTD
- `Employer's NI` TYTD

### Accumulations
- Pension-relevant YTD: `Employee Pension Salary Sacrifice`, `Employers Pension`
- BIK YTD: `Cashplan Medical Benefit`, `Food Allowance`, `Private Dental Benefit`, `Private Medical Benefit`
- Bonus/Salary YTD: `Salary`, `Bonus Cash Plan` (if present in accumulations section)

### Employer contributions
- `NI (Category A)` employer
- `Employers Pension`
- `Employee Pension Salary Sacrifice` (reiterated)

## Step 4: Compute analysis

### 4.1 Month-over-month delta
Compare against the previous payslip row in `payslips_index.md`. Flag significant changes (>20%) in:
- On-call (weekday / weekend)
- RSU vesting (presence/absence)
- New earnings line items
- Pension sacrifice amount

### 4.2 FY gross projection

Use TYTD figures + knowledge of remaining months:

**Months elapsed in FY** = Tax Month number (1=April, 12=March). So if Tax Month 1, 1/12 of year elapsed.

**Naive run-rate projection**:
- Annual gross (paid items) ≈ `TYTD Gross Pay (this employment) × 12 / Tax Month`
- But this over-indexes on early months if income is ramping (e.g., new salary from May).

**Better: compositional projection**. Build the projection by component:
- **Base salary** (FY26/27): known by month. If salary uplift pending (promotion), split months at old vs new rate.
  - Example post-May 2026: April £5,417 + (May–March) £5,958 × 11 = £70,958
- **On-call**: use YTD average per month elapsed × 12 for the remaining projection. Cross-check against historical pattern in `payslips_index.md`. Flag variance.
- **Bonus Cash Plan** (original grant cash): confirmed ~£545/mo → £6,540/yr
- **New grant cash** (from Aug 2026): 11/48 × $25,000 ≈ £4,407 in FY26/27
- **RSU vesting** (original): use YTD to date, extrapolate based on vesting schedule (not every month vests)
- **New grant RSU** (from Aug 2026): 11/48 × $25,000 ≈ £4,407 in FY26/27
- **Incremental allowance**: £33/mo × 12 = £396
- **Live Music / Net Payment / ad-hoc**: project from YTD run rate, assume continues at same pace
- **Notional BIK**: use Accumulations YTD × 12 / Tax Month (food, cashplan, medical, dental)

Sum → **Projected FY gross taxable income**.

### 4.3 Pension sacrifice recalibration

- Read current target from `pension-sacrifice-adjustment.md` (Action line).
- Read actual sacrifice applied from payslip (`EE Pension Sal Sac` × -1).
- **Adjusted net income** = projected gross - (annual pension sacrifice at current rate).

Determine recommendation:
| Adjusted net projection | Recommendation |
|--|--|
| ≤ £100k | **Maintain current sacrifice.** No change needed — already out of trap zone. |
| £100k – £103k | Marginal trap exposure. **Maintain** (low uplift) unless Kunhee wants 62% relief on the margin. |
| £103k – £110k | **Increase sacrifice** by roughly `(adjusted_net - £100,000) ÷ 12` per month, rounded to nearest £50. |
| > £110k | Significant trap exposure. **Increase to £846/mo** (or up to £2k/yr under April 2029 cap). |

**Liquidity override**: if the user has indicated house-purchase is imminent (check `pension-sacrifice-adjustment.md` Step 3 note, or project notes), freeze sacrifice at current level regardless — prioritise deposit.

**Drift check**: if payslip sacrifice ≠ current target (e.g., target £400 but payslip shows £217), flag: *"Workday change not yet applied on this payslip. Follow up."*

### 4.4 Savings capacity

- Monthly take-home from payslip (Net Pay).
- Annual take-home projection ≈ Net Pay × 12 (adjusted for known one-offs).
- Subtract estimated living costs (from plan: ~£2,000/mo pre-purchase).
- Compare against plan's ~£3,700/mo target savings capacity. Flag if tracking below.

### 4.5 Sanity checks
- Compare **Annual Salary** on payslip to expected (post-promotion £71,500 from May 2026; £65,000 before).
- If new salary is expected but payslip still shows old, flag: *"Promotion not yet reflected. Investigate."*
- Tax code should be `1257L` unless it's changed — flag if different.
- Payslip `Student Loan` / `Postgraduate Loan` — flag if present when they weren't before.

## Step 5: Write the analysis note

Path: `~/Notes/Personal/Payslips/YYYY-MM-analysis.md` (e.g., `2026-04-analysis.md`). Template:

```markdown
---
id: payslip-YYYY-MM
aliases: [Payslip YYYY-MM]
tags: [domain/personal, type/analysis, status/active]
created: YYYY-MM-DD
updated: YYYY-MM-DD
pay-day: DD/MM/YYYY
tax-month: N
---

# Payslip Analysis — Month YYYY

## Headline
- **Pay Day**: DD/MM/YYYY (Tax Month N)
- **Annual Salary (reference)**: £X,XXX
- **Net pay**: £X,XXX.XX
- **Pension sacrifice applied**: £XXX.XX (target: £XXX)

## Earnings breakdown
| Component | This month | Prior month | Δ |
|-----------|------------|-------------|---|
| Salary | | | |
| Bonus Cash Plan | | | |
| On Call (weekday + weekend) | | | |
| RSU net settled | | | |
| Incremental Allowance | | | |
| Ad-hoc (Live Music, Net Payment) | | | |
| Notional BIK subtotal | | | |
| **Total paid earnings** | | | |

## Tax Year to Date
- Gross Pay (this employment): £X,XXX
- Taxable Pay (this employment): £X,XXX
- Tax: £X,XXX
- Pension Sal Sac: £X,XXX
- Employer Pension: £X,XXX

## FY Projection (compositional)
| Component | Projected FY | Basis |
|-----------|--------------|-------|
| Base salary | | |
| On-call | | YTD × 12 / Tax Month |
| Bonus Cash Plan | | |
| Original RSU vesting | | |
| New grant cash (Aug onwards) | | |
| New grant RSU (Aug onwards) | | |
| Incremental + ad-hoc | | |
| Notional BIK | | |
| **Projected FY gross** | **£XXX,XXX** | |

**Adjusted net (at current £X/mo sacrifice)**: £X,XXX → {below £100k / marginal trap / in trap by £X}

## Pension sacrifice recommendation
- Current target (pension-sacrifice-adjustment.md): £XXX/mo
- Actual applied (this payslip): £XXX/mo
- Recommendation: **{Maintain / Increase to £XXX / Decrease to £XXX}**
- Rationale: …

## Anomalies / flags
- {e.g., "On-call this month 66% lower than last month — rota variability"}
- {e.g., "First payslip at new salary — promotion uplift confirmed"}
- {e.g., "Workday change not yet applied — follow up"}

## Actions
- [ ] …
- [ ] …

## Related
- [[financial-plan-2026]]
- [[pension-sacrifice-adjustment]]
- Source: `~/Documents/Personal/<filename>.pdf`
```

## Step 6: Update pension-sacrifice-adjustment.md (only if target changes)

If Step 4.3 produces a recommendation that materially differs from the current target (e.g., >£50/mo change or a maintain→increase/decrease flip):
1. Update the **Action** line's target.
2. Update the staged timing table if the current step's target changes.
3. Bump `updated:` in frontmatter.
4. Tell the user what changed and why.

If recommendation is "maintain", do NOT touch `pension-sacrifice-adjustment.md`.

## Step 7: Update payslips_index.md

If missing, initialise with this structure. Otherwise, append a new row and update `updated:`.

```markdown
---
id: payslips-index
aliases: [Payslips Index]
tags: [type/moc, domain/personal, status/active]
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Payslips Index

Summary of monthly Spotify payslips. Full analyses in per-month notes.

## Summary table

| Month | Pay Day | Base | On-call | Bonus Cash | RSU net | Ad-hoc | Total paid | Pension Sac | Net Pay | TYTD Gross | Projected FY | Analysis |
|-------|---------|------|---------|------------|---------|--------|------------|-------------|---------|------------|--------------|----------|
| Mar 2026 | 25/03 | 5,417 | 1,433 | 542 | 172 | 0 | 7,380 | 217 | 4,931 | 69,052 | — | [[2026-03-analysis]] |
| Apr 2026 | 24/04 | 5,417 | 481 | 549 | 0 | 307 | 6,570 | 217 | 4,587 | 6,863 | ~£104k | [[2026-04-analysis]] |

## Recent recommendation trajectory
- YYYY-MM-DD: {e.g., "Target revised from £846→£400/mo after April payslip showed on-call variability"}
```

Append the new payslip row. Keep table chronological.

## Step 8: Output summary to user

Present in this format:

```
## Payslip Analysis — Month YYYY

### Headline
Net pay: £X,XXX (Δ £+/-XXX vs last month)
Pension sacrifice applied: £XXX (target: £XXX) {✓ matches / ⚠️ drift — follow up}

### This month vs last month
On-call: £XXX (Δ £+/-XXX, X% change)
RSU: £XXX {none this month / vest landed}
Ad-hoc: £XXX {e.g., Live Music, Net Payment}

### FY projection (compositional)
Projected FY gross taxable: **£XXX,XXX**
At current sacrifice £XXX/mo → adjusted net £XX,XXX
{Below £100k — no trap / In trap by £X,XXX}

### Recommendation
{Maintain current target / Increase to £XXX / Decrease to £XXX}
Rationale: {1-2 sentences tied to the actual numbers, not generic}

### Flags
- …
- …

### Files
- Analysis: `~/Notes/Personal/Payslips/YYYY-MM-analysis.md`
- Index: `~/Notes/Personal/Payslips/payslips_index.md`
{- Updated: `~/Notes/Personal/pension-sacrifice-adjustment.md` (target changed from X to Y)}
```

### Tone
- Direct, data-led. Cite specific numbers.
- If recommendation is maintain, say so cleanly without hedging.
- Flag anomalies clearly but don't over-dramatise rota variability.
- Never recommend action not backed by YTD + projection math.
- If the data isn't enough (e.g., only 1-2 months into FY with a pending salary change), say so and recommend revisiting after more data.

## Notes for future sessions
- Kunhee's pension sacrifice strategy prioritises **liquidity during the house-deposit accumulation window** (plan §3). Don't blindly chase 62% marginal relief if it harms deposit savings.
- The plan's £110k gross figure was calibrated off March 2026 (heavy on-call) — treat it as an upper bound, not a baseline.
- Rota variability is the biggest source of uncertainty — on-call can swing from £480/mo (April) to £1,433/mo (March). Wait for multiple months before drastic changes.
- Re-baseline fully each April (new tax year, full FY YTD visible on March payslip).
