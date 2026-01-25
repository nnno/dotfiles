#!/usr/bin/env bash
# 共通関数定義

function symlink() {
  local DIR=$1
  for dotfile in "${DIR}"/.??* ; do
    [[ "$dotfile" == "${DIR}/.git" ]] && continue
    [[ "$dotfile" == "${DIR}/.github" ]] && continue
    [[ "$dotfile" == "${DIR}/.DS_Store" ]] && continue
    [[ "$dotfile" == "${DIR}/.idea" ]] && continue
    [[ "$dotfile" == "${DIR}/." ]] && continue
    ln -fnsv "$dotfile" "$HOME"
  done
}

function setup_sheldon() {
  local SCRIPT_DIR=$1
  if [ ! -d "$HOME"/.config/sheldon ]; then
    mkdir -p "$HOME"/.config/sheldon
  fi
  ln -fnsv "$SCRIPT_DIR"/zsh/plugins.toml "$HOME"/.config/sheldon/plugins.toml
}

# ディレクトリ内の各サブディレクトリをリンク
function symlink_subdirs() {
  local SRC_DIR=$1
  local DEST_DIR=$2
  mkdir -p "$DEST_DIR"
  for item in "$SRC_DIR"/*/ ; do
    [[ ! -d "$item" ]] && continue
    [[ "$(basename "$item")" == ".git" ]] && continue
    ln -fnsv "$item" "$DEST_DIR"/
  done
}
