### Homebrew
- パッケージは `brew/Brewfile` で管理する。直接 `brew install` しない

### Python
- `pip` / `pip install` は使用しない
- 一時的なツール利用には `uvx` を使用する（例: `uvx pymupdf ...`）
- パッケージ管理には `uv add`、スクリプト実行には `uv run` を使用する
