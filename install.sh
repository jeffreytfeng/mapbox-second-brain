#!/usr/bin/env bash
# install.sh — one-shot installer for the mapbox-second-brain template.
#
# What it does:
#   0. Checks prerequisites (python3 required; warns if bun, qmd or gws are missing)
#   1. Copies knowledge-base/ to ~/Documents/second-brain/ (skipped if it already exists)
#   2. Copies claude-plugin/ to ~/.claude/plugins/local/mapbox-second-brain/
#      (the plugin ships the context-enrichment hook in hooks/hooks.json)
#   3. Registers the marketplace and enables the plugin in ~/.claude/settings.json
#   4. Removes hook entries written by older versions of this installer
#   5. If the claude CLI is available, installs the plugin through it too
#
# Safe to re-run: it never overwrites your KB or your customized skills.

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

KB_SOURCE="$SCRIPT_DIR/knowledge-base"
KB_TARGET="$HOME/Documents/second-brain"

PLUGIN_SOURCE="$SCRIPT_DIR/claude-plugin"
PLUGIN_TARGET="$HOME/.claude/plugins/local/mapbox-second-brain"

MARKETPLACE_NAME="mapbox-second-brain"
PLUGIN_KEY="second-brain@$MARKETPLACE_NAME"

LEGACY_HOOK="$HOME/.claude/hooks/context-enrichment.sh"

SETTINGS_FILE="$HOME/.claude/settings.json"
LEGACY_LOCAL_SETTINGS_FILE="$HOME/.claude/settings.local.json"

green() { printf "\033[0;32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[0;33m%s\033[0m\n" "$1"; }
red() { printf "\033[0;31m%s\033[0m\n" "$1" >&2; }

echo "Installing mapbox-second-brain..."

# ---------------------------------------------------------------------------
# Step 0: Prerequisites
# ---------------------------------------------------------------------------
if ! command -v python3 >/dev/null 2>&1; then
  red "ERROR: python3 not found. Install the Xcode Command Line Tools (xcode-select --install) and re-run."
  exit 1
fi

MISSING=()
has_tool() { command -v "$1" >/dev/null 2>&1 || [ -x "$HOME/.bun/bin/$1" ]; }
has_tool bun || MISSING+=("bun: curl -fsSL https://bun.sh/install | bash")
has_tool qmd || MISSING+=("qmd: bun install -g @tobilu/qmd  (KB search and the context hook need it)")
has_tool gws || MISSING+=("gws: required by /update, see https://github.com/mapbox/claude-plugins/tree/main/gws")

