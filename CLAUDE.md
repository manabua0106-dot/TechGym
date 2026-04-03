# TechGym 記事制作パイプライン

## 絶対遵守事項
1. **H2単位で執筆する。** 記事全文を一気に書かない。1つのH2を書き終えたら@iron-rule-checkerを通す。
2. **service-info.mdが唯一の正。** テーブル・画像・CTA・アフィリURLはservice-info.mdからコピペする。外部データを混ぜない。
3. **禁止語は0件が納品条件。** lint.shで検出された禁止語は全て潰してから次のH2に進む。
4. **pタグは使わない。** 改行のみで段落を分ける。
5. **推測で数値を書かない。** 確認できない料金・給付金情報は「公式サイトで要確認」と書く。
6. **比喩表現禁止。** 「跳ね上がる」「ふくらむ」「鍵」「分かれ目」等は使わない。

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
2. @iron-rule-checker → 鉄のルール違反チェック
3. `bash scripts/lint.sh` → 機械チェック
4. 問題があれば修正 → 再チェック
5. 全パスしたら次のH2へ

### Phase 3：最終チェック・仕上げ
全H2完了後：
1. @editorial-reviewer → G-4チェックリスト全項目
2. @duplicate-checker → セクション間・記事間重複
3. @kw-checker → KW配置状況
4. @prep-logic-checker → PREP構造・論理
5. `bash scripts/check-sources.sh` → service-info整合性
6. @editor → Manabuさんと対話型修正

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

## ファイル構成
```
techgym-articles/
├── CLAUDE.md                    ← このファイル
├── README.md
├── .claude/
│   ├── agents/                  エージェント（8個）
│   │   ├── duplicate-checker.md
│   │   ├── editor.md
│   │   ├── editorial-reviewer.md
│   │   ├── iron-rule-checker.md
│   │   ├── kw-checker.md
│   │   ├── prep-logic-checker.md
│   │   ├── researcher.md
│   │   └── writer.md
│   ├── rules/                   ルール（毎回自動読み込み）
│   │   ├── agent-info.md
│   │   ├── cta-templates.md
│   │   ├── internal-links.md
│   │   ├── iron-rule.md
│   │   ├── prohibited-words.md
│   │   └── service-info.md
│   └── memory/                  フィードバック蓄積（学びの記録）
│       ├── MEMORY.md
│       ├── feedback_writing.md
│       ├── feedback_structure.md
│       ├── feedback_client.md
│       ├── feedback_techgym.md
│       └── feedback_legal.md
├── articles/                    記事出力先
├── references/                  必要時のみ手動参照
│   ├── README.md
│   ├── h3-templates.md
│   ├── structure-examples.md
│   ├── style-examples.md
│   ├── legal-safe-table.md
│   └── writing-manual-full.md
└── scripts/
    ├── check-sources.sh
    └── lint.sh
```

## 記事タイプ（4種）
- **タイプA**：ランキング型 → AI CAMPバナー + 選び方 + 紹介 + メリット + FAQ + まとめ
- **タイプB**：地域別比較 → 冒頭訴求テーブル + 紹介 + まとめ
- **タイプC**：単体レビュー → 概要 + 口コミ + 料金 + メリデメ + まとめ
- **タイプD**：情報コラム → 自由構成 + テックジム誘導

詳細は references/writing-manual-full.md のA-1を参照。

## テックジムの扱い
- ランキング型記事：訴求1位の次（通常2位）に配置。紹介分量は訴求1位と同程度以上。
- 地域別記事：校舎がある地域のみ本文に掲載。ない地域はフッターのみ。
- 東京記事：最上位H2サービスとして配置。VKボタン（is-style-shine）で強調。
- テックジムのCTAにrel="nofollow"を付けない。アフィリタグを混入させない。

## CLAUDE.mdの運用ルール
- **このファイルは200行以内を維持する。** 200行を超えるとClaudeの指示遵守率が下がる。
- ルールを追加したい場合は rules/ に別ファイルとして追加する。
- 詳細なチェック基準は agents/ に記載する。
- CLAUDE.mdには「絶対遵守事項」と「パイプラインの流れ」だけを書く。

## memoryの運用ルール
- Manabuさんからフィードバックを受けたら、該当するmemoryファイルに日付付きで追記する。
- **「許容」「これでいい」「もう指摘しないで」と言われた判断は必ずmemoryに記録する。**
- 同じフィードバックを二度させない。一度言われたことは学習する。
- memoryに「今の作業の進捗」は入れない。入れるのは「次回以降も使える普遍的な学び」だけ。
