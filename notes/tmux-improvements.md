# tmux 設定改善

Claude Code / Codex CLI をシェルベースで使う際の tmux ワークフローを改善する。

## 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| `tmux/tmux.conf` | DCS パススルー、TPM プラグイン、セッション切替キーバインド |
| `dotfiles/.zshrc` | `tmux-session` 関数の追加 |
| `brew/Brewfile` | `brew "tmux"` の明示追加 |
| `bin/lib/common.sh` | `setup_tmux()` に TPM 自動インストール処理を追加 |

## 1. DCS パススルー対応

```tmux
set -g allow-passthrough on
set -g set-clipboard on
```

- `allow-passthrough on`: OSC シーケンスをターミナルエミュレータに透過させる（tmux 3.3+ 必要）
- `set-clipboard on`: OSC 52 ベースのクリップボード連携（SSH 越しでも動作）

これにより、tmux 内で Claude Code を使用した際の通知やクリップボード連携が正常に動作する。

## 2. TPM + セッション永続化

### TPM 自動インストール

`bin/lib/common.sh` の `setup_tmux()` が、`~/.config/tmux/plugins/tpm` が存在しない場合に自動で `git clone` する。

```bash
local TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
```

### プラグイン構成

| プラグイン | 役割 |
|------------|------|
| `tmux-plugins/tpm` | プラグインマネージャ |
| `tmux-plugins/tmux-resurrect` | セッションの手動保存・復元 |
| `tmux-plugins/tmux-continuum` | 15分間隔の自動保存 + tmux 起動時の自動復元 |

セッション保存先: `~/.config/tmux/resurrect/`

### 使い方

| 操作 | キーバインド |
|------|-------------|
| プラグインインストール | `PREFIX + I` |
| セッション保存 | `PREFIX + Ctrl-s` |
| セッション復元 | `PREFIX + Ctrl-r` |

※ continuum により15分ごとに自動保存されるため、通常は手動保存不要。

## 3. セッション切替（ghq + fzf 連携）

### `tmux-session` 関数

`dotfiles/.zshrc` に追加。`ghq list` の一覧から fzf でプロジェクトを選択し、対応する tmux セッションを作成または切替する。

動作:
- 既存セッションがあれば `switch-client` / `attach-session`
- なければ `new-session` でプロジェクトディレクトリをカレントにして作成
- tmux 内外どちらからでも正しく動作する

### キーバインド

```tmux
bind f run-shell "tmux neww 'zsh -ic tmux-session'"
```

`PREFIX + f` で新しいウィンドウを開き、fzf によるプロジェクト選択を起動する。

## 4. Brewfile

`brew/Brewfile` に `brew "tmux"` を明示的に追加。

## セットアップ手順

```bash
# 1. setup スクリプトを実行（シンボリンク + TPM インストール）
bash bin/setup_mac.sh

# 2. tmux を起動し、TPM プラグインをインストール
tmux
# PREFIX + I を押す

# 3. 動作確認
# PREFIX + f でセッション切替
# PREFIX + Ctrl-s でセッション保存
# tmux を終了して再起動後、PREFIX + Ctrl-r で復元
```
