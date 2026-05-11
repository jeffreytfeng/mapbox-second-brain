---
name: consolidate-profile
description: Roll dated-update sections in a Knowledge/People/<person>.md profile into the canonical sections, archive the raw bullets, and update the consolidation log. Use when the user types "/consolidate-profile", asks to "consolidate profiles", "clean up Anu's profile", or "roll up dated updates". Also invoked automatically by /learn when a profile is 30+ days stale.
argument-hint: "[person-slug | --all]  — e.g. /consolidate-profile anu-sharma  OR  /consolidate-profile --all"
user-invocable: true
version: 1.0.0
---

# Profile Consolidator

Profiles in `Knowledge/People/` grow by accumulating `## YYYY-MM-DD Update` sections every time `/learn` runs. Without consolidation, after ~6 months most of a profile is decayed bullets that no longer reflect current truth. This skill rolls those bullets into the canonical sections, archives the raw history, and stamps the consolidation log.

## When to invoke

- User explicitly types `/consolidate-profile <name>` or `/consolidate-profile --all`.
- `/learn` auto-invokes this skill when a profile is **≥30 days since last consolidation** AND has **≥1 new dated-update section** since then.

## Inputs

- `<person-slug>` — file basename in `Knowledge/People/` (e.g. `anu-sharma`, `jordan-parmer`). Use the slug without `.md`.
- `--all` — consolidate every profile that meets the 30-days-+-new-updates threshold (used by `/learn` auto-trigger and by manual quarterly sweeps).

If invoked with no argument, ask the user which profile or whether to do `--all`.

## Instructions

### 1. Identify scope

- If a single name is provided, target only that profile.
- If `--all`, read `Knowledge/People/.consolidation-log.md` and identify every profile that's ≥30 days stale AND has new dated-update sections since the logged date. Process each one in turn.

### 2. For each profile, audit before consolidating

Read `Knowledge/People/<name>.md`. Identify:

- The canonical sections at the top (Quick Facts, Career Background, Interaction Level, What they care about, How to work with them, Communication Style, Personal Notes — the exact set varies per profile).
- The trailing `## YYYY-MM-DD Update` sections that have accumulated.

Read `Knowledge/People/.consolidation-log.md` to find the last consolidation date for this person. Only consolidate dated-update sections **dated after the last consolidation** — leave older sections alone (they were either already consolidated, or are pre-system content the user wanted to preserve).

If the profile has **no dated-update sections newer than the last consolidation**, skip — update the log timestamp to today (so we don't re-check this profile until 30 more days pass) and move on.

### 3. Synthesize updates into canonical sections

Read the to-be-consolidated dated-update bullets. For each bullet, decide where it belongs in the canonical structure:

| Bullet topic | Canonical destination |
|---|---|
| New role/title/team/reports-to | **Quick Facts** |
| New career fact (past role surfaced, education) | **Career Background** |
| New cadence, new recurring meeting, OOO/leave plans | **Interaction Level** |
| New priority, opinion, or stance they've expressed | **What they care about** |
| New working pattern, ask, or directive for partnering with them | **How to work with them** |
| New observation about their tone, comms preferences | **Communication Style** |
| New personal context (family, location move, hobby) | **Personal Notes** |
| Time-bound or now-completed action items | **Drop** (these are stale by definition) |

**Synthesis rules:**

- **Merge, don't append.** If "What they care about" already says "values clarity on metrics tied to revenue" and the dated update says "asked me to define Northstar metric for Search Box" — that's the same insight, refined. Update the existing bullet, don't add a new one.
- **Promote durable patterns, demote one-off context.** A single mention of a preference is a data point; three mentions over multiple updates is a pattern that belongs in the canonical section.
- **Drop the date when integrating.** "On May 6, she said X" → "She prioritizes X." The date lives in the archive.
- **Preserve dissent.** If a dated update *contradicts* an existing canonical bullet (e.g. profile said "open to consumer apps," update said "explicitly does not want a consumer product"), the newer take wins but flag the contradiction in the consolidation report so the user can verify.
- **Don't over-summarize.** If a working note is genuinely specific and load-bearing (e.g. "the Christian → Peter escalation chain on Zeekr"), keep the specificity in the canonical section.

### 4. Archive the raw bullets

Append the consolidated dated-update sections (verbatim, before deletion) to `Knowledge/People/_archive/<name>-updates.md`:

```markdown
## Archived <consolidation-date>
*Consolidated by /consolidate-profile on <consolidation-date>. Source: pre-consolidation dated-update sections from <name>.md.*

<paste raw dated-update sections here, oldest-first>

---
```

Create the archive file if it doesn't exist. Order entries newest-archived-first (newest archive section at top).

### 5. Remove the dated-update sections from the live profile

Once archived and synthesized, delete the consolidated `## YYYY-MM-DD Update` sections from the live profile file. The canonical sections at the top now contain the integrated content; the archive preserves the raw history.

Leave any dated-update sections **dated before the last consolidation** untouched — those were either already consolidated or are pre-system content.

### 6. Update the consolidation log

Edit `Knowledge/People/.consolidation-log.md`:

```
<name>: <consolidation-date>
```

Update the existing line if the name is present; append if not. Maintain alphabetical order.

If the log file doesn't exist, create it with this header:

```markdown
# Profile Consolidation Log
*One line per person. `<name>: <last-consolidated-YYYY-MM-DD>`. Maintained by /consolidate-profile.*

```

### 7. Report

Tell the user, per profile consolidated:

- Person name and the date range of dated-update sections consolidated (e.g. "anu-sharma: rolled in 6 updates from 2026-04-22 to 2026-05-08")
- Which canonical sections got new content (just the section names, not the diff)
- Any contradictions surfaced (with the contradicting bullets quoted briefly)
- Confirmation the archive was written and the log updated

For `--all` runs, end with a short summary: "Consolidated N profiles; skipped M (no new updates since last consolidation)."

## What NOT to do

- **Don't auto-delete content** without archiving first. The archive is the safety net.
- **Don't consolidate updates dated before the last log entry.** Those are out of scope.
- **Don't rewrite canonical sections in your own voice** if the user has personalized them. Match the existing tone of the profile.
- **Don't merge across people.** A single run is one profile (or all profiles, processed independently).
- **Don't run if `Knowledge/People/` doesn't exist** in the current project. This skill is second-brain-specific; if the directory is missing, error gracefully and explain that the skill expects that path.

## Notes

- This skill is idempotent: running it twice in a row on the same profile is a no-op the second time (no new updates since the just-logged consolidation date).
- The 30-day cadence comes from /learn's auto-trigger threshold. Manual runs bypass that threshold — if the user explicitly invokes `/consolidate-profile`, do it regardless of date.
- For a quarterly sweep, just run `/consolidate-profile --all` — the log handles per-person staleness independently.
