#!/usr/bin/env bash
set -o pipefail

STATE_DIR="/tmp/claude-tmux-state"
mkdir -p "$STATE_DIR"

ACTION="$1"

# tmux外では状態ファイル更新をスキップ
if [ -n "$TMUX_PANE" ]; then
  STATE_FILE="$STATE_DIR/$(echo "$TMUX_PANE" | tr -d '%')"
  echo "$ACTION $(date +%s)" > "$STATE_FILE"
fi

# セッション名を取得（通知タイトル用）
SESSION_NAME=""
if [ -n "$TMUX" ]; then
  SESSION_NAME=$(tmux display-message -p '#S' 2>/dev/null)
fi
TITLE="Claude Code"
[ -n "$SESSION_NAME" ] && TITLE="Claude Code ($SESSION_NAME)"

# 通知送信（System Events経由でフォーカス中でも通知を表示）
notify() {
  local title="$1" message="$2" sound="$3"
  osascript -e "tell application \"System Events\" to display notification \"$message\" with title \"$title\" sound name \"$sound\"" 2>/dev/null
}

case "$ACTION" in
  idle)
    notify "$TITLE" "応答が完了しました" "Glass"
    ;;
  notification)
    MESSAGE=""
    if [ ! -t 0 ]; then
      INPUT=$(cat)
      MESSAGE=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('message',''))" 2>/dev/null)
    fi
    [ -z "$MESSAGE" ] && MESSAGE="通知があります"
    notify "$TITLE" "$MESSAGE" "Purr"
    ;;
esac
