# okf-conventions

各プロジェクトの知識ベース (`Knowledge/`) で使う **OKF (Open Knowledge Format)** の
**運用規約** と **導入ツール** を 1 つにまとめたリポジトリ。

このリポジトリは各プロジェクトに **git submodule** として `Knowledge/conventions/` に埋め込まれ、
**読み取り専用** で参照される。規約を改善したいときはここ 1 か所を更新し、各プロジェクトの
submodule ポインタを進めることで全プロジェクトへ反映する。

## 中身

| パス | 内容 |
|---|---|
| [`CONVENTIONS.md`](./CONVENTIONS.md) | OKF 運用ルール (type 語彙・命名・リンク・log 規約) |
| [`OKF-SPEC.md`](./OKF-SPEC.md) | OKF v0.1 仕様の要約 (エージェントがオフライン参照する用) |
| `okf-add.sh` | 既存プロジェクトに OKF 知識ベースを導入するスクリプト |
| `scaffold/` | `Knowledge/` 直下にコピーされる雛形 (index.md / log.md / lore / design / systems) |
| `claude-snippet.md` | プロジェクトの `CLAUDE.md` に追記されるエージェント運用ルール |

※ `okf-add.sh` / `scaffold/` / `claude-snippet.md` は導入時にしか使わないが、管理を 1 リポジトリに
まとめる方針のため同梱している (submodule にも含まれる)。

## 設計思想: 「規約は中央集権・知識は各プロジェクト所有」

- **規約 (このリポジトリ)** … 各プロジェクトでは編集しない読み取り専用。中央で更新して配布する。
- **知識データ (各プロジェクトの `Knowledge/` 直下)** … 各プロジェクトのリポジトリ自身にコミットされる。

submodule 内に知識データを置くと親リポジトリにコミットできないため、この境界を厳守する。

## 導入後の各プロジェクトの構成

```
<project>/
├── CLAUDE.md                    # OKF 運用ルールが追記される
└── Knowledge/
    ├── index.md                 # バンドル目次 (okf_version 宣言)
    ├── log.md                   # 更新履歴
    ├── conventions/             # submodule -> このリポジトリ (読み取り専用)
    ├── lore/                    # 知識データ (各プロジェクトにコミット)
    ├── design/
    └── systems/
```

`Knowledge/` はプロジェクトルート直下に置く。Unity が import するのは `Assets/` の中だけなので、ルート直下のフォルダは名前に関わらず Unity に取り込まれない。

## 使い方

### 既存プロジェクトに導入

```bash
git clone https://github.com/void2610/okf-conventions.git
cd okf-conventions
./okf-add.sh ~/Documents/GitHub/<project>
```

スクリプトは変更をコミットせずワーキングツリーに残す。確認後にコミットする:

```bash
cd ~/Documents/GitHub/<project>
git status
git add .gitmodules Knowledge CLAUDE.md
git commit -m "feat: OKF 知識ベースを追加"
```

### 規約を最新化 (全プロジェクト一括)

```bash
for proj in ~/Documents/GitHub/*/; do
  [ -d "$proj/Knowledge/conventions" ] || continue
  git -C "$proj" submodule update --remote Knowledge/conventions
  git -C "$proj" add Knowledge/conventions
  git -C "$proj" commit -m "chore: OKF規約を最新に更新"
done
```

### clone 時の注意

submodule を含むプロジェクトは `--recurse-submodules` を付けて clone する:

```bash
git clone --recurse-submodules <project-url>
# 付け忘れた場合:
git submodule update --init --recursive
```

## 出典

OKF は Google Cloud が公開した Open Knowledge Format に準拠する。
https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md
