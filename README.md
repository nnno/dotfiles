# dotfiles

macOS / Raspberry Pi 4 / WSL Ubuntu の初期化と dotfiles 管理を行うリポジトリ。

## ディレクトリ構成

- `bin/` - OS別スクリプト
  - `init_*.sh` - dotfiles 取得までの最小限のブートストラップ
  - `setup_*.sh` - dotfiles を使った設定適用 + ソフトウェアのインストール
  - `bin/lib/common.sh` - 共通関数（`symlink`, `setup_sheldon`, `symlink_subdirs`）
- `dotfiles/` - `$HOME` にシンボリックリンクする設定ファイル（`.zshrc`, `.vimrc` 等）
- `brew/` - Homebrew Bundle 定義（`Brewfile`, `Brewfile.macapp`）
- `zsh/` - sheldon 用プラグイン定義（`plugins.toml`）
- `tmux/` - tmux 設定（`tmux.conf`、セッション管理、Claude Code 通知スクリプト）
- `mise/` - mise 設定（`config.toml` → `~/.config/mise/`）
- `config/` - アプリケーション設定
  - `claude/` → `~/.claude/` にシンボリックリンク
  - `codex/` → `~/.codex/` にシンボリックリンク
  - `ghostty/` → Ghostty ターミナルの設定

## 使い方

```bash
# macOS
make mac-init     # Xcode CLI と Homebrew の準備
make mac-setup    # dotfiles の symlink 作成と設定
make mac-brew     # brew/Brewfile でパッケージをインストール
make mac-all      # 上記を一括実行

# Raspberry Pi 4
make rpi4-all

# WSL Ubuntu
make wsl_ubuntu-all
```

個別実行: `bash bin/setup_mac.sh`

## init と setup の責務分担

| スクリプト | 責務 | 実行タイミング |
|------------|------|----------------|
| `init_*.sh` | dotfiles を取得するまでの最小限のブートストラップ | 新規マシンで1回のみ |
| `setup_*.sh` | dotfiles を使った設定適用 + ソフトウェアのインストール | 何度でも再実行可能 |

### init_*.sh が行うこと
- OS 固有の前提条件（Xcode CLI）
- パッケージマネージャー自体のインストール（Homebrew）
- dotfiles 取得に必要な最小ツール（ghq, fzf）
- シェルの変更（zsh）
- dotfiles リポジトリの取得（`ghq get`）

### setup_*.sh が行うこと
- dotfiles のシンボリックリンク作成
- 環境設定（macOS defaults, sheldon, mise 設定）
- パッケージのインストール（`brew bundle`, `mise install`）
- AI ツールのインストールと設定
  - macOS: Claude Code, Codex のインストールと `~/.claude`, `~/.codex` の設定
  - Raspberry Pi 4 / WSL Ubuntu: Claude Code のインストールのみ

## マシン固有の設定

各マシン固有の設定は `~/.zshrc.local` に記載してください（git 管理対象外）。

例: Docker Desktop や Google Cloud SDK を使う場合

```zsh
# ~/.zshrc.local

# Docker Desktop completions
if [ -d "$HOME/.docker/completions" ]; then
  fpath=($HOME/.docker/completions $fpath)
fi

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
```
