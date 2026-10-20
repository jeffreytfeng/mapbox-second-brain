---
name: wbr-write
description: Draft one product area's weekly section (Business Update plus Opportunities, Risks, and Challenges) for your weekly business review (WBR) 2x2 doc, from the Mode weighted-usage scorecard and a sweep of Slack, Gmail, Jira, Drive, Granola and the KB, delivered as a new Google Doc to copy and paste. Works for any service org (Search, Navigation, Maps) or a custom set of service families. Use when the user types "/wbr-write", or asks to "write the WBR", "draft the 2x2 update", "do the weekly business update for <area>", or "fill in <area> in the WBR".
argument-hint: "<area: Search|Navigation|Maps|service families> [WBR date M/D/YY] [WBR doc URL]"
user-invocable: true
---

# WBR Write (any product area)

Draft the weekly 2x2 section for one product area. Readers are your leadership team. Output is a **new** Google Doc; never edit the WBR doc.

Read `reference.md` in this folder before Step 2. It holds the Mode API extraction code, the Docs import `$` fix, and dashboard quirks.

## Inputs

Parse `$ARGUMENTS`:
- **Area:** a service org (Search, Navigation, Maps) or an explicit list of Mode `SERVICE_FAMILY` values. If missing, ask.
- **WBR date:** defaults to the next Wednesday. The data week is the Saturday before it (e.g. WBR 10/21 covers the week ending Sat 10/17).
- **WBR doc:** if no URL is given, find `<your-wbr-doc-title> - <date>` in Drive (set the title pattern once in reference.md §5).

Check `Raw/.last-updated`. If it is more than 24h old, say so in one line and continue: this skill reads live sources anyway.

Keep a task list (update_plan) covering the steps below.

## Step 1: Learn the format from prior WBRs

- Export the current WBR doc and the 3 most recent prior versions to markdown (reference.md §5).
- Extract this area's Business Update and its ORC items from each. Note:
  - sentence order and number formatting (`$XK (+$XK, +X% WoW)`)
  - mover groupings (sub-headers per service family)
  - which lines are standard (e.g. Active Developer Accounts) vs occasional
  - owner formatting
- List last week's ORC items for this area. Each one must be carried forward or deliberately dropped.
- Look at sections other PMs have already filled in this week's doc, to match the current house style (e.g. "Next:" / "So what:" lines).

## Step 2: Pull the numbers (in parallel with Step 3)

From the Mode scorecard via Claude in Chrome (reference.md §1-2):
1. Screenshot the area's card and save it to disk. Its total, revenue categories and service families (each with REV, CHG, WoW, YoY) are the headline numbers.
2. Use the API aggregation for weekly totals, top account movers per service family, and the **restatement check** against last week's run.
3. **Active Developer Accounts (required):** from Tableau Existing vs New Active Developer Volumes, filtered to the area's Service Org with View Period = Weekly (reference.md §3). Read the latest week's Existing Active and Newly Active counts with WoW %, plus the service that drove the change.
4. Optional and supporting only: Tableau Weighted Usage, Product Business Metrics and Service Revenue. If a dashboard won't load in about 60s, skip it and log an open check.

Sanity-check: the area's family totals should sum to the card total.

## Step 3: Research ORC items and mover causes (background subagent)

Launch one general-purpose subagent in the background (read-only; no messages, edits or comments). Give it:
- the area, today's date and the 8-day window
- last week's ORC items, verbatim
- the top movers from Step 2, so it can look for causes

Its sources:
- `Knowledge/Customers/`, `Knowledge/Context/` (goals, strategic-context, and any leadership-expectations doc), `Tasks/active.md`, and `Raw/` files modified in the window
- Slack: search_public_and_private on customer names, launch names and Jira keys, plus the area's channels
- Gmail, Jira and Confluence (cloudId must be the UUID; no `comment` field), Drive via gws, and Granola meetings in the window

Ask for:
- 5-7 ranked items: type, headline, what changed with absolute dates, base and new values, next step with date, owner, source links, verified or inferred
- a "Revenue mover explanations" section
- a "Gaps" section

When it returns, spot-check the 2-3 heaviest claims yourself (reference.md §6).

## Step 4: Draft

**Business Update:**
- **Headline paragraph:** total with $ change, WoW and YoY; the main driver; each revenue category with $ change and WoW; each service family with WoW and YoY.
- Add one sentence isolating the biggest account ("Excluding X, <area> was ...") when one account drives most of the move.
- If the restatement check fired, add a highlighted note giving the old and new prior-week values.
- Card image.
- **Active Developer lines**, always, as two lines placed just before Biggest Movers:
  ```
  Active Developer Accounts: <N> (+X% WoW)
  Newly Active Developer Accounts: <N> (+X% WoW), mostly driven by <service> (<count>, +X% WoW).
  ```
  If the dashboard failed, keep the lines with a highlighted [VERIFY] rather than omitting them.
- **Biggest Movers** grouped by service family: 2-5 per family. Format: `**Account:** $X (+/-$X, +/-X% WoW, from $Y). Cause.` If the cause is unknown, highlight it as unknown, never invent one. Close the loop on anything last week predicted.

**Opportunities, Risks, and Challenges:** 4-6 items. For each:
- `[Risk|Opportunity|Challenge|Update]` plus a **bold headline that states the news**.
- Then 3-6 sentences:
  - what happened (dated)
  - base and new values
  - what we're doing
  - **Next:** with an absolute date
  - **So what:** one line on business impact
  - **Owner:** one named owner (others go in parentheses)

Apply your leadership's WBR expectations (if you keep them in `Knowledge/Context/`, read that file). The defaults below work well:
- bring a recommendation, not options
- absolute dates
- no benchmark without customer or usage evidence (report offline evals and live traffic side by side)
- no headcount asks
- no "Pricing TBD"

Where the call belongs to the user (a price point, an option choice), leave a highlighted `[<user> to fill in ...]` placeholder rather than deciding for them.

Writing rules: no em dashes anywhere. Lead with what changed. Short sentences. Leave confidential items (e.g. M&A) out of the draft and mention them only in the open checks.

## Step 5: Build the Google Doc

Follow reference.md §4: HTML with `\$` escapes, the card as a base64 image, highlighted [VERIFY] spans, upload with conversion, `replaceAllText` back to `$`, then verify (no equations, image present, no em dashes). Title: `<Area> WBR Update - <M/D/YY> (draft)`.

Doc layout:
1. Title, plus one italic line linking the WBR doc and naming the data week and source.
2. "Business Update (left cell)".
3. "Opportunities, Risks, and Challenges (right cell)".
4. "Sources and open checks": the dashboards and threads used, the [VERIFY] list, and anything left out on purpose.

Optionally screenshot the doc in Chrome to confirm it renders, then close the tab.

## Step 6: Report back

In chat:
- the doc link
- the headline numbers (one short list)
- the 3-4 things to know before pasting: restatements, data-honesty gaps, and calls only the user can make
- what was omitted and why
- a Sources line

Call wrap_up.
