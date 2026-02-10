#!/usr/bin/env bash

set -o pipefail

if [[ $OSTYPE != darwin* ]]; then
    exit
fi

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR"/bin/lib/common.sh

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
symlink "$SCRIPT_DIR"/dotfiles

# ============================================================
# zsh + sheldon
# ============================================================
setup_sheldon "$SCRIPT_DIR"

# ============================================================
# tmux
# ============================================================
setup_tmux "$SCRIPT_DIR"

# mise
if [ ! -d "$HOME"/.config/mise ]; then
  mkdir -p "$HOME"/.config/mise
fi
ln -fnsv "$SCRIPT_DIR"/mise/config.toml "$HOME"/.config/mise/config.toml

# ============================================================
# Ghostty
# ============================================================
mkdir -p "$HOME"/.config/ghostty
ln -fnsv "$SCRIPT_DIR"/config/ghostty/config "$HOME"/.config/ghostty/config

# ============================================================
# AI tools (Claude Code, OpenAI Codex)
# ============================================================
# Claude Code (Native Install)
if ! type claude &>/dev/null; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

mkdir -p "$HOME"/.claude
ln -fnsv "$SCRIPT_DIR"/config/claude/CLAUDE.md "$HOME"/.claude/CLAUDE.md
ln -fnsv "$SCRIPT_DIR"/config/claude/settings.json "$HOME"/.claude/settings.json
symlink_subdirs "$SCRIPT_DIR"/config/claude/skills "$HOME"/.claude/skills
symlink_subdirs "$SCRIPT_DIR"/config/claude/commands "$HOME"/.claude/commands

# OpenAI Codex
mkdir -p "$HOME"/.codex
ln -fnsv "$SCRIPT_DIR"/config/codex/AGENTS.md "$HOME"/.codex/AGENTS.md
symlink_subdirs "$SCRIPT_DIR"/config/codex/skills "$HOME"/.codex/skills

# ============================================================
# brew
# ============================================================
export PATH=$HOME/.homebrew/bin:$PATH
export HOMEBREW_CACHE=$HOME/.homebrew/caches

brew bundle --file ./brew/Brewfile

# ============================================================
# development tools via mise
# ============================================================
if type mise &>/dev/null; then
  mise install
fi

echo "========================================"
echo "brew bundle --file ./brew/Brewfile.macapp"
