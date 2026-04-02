# TechGym エージェント一覧

## 執筆フェーズ（Phase 2）

### @researcher — 構成案作成
- 起動：`@researcher [依頼情報]`
- 役割：競合分析 → サジェスト/PAA分析 → 構成案作成
- 出力：H2/H3構成案、必須要素チェック、差別化要素、サブKW/共起語一覧

### @writer — 本文執筆
- 起動：`@writer [H2指示]`
- 役割：H2を1つずつ執筆。service-info.mdからテーブル・画像・CTAをコピペ
- 制約：1回の実行で1つのH2だけ書く。複数H2を一気に書かない

## チェックフェーズ（Phase 2〜3）

### @iron-rule-checker — 鉄のルール違反検出
- 起動：H2完了時に自動 / `@iron-rule-checker`で手動
- 役割：絶対遵守ルール（pタグ禁止・禁止語ゼロ・service-infoコピペ等）の違反検出
- 優先度：最高。このチェッカーの指摘は例外なく修正

### @kw-checker — KW含有チェック
- 起動：`@kw-checker`で手動
- 役割：メインKW・複合KW・サブKW・共起語の配置状況を一覧表で報告
- 入力：初回にManabuさんからKW情報を受け取る

### @prep-logic-checker — PREP構造・論理チェック
- 起動：`@prep-logic-checker`で手動
- 役割：H3の1文目が結論か、1文目とstrong締めの重複、論理の飛躍等を検出

### @duplicate-checker — 重複検出
- 起動：`@duplicate-checker`で手動
- 役割：セクション間重複、テーブルvs本文重複、記事間重複、表現の繰り返しを検出

### @editorial-reviewer — 全体品質レビュー
- 起動：`@editorial-reviewer`で手動
- 役割：G-4チェックリストの全項目を実行。最も網羅的なチェッカー

## 仕上げフェーズ（Phase 3）

### @editor — 対話型修正
- 起動：`@editor`で手動
- 役割：Manabuさんと対話しながら記事を仕上げる。修正指示を受けて「変更前→変更後」で提示

## 推奨ワークフロー

```
Phase 1: @researcher → 構成案確定
Phase 2: @writer（H2ごとにループ）→ @iron-rule-checker（自動）
Phase 3: @editorial-reviewer → @duplicate-checker → @kw-checker → @prep-logic-checker
Phase 4: @editor（Manabuさんと対話型修正）→ 納品
```
