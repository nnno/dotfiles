#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR"/bin/lib/common.sh

# ============================================================
# symlink
# ============================================================
symlink "$SCRIPT_DIR"/dotfiles

# ============================================================
# zsh, sheldon, fzf
# ============================================================
# install sheldon (from Pre-built binaries)
if [ ! -e "$HOME"/.local/bin/sheldon ]; then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
else
  echo "sheldon already installed."
fi

# setup plugin.toml
setup_sheldon "$SCRIPT_DIR"

sudo apt install fzf

# ============================================================
# AI tools (Claude Code)
# ============================================================
# Claude Code (Native Install)
if ! type claude &>/dev/null; then
  curl -fsSL https://claude.ai/install.sh | bash
fi
