# /update — Backfill & Wide-Window Audit Playbook

Read this file only when doing a **historical backfill** or **wide-window audit** of Meet Recordings — re-checking a multi-week or multi-month range, not a routine day-to-day `/update` run. It holds the incident history and procedures that justify the guardrails in the main `SKILL.md`, kept out of the routine path so they don't load on every run.

---

## Why Step 1.5 is mandatory every run

A real run once skipped the Meet Recordings folder scan entirely, reasoning "meeting notes are already covered by `/granola-sync`." That reasoning is always wrong: `/granola-sync` only handles notes you captured in Granola (tracked separately in `Raw/granola-sync-state.json`) — it has no visibility into Gemini's independent auto-notes for meetings not run through Granola. A follow-up two-week audit after that incident found 12 more missed meetings, one of which carried a critical data-quality decision. If a run ever catches itself thinking "this is probably already covered," that is the exact failure mode — stop and run the scan for real. Log incidents like this as a "Backfill correction" entry in `Raw/meet-recordings-index.md` so there's a record.

## Drive shortcut ID instability

Drive shortcut target IDs are not stable over time — an ID-only dedup check produces false "gap" positives on historical audits. A three-month deep audit found the same meeting logged under two *different* target IDs across two separate historical sync entries in the same index — the shortcut had been recreated at some point, silently changing its `targetId`.

On a routine day-to-day `/update` run this doesn't matter (the cutoff window is narrow enough that IDs are fresh). But on a historical backfill or wide-range audit, **dedup by date + meeting title first, not ID alone** — check `Raw/meet-recordings-index.md` and the relevant person/topic file for a matching date before concluding something is missing. Treat an ID-only "NOT_FOUND" result across a wide historical window as a hypothesis to verify by title, not a confirmed gap.

## Why deferrals get reconciled every run

Syncs have a track record of explicitly deferring a meeting to "next sync" and then silently dropping it — the promise gets made in one run's index entry and never checked against what the following run actually captured. This is why `SKILL.md` Step 1.5h requires closing that loop on every run, not just during backfills.

---

## Pinned folders beyond Meet Recordings

Not every meeting-notes doc lives in the Meet Recordings folder. Google (or you) may organize notes into other dedicated folders that the folder-scan in 1.5a never touches. **List pinned folders here as you discover them** — one bullet each, with the folder ID and its internal structure. Patterns seen so far:

- **"1:1s" folder** — `<your-1on1-folder-id>`. A **persistent, cumulative notes doc per person**: Gemini appends new dated sections to the same doc across that person's recurring 1:1 series, rather than creating a new doc per meeting instance as it does in Meet Recordings. Title pattern `<Person> / <You> 1:1 Meeting Notes` or `Notes - <Person> / <You>`. `modifiedTime` reflects the *last* update, not creation — a doc modified months ago may still be the single source of truth for that person's early 1:1s.
- **"Meeting Notes" folder** — `<your-meeting-notes-folder-id>`. A **mixed-content** folder: direct Gemini-notes docs and shortcuts for one-off/multi-person meetings, possibly subfolders of your own self-authored synthesis docs (derived from already-captured KB content, not primary sources; skip them), and shortcuts to shared team-wide living documents (see below).
- **Shared/recurring team-wide living docs** (e.g. a staff-meeting "Agenda and Notes" doc, often found as shortcuts inside "Meeting Notes") — one continuously-updated doc shared across an entire team/org for a whole year, not person- or meeting-specific. Do not do a full read of these by default — they're large, mostly about other people's agenda items, and low marginal value for a single person's KB. Only read a targeted section if a specific date/topic needs verification (e.g. searching within the doc for a known meeting date).

**Backfill procedure:**
1. **"1:1s"**: `search_files` with `parentId = '<your-1on1-folder-id>'`, then **read every single person's doc in full — not a sample, not a spot-check of a subset**. One audit that initially spot-checked only a few people missed genuine gaps (8 missing dated sections for one person alone); the follow-up full read of all ~34 people found real content missing for 7 more. For each person, compare **every dated section** in their cumulative doc against `Raw/<person>-1on1-notes.md` by date — a file existing for a person is not proof their content is complete.
2. **"Meeting Notes"**: `search_files` with `parentId = '<your-meeting-notes-folder-id>'`, read each direct doc and resolve each shortcut's `targetId` via `gws` (the Drive MCP returns empty content for shortcuts). Cross-check each by date/title before assuming it's new (dedup by date + title, not ID — a shortcut here may point to a target already captured under a different path).
3. New people found in the "1:1s" folder with no existing `Raw/` file at all are a strong signal of a genuine gap (a single audit surfaced three, all with real, substantive first-1:1 content that had never been captured anywhere). Create a new `<person>-1on1-notes.md` file per the existing 1:1 naming convention.
4. **Periodically re-run Drive-wide folder discovery** (not just rely on the pinned list above) in case you create a new dedicated folder: search Drive for folders titled like "Meeting Notes," "1:1(s)," "Notes," etc. Scope the search to the same parent folder as the known pinned folders rather than searching all of Drive — an unscoped Drive-wide search returns heavy noise (local "My Mac" sync mirrors, unrelated scratch/temp folders). Add any newly-found pinned folder to the list above with a one-line description of its internal structure.

---

## Calendar-invite attachments cross-check (tertiary, backfill only)

On a routine day-to-day `/update` run, the Meet Recordings folder scan plus the Gmail fallback catch essentially everything — skip this entirely. It exists for **historical backfills or wide-window audits**, where one audit found a large cross-functional contract-negotiation meeting that had **no Meet Recordings folder shortcut at all** and **no matching Gmail gemini-notes email in the standard search** — it only surfaced by directly enumerating calendar events and reading their `attachments` field for a "Notes by Gemini"/"Notes by Granola" link.

If doing a wide-window audit:
1. Pull calendar events for the window via `list_events` (the Calendar MCP truncates large ranges — pull in ~2-week chunks and extract with `jq`/python rather than reading the raw tool output).
2. For each event, check `attachments[].title` for `Notes by Gemini` or `Notes by Granola`; extract the Drive doc ID from `attachments[].fileUrl`.
3. Dedup against everything already known **by date + title, not ID alone** (see the ID-instability section above) — the overwhelming majority of hits will be meetings already captured under a different historical ID.
4. Only chase down genuinely-unmatched titles. Expect most of what's left after dedup to be low-stakes single 1:1s or already-covered recurring meetings; a few will be real, high-value gaps.
