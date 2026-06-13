---
type: Conventions
title: OKF ローカル運用規約
description: void2610 のプロジェクト群で共通の OKF 知識ベース運用ルール。
timestamp: 2026-06-13T00:00:00Z
---

# 概要

このドキュメントは、各プロジェクトの `Knowledge/` バンドルを運用するための共通ルールを定める。
すべてのバンドルは [OKF v0.1](./OKF-SPEC.md) に準拠する。

このファイルは各プロジェクトに `Knowledge/conventions/CONVENTIONS.md` として **読み取り専用** で埋め込まれる。
ここを編集する場合は中央リポジトリ `okf-conventions` で行うこと。

# ディレクトリ規約

各プロジェクトの知識バンドルは **プロジェクトルート直下の `Knowledge/`** に置く。

- Unity がアセットとして import するのは `Assets/` の中だけなので、ルート直下に置けば
  名前に関わらず Unity に取り込まれない (`Docs/` 等と同じ)。よって末尾 `~` は不要。
- 非 Unity プロジェクトでも統一のため同じ `Knowledge/` を使う。

標準構成:

```
Knowledge/
├── index.md            # バンドル目次 + okf_version 宣言 (frontmatter は index のみ許可)
├── log.md              # 更新履歴 (新しい順)
├── conventions/        # この規約リポジトリ (submodule・読み取り専用)
├── lore/               # 世界観・設定資料 (ゲーム向け)
├── design/             # 設計・仕様ドキュメント
└── systems/            # 実装と紐づく概念 (resource: でコード/アセットを指す)
```

不要なトップディレクトリ (例: ツール系プロジェクトの `lore/`) は削除してよい。

# type 語彙

`type` は必須。原則として以下から選ぶ。新しい種類が必要なら追加してよい (中央登録不要)。

| type | 用途 |
|---|---|
| `Character` | 登場人物・NPC |
| `Location` | 場所・地名 |
| `Faction` | 勢力・組織 |
| `Item` | アイテム・装備 |
| `Quest` | クエスト・イベント |
| `Mechanic` | ゲームメカニクス |
| `System` | 実装システム (コードと紐づく) |
| `Design` | 設計判断・仕様 |
| `Decision` | 意思決定の記録 (なぜそうしたか) |
| `Reference` | 外部資料へのポインタ |

# 命名規約

- ファイル名は **kebab-case**。例: `the-warden.md`, `core-loop.md`。
- `_` 始まりのファイル名は記入例・テンプレート扱い (例: `_example.md`)。実運用前に削除する。
- ディレクトリ名も kebab-case。

# frontmatter 規約

- `type` は必ず記入し、空にしない。
- `title` / `description` は原則記入する (`description` は index 生成と検索に使われる)。
- 実装と紐づく概念は `resource:` にリポジトリ相対パスを書く。例: `resource: Assets/Scripts/Inventory/InventoryManager.cs`。
- `timestamp` は ISO 8601 (`YYYY-MM-DDTHH:MM:SSZ`)。**更新のたびに現在時刻へ更新する**。
- `tags` は横断的な分類に使う YAML リスト。

# リンク規約

- 概念間リンクは **バンドル基準の絶対パス** を優先する。例: `[番人](/lore/characters/the-warden.md)`。
- リンクの意味 (関係の種類) は周囲の文章で表現する。リンク自体は型を持たない。
- 参照先が未作成でもリンクを書いてよい (壊れたリンクは許容される)。後で作る目印になる。

# index.md 規約

- 各ディレクトリに目次として `index.md` を置いてよい (progressive disclosure)。
- index.md は frontmatter を持たない。ただし **バンドルルートの index.md のみ** `okf_version: "0.1"` を frontmatter で宣言できる。
- エントリ形式: `* [タイトル](/絶対パス.md) - 概要 (frontmatter の description)`。

# log.md 規約 (重要)

- 概念を **新規作成・更新したら**、同階層 (無ければバンドルルート) の `log.md` に 1 行追記する。
- 日付見出しは ISO 8601 の `YYYY-MM-DD`、**新しい順**。
- 行頭の太字ラベル (`Creation` / `Update` / `Deletion`) は慣習。

例:

```markdown
# Update Log

## 2026-06-13
* **Creation**: [アリア](/lore/characters/aria.md) を新規作成。
* **Update**: [沈黙の森](/lore/locations/forest-of-echoes.md) に地理情報を追記。
```

# 適合性 (これだけは守る)

1. すべての非予約 `.md` がパース可能な YAML frontmatter を持つ。
2. その frontmatter に空でない `type` がある。
3. `index.md` / `log.md` は本規約の形式に従う。

その他はソフト指針。欠損フィールド・未知の type・壊れリンク・index 欠如を理由に処理を止めないこと。
