#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

mkdir -p "$BIN_DIR"

install -m 755 "$REPO_DIR/claude-status" "$BIN_DIR/claude-status"
install -m 755 "$REPO_DIR/claude-usage" "$BIN_DIR/claude-usage"

python3 - <<EOF
import json, sys

path = "$SETTINGS"
try:
    with open(path) as f:
        d = json.load(f)
except FileNotFoundError:
    d = {}

d.setdefault("statusLine", {}).update({
    "type": "command",
    "command": "~/.local/bin/claude-status",
    "padding": 0,
})

with open(path, "w") as f:
    json.dump(d, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF

echo "installed:"
echo "  $BIN_DIR/claude-status"
echo "  $BIN_DIR/claude-usage"
echo "  $SETTINGS (statusLine updated)"
