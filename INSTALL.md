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

## 4. Make the context-enrichment hook executable

The hook ships inside the plugin: `hooks/hooks.json` registers `hooks/context-enrichment.sh` as a `UserPromptSubmit` hook, and Claude Code loads it automatically when the plugin is enabled. No separate hook registration is needed.

```bash
chmod +x ~/.claude/plugins/local/mapbox-second-brain/hooks/context-enrichment.sh
```

> The hook calls `qmd` (a local-first search tool). If `qmd` isn't installed, the hook exits silently and nothing breaks, but you get no KB context. Install it with `bun install -g @tobilu/qmd` (https://github.com/tobi/qmd).

---

## 5. Register the marketplace + plugin in `~/.claude/settings.json`

Open `~/.claude/settings.json` (create it if missing). Make sure the file is valid JSON. Merge in these **top-level** keys, and do **not** overwrite the entire file:

```json
{
  "extraKnownMarketplaces": {
    "mapbox-second-brain": {
      "source": {
        "source": "directory",
        "path": "/Users/<YOUR-USERNAME>/.claude/plugins/local/mapbox-second-brain"
      }
    }
  },
  "enabledPlugins": {
    "second-brain@mapbox-second-brain": true
  }
}
```

Replace `<YOUR-USERNAME>` with your macOS username (run `whoami` to check); the path must be absolute. If the file already has `extraKnownMarketplaces` or `enabledPlugins`, add these entries inside them and keep everything else untouched.

If you have the `claude` CLI, you can do this step with commands instead:

```bash
claude plugin marketplace add ~/.claude/plugins/local/mapbox-second-brain --scope user
claude plugin install second-brain@mapbox-second-brain --scope user
```

---

## 6. (Upgrading only) Remove old installer entries

Older versions of `install.sh` wrote a nested `"plugins": { "marketplaces": ..., "enabledPlugins": ... }` block into `~/.claude/settings.json` and a `UserPromptSubmit` hook pointing at `~/.claude/hooks/context-enrichment.sh` into `~/.claude/settings.local.json`. Claude Code doesn't read either one. Delete those entries (or just re-run `install.sh`, which migrates them for you). If you customized `~/.claude/hooks/context-enrichment.sh`, copy your changes into the plugin's copy at `~/.claude/plugins/local/mapbox-second-brain/hooks/`.

---

## 7. Verify

Quit and reopen Claude Code (plugins and hooks load at session start), then open a session at `~/Documents/second-brain/`:

```bash
cd ~/Documents/second-brain
claude
```

You should see the `second-brain` plugin's slash commands available (`/morning-brief`, `/sync`, `/learn`, `/retro`, etc.). If they're missing, run `/plugin` and install `second-brain` from the `mapbox-second-brain` marketplace.

---

## 8. Run the setup interview

Paste the contents of `SETUP_PROMPT.md` (in this template's root) into the new Claude session. It will walk you through 7 phases: verify install → interview → connect MCP & seed KB → distill Context/People → validate hook → verify learning loop → set up morning brief.

After the interview, run `/my-voice` once you have a few real writing samples in your Drive/Slack history — this generates `Knowledge/Context/my-voice.md` so other skills sound like you wrote them.

---

## Uninstall

```bash
rm -rf ~/Documents/second-brain
rm -rf ~/.claude/plugins/local/mapbox-second-brain
# Manually remove the mapbox-second-brain entry from extraKnownMarketplaces and
# second-brain@mapbox-second-brain from enabledPlugins in ~/.claude/settings.json
```
