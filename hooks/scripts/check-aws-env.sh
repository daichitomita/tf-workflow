#!/bin/bash

# stdin から tool_input を読み取り、terraform/terragrunt コマンドかどうか判定
COMMAND=$(jq -r '.tool_input.command // ""' < /dev/stdin)

if ! echo "$COMMAND" | grep -qE '(terraform|terragrunt)'; then
  # terraform/terragrunt 以外のコマンドはスキップ
  exit 0
fi

# AWS認証情報のチェック
if [ -n "$AWS_PROFILE" ]; then
  exit 0
elif [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
  exit 0
else
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"AWS環境変数が設定されていません。以下のいずれかを設定してください:\n- AWS_PROFILE\n- AWS_ACCESS_KEY_ID と AWS_SECRET_ACCESS_KEY"}}'
  exit 0
fi
