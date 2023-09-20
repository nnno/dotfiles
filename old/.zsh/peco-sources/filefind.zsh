function peco-filefind() {
    local current_buffer=$BUFFER
    # .git系など不可視フォルダは除外
    local selected_dir="$(find . -maxdepth 10 -type f | peco)"
    if [ -e "$selected_dir" ]; then
        BUFFER="${current_buffer} \"${selected_dir}\""
        CURSOR=$#BUFFER
    fi
    zle clear-screen
}
zle -N peco-filefind

