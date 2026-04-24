# TechGym 記事制作パイプライン

**バージョン**：v1.2（2026-04-24）
**正本マニュアル**：`.claude/rules/writing-manual.md`

---

## ⚠️ 最重要：Single Source of Truth

このリポジトリの**ライティングルールは `writing-manual.md` のみが正本**です。
本ファイル（CLAUDE.md）・各エージェント・各チェッカーは、writing-manual.md を参照するだけで、ルールを独自に再定義しません。

矛盾が生じた場合は writing-manual.md の記述が優先されます。

---

## 絶対遵守事項（3グループ責任分界）

10項目の絶対遵守ルールは、責任の性質で3グループに分ける。

### 🟦 グループA：プロセス系（writer 責任）

writer 自身が守る。自動検査できない性質のルール。

1. **H2単位で執筆する。** 記事全文を一気に書かない。1つのH2を書き終えたら iron-rule-checker を通す。
2. **検証まで1セットにする。** 「書く→チェックする→問題があれば自分で直す→直した結果を見せる」まで1回の実行で完結させる。作りっぱなしにしない。
3. **ミスしたら自分で memory に追記する。** Manabuさんに指摘されたら、なぜダメだったかを理解し、該当する feedback_*.md に日付付きで追記する。同じミスは二度としない。
4. **文体・構成FBを毎回適用する。** feedback_writing.md / feedback_structure.md を起動時に必ず読む。

### 🟩 グループB：自動検査系（iron-rule-checker 責任）

文字列grepで検出可能。Hooksで lint.sh が自動実行される。

5. **service-info.md が唯一の正。** テーブル・画像・CTA・アフィリURLはservice-info.mdからコピペする。外部データを混ぜない。
6. **禁止語ゼロが納品条件。** writing-manual.md 付録の禁止語リストに基づいて検査する。検出された禁止語は全て潰してから次のH2に進む。
7. **pタグは使わない。** 改行のみで段落を分ける。
8. **本文中でテックジムを出さない。** テックジムへの誘導はフッター定型ブロックに集約する。

### 🟥 グループC：意味検査系（editorial-reviewer 責任）

LLM-based の意味検査が必要。単純 grep では検出不可。

9. **推測で数値を書かない。** 確認できない料金・給付金情報は「公式サイトで要確認」と書く。数値には [出典名](URL) を併記する。
10. **比喩表現禁止 + 景表法チェック。** 「跳ね上がる」「分かれ目」等は使わない。数値実績は出典フル記載必須。給付金・価格は条件併記必須。比較・最上級語は根拠なしで使用禁止。

---

## Hooks（自動実行）

settings.json に以下の Hooks を設定済み。Claude が忘れても自動で実行される。

- **articles/配下の.htmlファイルを保存するたびに** → `lint.sh` が自動実行される
- **articles/配下の final.html を保存したとき** → `check-sources.sh` が自動実行される

---

## パイプライン

### Phase 1：構成案作成

```
@researcher [依頼情報]
```

researcher が競合分析 → 構成案を出す。構成案確定後に Phase 2 に進む。

### Phase 2：執筆（H2単位ループ）

```
@writer [構成案 or H2指示]
```

1. writer が H2 を1つ書く → articles/ に保存
2. Hooks: lint.sh が自動実行 → 禁止語・文長・景表法チェック
3. @iron-rule-checker → グループB項目の違反チェック
4. 問題があれば**自分で修正して再保存**（Hooks が再度 lint.sh を実行）
5. 全パスしたら次の H2 へ
   ※「問題がありました。修正しますか？」と聞くな。自分で直せ。

### Phase 3：最終チェック・仕上げ

全 H2 完了後：

1. @editorial-reviewer → グループC項目（意味検査） + G-4 チェックリスト全項目
2. @duplicate-checker → セクション間・記事間重複
3. @kw-checker → KW 配置状況
4. @prep-logic-checker → PREP 構造・論理
5. final.html に結合して保存 → Hooks: check-sources.sh が自動実行
6. @editor → Manabuさんと対話型修正

---

## 自己学習サイクル

Manabuさんからフィードバックを受けたら：

1. 指摘内容を理解する
2. 該当する feedback_*.md（rules/フォルダ内）に日付付きで追記する
3. 次回以降、そのルールを自動で適用する
4. 指摘が繰り返され、恒久ルール化が妥当と判断したら **writing-manual.md に昇格** させ、feedback からは削除する（二重管理回避）
5. 同じフィードバックを二度させない

