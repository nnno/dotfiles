# fzf configuration
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --preview-window=right:50%:wrap
'

# Ctrl-R: 履歴検索（プレビュー付き）
function fzf-select-history() {
  BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER" \
    --preview 'echo {}' \
    --preview-window=up:3:wrap)
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N fzf-select-history
bindkey '^R' fzf-select-history

# Ctrl-U: ghq管理下のリポジトリを一覧表示
function fzf-ghq-src() {
  local selected_dir=$(ghq list -p | fzf \
    --prompt="repositories > " \
    --query "$LBUFFER" \
    --preview 'ls -la {}' \
    --preview-window=right:50%)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-ghq-src
bindkey '^U' fzf-ghq-src
