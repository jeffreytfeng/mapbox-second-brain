# Knowledge/People/

This folder holds one Markdown file per person you work with regularly. Each file is the canonical home for everything about that individual — preferences, history, recent updates, asks they've made, sensitivities to be aware of.

`Knowledge/Context/team-context.md` is an **index only**. Person-level detail lives here, not there.

## Why per-person files?

- Skills like `/meeting-prep` look up the person by filename and load their full context before drafting
- The `/learn` skill auto-appends dated updates after each session where the person came up
- Keeps team-context.md from growing into a wall of text

## File naming

Use lowercase first-last with hyphens, `.md` extension. Match the slug convention so skills can find files programmatically.

Examples:
- `jane-smith.md`
- `carlos-ruiz-perez.md`

If two people share a name, append a disambiguator: `jane-smith-eng.md`.

## File format

Use the skeleton below. Skills update the **Recent Updates** section automatically; the rest you maintain by hand or via `/learn`.

```markdown
# <Full Name>

**Role:** <Title at company>
**Team:** <Team name>
**Relationship to me:** Manager | Skip-level | Peer PM | Engineering partner | Designer | etc.
**Located:** <City / timezone>
**LinkedIn:** <URL or "not confirmed">

---

## Quick Facts

- **Reports to:** <name>
- **Manages:** <names or count>
- **At company since:** <year>
- **Prior roles:** <one-line summary>

---

## How They Work

- **Communication preferences:** <Slack vs email, how fast they respond, tone they expect>
- **Decision style:** <data-driven, intuition-led, consensus-seeking, etc.>
- **What they value in a partner:** <observed pattern>
- **What frustrates them:** <observed pattern — kept honest, not gossipy>

---

## What They Care About

<!-- Their stated priorities, OKRs, the metrics they push on, the bets they own -->

- <bullet>
- <bullet>

---

## Career Background

| Years | Role | Company |
|-------|------|---------|
|  |  |  |

---

## Recent Updates

<!-- /learn appends dated entries here automatically. Format:

## [YYYY-MM-DD] Update
- <new context>
- <new context>

Keep entries short — one bullet per actual change. Don't log routine status updates.
-->
```

## Example skeleton (copy when creating a new file)

The block above is the working template — copy it into a new file, fill in what you know, and let `/learn` add dated updates over time.

## What NOT to put here

- Private/sensitive notes that shouldn't be in a synced KB (use a local secure note instead)
- One-time meeting logistics (those go in `Raw/` digests)
- Org-level customer or team dynamics — those belong in `Knowledge/Context/team-context.md`
