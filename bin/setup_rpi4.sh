#!/usr/bin/env bash

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
# zsh, sheldon, peco
# ============================================================
# install sheldon (from Pre-built binaries)
if [ ! -e "$HOME"/.local/bin/shelcon ]; then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
else
  echo "sheldon already installed."
fi

# setup plugin.toml
SCRIPT_DIR="$(cd "$(dirname "$1")" && pwd)"

if [ ! -d "$HOME"/.config/sheldon ]; then
  mkdir -p "$HOME"/.config/sheldon
fi
ln -fnsv "$SCRIPT_DIR"/zsh/plugins.toml "$HOME"/.config/sheldon/plugins.toml

sudo apt install peco