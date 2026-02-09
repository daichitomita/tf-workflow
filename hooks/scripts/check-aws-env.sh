#!/bin/bash

# stdin から tool_input を読み取り、terraform/terragrunt コマンドかどうか判定
COMMAND=$(jq -r '.tool_input.command // ""' < /dev/stdin)

if ! echo "$COMMAND" | grep -qE '(terraform|terragrunt)'; then
  # terraform/terragrunt 以外のコマンドはスキップ
  exit 0
fi

# AWS_PROFILE が設定されている場合
if [ -n "$AWS_PROFILE" ]; then
  # 認証が有効か確認
  if aws sts get-caller-identity --profile "$AWS_PROFILE" > /dev/null 2>&1; then
    exit 0
  fi
  # 認証切れ → deny + 自動認証を促す
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"AWS SSO セッションが期限切れです。","additionalContext":"aws sso login --profile '$AWS_PROFILE' を実行して再認証してください。"}}'
  exit 0
fi

# 静的キーが設定されている場合
if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
  if aws sts get-caller-identity > /dev/null 2>&1; then
    exit 0
  fi
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"AWS認証情報が無効です。AWS_ACCESS_KEY_ID と AWS_SECRET_ACCESS_KEY を確認してください。"}}'
  exit 0
fi

# 何も設定されていない
echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"AWS環境変数が設定されていません。以下のいずれかを設定してください:\n- AWS_PROFILE\n- AWS_ACCESS_KEY_ID と AWS_SECRET_ACCESS_KEY"}}'
exit 0
