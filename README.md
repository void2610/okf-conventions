# okf-conventions

各プロジェクトの知識ベース (`Knowledge~/`) で共有する **OKF (Open Knowledge Format) のローカル運用規約** を一元管理するリポジトリ。

このリポジトリは各プロジェクトに **git submodule** として `Knowledge~/conventions/` に埋め込まれ、**読み取り専用**で参照される。規約を改善したいときはここ 1 か所を更新し、各プロジェクトの submodule ポインタを進めることで全プロジェクトへ反映する。

## 中身

| ファイル | 内容 |
|---|---|
| [`CONVENTIONS.md`](./CONVENTIONS.md) | このプロジェクト群で共通の OKF 運用ルール (type 語彙・命名・リンク・log 規約) |
| [`OKF-SPEC.md`](./OKF-SPEC.md) | OKF v0.1 仕様の要約 (エージェントがオフラインで参照できるよう同梱) |

## 設計思想: 「規約は中央集権・知識は各プロジェクト所有」

- **規約 (このリポジトリ)** … 各プロジェクトでは編集しない読み取り専用。中央で更新して配布する。
- **知識データ (各プロジェクトの `Knowledge~/` 直下)** … 各プロジェクトのリポジトリ自身にコミットされる。

submodule 内に知識データを置くと親リポジトリにコミットできないため、この境界を厳守する。

## 更新の反映 (全プロジェクト一括)

```bash
for proj in ~/Documents/GitHub/*/; do
  [ -d "$proj/Knowledge~/conventions" ] || continue
  git -C "$proj" submodule update --remote Knowledge~/conventions
  git -C "$proj" add Knowledge~/conventions
  git -C "$proj" commit -m "chore: OKF規約を最新に更新"
done
```

## 新規導入

[`okf-template`](https://github.com/void2610/okf-template) リポジトリの `okf-add.sh` を使う。

## 出典

OKF は Google Cloud が公開した Open Knowledge Format 仕様に準拠する。
- 仕様: https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md
