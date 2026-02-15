#!/usr/bin/env bash
set -o pipefail

STATE_DIR="/tmp/claude-tmux-state"
[ ! -d "$STATE_DIR" ] && exit 0

NOW=$(date +%s)
STALE_THRESHOLD=300  # 5分
WORKING=0
IDLE=0

# 現在のtmuxペイン一覧を取得
ACTIVE_PANES=""
if [ -n "$TMUX" ]; then
  ACTIVE_PANES=$(tmux list-panes -a -F '#{pane_id}' 2>/dev/null | tr -d '%')
fi

for STATE_FILE in "$STATE_DIR"/*; do
  [ ! -f "$STATE_FILE" ] && continue

  PANE_ID=$(basename "$STATE_FILE")

  # 存在しないペインの状態ファイルを削除
  if [ -n "$ACTIVE_PANES" ]; then
    if ! echo "$ACTIVE_PANES" | grep -q "^${PANE_ID}$"; then
      rm -f "$STATE_FILE"
      continue
    fi
  fi

  read -r STATE TIMESTAMP < "$STATE_FILE"

  # working状態で5分以上更新なしは無視（クラッシュ対策）
  # idle/notificationは入力待ちで長時間続くのが正常なのでstale扱いしない
  if [ "$STATE" = "working" ] && [ -n "$TIMESTAMP" ] && [ $((NOW - TIMESTAMP)) -gt $STALE_THRESHOLD ]; then
    continue
  fi

  case "$STATE" in
    working) WORKING=$((WORKING + 1)) ;;
    idle|notification) IDLE=$((IDLE + 1)) ;;
  esac
done

# 何もなければ表示しない
[ $WORKING -eq 0 ] && [ $IDLE -eq 0 ] && exit 0

OUTPUT=""
[ $WORKING -gt 0 ] && OUTPUT="#[fg=yellow]⚡${WORKING}"
if [ $IDLE -gt 0 ]; then
  [ -n "$OUTPUT" ] && OUTPUT="$OUTPUT "
  OUTPUT="${OUTPUT}#[fg=cyan]●${IDLE}"
fi

echo "#[fg=white][${OUTPUT}#[fg=white]] "
