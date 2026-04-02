# TechGym 記事制作パイプライン

TechGym（techgym.jp）のSEO記事を制作するClaude Codeリポジトリ。

## 使い方

### 1. 構成案作成
```
@researcher 下記の依頼情報に基づいて構成案を作成してください。
[依頼情報を貼る]
```

### 2. 本文執筆 → チェック → 仕上げ
構成案確定後、H2単位でwriterに書かせる。
```
@writer H2①「選び方」を書いてください。構成案は articles/ にあります。
```
各H2完了時に@iron-rule-checkerとlint.shが走る。

### 3. 最終チェック
全H2完了後、以下のチェッカーを順に実行する。
```
@editorial-reviewer
@duplicate-checker
@kw-checker
@prep-logic-checker
bash scripts/check-sources.sh articles/xxx/final.html
```

### 4. 対話型修正
```
@editor
```
Manabuさんと対話しながら仕上げる。

### 5. 構成を直接指定する場合
```
構成案は確定済みです。下記の構成で本文を書いてください。1文字も変えないでください。
[構成を貼る]
```

## ファイル構成
```
techgym-articles/
├── CLAUDE.md                    パイプライン定義（200行以内）
├── README.md                    このファイル
├── .claude/
│   ├── agents/                  エージェント（8個）
│   │   ├── duplicate-checker.md   重複検出
│   │   ├── editor.md              対話型修正
│   │   ├── editorial-reviewer.md  全体品質レビュー
│   │   ├── iron-rule-checker.md   鉄のルール違反検出
│   │   ├── kw-checker.md          KW含有チェック
│   │   ├── prep-logic-checker.md  PREP構造・論理チェック
│   │   ├── researcher.md          構成案作成
│   │   └── writer.md              本文執筆
│   └── rules/                   ルール（毎回自動読み込み）
│       ├── agent-info.md          エージェント一覧と起動方法
│       ├── cta-templates.md       CTAテンプレート一覧
│       ├── internal-links.md      内部リンクURL一覧
│       ├── iron-rule.md           鉄のルール（絶対遵守）
│       ├── prohibited-words.md    禁止語・変換ルール
│       └── service-info.md        サービス情報マスターデータ
├── articles/                    記事の出力先
├── references/                  必要時のみ手動参照
│   ├── README.md                  referencesフォルダの説明
│   ├── h3-templates.md            H3の型テンプレート集
│   ├── structure-examples.md      記事タイプ別構成例
│   ├── style-examples.md          文体パターン合格例
│   ├── legal-safe-table.md        景表法注意表現リスト
│   └── writing-manual-full.md     マニュアルv1.1全文
└── scripts/
    ├── check-sources.sh           service-info整合性チェック
    └── lint.sh                    禁止語・文長・景表法チェック
```

## 設計思想

### ヤマダイ版との違い
- エージェント構成：ヤマダイと同等の8エージェント体制
- ショートコードなし：TechGymにはWPショートコードが存在しないため、全CTAは生HTMLリンクまたはVKブロックスボタン。cta-templates.mdで管理
- 自社サービス配置ルール：テックジムが比較記事内に入る構造（ヤマダイにはない設計要素）
- 記事タイプ4種：ランキング型・地域別比較・単体レビュー・情報コラム
- 法令チェック：薬機法・健康増進法は適用外。景表法のみ注意

### コンテキスト軽量化
- rulesフォルダ：毎回自動読み込み（6ファイル）
- referencesフォルダ：必要時のみ手動参照（6ファイル）
- マニュアル全文はreferencesに退避し、rulesには要約版のみ
- CLAUDE.mdは200行以内を維持
