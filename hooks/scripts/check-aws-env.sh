#!/bin/bash

# AWS認証情報のチェック
# matcher で terraform/terragrunt コマンドのフィルタリング済み
if [ -n "$AWS_PROFILE" ]; then
  exit 0
elif [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
  exit 0
else
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"AWS環境変数が設定されていません。以下のいずれかを設定してください:\n- AWS_PROFILE\n- AWS_ACCESS_KEY_ID と AWS_SECRET_ACCESS_KEY"}}'
  exit 0
fi
