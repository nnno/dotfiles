function peco-dfind() {
    local current_buffer=$BUFFER
    # .git系など不可視フォルダは除外
    local selected_dir="$(find . -maxdepth 10 -type d ! -path "*/.*"| peco)"
    if [ -d "$selected_dir" ]; then
        BUFFER="${current_buffer} \"${selected_dir}\""
        CURSOR=$#BUFFER
        # ↓決定時にそのまま実行するなら
        #zle accept-line
    fi
    zle clear-screen
}
zle -N peco-dfind
