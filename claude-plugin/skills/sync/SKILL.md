---
name: sync
description: Full close-of-day sync — runs /update (external sources) then /learn (conversation insights). Use this instead of running both manually.
user-invocable: true
---

# /sync — Full Sync

Run `/update` followed by `/learn` in sequence. This is the end-of-session command that both pulls the outside world into the second-brain and captures what was learned in this conversation.

## When to use

| Command | When |
|---------|------|
| `/sync` | End of day, or end of any session where you want both external data and conversation insights captured |
| `/update` | Morning refresh — no conversation to learn from yet |
| `/learn` | Mid-session — something important surfaced, no need to pull external data |

## Step 1: Run /update

Execute all steps from the `/update` skill in full:
- Establish cutoff from `Raw/last-updated.md`
- Scan `~/Google Drive/` and Drive MCP for new/updated files → export to `Raw/`
- Summarize Gmail threads → `Raw/gmail-digest-<date>.md`
- Summarize Slack channels and DMs → `Raw/slack-digest-<date>.md`
- Update `Tasks/active.md` with new action items and status changes
- Re-index with `qmd collection add` + `qmd update`
- Write timestamp to `Raw/last-updated.md`

## Step 2: Run /learn

Execute all steps from the `/learn` skill in full:
- Review the current conversation for mistakes, surprises, validated approaches, new facts
- Update `memory/` files (feedback, project, user profile)
- Update `Knowledge/People/` profiles for anyone who surfaced in the session
- Update `~/.claude/CLAUDE.md` if there are persistent tool gotchas

## Step 3: Combined report

Output a single summary covering both:

```
## Sync complete — <date>

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
- Skipped: [what and why]
```

Keep the report concise. One combined block, not two separate reports.
