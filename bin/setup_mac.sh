#!/usr/bin/env bash

set -o pipefail

if [[ $OSTYPE != darwin* ]]; then
    exit
fi

# ============================================================
# defaults settings for mac
# ============================================================
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Screenshots
if [ ! -d "$HOME"/Screenshots ]; then
  mkdir "$HOME"/Screenshots
fi
defaults write com.apple.screencapture location $HOME/Screenshots
defaults write com.apple.screencapture name ss

# ============================================================
# symlink
# ============================================================

function symlink() {
  DIR=$1
  for dotfile in "${DIR}"/.??* ; do
    [[ "$dotfile" == "${DIR}/.git" ]] && continue
    [[ "$dotfile" == "${DIR}/.github" ]] && continue
    [[ "$dotfile" == "${DIR}/.DS_Store" ]] && continue
    [[ "$dotfile" == "${DIR}/.idea" ]] && continue
    [[ "$dotfile" == "${DIR}/." ]] && continue

    ln -fnsv "$dotfile" "$HOME"
  done
}

SCRIPT_DIR="$(cd "$(dirname "$1")" && pwd)"
symlink "$SCRIPT_DIR"/dotfiles

# ============================================================
# zsh + sheldon
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$1")" && pwd)"

if [ ! -d "$HOME"/.config/sheldon ]; then
  mkdir -p "$HOME"/.config/sheldon
fi
ln -fnsv "$SCRIPT_DIR"/zsh/plugins.toml "$HOME"/.config/sheldon/plugins.toml

# ============================================================
# brew
# ============================================================
export PATH=$HOME/.homebrew/bin:$PATH
export HOMEBREW_CACHE=$HOME/.homebrew/caches

# brew bundle --global
echo "brew bundle --file ./brew/Brewfile"
echo "brew bundle --file ./brew/Brewfile.macapp"
