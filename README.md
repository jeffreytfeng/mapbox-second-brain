# Mapbox Second Brain

A personal context-aware knowledge assistant that runs in Claude Code. Built by [@jeffreytfeng](https://github.com/jeffreytfeng) and shared with Mapbox colleagues. It keeps you in context across all your projects by syncing Gmail, Google Calendar, Google Drive, and Slack into a searchable local Knowledge Base (KB), and then providing relevant context into every Claude Code or Claude Co-Work prompt.

## What you get

- **A KB skeleton** at `~/Documents/second-brain/` (`Knowledge/Context/` for your role + goals, `Knowledge/People/` for stakeholders, `Knowledge/Reference/` with Mapbox company + product context, `Raw/` as the synced source-of-truth cache, `Tasks/` for active work, `Templates/` for reusable PM docs)
- **13 skills** packaged as a local Claude Code plugin: `/update`, `/learn`, `/sync`, `/retro`, `/morning-brief`, `/my-voice`, `/meeting-prep`, `/weekly-update`, `/prd-write`, `/draft-prfaq-section`, `/synthesize-research`, `/strategy-doc-review`, `/cherie-reviewer` (pressure-test OP/strategy docs against Cherie Wong's review gates before sharing)
- **A UserPromptSubmit hook** that searches your KB on every prompt and injects relevant snippets so Claude has context without you having to paste it
- **An auto-memory system** that captures preferences, gotchas, and project facts across sessions

## Before you start

Add the four MCP connectors at [claude.ai/customize/connectors](https://claude.ai/customize/connectors):
- Google Drive
- Gmail
- Google Calendar
- Slack

Adding the connector at claude.ai is a one-time prereq; the OAuth handshake (run via `/mcp` in Claude Code) is part of the setup interview.

## Three-step setup

```bash
# 1. Clone
git clone https://github.com/jeffreytfeng/mapbox-second-brain.git
cd mapbox-second-brain

# 2. Install
./install.sh

# 3. Open Claude Code at ~/Documents/second-brain/ and paste the contents of SETUP_PROMPT.md
```

`install.sh` copies the skeleton into `~/Documents/second-brain/`, installs the plugin into `~/.claude/plugins/local/mapbox-second-brain/`, copies the hook to `~/.claude/hooks/`, and safe-merges marketplace + plugin entries into your Claude settings. It refuses to overwrite an existing `~/Documents/second-brain/` — back up first if you have one.

`SETUP_PROMPT.md` is a paste-into-Claude-Code interview that walks you through customization in 7 phases (verify install → interview → connect MCP → distill context → validate hook → verify learning loop → set up morning brief). Phase 0 sanity-checks the install before doing anything destructive.

If you'd rather install manually, see [INSTALL.md](INSTALL.md).

## Prerequisites

- macOS (some bits assume it; `launchctl`-related notes are macOS-flavored)
- Claude Code CLI ([install](https://docs.anthropic.com/claude/docs/claude-code))
- Bun (`curl -fsSL https://bun.sh/install | bash`) — needed for `qmd`
- `qmd` ([github.com/tobi/qmd](https://github.com/tobi/qmd)) — `bun install -g qmd`. Used for KB indexing and search.
- Python 3 (ships with macOS)
- A Mapbox Google Workspace + Slack account, connected as MCP connectors via [claude.ai/customize/connectors](https://claude.ai/customize/connectors). The setup prompt walks you through OAuth via `/mcp`.

## Repo layout

```
mapbox-second-brain/
├── README.md             # this file
├── SETUP_PROMPT.md       # paste into Claude Code after install.sh
├── INSTALL.md            # manual install fallback
├── install.sh            # one-shot installer
├── knowledge-base/       # → ~/Documents/second-brain/
│   ├── CLAUDE.md
│   ├── Knowledge/
│   │   ├── Context/      # stub files — your role, goals, growth edges
│   │   ├── People/       # one .md per stakeholder
│   │   └── Reference/    # Mapbox company + product context (verbatim)
│   ├── Raw/              # synced source-of-truth cache
│   ├── Tasks/
│   └── Templates/        # PRD, PRFAQ, 1on1, weekly update, etc.
└── claude-plugin/        # → ~/.claude/plugins/local/mapbox-second-brain/
    ├── .claude-plugin/
    │   ├── marketplace.json
    │   └── plugin.json
    ├── skills/           # 13 skills (SKILL.md per skill)
    └── hooks/
        ├── hooks.json
        └── context-enrichment.sh
```

## Daily workflow once set up

- **Morning:** the cloud morning-brief routine emails your daily brief at 7am. Read it.
- **During the day:** Claude Code prompts get auto-enriched with KB context via the hook. You don't have to do anything.
- **End of day:** `/sync` (runs `/update` + `/learn`). Pulls fresh email/Slack/Drive into `Raw/`, captures session learnings to memory, refreshes the Drive context doc the morning-brief routine reads from.
- **End of month:** `/retro` for a structured reflection.

## Customizing it

Everything is meant to be modifiable. The skills are short, dependency-free SKILL.md files — open `~/.claude/plugins/local/mapbox-second-brain/skills/<skill>/SKILL.md` and edit. The hook is one shell script. The KB structure is just markdown files in folders. Nothing magic.

If you change a skill, restart your Claude Code session for the change to take effect.

## Known gotchas

- **Slack MCP requires OAuth.** Showing up in the connector list doesn't mean it's authenticated. Run `/mcp` and complete the browser flow.
- **Drive `modifiedTime` needs full ISO 8601 with `Z`.** `2026-04-29T03:52:00.000Z`, not `2026-04-29T03:52:00`.
- **`qmd collection add Raw` (capital R) creates a duplicate.** Use lowercase or skip after the first run.
- **Cloud routines have no local filesystem access.** That's why the `/learn` skill pushes a context doc to Google Drive — it's the bridge.
- **DST.** Cron expressions are UTC. When DST starts/ends, update the morning-brief cron at `https://claude.ai/code/routines/<routine-id>` or it'll drift one hour.

## License & contributions

This is a personal-productivity setup shared with colleagues. Fork it, edit it, share improvements back. No formal license — treat it as MIT-equivalent for Mapbox-internal use.

Issues and PRs welcome at [github.com/jeffreytfeng/mapbox-second-brain](https://github.com/jeffreytfeng/mapbox-second-brain).