---

## エージェント一覧

詳細は `rules/agent-info.md` を参照。

| エージェント | 役割 | 責任グループ |
|---|---|---|
| @researcher | 構成案作成 | — |
| @writer | 本文執筆（H2単位） | 🟦 グループA |
| @iron-rule-checker | 鉄のルール違反検出（最優先） | 🟩 グループB |
| @kw-checker | KW 含有チェック | — |
| @prep-logic-checker | PREP 構造・論理チェック | — |
| @duplicate-checker | 重複検出 | — |
| @editorial-reviewer | 全体品質レビュー | 🟥 グループC |
| @editor | 対話型修正 | — |

---

## ファイル構成（3層構造）

⚠️ **全ファイルを最初に一括で読み込まない。作業フェーズごとに必要なファイルだけ読む。**
一括読み込みはコンテキストを圧迫し、出力が途中で止まる原因になる。各エージェントの md ファイルに読み込みタイミングの表がある。

```
techgym-articles/
├── CLAUDE.md                    ← このファイル（200行以内を維持）
├── README.md
├── .claude/
│   ├── settings.json            権限制御 + Hooks 定義
│   ├── agents/                  ← Layer 1: skills（呼ばれたときだけ起動）
│   │   ├── researcher.md          構成案作成
│   │   ├── writer.md              本文執筆
│   │   ├── editor.md              対話型修正
│   │   ├── iron-rule-checker.md   鉄のルール違反検出
│   │   ├── kw-checker.md          KW 含有チェック
│   │   ├── prep-logic-checker.md  PREP 構造・論理チェック
│   │   ├── duplicate-checker.md   重複検出
│   │   └── editorial-reviewer.md  全体品質レビュー
│   └── rules/                   ← Layer 2: rules（毎回自動読み込み）+ Layer 3: memory
│       ├── writing-manual.md      ⭐ 正本マニュアル（SSOT）
│       ├── agent-info.md          エージェント一覧
│       ├── cta-templates.md       CTA テンプレート
│       ├── internal-links.md      内部リンク URL
│       ├── prohibited-words.md    禁止語（writing-manual 付録への参照）
│       ├── service-info.md        サービス情報 DB
│       ├── MEMORY.md              記憶の索引
│       ├── feedback_writing.md    文体 FB 蓄積（確定前の一時記録）
│       ├── feedback_structure.md  構成 FB 蓄積
│       ├── feedback_client.md     クライアント判断基準
│       ├── feedback_techgym.md    テックジム扱い FB
│       └── feedback_legal.md      景表法 FB 蓄積
├── references/                  必要時のみ手動参照
│   ├── h3-templates.md            H3 テンプレート集
│   ├── structure-examples.md      記事タイプ別構成例
│   ├── style-examples.md          文体合格例
│   └── legal-safe-table.md        景表法注意表現
├── scripts/
│   ├── lint.sh                    禁止語・文長チェック
│   └── check-sources.sh          service-info 整合性チェック
└── articles/                    記事出力先
```

---

## 記事タイプ（4種）

詳細は writing-manual.md §A-1 を参照。

- **タイプA**：ランキング型 → AI CAMP バナー + 選び方 + 紹介 + メリット + FAQ + まとめ
- **タイプB**：地域別比較 → 冒頭訴求テーブル + 紹介 + まとめ
- **タイプC**：単体レビュー → 概要 + 口コミ + 料金 + メリデメ + まとめ
- **タイプD**：情報コラム → 自由構成

---

## テックジムの扱い（2026-04 変更）

- **本文中でテックジムは出さない**（ランキング・地域別・単体・情報コラム全タイプ共通）
- テックジム誘導は**フッター定型ブロック（§C-3）に集約**
- 導入文のテックジム誘導リンクは廃止

詳細は writing-manual.md §I-3 を参照。

---

## 運用ルール

- **CLAUDE.md は 200行以内を維持する。** ルール追加は writing-manual.md に書く。
- **feedback_*.md は一時的な記録場所。** 恒久ルール化が決まったら writing-manual.md に昇格させ、feedback からは削除する。
- **memory に「今の作業進捗」は入れない。** 入れるのは「次回以降も使える普遍的な学び」だけ。
