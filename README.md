# 売上集計サンプル（CGAI 連携テスト用）

売上 CSV（日付,金額）を読み、月ごとの合計を表示する小さなサンプルです。CGAI の開発環境（Claude Code・GitHub・Notion）の連携テストに使います。

```
npm start      # sample/sales.csv を集計して表示
npm test       # テスト
npm run lint   # 文法チェック
```

- Notion システムページ:
- Notion 仕様ページ:

---

## このリポジトリのファイル（CGAI テンプレート）

| ファイル | 役割 |
| --- | --- |
| project-rules.yaml | 開発ルールの正本 |
| CLAUDE.md | Claude Code への作業指示 |
| .claude/settings.json | Claude Code の安全設定（サンドボックス、禁止・確認するコマンド） |
| .claude/hooks/guard-branch.sh | main 上の作業と命名違反のブランチを止める |
| .claude/commands/system-doc.md | Notion のページを下書きする `/system-doc` |
| .mcp.json | Notion 連携（CGAI ページ限定。トークンは各自の NOTION_TOKEN） |
| .claude/mcp/notion-mcp.js | Notion 連携の起動役（Mac・Linux・Windows 共通） |
| .github/workflows/ci.yml | lint・テスト・秘密情報チェック |
| .github/workflows/branch-rules.yml | ブランチ名と Issue 番号の検査 |
| .github/workflows/claude.yml | Issue・PR の `@claude` で Claude を呼ぶ |
| .github/workflows/claude-review.yml | PR の自動レビュー |
| .github/pull_request_template.md | PR の確認項目 |
| .github/CODEOWNERS | ルール・安全設定の変更にだけテックリードの承認を求める |
| scripts/setup-repo.sh | main の保護を設定する |
| docs/notion-format.md | CGAI の Notion フォーマット |
| docs/system-overview.md | システムページの下書き |
| docs/managed-settings.example.json | 組織に配布する強制設定の見本 |

詳しくは「CGAI 開発マニュアル」と「CGAI 環境構築・管理マニュアル」を参照してください。
