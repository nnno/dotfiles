# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

macOS / Raspberry Pi 4 / WSL Ubuntu の初期化と dotfiles 管理を行うリポジトリ。

## ディレクトリ構成

- `bin/` - OS別スクリプト
  - `init_*.sh` - dotfiles 取得までの最小限のブートストラップ
  - `setup_*.sh` - dotfiles を使った設定適用 + ソフトウェアのインストール
  - `lib/common.sh` - 共通関数（`symlink`, `setup_sheldon`, `symlink_subdirs`）
- `dotfiles/` - `$HOME` にシンボリックリンクする設定ファイル（`.zshrc`, `.vimrc` 等）
- `brew/` - Homebrew Bundle 定義（`Brewfile`, `Brewfile.macapp`）
- `zsh/` - sheldon 用プラグイン定義（`plugins.toml`）
- `mise/` - mise 設定（`config.toml` → `~/.config/mise/`）
- `config/` - AI ツール設定
  - `claude/` → `~/.claude/` にシンボリックリンク
  - `codex/` → `~/.codex/` にシンボリックリンク

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
- AI ツールのインストールと設定（Claude Code, Codex）

## コマンド

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

個別実行: `sh bin/setup_mac.sh`

## コーディング規約

- Shell スクリプトは `#!/usr/bin/env bash` と `set -o pipefail` を使用
- 新しいスクリプトでは `bin/lib/common.sh` の共通関数を利用する
- インデントは 2 スペース、既存ファイルの形式に合わせる
- dotfiles は実ファイル名を維持（`.zshrc`, `.yabairc` 等）

## コミットメッセージ

`type(scope): 内容` 形式を使用。例:
- `feat(setup_mac.sh): asdf 追加`
- `fix(.zshrc): docker 設定修正`

## テスト

自動テストはなし。変更後は対象 OS で手動確認:
- `$HOME` 配下のシンボリックリンクが正しく作成されること
- `brew bundle` や `mise` の実行結果にエラーがないこと
