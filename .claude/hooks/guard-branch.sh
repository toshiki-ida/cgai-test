#!/usr/bin/env bash
# Claude Code の PreToolUse フック
# main 上での git commit / push、命名違反ブランチの作成を止める。
# 終了コード 2 = ブロック（stderr のメッセージが Claude に返る）

input="$(cat)"
# 実行しようとしているコマンドを取り出す（Windows でも動くよう、node → python3 → sed の順に試す）
if command -v node >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{try{process.stdout.write(((JSON.parse(s).tool_input)||{}).command||"")}catch(e){}})' 2>/dev/null)"
elif command -v python3 >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)"
else
  cmd="$(printf '%s' "$input" | sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' | head -1)"
fi
# どの方法でも読めなかった git 操作は、安全のため止める
if [ -z "$cmd" ] && printf '%s' "$input" | grep -q 'git'; then
  echo "ブロック: コマンドの内容を確認できませんでした。Node.js が入っているか確認してください。" >&2
  exit 2
fi

# git 以外は対象外
case "$cmd" in
  *git*) ;;
  *) exit 0 ;;
esac

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
pattern='^(feature|fix|docs|chore|refactor|test)/[0-9]+-[a-z0-9-]+$'

# 0) バージョンタグの push（例: git push origin v1.2.0 / --tags）だけは許可
if printf '%s' "$cmd" | grep -Eq '^git push( +[a-zA-Z0-9_-]+)? +(--tags|v[0-9]+\.[0-9]+\.[0-9]+) *$'; then
  exit 0
fi

# 1) main 上でのコミット・push・マージを拒否
if printf '%s' "$cmd" | grep -Eq 'git (commit|push|merge|rebase)'; then
  if [ "$branch" = "main" ]; then
    echo "ブロック: main ブランチ上での操作は禁止です。main から feature/<Issue番号>-<概要> を作成して作業してください（project-rules.yaml 参照）。" >&2
    exit 2
  fi
fi

# 2) main を明示した push を拒否
if printf '%s' "$cmd" | grep -Eq 'git push.*(\s|:)main(\s|$)'; then
  echo "ブロック: main への直接 push は禁止です。PR を作成してください。" >&2
  exit 2
fi

# 3) 新しいブランチ名の検査（git switch -c / checkout -b / branch）
new_branch="$(printf '%s' "$cmd" | sed -nE 's/.*git (switch -c|checkout -b|branch) +([^ ]+).*/\2/p')"
if [ -n "$new_branch" ] && ! printf '%s' "$new_branch" | grep -Eq "$pattern"; then
  echo "ブロック: ブランチ名 '$new_branch' は命名規則に合いません。例: feature/12-csv-export, fix/15-null-check" >&2
  exit 2
fi

exit 0
