# Mapbox Second Brain

A personal context-aware knowledge assistant that runs in Claude Code. Built by [@jeffreytfeng](https://github.com/jeffreytfeng) and shared with Mapbox colleagues. It keeps you in context across all your projects by syncing Gmail, Google Calendar, Google Drive, and Slack into a searchable local Knowledge Base (KB), and then providing relevant context into every Claude Code or Claude Co-Work prompt.

## What you get

- **A KB skeleton** at `~/Documents/second-brain/` (`Knowledge/Context/` for your role + goals, `Knowledge/People/` for stakeholders, `Knowledge/Customers/` for customer accounts — one `.md` per customer, auto-updated on every sync, `Knowledge/Reference/` with Mapbox company + product context, `Raw/` as the synced source-of-truth cache, `Tasks/` for active work, `Templates/` for reusable PM docs)
- **19 skills** packaged as a local Claude Code plugin: `/update`, `/learn`, `/sync`, `/granola-sync` (copy Granola meeting notes into Drive, split work vs. personal, named to match the calendar event), `/retro`, `/morning-brief`, `/my-voice`, `/meeting-prep`, `/weekly-update`, `/prd-write`, `/prfaq-write` (draft any PRFAQ section + critique for unsupported claims and weak arguments), `/synthesize-research`, `/strategy-doc-review`, `/cherie-reviewer` (pressure-test OP/strategy docs against Cherie Wong's review gates before sharing), `/consolidate-profile` (roll dated updates in a stakeholder profile into its canonical sections), `/llm-council` (pressure-test any decision through 5 AI advisors with anonymous peer review, per Karpathy's LLM Council method), `/reply` (triage what's waiting on you across Slack, Gmail, and Jira, then draft replies in your voice as native drafts you review and send yourself; never sends), `/no-ai-slop` (edit, compose, or audit writing to strip AI-sounding patterns while keeping your voice), `/wbr-write` (draft your product area's weekly WBR 2x2 section: Business Update from the Mode weighted-usage scorecard plus risks and opportunities from Slack, Gmail, Jira, Drive and Granola, delivered as a Google Doc to paste)
- **A UserPromptSubmit hook** that searches your KB on every prompt and injects relevant snippets so Claude has context without you having to paste it
- **An auto-memory system** that captures preferences, gotchas, and project facts across sessions

## Before you start

Add the four MCP connectors at [claude.ai/customize/connectors](https://claude.ai/customize/connectors):
- Google Drive
- Gmail
- Google Calendar
- Slack

Adding the connector at claude.ai is a one-time prereq; the OAuth handshake (run via `/mcp` in the Claude Code terminal, or from the connector settings in the Claude desktop app) is part of the setup interview.

## Easiest: let Claude install it

Open Claude Code in any folder and paste this. Claude checks prerequisites, clones the repo, reads and runs `install.sh`, and tells you when to restart. It asks before installing anything.

```text
Help me install https://github.com/jeffreytfeng/mapbox-second-brain. Ask before installing anything or changing files outside the clone.

1. Check the prerequisites in its README (macOS, python3, bun, qmd, gws). Tell me what's missing, offer to install bun and qmd, and walk me through installing and authenticating gws (the auth step opens my browser).
2. Ask me to confirm I've added the Google Drive, Gmail, Google Calendar and Slack connectors at claude.ai/customize/connectors. You can't do this part for me.
3. If ~/Documents/second-brain already exists, stop and ask me before going further.
4. Clone the repo to ~/mapbox-second-brain, read install.sh and summarize what it will change, then run it.
5. Check that ~/.claude/settings.json now has mapbox-second-brain under extraKnownMarketplaces and second-brain@mapbox-second-brain under enabledPlugins.
6. Tell me to quit and reopen Claude Code in ~/Documents/second-brain (plugins load at session start) and paste the contents of SETUP_PROMPT.md to start the guided setup.
```

## Or install it yourself

```bash
# 1. Clone
git clone https://github.com/jeffreytfeng/mapbox-second-brain.git
cd mapbox-second-brain

# 2. Install
./install.sh

# 3. Quit and reopen Claude Code at ~/Documents/second-brain/, then paste the contents of SETUP_PROMPT.md
```

`install.sh` copies the skeleton into `~/Documents/second-brain/`, installs the plugin (skills plus the context-enrichment hook) into `~/.claude/plugins/local/mapbox-second-brain/`, and safe-merges the marketplace + plugin entries into `~/.claude/settings.json`. It warns about missing prerequisites and never overwrites an existing `~/Documents/second-brain/` or skills you've customized, so it's safe to re-run.

`SETUP_PROMPT.md` is a paste-into-Claude-Code interview that walks you through customization in 7 phases (verify install → interview → connect MCP → distill context → validate hook → verify learning loop → set up morning brief). Phase 0 sanity-checks the install before doing anything destructive.

If you'd rather install manually, see [INSTALL.md](INSTALL.md).

## Prerequisites

- macOS (some bits assume it; `launchctl`-related notes are macOS-flavored)
- Claude Code CLI ([install](https://docs.anthropic.com/claude/docs/claude-code))
- Bun (`curl -fsSL https://bun.sh/install | bash`) — needed for `qmd`
- `qmd` ([github.com/tobi/qmd](https://github.com/tobi/qmd)) — `bun install -g @tobilu/qmd`. Used for KB indexing and search.
- Python 3 (ships with macOS)
- `gws` (Google Workspace CLI) — **required**. `/update` uses it to read Gemini meeting notes and resolve Meet-recording shortcuts that the Drive MCP can't. Install from [mapbox/claude-plugins/gws](https://github.com/mapbox/claude-plugins/tree/main/gws) and follow the [gws User Setup Guide](https://mapbox.atlassian.net/wiki/spaces/KB/pages/2624880645/Google+Workspace+CLI+gws+User+Setup+Guide) to authenticate.
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
│   │   ├── Customers/    # one .md per customer account; auto-updated on /sync + /learn + /update
│   │   └── Reference/    # Mapbox company + product context (verbatim)
│   ├── Raw/              # synced source-of-truth cache
│   ├── Tasks/
│   └── Templates/        # PRD, PRFAQ, 1on1, weekly update, etc.
└── claude-plugin/        # → ~/.claude/plugins/local/mapbox-second-brain/
    ├── .claude-plugin/
    │   ├── marketplace.json
    │   └── plugin.json
    ├── skills/           # 19 skills (SKILL.md per skill)
    └── hooks/
        ├── hooks.json
        └── context-enrichment.sh
```

## Daily workflow once set up

- **Morning:** the cloud morning-brief routine DMs your daily brief to you on Slack at 7am (Gmail send is disabled by Mapbox org policy). Read it.
- **During the day:** Claude Code prompts get auto-enriched with KB context via the hook. You don't have to do anything.
- **End of day:** `/sync` (runs `/granola-sync` + `/update` + `/learn`). Copies Granola meeting notes into Drive, pulls fresh email/Slack/Drive into `Raw/`, captures session learnings to memory, refreshes the Drive context doc the morning-brief routine reads from.
- **End of month:** `/retro` for a structured reflection.

## Customizing it

Everything is meant to be modifiable. The skills are short, dependency-free SKILL.md files — open `~/.claude/plugins/local/mapbox-second-brain/skills/<skill>/SKILL.md` and edit. The hook is one shell script at `~/.claude/plugins/local/mapbox-second-brain/hooks/context-enrichment.sh`. The KB structure is just markdown files in folders. Nothing magic.

If you change a skill, restart your Claude Code session for the change to take effect.

## Known gotchas

- **Installed before October 2026?** Older versions of `install.sh` wrote plugin and hook settings Claude Code doesn't read, so the skills and hook may never have loaded. Pull the latest repo and re-run `./install.sh`: it migrates the settings and leaves your KB and skills alone.
- **Slack MCP requires OAuth.** Showing up in the connector list doesn't mean it's authenticated. Run `/mcp` and complete the browser flow.
- **Drive `modifiedTime` needs full ISO 8601 with `Z`.** `2026-04-29T03:52:00.000Z`, not `2026-04-29T03:52:00`.
- **`qmd collection add` needs an absolute path.** A relative path resolves against the current working directory, not home, so adding the same folder twice under different spellings creates a duplicate collection. Use `qmd collection add ~/Documents/second-brain/Raw`; the resulting collection is named `Raw`.
- **Hook adds no context?** The hook exits quietly if it cannot find `qmd`. Check that it resolves: `command -v qmd`, or that `~/.bun/bin/qmd` exists.
- **`qmd update` does not embed.** It indexes new and changed files but generates no vectors, so `qmd vsearch` stays blind to them until you also run `qmd embed`.
- **Cloud routines have no local filesystem access.** That's why the `/learn` skill pushes a context doc to Google Drive — it's the bridge.
- **DST.** Cron expressions are UTC. When DST starts/ends, update the morning-brief cron at `https://claude.ai/code/routines/<routine-id>` or it'll drift one hour.

## License & contributions

This is a personal-productivity setup shared with colleagues. Fork it, edit it, share improvements back. No formal license — treat it as MIT-equivalent for Mapbox-internal use.

Issues and PRs welcome at [github.com/jeffreytfeng/mapbox-second-brain](https://github.com/jeffreytfeng/mapbox-second-brain).
