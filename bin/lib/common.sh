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

function setup_tmux() {
  local SCRIPT_DIR=$1
  if [ ! -d "$HOME"/.config/tmux ]; then
    mkdir -p "$HOME"/.config/tmux
  fi
  ln -fnsv "$SCRIPT_DIR"/tmux/tmux.conf "$HOME"/.config/tmux/tmux.conf

  # TPM (tmux plugin manager) のインストール
  local TPM_DIR="$HOME/.config/tmux/plugins/tpm"
  if [ ! -d "$TPM_DIR" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  fi
}

# ディレクトリ内の各サブディレクトリとファイルをリンク
function symlink_subdirs() {
  local SRC_DIR=$1
  local DEST_DIR=$2
  mkdir -p "$DEST_DIR"
  for item in "$SRC_DIR"/* ; do
    [[ ! -e "$item" ]] && continue
    [[ "$(basename "$item")" == ".git" ]] && continue
    ln -fnsv "$item" "$DEST_DIR"/
  done
}
