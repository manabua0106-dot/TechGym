# TechGym 記事制作パイプライン

## 絶対遵守事項
1. **H2単位で執筆する。** 記事全文を一気に書かない。1つのH2を書き終えたら@iron-rule-checkerを通す。
2. **service-info.mdが唯一の正。** テーブル・画像・CTA・アフィリURLはservice-info.mdからコピペする。外部データを混ぜない。
3. **禁止語は0件が納品条件。** lint.shはHooksで自動実行される。検出された禁止語は全て潰してから次のH2に進む。
4. **pタグは使わない。** 改行のみで段落を分ける。
5. **推測で数値を書かない。** 確認できない料金・給付金情報は「公式サイトで要確認」と書く。
6. **比喩表現禁止。** 「跳ね上がる」「ふくらむ」「鍵」「分かれ目」等は使わない。
7. **ミスしたら自分でmemoryに追記しろ。** Manabuさんに指摘されたら、なぜダメだったかを理解し、該当するfeedback_*.mdに日付付きで追記する。同じミスは二度としない。
8. **検証まで1セットにする。** 「書く→チェックする→問題があれば自分で直す→直した結果を見せる」まで1回の実行で完結させる。作りっぱなしにしない。

## Hooks（自動実行）
settings.jsonに以下のHooksを設定済み。Claudeが忘れても自動で実行される。
- **articles/配下の.htmlファイルを保存するたびに** → lint.shが自動実行される
- **articles/配下のfinal.htmlを保存したとき** → check-sources.shが自動実行される

## パイプライン

### Phase 1：構成案作成
```
@researcher [依頼情報]
```
researcherが競合分析→構成案を出す。構成案確定後にPhase 2に進む。

### Phase 2：執筆（H2単位ループ）
```
@writer [構成案 or H2指示]
```
1. writerがH2を1つ書く → articles/に保存
2. Hooks: lint.shが自動実行 → 禁止語・文長・景表法チェック
3. @iron-rule-checker → 鉄のルール違反チェック
4. 問題があれば**自分で修正して再保存**（Hooksが再度lint.shを実行）
5. 全パスしたら次のH2へ
※ 「問題がありました。修正しますか？」と聞くな。自分で直せ。

### Phase 3：最終チェック・仕上げ
全H2完了後：
1. @editorial-reviewer → G-4チェックリスト全項目
2. @duplicate-checker → セクション間・記事間重複
3. @kw-checker → KW配置状況
4. @prep-logic-checker → PREP構造・論理
5. final.htmlに結合して保存 → Hooks: check-sources.shが自動実行
6. @editor → Manabuさんと対話型修正

## 自己学習サイクル
Manabuさんからフィードバックを受けたら：
1. 指摘内容を理解する
2. 該当するfeedback_*.md（rules/フォルダ内）に日付付きで追記する
3. 次回以降、そのルールを自動で適用する
4. **「許容」「これでいい」「もう指摘しないで」と言われた判断は必ず記録する**
5. 同じフィードバックを二度させない

## エージェント一覧
詳細は rules/agent-info.md を参照。

| エージェント | 役割 |
|-------------|------|
| @researcher | 構成案作成 |
| @writer | 本文執筆（H2単位） |
| @iron-rule-checker | 鉄のルール違反検出（最優先） |
| @kw-checker | KW含有チェック |
| @prep-logic-checker | PREP構造・論理チェック |
| @duplicate-checker | 重複検出 |
| @editorial-reviewer | 全体品質レビュー（G-4全項目） |
| @editor | 対話型修正 |

## ファイル構成（3層構造）

**⚠️ 全ファイルを最初に一括で読み込まない。作業フェーズごとに必要なファイルだけ読む。**
**一括読み込みはコンテキストを圧迫し、出力が途中で止まる原因になる。各エージェントのmdファイルに読み込みタイミングの表がある。**

```
techgym-articles/
├── CLAUDE.md                    ← このファイル（200行以内を維持）
├── README.md
├── .claude/
│   ├── settings.json            権限制御 + Hooks定義
│   ├── agents/                  ← Layer 1: skills（呼ばれたときだけ起動）
│   │   ├── researcher.md          構成案作成
│   │   ├── writer.md              本文執筆
│   │   ├── editor.md              対話型修正
│   │   ├── iron-rule-checker.md   鉄のルール違反検出
│   │   ├── kw-checker.md          KW含有チェック
│   │   ├── prep-logic-checker.md  PREP構造・論理チェック
│   │   ├── duplicate-checker.md   重複検出
│   │   └── editorial-reviewer.md  全体品質レビュー
│   └── rules/                   ← Layer 2: rules（毎回自動読み込み）+ Layer 3: memory（FB蓄積）
│       ├── agent-info.md          エージェント一覧
│       ├── cta-templates.md       CTAテンプレート
│       ├── internal-links.md      内部リンクURL
│       ├── iron-rule.md           鉄のルール
│       ├── prohibited-words.md    禁止語・変換ルール
│       ├── service-info.md        サービス情報DB
│       ├── MEMORY.md              記憶の索引
│       ├── feedback_writing.md    文体FB蓄積
│       ├── feedback_structure.md  構成FB蓄積
│       ├── feedback_client.md     クライアント判断基準
│       ├── feedback_techgym.md    テックジム扱いFB
│       └── feedback_legal.md      景表法FB蓄積
├── references/                  必要時のみ手動参照
│   ├── writing-manual-full.md     マニュアルv1.1全文
│   ├── h3-templates.md            H3テンプレート集
│   ├── structure-examples.md      記事タイプ別構成例
│   ├── style-examples.md          文体合格例
│   └── legal-safe-table.md        景表法注意表現
├── scripts/
│   ├── lint.sh                    禁止語・文長チェック（Hooksで自動実行）
│   └── check-sources.sh          service-info整合性チェック（Hooksで自動実行）
└── articles/                    記事出力先
```

## 記事タイプ（4種）
- **タイプA**：ランキング型 → AI CAMPバナー + 選び方 + 紹介 + メリット + FAQ + まとめ
- **タイプB**：地域別比較 → 冒頭訴求テーブル + 紹介 + まとめ
- **タイプC**：単体レビュー → 概要 + 口コミ + 料金 + メリデメ + まとめ
- **タイプD**：情報コラム → 自由構成 + テックジム誘導

## テックジムの扱い
- ランキング型記事：訴求1位の次（通常2位）に配置。紹介分量は訴求1位と同程度以上。
- 地域別記事：校舎がある地域のみ本文に掲載。ない地域はフッターのみ。
- 東京記事：最上位H2サービスとして配置。VKボタン（is-style-shine）で強調。
- テックジムのCTAにrel="nofollow"を付けない。アフィリタグを混入させない。

## 運用ルール
- **CLAUDE.mdは200行以内を維持する。** ルール追加はrules/に別ファイルで。
- **memoryファイル（feedback_*.md）はrules/内に配置。** 毎回自動読み込みされるためFBが確実に適用される。
- **memoryに「今の作業進捗」は入れない。** 入れるのは「次回以降も使える普遍的な学び」だけ。
