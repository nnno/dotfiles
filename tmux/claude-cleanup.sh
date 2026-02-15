#!/usr/bin/env bash
set -o pipefail

STATE_DIR="/tmp/claude-tmux-state"

if [ -n "$TMUX_PANE" ]; then
  STATE_FILE="$STATE_DIR/$(echo "$TMUX_PANE" | tr -d '%')"
  rm -f "$STATE_FILE"
fi