if [ ${#MISSING[@]} -gt 0 ]; then
  yellow "  Missing prerequisites (install continues; SETUP_PROMPT.md Phase 0 checks these again):"
  for m in "${MISSING[@]}"; do yellow "    - $m"; done
fi

# ---------------------------------------------------------------------------
# Step 1: Knowledge base
# ---------------------------------------------------------------------------
if [ ! -d "$KB_SOURCE" ]; then
  red "ERROR: knowledge-base/ not found at $KB_SOURCE"
  exit 1
fi

if [ -e "$KB_TARGET" ]; then
  yellow "  $KB_TARGET already exists, leaving it untouched."
  yellow "  For a fresh KB, move it aside (mv $KB_TARGET ${KB_TARGET}.bak) and re-run."
else
  mkdir -p "$(dirname "$KB_TARGET")"
  cp -R "$KB_SOURCE" "$KB_TARGET"
  green "  Copied knowledge-base/ → $KB_TARGET"
fi

# ---------------------------------------------------------------------------
# Step 2: Plugin directory
# ---------------------------------------------------------------------------
mkdir -p "$(dirname "$PLUGIN_TARGET")"

# Older installs shipped a hooks.json without the top-level "hooks" key,
# which Claude Code ignores. Detect that so we can refresh just the hook files.
hooks_json_is_current() {
  python3 -c 'import json, sys; sys.exit(0 if "hooks" in json.load(open(sys.argv[1])) else 1)' "$1" 2>/dev/null
}

if [ ! -e "$PLUGIN_TARGET" ]; then
  cp -R "$PLUGIN_SOURCE" "$PLUGIN_TARGET"
  chmod +x "$PLUGIN_TARGET/hooks/context-enrichment.sh"
  green "  Copied claude-plugin/ → $PLUGIN_TARGET"
elif hooks_json_is_current "$PLUGIN_TARGET/hooks/hooks.json"; then
  yellow "  $PLUGIN_TARGET already exists, keeping your skills as-is."
else
  mkdir -p "$PLUGIN_TARGET/hooks"
  cp "$PLUGIN_SOURCE/hooks/hooks.json" "$PLUGIN_TARGET/hooks/hooks.json"
  cp "$PLUGIN_SOURCE/hooks/context-enrichment.sh" "$PLUGIN_TARGET/hooks/context-enrichment.sh"
  chmod +x "$PLUGIN_TARGET/hooks/context-enrichment.sh"
  green "  Updated the plugin's hook files (kept your skills as-is)"
  if [ -e "$LEGACY_HOOK" ]; then
    yellow "  The hook now runs from $PLUGIN_TARGET/hooks/context-enrichment.sh."
    yellow "  $LEGACY_HOOK is no longer used; copy over any tweaks you made to it."
  fi
fi

# ---------------------------------------------------------------------------
# Step 3: Register marketplace + enable plugin in ~/.claude/settings.json
# ---------------------------------------------------------------------------
mkdir -p "$(dirname "$SETTINGS_FILE")"

python3 - "$SETTINGS_FILE" "$MARKETPLACE_NAME" "$PLUGIN_KEY" "$PLUGIN_TARGET" <<'PY'
import json, os, sys

settings_path, marketplace_name, plugin_key, marketplace_path = sys.argv[1:5]

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

changed = False

# Top-level extraKnownMarketplaces + enabledPlugins is the shape Claude Code reads.
marketplaces = settings.setdefault("extraKnownMarketplaces", {})
if marketplace_name not in marketplaces:
    marketplaces[marketplace_name] = {
        "source": {"source": "directory", "path": marketplace_path},
    }
    changed = True

enabled = settings.setdefault("enabledPlugins", {})
if enabled.get(plugin_key) is not True:
    enabled[plugin_key] = True
    changed = True

# Older installers wrote a nested "plugins" object that Claude Code never read.
legacy = settings.get("plugins")
if isinstance(legacy, dict):
    for section, key in (("marketplaces", marketplace_name), ("enabledPlugins", plugin_key)):
        entries = legacy.get(section)
        if isinstance(entries, dict) and key in entries:
            del entries[key]
            changed = True
            if not entries:
                del legacy[section]
    if not legacy:
        del settings["plugins"]

if changed:
    tmp_path = settings_path + ".tmp"
    with open(tmp_path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    os.replace(tmp_path, settings_path)
    print(f"  Registered marketplace + enabled plugin in {settings_path}")
else:
    print(f"  {settings_path} already has marketplace + plugin entries, no change")
PY

# ---------------------------------------------------------------------------
# Step 4: Remove the hook entry older installers put in ~/.claude/settings.local.json
# (the plugin now registers the hook itself; leaving this would risk running it twice)
# ---------------------------------------------------------------------------
if [ -e "$LEGACY_LOCAL_SETTINGS_FILE" ]; then
  python3 - "$LEGACY_LOCAL_SETTINGS_FILE" <<'PY'
import json, os, sys

settings_path = sys.argv[1]
legacy_command = "~/.claude/hooks/context-enrichment.sh"

try:
    with open(settings_path) as f:
        settings = json.load(f)
except (json.JSONDecodeError, OSError):
    sys.exit(0)

hooks = settings.get("hooks") if isinstance(settings, dict) else None
entries = hooks.get("UserPromptSubmit") if isinstance(hooks, dict) else None
if not isinstance(entries, list):
    sys.exit(0)

def is_legacy(entry):
    return isinstance(entry, dict) and any(
        isinstance(h, dict) and h.get("command") == legacy_command
        for h in entry.get("hooks", [])
    )

kept = [e for e in entries if not is_legacy(e)]
if len(kept) == len(entries):
    sys.exit(0)

if kept:
    hooks["UserPromptSubmit"] = kept
else:
    del hooks["UserPromptSubmit"]
    if not hooks:
        del settings["hooks"]

tmp_path = settings_path + ".tmp"
with open(tmp_path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
os.replace(tmp_path, settings_path)
print(f"  Removed the old hook entry from {settings_path} (the plugin registers it now)")
PY
fi

# ---------------------------------------------------------------------------
# Step 5: Install through the claude CLI when it's available
# ---------------------------------------------------------------------------
if claude --version >/dev/null 2>&1; then
  if claude plugin marketplace add "$PLUGIN_TARGET" --scope user </dev/null >/dev/null 2>&1 \
    && claude plugin install "$PLUGIN_KEY" --scope user </dev/null >/dev/null 2>&1; then
    green "  Installed $PLUGIN_KEY with the claude CLI"
  else
    yellow "  The claude CLI couldn't install the plugin. If /sync, /learn etc. are missing after"
    yellow "  restarting Claude Code, run /plugin and install second-brain from $MARKETPLACE_NAME."
  fi
else
  yellow "  claude CLI not found. Claude Code reads the settings.json entries on next start; if"
  yellow "  /sync, /learn etc. are missing, run /plugin and install second-brain from $MARKETPLACE_NAME."
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo
green "Install complete."
echo
echo "Next steps:"
step=1
if [ ${#MISSING[@]} -gt 0 ]; then
  echo "  $step. Install the missing prerequisites listed above"
  step=$((step + 1))
fi
echo "  $step. Quit and reopen Claude Code (plugins and hooks load at session start), opened at ~/Documents/second-brain/"
echo "  $((step + 1)). Paste the contents of SETUP_PROMPT.md to start the interview"
echo
