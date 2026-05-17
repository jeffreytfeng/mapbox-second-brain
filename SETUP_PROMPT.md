# Second Brain Setup — paste this into Claude Code

I cloned the `mapbox-second-brain` repo and ran `install.sh`. That put the KB skeleton at `~/Documents/second-brain/`, the plugin at `~/.claude/plugins/local/mapbox-second-brain/`, the context-enrichment hook in `~/.claude/hooks/`, and merged the relevant entries into my Claude Code settings.

Your job is to walk me through customizing it — interview me, build my profile, test the connectors, set up the daily morning brief. We'll do this in 7 phases. Don't skip ahead. Confirm each phase works before moving on.

## Phase 0: Verify the install

Sanity check before we start. Run these and report what's missing:

1. `ls ~/Documents/second-brain/` — confirm `Knowledge/`, `Raw/`, `Tasks/`, `Templates/`, `CLAUDE.md`; inside `Knowledge/` confirm `Context/`, `People/`, `Customers/`, `Reference/`
2. `ls ~/.claude/plugins/local/mapbox-second-brain/` — confirm `skills/` and `hooks/`
3. Check `~/.claude/settings.json` — confirm the `mapbox-second-brain` marketplace and `second-brain` plugin are enabled
4. Check `~/.claude/settings.local.json` — confirm a UserPromptSubmit hook pointing at `~/.claude/hooks/context-enrichment.sh` is registered
5. `which qmd` — confirm qmd is on PATH; if not, install with `bun install -g qmd`
6. `qmd collection list` — confirm `raw` collection exists; if not, run `qmd collection add Documents/second-brain/Raw` (lowercase only — capital R creates a duplicate)

If anything is missing, stop and tell me what to fix.

## Phase 1: Interview me & write `me.md`

Interview me conversationally — 5–7 questions max, no template. Cover:

