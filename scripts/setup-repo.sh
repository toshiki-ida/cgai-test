#!/usr/bin/env bash
# =====================================================================
# リポジトリの初期セットアップ（1回だけ実行）
#   - デフォルトブランチを main に
#   - main を保護（直接 push 禁止、PR と必須チェック ci / branch-rules）
#   - CODEOWNERS に書いたファイル（ルール・安全設定）の変更はテックリードの承認が必要
#   - マージ設定（squash、マージ後のブランチ自動削除）
# 使い方: bash scripts/setup-repo.sh your-org/your-repo [承認人数]
#   承認人数を省略すると 0（自己レビューでマージ可）
#   他の人の承認を必須にしたいリポジトリだけ 1 を指定する
# 前提: gh auth login 済み
# =====================================================================
set -euo pipefail

REPO="${1:?使い方: bash scripts/setup-repo.sh <owner>/<repo> [承認人数]}"
APPROVALS="${2:-0}"
case "$APPROVALS" in 0|1|2) ;; *) echo "承認人数は 0〜2 で指定してください"; exit 1 ;; esac

echo "==> デフォルトブランチを main に、マージ設定を更新"
gh api -X PATCH "repos/$REPO" \
  -f default_branch=main \
  -F allow_squash_merge=true \
  -F allow_merge_commit=false \
  -F allow_rebase_merge=false \
  -F delete_branch_on_merge=true >/dev/null

echo "==> main を保護（承認 $APPROVALS 名、必須チェック ci / branch-rules）"
gh api -X PUT "repos/$REPO/branches/main/protection" --input - >/dev/null <<JSON
{
  "required_status_checks": { "strict": true, "contexts": ["ci", "branch-rules"] },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": $APPROVALS,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true
  },
  "restrictions": null,
  "required_linear_history": false,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_conversation_resolution": true
}
JSON

echo ""
echo "完了。残りの作業（環境管理者に依頼）:"
echo "  - このリポジトリを Claude の GitHub App と ANTHROPIC_API_KEY（組織シークレット）の対象に追加する"
