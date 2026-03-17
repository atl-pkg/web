#!/bin/bash
# decision-enforce.sh — PostToolUse decision pattern enforcer
#
# Generated per-project by: pt enforce-hooks
# Installed at: <project_root>/.claude/hooks/decision-enforce.sh
#
# Reads: ~/.project-tracker/hooks/<slug>/decision-patterns.json
# On violation: exit 2 (Claude Code blocks and shows error)
# On warning:   exit 0 with stderr output (advisory only)
#
# Template — SLUG is substituted at generation time.

set -euo pipefail

SLUG="web"
PATTERNS_FILE="$HOME/.project-tracker/hooks/$SLUG/decision-patterns.json"

# Nothing to enforce if no patterns file exists yet
[[ ! -f "$PATTERNS_FILE" ]] && exit 0

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only enforce on file writes/edits
if [[ "$TOOL_NAME" == "Write" ]]; then
    CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty')
elif [[ "$TOOL_NAME" == "Edit" ]]; then
    CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // empty')
else
    exit 0
fi

[[ -z "$FILE_PATH" || -z "$CONTENT" ]] && exit 0

BLOCKERS=""
WARNINGS=""

add_blocker() { BLOCKERS="${BLOCKERS:+$BLOCKERS\n}[$1] $2"; }
add_warning()  { WARNINGS="${WARNINGS:+$WARNINGS\n}[$1] $2"; }

# Iterate over each decision in the patterns file
while IFS= read -r decision_id; do
    [[ "$decision_id" == _* ]] && continue  # skip _comment, _format, etc.

    # Apply file_filter if present
    file_filter=$(jq -r --arg d "$decision_id" '.[$d].file_filter // empty' "$PATTERNS_FILE")
    if [[ -n "$file_filter" ]] && ! echo "$FILE_PATH" | grep -qE "$file_filter"; then
        continue
    fi

    # Apply block patterns
    block_count=$(jq --arg d "$decision_id" '.[$d].block | length' "$PATTERNS_FILE" 2>/dev/null || echo 0)
    for ((i=0; i<block_count; i++)); do
        pattern=$(jq -r --arg d "$decision_id" --argjson i "$i" '.[$d].block[$i].pattern' "$PATTERNS_FILE")
        message=$(jq -r --arg d "$decision_id" --argjson i "$i" '.[$d].block[$i].message' "$PATTERNS_FILE")
        if echo "$CONTENT" | grep -qE "$pattern" 2>/dev/null; then
            add_blocker "$decision_id" "$message"
        fi
    done

    # Apply warn patterns
    warn_count=$(jq --arg d "$decision_id" '.[$d].warn | length' "$PATTERNS_FILE" 2>/dev/null || echo 0)
    for ((i=0; i<warn_count; i++)); do
        pattern=$(jq -r --arg d "$decision_id" --argjson i "$i" '.[$d].warn[$i].pattern' "$PATTERNS_FILE")
        message=$(jq -r --arg d "$decision_id" --argjson i "$i" '.[$d].warn[$i].message' "$PATTERNS_FILE")
        if echo "$CONTENT" | grep -qE "$pattern" 2>/dev/null; then
            add_warning "$decision_id" "$message"
        fi
    done

done < <(jq -r 'keys[]' "$PATTERNS_FILE" 2>/dev/null)

# Warnings: print to stderr, don't block
if [[ -n "$WARNINGS" ]]; then
    echo "" >&2
    echo "── pt decision warnings ─────────────────" >&2
    echo "File: $FILE_PATH" >&2
    echo -e "$WARNINGS" >&2
    echo "─────────────────────────────────────────" >&2
fi

# Blockers: print to stderr and exit 2
if [[ -n "$BLOCKERS" ]]; then
    echo "" >&2
    echo "══ pt decision VIOLATION ════════════════" >&2
    echo "File: $FILE_PATH" >&2
    echo -e "$BLOCKERS" >&2
    echo "" >&2
    echo "Make a surgical Edit to fix before proceeding." >&2
    echo "════════════════════════════════════════" >&2
    exit 2
fi

exit 0
