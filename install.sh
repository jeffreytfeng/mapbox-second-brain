#!/usr/bin/env bash
# install.sh — one-shot installer for the mapbox-second-brain template.
#
# What it does:
#   1. Copies knowledge-base/ to ~/Documents/second-brain/
#   2. Copies claude-plugin/ to ~/.claude/plugins/local/mapbox-second-brain/
#   3. Installs the context-enrichment hook script to ~/.claude/hooks/
#   4. Safe-merges marketplace + plugin entries into ~/.claude/settings.json
#   5. Safe-merges the UserPromptSubmit hook into ~/.claude/settings.local.json
#
# Idempotent: if files already exist, it warns and skips rather than clobbering.

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

KB_SOURCE="$SCRIPT_DIR/knowledge-base"
KB_TARGET="$HOME/Documents/second-brain"

PLUGIN_SOURCE="$SCRIPT_DIR/claude-plugin"
PLUGIN_TARGET="$HOME/.claude/plugins/local/mapbox-second-brain"

HOOK_SOURCE="$SCRIPT_DIR/claude-plugin/hooks/context-enrichment.sh"
HOOK_TARGET="$HOME/.claude/hooks/context-enrichment.sh"

SETTINGS_FILE="$HOME/.claude/settings.json"
LOCAL_SETTINGS_FILE="$HOME/.claude/settings.local.json"

green() { printf "\033[0;32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[0;33m%s\033[0m\n" "$1"; }
red() { printf "\033[0;31m%s\033[0m\n" "$1" >&2; }

echo "Installing mapbox-second-brain..."

# ---------------------------------------------------------------------------
# Step 1: Knowledge base
# ---------------------------------------------------------------------------
if [ -e "$KB_TARGET" ]; then
  red "ERROR: $KB_TARGET already exists."
  red "  Back it up (e.g., 'mv $KB_TARGET ${KB_TARGET}.bak') and re-run this installer."
  exit 1
fi

if [ ! -d "$KB_SOURCE" ]; then
  red "ERROR: knowledge-base/ not found at $KB_SOURCE"
  exit 1
fi

mkdir -p "$(dirname "$KB_TARGET")"
cp -R "$KB_SOURCE" "$KB_TARGET"
green "  Copied knowledge-base/ → $KB_TARGET"

# ---------------------------------------------------------------------------
# Step 2: Plugin directory
# ---------------------------------------------------------------------------
mkdir -p "$(dirname "$PLUGIN_TARGET")"

if [ -e "$PLUGIN_TARGET" ]; then
  yellow "  $PLUGIN_TARGET already exists — skipping plugin copy."
  yellow "  If you want to overwrite, delete it first: rm -rf $PLUGIN_TARGET"
else
  cp -R "$PLUGIN_SOURCE" "$PLUGIN_TARGET"
  green "  Copied claude-plugin/ → $PLUGIN_TARGET"
fi

# ---------------------------------------------------------------------------
# Step 3: Context-enrichment hook script
# ---------------------------------------------------------------------------
mkdir -p "$(dirname "$HOOK_TARGET")"

if [ -e "$HOOK_TARGET" ]; then
  yellow "  $HOOK_TARGET already exists — skipping hook copy."
  yellow "  If you want to overwrite, delete it first: rm $HOOK_TARGET"
else
  cp "$HOOK_SOURCE" "$HOOK_TARGET"
  chmod +x "$HOOK_TARGET"
  green "  Copied context-enrichment.sh → $HOOK_TARGET (executable)"
fi

# ---------------------------------------------------------------------------
# Step 4: Merge marketplace + plugin into ~/.claude/settings.json
# ---------------------------------------------------------------------------
mkdir -p "$(dirname "$SETTINGS_FILE")"

python3 - "$SETTINGS_FILE" <<'PY'
import json, os, sys

settings_path = sys.argv[1]
plugin_name = "second-brain"
marketplace_name = "mapbox-second-brain"
marketplace_source = os.path.expanduser("~/.claude/plugins/local/mapbox-second-brain")

# Load existing settings or start fresh
if os.path.exists(settings_path):
    try:
        with open(settings_path) as f:
            settings = json.load(f)
    except json.JSONDecodeError:
        print(f"  WARNING: {settings_path} is not valid JSON. Aborting merge.", file=sys.stderr)
        sys.exit(1)
else:
    settings = {}

if not isinstance(settings, dict):
    print(f"  WARNING: {settings_path} root is not an object. Aborting merge.", file=sys.stderr)
    sys.exit(1)

# Ensure shape
settings.setdefault("plugins", {})
settings["plugins"].setdefault("marketplaces", {})
settings["plugins"].setdefault("enabledPlugins", {})

changed = False

# Add the marketplace if not present
if marketplace_name not in settings["plugins"]["marketplaces"]:
    settings["plugins"]["marketplaces"][marketplace_name] = {
        "type": "local",
        "source": marketplace_source,
    }
    changed = True

# Enable the plugin from this marketplace if not present
plugin_key = f"{plugin_name}@{marketplace_name}"
if plugin_key not in settings["plugins"]["enabledPlugins"]:
    settings["plugins"]["enabledPlugins"][plugin_key] = True
    changed = True

if changed:
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    print(f"  Updated {settings_path} with marketplace + plugin entries")
else:
    print(f"  {settings_path} already has marketplace + plugin entries — no change")
PY

# ---------------------------------------------------------------------------
# Step 5: Merge UserPromptSubmit hook into ~/.claude/settings.local.json
# ---------------------------------------------------------------------------
python3 - "$LOCAL_SETTINGS_FILE" <<'PY'
import json, os, sys

settings_path = sys.argv[1]
hook_command = "~/.claude/hooks/context-enrichment.sh"

if os.path.exists(settings_path):
    try:
        with open(settings_path) as f:
            settings = json.load(f)
    except json.JSONDecodeError:
        print(f"  WARNING: {settings_path} is not valid JSON. Aborting hook merge.", file=sys.stderr)
        sys.exit(1)
else:
    settings = {}

if not isinstance(settings, dict):
    print(f"  WARNING: {settings_path} root is not an object. Aborting hook merge.", file=sys.stderr)
    sys.exit(1)

settings.setdefault("hooks", {})
settings["hooks"].setdefault("UserPromptSubmit", [])

# Look for existing entry pointing at our hook
already_present = False
for entry in settings["hooks"]["UserPromptSubmit"]:
    if not isinstance(entry, dict):
        continue
    for h in entry.get("hooks", []):
        if isinstance(h, dict) and h.get("command") == hook_command:
            already_present = True
            break
    if already_present:
        break

if not already_present:
    settings["hooks"]["UserPromptSubmit"].append({
        "matcher": "",
        "hooks": [{"type": "command", "command": hook_command}],
    })
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    print(f"  Added UserPromptSubmit hook to {settings_path}")
else:
    print(f"  UserPromptSubmit hook already present in {settings_path} — no change")
PY

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo
green "Install complete."
echo
echo "Next steps:"
echo "  1. Open Claude Code at ~/Documents/second-brain/"
echo "  2. Paste the contents of SETUP_PROMPT.md to start the interview"
echo "  3. (Optional) Install qmd if you want the context-enrichment hook to find KB results: bun install -g qmd  (https://github.com/tobi/qmd)"
echo
