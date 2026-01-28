# Repository Guidelines

## Project Structure & Module Organization
この リポジトリ は macOS / Raspberry Pi 4 / WSL Ubuntu の 初期化 と dotfiles 管理 を 目的 とします。
- `bin/` : OS 別 の 初期化 / 設定 スクリプト。例 `init_mac.sh` や `setup_wsl_ubuntu.sh`。
- `dotfiles/` : `$HOME` に シンボリックリンク する 設定 ファイル。例 `.zshrc` `.vimrc` `.tmux.conf`。
- `brew/` : Homebrew の Bundle 定義。例 `Brewfile` `Brewfile.macapp`。
- `zsh/` : sheldon 用 の プラグイン 定義 と 補助 スクリプト。例 `plugins.toml`。
- `mise/` : mise 設定（`config.toml` → `~/.config/mise/`）。
- `config/` : AI ツール 設定（`claude/` → `~/.claude/`, `codex/` → `~/.codex/`）。

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

## Build, Test, and Development Commands
主要 な 実行 は Makefile か 直実行 で 行います。
- `make mac-init` : macOS の 初期化（Xcode CLI と Homebrew 準備）。
- `make mac-setup` : macOS の 設定 と dotfiles の symlink 作成。
- `make mac-brew` : `brew/Brewfile` で パッケージ を 一括 取得。
- `make mac-all` : macOS の 一連 処理 を まとめて 実行。
- `make rpi4-all` / `make wsl_ubuntu-all` : 各 環境 向け の 初期化 と 設定。
必要 に 応じて `bash bin/setup_mac.sh` の ように 個別 実行 も 可能 です。

## Coding Style & Naming Conventions
- Shell は `bash` 前提。新規 スクリプト も `#!/usr/bin/env bash` を 付け、`set -o pipefail` を 使う。
- インデント は 2 スペース を 基本 とし、既存 ファイル の 流儀 に 合わせる。
- dotfiles の 命名 は 実ファイル 名 を 維持 する（例 `.zshrc` `.yabairc`）。

## Testing Guidelines
自動 テスト は ありません。変更 後 は 対象 OS で 実行 し、以下 を 手動 確認 します。
- `$HOME` 配下 の シンボリックリンク が 期待 通り 作成 される。
- `brew bundle` や `mise` の 実行 結果 に エラー が ない。

## Commit & Pull Request Guidelines
コミット は 既存 履歴 に 合わせ、`type(scope): 内容` 形式 を 推奨 します。
- 例 `feat(setup_mac.sh): asdf 追加` / `fix(.zshrc): docker 設定 修正`。
- 変更 対象 と 実行 環境 を 短く 明示 する。
PR では 変更 目的、実行 した コマンド、動作 確認 内容 を 記載 してください。

## Security & Configuration Tips
この リポジトリ は OS 設定 変更 と パッケージ 追加 を 行います。実行 前 に スクリプト を 読み、対象 OS か を 確認 してください。機密 値 は dotfiles に 直接 書かず、環境 変数 や 既存 の 仕組み を 利用 します。
