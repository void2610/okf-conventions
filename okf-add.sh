#!/usr/bin/env bash
# OKF 知識ベースを既存プロジェクトに導入するスクリプト。
#
#   - Knowledge/conventions/ に okf-conventions を submodule として追加 (読み取り専用)
#   - scaffold/ の雛形を Knowledge/ にコピー (既存ファイルは上書きしない)
#   - プロジェクトの CLAUDE.md にエージェント運用ルールを追記
#
# 変更はコミットせずワーキングツリーに残すので、内容を確認してから自分でコミットすること。
#
# 使い方:
#   ./okf-add.sh <プロジェクトのパス>
#   ./okf-add.sh ~/Documents/GitHub/void-red

set -euo pipefail

CONV_URL="https://github.com/void2610/okf-conventions.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROJ="${1:-}"
if [ -z "$PROJ" ]; then
  echo "usage: $0 <project-path>" >&2
  exit 1
fi
PROJ="$(cd "$PROJ" && pwd)"

if [ ! -d "$PROJ/.git" ]; then
  echo "error: $PROJ は git リポジトリではありません" >&2
  exit 1
fi

KB="$PROJ/Knowledge"
echo "==> 対象: $PROJ"

# 1) conventions を submodule として追加
if [ -d "$KB/conventions" ]; then
  echo "    conventions submodule は既に存在 (スキップ)"
else
  echo "    submodule 追加: Knowledge/conventions"
  git -C "$PROJ" submodule add -q "$CONV_URL" "Knowledge/conventions"
fi

# 2) 雛形コピー (既存は上書きしない)
echo "    雛形コピー: scaffold/ -> Knowledge/"
mkdir -p "$KB"
# cp -n で既存ファイルを保護しつつ再帰コピー
(cd "$SCRIPT_DIR/scaffold" && find . -type f) | while read -r f; do
  dest="$KB/${f#./}"
  if [ -e "$dest" ]; then
    echo "      skip (既存): ${f#./}"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$SCRIPT_DIR/scaffold/${f#./}" "$dest"
    echo "      add: ${f#./}"
  fi
done

# 3) CLAUDE.md に運用ルールを追記
CLAUDE="$PROJ/CLAUDE.md"
if grep -q "OKF:START" "$CLAUDE" 2>/dev/null; then
  echo "    CLAUDE.md は既に OKF ルールを含む (スキップ)"
else
  echo "    CLAUDE.md にエージェント運用ルールを追記"
  { [ -s "$CLAUDE" ] && echo ""; cat "$SCRIPT_DIR/claude-snippet.md"; } >> "$CLAUDE"
fi

echo "==> 完了。変更を確認してコミットしてください:"
echo "    git -C \"$PROJ\" status"
