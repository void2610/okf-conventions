---
type: Reference
title: OKF v0.1 仕様要約
description: Open Knowledge Format v0.1 の要点をエージェント参照用にまとめたもの。
resource: https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md
timestamp: 2026-06-13T00:00:00Z
---

# OKF とは

Open Knowledge Format (OKF) は、知識 (データやシステムを取り巻くメタデータ・文脈・知見) を
**YAML frontmatter 付き Markdown ファイルのディレクトリツリー** で表現する最小限の規約。
人間にもエージェントにも読め、diff でき、可搬。GCP 等のインフラには依存しない。

正式仕様: https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md

# 用語

- **Bundle**: 配布単位となるディレクトリツリー (Git リポジトリ推奨)。
- **Concept**: 知識の最小単位 = 1 つの Markdown ファイル。
- **Concept ID**: `.md` を除いたファイルパス (例: `lore/characters/aria`)。
- **Frontmatter**: 先頭の `---` で囲った YAML。
- **Body**: frontmatter 以降すべて。

# 予約ファイル名

| ファイル | 役割 |
|---|---|
| `index.md` | ディレクトリ目次 (progressive disclosure) |
| `log.md` | 更新履歴 |

それ以外の `.md` はすべて概念ドキュメント。

# Frontmatter

```yaml
---
type: <型名>          # 必須 (中央登録不要・consumer は未知の型を許容)
title: <表示名>        # 推奨
description: <1行要約>  # 推奨
resource: <正規URI>    # 推奨 (実体を指す)
tags: [a, b]          # 推奨
timestamp: <ISO 8601> # 推奨
# 独自キー追加可・consumer は未知キーを保持し拒否しない
---
```

# Body

標準 Markdown。散文より構造 (見出し・リスト・表・コードブロック) を優先。
慣用見出し (任意): `# Schema` / `# Examples` / `# Citations`。

# リンク

- 絶対 (バンドル基準): `[x](/tables/customers.md)` — 移動に強く推奨。
- 相対: `[x](./other.md)`。
- リンク = 型なし有向エッジ。関係の種類は周囲の文章で表す。
- 壊れたリンクは不正ではない (consumer は許容必須)。

# index.md / log.md

- index.md: frontmatter 無し。`* [タイトル](url) - 概要` の箇条書き。
- ルート index.md のみ `okf_version: "0.1"` を frontmatter で宣言可。
- log.md: `## YYYY-MM-DD` 見出しで新しい順。

# 適合性 (v0.1)

1. すべての非予約 `.md` がパース可能な YAML frontmatter を持つ。
2. frontmatter に空でない `type` がある。
3. 予約ファイルは §6–7 の形に従う。

その他はソフト指針。consumer は欠損・未知型・未知キー・壊れリンク・index 欠如で拒否してはならない。

# バージョニング

現行 0.1。`<major>.<minor>`。minor = 後方互換の追加、major = 破壊的変更。
未知バージョンでも consumer はベストエフォートで読む。
