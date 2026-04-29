#!/usr/bin/env bash
# =============================================================================
# scripts/security-check.sh
#
# PreToolUse security guard for GitHub Copilot / Claude Code hooks.
#
# The AI runtime pipes a JSON object to stdin describing the tool call it is
# about to make.  This script inspects the file content (or path) and returns
# a JSON response that either ALLOWS or DENIES the operation.
#
# Expected stdin shape (simplified):
#   {
#     "tool": "EditFile",
#     "input": {
#       "path": "app/components/UserLogin.vue",
#       "content": "... file content ..."
#     }
#   }
#
# Response shape (allow):
#   { "action": "allow" }
#
# Response shape (deny):
#   { "action": "deny", "reason": "Human-readable explanation" }
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Read the full JSON payload from stdin
# ---------------------------------------------------------------------------
PAYLOAD=$(cat)

# ---------------------------------------------------------------------------
# Extract the file content field.
# We use `grep -o` + a small Python one-liner for portability (no jq required).
# If Python is unavailable, fall back to a raw string search on the payload.
# ---------------------------------------------------------------------------
if command -v python3 &>/dev/null; then
  FILE_CONTENT=$(echo "$PAYLOAD" | python3 -c "
import sys, json
data = json.load(sys.stdin)
# Support both 'content' and 'new_content' field names used by different agents
print(data.get('input', {}).get('content', '') or data.get('input', {}).get('new_content', ''))
" 2>/dev/null || echo "")
else
  # Fallback: treat the whole payload as the search target
  FILE_CONTENT="$PAYLOAD"
fi

# ---------------------------------------------------------------------------
# RULE 1 — Block plain-text passwords
# ---------------------------------------------------------------------------
BLOCKED_PATTERN="DANGEROUS_PLAINTEXT_PASSWORD"

if echo "$FILE_CONTENT" | grep -qF "$BLOCKED_PATTERN"; then
  cat <<JSON
{
  "action": "deny",
  "reason": "Security violation: the file contains the literal string '${BLOCKED_PATTERN}'. Store credentials in environment variables or a secrets manager, never in source code."
}
JSON
  exit 0
fi

# ---------------------------------------------------------------------------
# RULE 2 — Block hardcoded private keys / PEM blocks
# ---------------------------------------------------------------------------
if echo "$FILE_CONTENT" | grep -qE "-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----"; then
  cat <<JSON
{
  "action": "deny",
  "reason": "Security violation: file appears to contain a private key (PEM block). Never commit private keys to source control."
}
JSON
  exit 0
fi

# ---------------------------------------------------------------------------
# All checks passed — allow the operation
# ---------------------------------------------------------------------------
cat <<JSON
{
  "action": "allow"
}
JSON
