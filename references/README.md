# references フォルダ

このフォルダには、必要時のみ手動で参照するファイルを格納する。
.claude/rules/ と異なり、**毎回の自動読み込み対象ではない**。

## ファイル一覧

| ファイル | 内容 | 参照タイミング |
|---------|------|--------------|
| writing-manual-full.md | マニュアルv1.1全文（686行） | ルールの詳細を確認したいとき |
| h3-templates.md | H3の型（選び方・メリット・注意点・紹介文）の具体例 | writerが執筆するとき |
| structure-examples.md | 記事タイプ別の構成例（実際のH2/H3構成） | researcherが構成案を作るとき |
| style-examples.md | 文体パターンの合格例（H3冒頭・strong締め・導入文等） | writerが文体を確認するとき |
| legal-safe-table.md | 景表法注意表現リスト | 景表法リスクが検出されたとき |

## 使い方
Claude Code内で以下のように参照する：
```
references/writing-manual-full.md を読んでください
```
```
references/h3-templates.md の選び方H3のテンプレートを確認して書いてください
```
