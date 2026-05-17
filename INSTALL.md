# Manual install — mapbox-second-brain

If you'd rather not run `install.sh`, follow these steps to install the template by hand. They mirror exactly what the script does.

> All paths assume macOS with `~/.claude/` as the Claude Code config directory and `~/Documents/` as your Documents folder. Adjust if your system differs.

---

## 0. Prerequisites

Before installing, add the four MCP connectors at [claude.ai/customize/connectors](https://claude.ai/customize/connectors): **Google Drive, Gmail, Google Calendar, Slack**. The OAuth flow (run via `/mcp` later) won't be possible until the connectors are added there. The setup interview will not work without them.

---

## 1. Sanity check — back up anything in the way

The installer refuses to overwrite an existing `~/Documents/second-brain/`. Do the same by hand:

```bash
ls ~/Documents/second-brain 2>/dev/null && \
  echo "Back this up first: mv ~/Documents/second-brain ~/Documents/second-brain.bak"
```

If the directory exists, move it aside (or merge changes manually after install).

---

## 2. Copy the knowledge base

From the directory containing this file (e.g., `~/Downloads/mapbox-second-brain/`):

```bash
cp -R knowledge-base ~/Documents/second-brain
```

Verify:

```bash
ls ~/Documents/second-brain
# Expect: CLAUDE.md  Knowledge/  Raw/  Tasks/  Templates/
ls ~/Documents/second-brain/Knowledge
# Expect: Context/  Customers/  People/  Reference/
```

---

## 3. Copy the Claude plugin

```bash
mkdir -p ~/.claude/plugins/local
cp -R claude-plugin ~/.claude/plugins/local/mapbox-second-brain
```

Verify:

```bash
ls ~/.claude/plugins/local/mapbox-second-brain
# Expect: .claude-plugin/  hooks/  skills/
```

---

## 4. Install the context-enrichment hook

The hook script is what injects KB search results into every prompt. Claude Code looks for it at `~/.claude/hooks/`.

```bash
mkdir -p ~/.claude/hooks
cp claude-plugin/hooks/context-enrichment.sh ~/.claude/hooks/context-enrichment.sh
chmod +x ~/.claude/hooks/context-enrichment.sh
```

> The hook calls `qmd` (a local-first vector search tool). If `qmd` isn't installed, the hook exits silently — nothing breaks. Install qmd later when you're ready: `bun install -g qmd` (https://github.com/tobi/qmd)

---

## 5. Register the marketplace + plugin in `~/.claude/settings.json`

Open `~/.claude/settings.json` (create it if missing). Make sure the file is valid JSON. Merge in the entries below — do **not** overwrite the entire file:

```json
{
  "plugins": {
    "marketplaces": {
      "mapbox-second-brain": {
        "type": "local",
        "source": "/Users/<YOUR-USERNAME>/.claude/plugins/local/mapbox-second-brain"
      }
    },
    "enabledPlugins": {
      "second-brain@mapbox-second-brain": true
    }
  }
}
```

Replace `<YOUR-USERNAME>` with your macOS username (run `whoami` to check). If `~/.claude/settings.json` already has a `plugins` object, just add the new keys under `marketplaces` and `enabledPlugins` — keep everything else untouched.

---

## 6. Register the hook in `~/.claude/settings.local.json`

The hook needs a `UserPromptSubmit` entry in `settings.local.json` so Claude Code runs it before every prompt. Open the file (create if missing) and merge:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          { "type": "command", "command": "~/.claude/hooks/context-enrichment.sh" }
        ]
      }
    ]
  }
}
```

If `UserPromptSubmit` already has entries, append yours — don't replace the array.

---

## 7. Verify

Restart Claude Code, then open a session at `~/Documents/second-brain/`:

```bash
cd ~/Documents/second-brain
claude
```

You should see the `second-brain` plugin's slash commands available (`/morning-brief`, `/sync`, `/learn`, `/retro`, etc.).

---

## 8. Run the setup interview

Paste the contents of `SETUP_PROMPT.md` (in this template's root) into the new Claude session. It will walk you through 7 phases: verify install → interview → connect MCP & seed KB → distill Context/People → validate hook → verify learning loop → set up morning brief.

After the interview, run `/my-voice` once you have a few real writing samples in your Drive/Slack history — this generates `Knowledge/Context/my-voice.md` so other skills sound like you wrote them.

---

## Uninstall

```bash
rm -rf ~/Documents/second-brain
rm -rf ~/.claude/plugins/local/mapbox-second-brain
rm ~/.claude/hooks/context-enrichment.sh
# Manually remove the marketplace/plugin entries from ~/.claude/settings.json
# and the UserPromptSubmit entry from ~/.claude/settings.local.json
```
