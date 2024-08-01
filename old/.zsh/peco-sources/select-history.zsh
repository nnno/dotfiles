function peco-select-history() {
  builtin history -n -r 1 \
    | anyframe-selector-auto "$LBUFFER" \
    | anyframe-action-execute
}
zle -N peco-select-history