- Who I am (role, company, who I report to, who reports to me)
- What I'm optimizing for this quarter (goals, key metrics, hard deadlines)
- My working style (tools I live in, how I prefer to communicate, what frustrates me)
- Growth edges (feedback patterns, things I want to break)
- Top 5–10 stakeholders by name and role (we'll build profiles for them in Phase 3)
- Things I care about outside work (helps personalize recommendations)

Write `~/Documents/second-brain/Knowledge/Context/me.md` when you have enough. Show it to me before saving — I want to edit before it's committed.

## Phase 2: Connect MCP, seed the KB, test search

1. Tell me to run `/mcp` and authenticate **Google Drive, Gmail, Google Calendar, and Slack**. Wait for me to confirm. Watch out: showing up in the connector list ≠ authenticated. The real tools (`slack_search_public_and_private`, etc.) only appear after OAuth completes.
2. Run `/update`. First run uses a 14-day cutoff. It'll:
   - Scan Google Drive for relevant work files
   - Summarize Gmail threads from `@<my-company-domain>` (ask me what to use)
   - Summarize Slack from subscribed channels + DMs
   - Re-index qmd
3. **Test the KB.** Ask me for 3 things I remember working on. Search with both `qmd search` (keyword) and `qmd vsearch` (semantic). Show me both. If results are bad, suggest tightening the relevance filter in `update/SKILL.md` before moving on.
4. Optional: ask if I want to run `/my-voice` now. It analyzes past Drive docs/emails/Slack to build a voice profile at `Knowledge/Context/my-voice.md`. Skip if I have <2 weeks of writing in connected sources — not enough signal.

## Phase 3: Distill `Knowledge/Context/` + build `Knowledge/People/`

For each `Context/*.md` stub, search the KB extensively (10+ queries mixing keyword and semantic), cite specific source documents in the file, and flag where you're inferring vs. quoting. **Do them one at a time.** After each, show me the draft, get my edits, then move on:

1. `strategic-context.md` — company/team direction
2. `role-context.md` — my responsibilities, deliverables, reporting line
3. `goals.md` — OKRs, key metrics, ownership table
4. `historical-context.md` — past decisions, pivots, lessons
5. `personal-growth.md` — feedback patterns, coaching themes
6. `team-context.md` — **INDEX ONLY** — bulleted list of links to `Knowledge/People/<person>.md`. Do NOT put person-level detail here.

Then `Knowledge/People/<person>.md` — one file per stakeholder I named in Phase 1 plus anyone who appears in 3+ KB results. Use `Knowledge/People/README.md` for format. Always attempt a LinkedIn lookup for new profiles (`site:linkedin.com "Name" <company>`); skip the URL if confidence is low.

Then `Knowledge/Customers/<customer>.md` — one file per key account or OEM customer that appeared in the synced KB content. Use `Knowledge/Customers/_template.md` for the format. The `/update` skill (Step 3.5) will auto-populate these on every sync run; create profiles manually here for any strategic accounts that are already known.

## Phase 4: Validate the context-enrichment hook

The hook is already installed. Test it:

1. I'll type a deliberately vague prompt referring to something in my KB ("what was that thing about [vague topic]")
2. Confirm a `<context>` block shows up in the prompt payload (you see it; I don't see it in chat)
3. If results are noisy or irrelevant, propose specific tweaks to `~/.claude/hooks/context-enrichment.sh` — usually: tighten the term extractor, cap result count, or filter stopwords.

## Phase 5: Verify the learning loop

Walk me through each skill once so I know what they do:

- `/sync` — runs `/update` then `/learn` in sequence. End-of-day command.
- `/learn` — captures conversation insights to `~/.claude/projects/-Users-<username>-Documents-second-brain/memory/`, updates `Knowledge/People/` profiles for anyone mentioned, and **pushes a fresh `<my-name> — Second Brain Context (Morning Brief)` doc to Google Drive**. That Drive doc is the bridge that lets the cloud morning-brief agent read my KB — it has no local filesystem access. If `/learn` Step 5 stops running, the morning brief goes stale.
- `/retro` — monthly reflection. Don't run today; just show me where it lives.

Show me `~/.claude/projects/-Users-<username>-Documents-second-brain/memory/MEMORY.md`. Auto-memory grows here over time. The index file is loaded into every session.

## Phase 6: Set up the daily morning-brief cloud routine

The morning brief runs as a remote scheduled agent (NOT a local cron). It needs MCP access to Calendar/Gmail/Slack/Drive — only a Claude session has those. A shell script literally cannot do this.

1. Confirm Slack is authenticated (Phase 2). If not, the routine will skip Slack.
2. Confirm `/learn` ran at least once and there's a `<my-name> — Second Brain Context (Morning Brief)` doc in my Google Drive. The cloud agent reads from this — without it, the brief has no context.
3. Run `/schedule` and create:
   - **Name:** "Morning Brief"
   - **Cron:** convert "7am my local time, weekdays" to UTC. Confirm the conversion with me before creating. Reminder: cron is UTC, so DST shifts will require updating the cron twice a year.
   - **Model:** claude-sonnet-4-6
   - **Connectors:** Gmail, Google Calendar, Google Drive, Slack
   - **Prompt:** based on `~/.claude/plugins/local/mapbox-second-brain/skills/morning-brief/SKILL.md`, with these overrides for the cloud context:
     - **Replace step 0 (Load context)** with: "Search Drive for files titled `<my-name> — Second Brain Context (Morning Brief)` and read the most recently modified one — this is the canonical source. The agent has NO local filesystem access, so this Drive doc replaces local `Tasks/active.md`, `goals.md`, `role-context.md`, etc."
     - **Replace step 7 (Write to morning-brief.md)** — the cloud agent has no local filesystem; do NOT try to write a local file. Instead:
       - **Send** the brief via Gmail (auto-send, not draft) to `<my-email>` with subject `Morning Brief — [Weekday, Month Day]`
       - **Save** a copy as a Google Drive doc titled `Morning Brief — YYYY-MM-DD`
4. Show me the routine ID. Save it as a project memory: `project_morning_brief.md`.

## Phase 7: First-week instructions

Tell me how to live with this thing:

- End of day: `/sync` (combines `/update` + `/learn`)
- On demand: `/morning-brief` for an interactive brief (separate from the daily cloud routine)
- After 1 week: `/retro` won't have a month yet, but `/learn` will have built up auto-memory — peek at `MEMORY.md` to see what stuck
- Periodic cleanup: old `Morning Brief — YYYY-MM-DD` Drive docs accumulate; delete manually monthly
- If Slack stops appearing in briefs: re-auth via `/mcp` (tokens expire)
- DST: when it ends/begins, update the morning-brief cron at `https://claude.ai/code/routines/<routine-id>`

## Rules for this whole process

- Ask before running anything that touches OAuth, the filesystem outside `~/Documents/second-brain/` and `~/.claude/`, or `/schedule`
- Show me file content before writing it. Every Context/ and People/ file gets reviewed.
- If something fails, diagnose root cause; don't retry blindly. Propose 2 alternatives.
- No over-engineering. These skills are short scripts on purpose, not frameworks.
- Known gotchas:
  - Slack MCP needs `/mcp` OAuth — auth tools in the deferred list ≠ authenticated
  - Drive `modifiedTime` filters need full ISO 8601 + `Z` (e.g., `2026-04-29T03:52:00.000Z`)
  - `qmd collection add Raw` (capital R) creates a duplicate collection — pass lowercase or skip after first run
  - Remote cloud routines have NO local filesystem access — they read from Drive only
  - macOS `launchctl` calls are blocked by the Claude Code harness — if needed, ask me to run them via `! command` in the prompt

Start with Phase 0. Verify the install. Then move to Phase 1.
