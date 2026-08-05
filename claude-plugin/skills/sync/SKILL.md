---
name: sync
description: Full close-of-day sync — runs /granola-sync (meeting notes), then /update (external sources), then /learn (conversation insights). Use this instead of running all three manually.
user-invocable: true
---

# /sync — Full Sync

Run `/granola-sync`, then `/update`, then `/learn`, in that order. This is the end-of-session (and nightly-automation) command that pulls Granola meeting notes into Drive, pulls the outside world into the second-brain, and captures what was learned in this conversation.

Granola-sync runs first so that any meeting docs it creates in the Meet Recordings folders are already in Drive by the time /update does its Drive scan — that way the new notes get indexed into `Raw/` and qmd in the same run instead of waiting for tomorrow's sync.

## When to use

| Command | When |
|---------|------|
| `/sync` | End of day, nightly automation, or end of any session where you want meeting notes, external data, and conversation insights all captured |
| `/granola-sync` | Just want Granola notes copied to Drive, nothing else |
| `/update` | Morning refresh — no conversation to learn from yet |
| `/learn` | Mid-session — something important surfaced, no need to pull external data |

## Step 1: Run /granola-sync

Execute all steps from the `/granola-sync` skill in full — pulls new Granola meetings since last sync, classifies work vs. personal, matches work notes to the calendar, and creates docs in the work or personal Meet Recordings folder as appropriate. See that skill for the full workflow and guardrails (state file, dedupe, exclusion criteria).

If you don't use Granola, skip this step and say so in the report.

## Step 2: Run /update

Execute all steps from the `/update` skill in full:
- Establish cutoff from `Raw/last-updated.md`
- Scan `~/Google Drive/My Drive/` and Drive MCP for new/updated files → export to `Raw/`
- Summarize Gmail threads → `Raw/gmail-digest-<date>.md`
- Summarize Slack channels and DMs → `Raw/slack-digest-<date>.md`
- Update `Tasks/active.md` with new action items and status changes
- Re-index with `qmd collection add` + `qmd update` + `qmd embed`
- Write timestamp to BOTH `Raw/last-updated.md` AND `Raw/.last-updated` (identical content — never skip, even on a no-new-content run)

## Step 3: Run /learn

Execute all steps from the `/learn` skill in full:
- Review the current conversation for mistakes, surprises, validated approaches, new facts
- Update `memory/` files (feedback, project, user profile)
- Update `Knowledge/People/` profiles for anyone who surfaced in the session
- Update `~/.claude/CLAUDE.md` if there are persistent tool gotchas

Note: when `/sync` runs as an unattended nightly job (no live conversation), there's nothing for `/learn` to review — skip it silently and say so in the report rather than fabricating learnings.

## Step 4: Combined report

Output a single summary covering all three:

```
## Sync complete — <date>

### Meeting notes (/granola-sync)
- Work notes synced: N (linked), M no calendar match
- Personal notes synced: N (linked)
- Excluded/skipped: [what and why]

### External sources (/update)
- Drive: N files exported/updated
- Gmail: N threads summarized
- Slack: N threads summarized, from N channels
- Customers: N profiles updated, N net-new profiles created
- Tasks: N new items, N status updates
- KB: indexed N new, N updated

### Session learnings (/learn)
- Saved: [what and where]
- People profiles updated: [who]
- Skipped: [what and why, or "skipped — unattended run, no conversation to review"]
```

Keep the report concise. One combined block, not three separate reports.
