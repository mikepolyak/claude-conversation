#!/usr/bin/env bash
#
# synthesize-insights.sh - Generate insights summary from conversation transcript
#
# Usage: synthesize-insights.sh <session-id>
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONVERSATIONS_DIR="$(cd "$SCRIPT_DIR/../conversations" && pwd)"

# Arguments
SESSION_ID="${1:-}"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Logging
log() {
    echo -e "${GREEN}[synthesize]${NC} $*"
}

error() {
    echo -e "${RED}[synthesize ERROR]${NC} $*" >&2
}

# Validate arguments
if [[ -z "$SESSION_ID" ]]; then
    error "Session ID is required"
    echo "Usage: $0 <session-id>" >&2
    exit 1
fi

SESSION_DIR="$CONVERSATIONS_DIR/$SESSION_ID"
TRANSCRIPT_FILE="$SESSION_DIR/transcript.jsonl"
INSIGHTS_FILE="$SESSION_DIR/insights.md"

# Validate session exists
if [[ ! -d "$SESSION_DIR" ]]; then
    error "Session not found: $SESSION_ID"
    exit 1
fi

if [[ ! -f "$TRANSCRIPT_FILE" ]]; then
    error "Transcript not found: $TRANSCRIPT_FILE"
    exit 1
fi

log "Generating insights for session: $SESSION_ID"

# Read metadata
METADATA=$(cat "$SESSION_DIR/session-metadata.json")
TOPIC=$(echo "$METADATA" | jq -r '.topic')
TOTAL_TURNS=$(echo "$METADATA" | jq -r '.current_turn')
STARTED_AT=$(echo "$METADATA" | jq -r '.started_at')
COMPLETED_AT=$(echo "$METADATA" | jq -r '.completed_at // "in progress"')

# Extract turns by agent
PROPOSER_TURNS=$(jq -r 'select(.agent == "proposer-agent") | .message' "$TRANSCRIPT_FILE")
CHALLENGER_TURNS=$(jq -r 'select(.agent == "challenger-agent") | .message' "$TRANSCRIPT_FILE")
MODERATOR_TURNS=$(jq -r 'select(.agent == "moderator-agent") | .message' "$TRANSCRIPT_FILE")

# Count turns by agent
PROPOSER_COUNT=$(jq -s 'map(select(.agent == "proposer-agent")) | length' "$TRANSCRIPT_FILE")
CHALLENGER_COUNT=$(jq -s 'map(select(.agent == "challenger-agent")) | length' "$TRANSCRIPT_FILE")
MODERATOR_COUNT=$(jq -s 'map(select(.agent == "moderator-agent")) | length' "$TRANSCRIPT_FILE")

log "Analyzing conversation..."
log "Total turns: $TOTAL_TURNS"
log "Proposer turns: $PROPOSER_COUNT"
log "Challenger turns: $CHALLENGER_COUNT"
log "Moderator turns: $MODERATOR_COUNT"

# Generate insights document
cat > "$INSIGHTS_FILE" <<EOF
# Conversation Insights: $TOPIC

## Session Information

- **Session ID**: $SESSION_ID
- **Topic**: $TOPIC
- **Started**: $STARTED_AT
- **Completed**: $COMPLETED_AT
- **Total Turns**: $TOTAL_TURNS

## Turn Distribution

- **Proposer**: $PROPOSER_COUNT turns
- **Challenger**: $CHALLENGER_COUNT turns
- **Moderator**: $MODERATOR_COUNT turns

## Conversation Flow

EOF

# Add turn-by-turn summary
echo "### Turn Summary" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"

jq -r '.turn as $turn | .role as $role | .timestamp as $ts | 
       "**Turn \($turn)** (\($role)) - \($ts)"' "$TRANSCRIPT_FILE" >> "$INSIGHTS_FILE"

echo "" >> "$INSIGHTS_FILE"

# Extract key themes (simple keyword analysis)
echo "## Key Themes" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"
echo "The following themes emerged during the conversation:" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"

# Simple word frequency analysis for common debate topics
declare -A keywords=(
    ["complexity"]="Complexity and simplicity trade-offs"
    ["cost"]="Cost considerations"
    ["risk"]="Risk assessment and mitigation"
    ["team"]="Team capabilities and structure"
    ["performance"]="Performance implications"
    ["scalability"]="Scalability concerns"
    ["security"]="Security considerations"
    ["alternative"]="Alternative approaches"
)

for keyword in "${!keywords[@]}"; do
    count=$(jq -r '.message' "$TRANSCRIPT_FILE" | grep -io "$keyword" | wc -l | tr -d ' ')
    if [[ $count -gt 2 ]]; then
        echo "- **${keywords[$keyword]}**: Mentioned $count times" >> "$INSIGHTS_FILE"
    fi
done

echo "" >> "$INSIGHTS_FILE"

# Add full transcript reference
echo "## Full Conversation Transcript" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"
echo "For the complete conversation, see:" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"
echo "- **Transcript**: [\`transcript.jsonl\`]($TRANSCRIPT_FILE)" >> "$INSIGHTS_FILE"
echo "- **Individual Responses**: \`responses/\` directory" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"

# Add moderator synthesis if available
if [[ $MODERATOR_COUNT -gt 0 ]]; then
    echo "## Moderator Synthesis" >> "$INSIGHTS_FILE"
    echo "" >> "$INSIGHTS_FILE"
    echo "The moderator provided the following synthesis:" >> "$INSIGHTS_FILE"
    echo "" >> "$INSIGHTS_FILE"
    echo '```' >> "$INSIGHTS_FILE"
    echo "$MODERATOR_TURNS" >> "$INSIGHTS_FILE"
    echo '```' >> "$INSIGHTS_FILE"
    echo "" >> "$INSIGHTS_FILE"
fi

# Add recommendations for action
echo "## Next Steps" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"
echo "Based on this conversation, consider:" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"
echo "1. **Review the full transcript** to understand all arguments and counterarguments" >> "$INSIGHTS_FILE"
echo "2. **Extract action items** from the moderator's synthesis (if available)" >> "$INSIGHTS_FILE"
echo "3. **Identify areas of consensus** that can be acted upon" >> "$INSIGHTS_FILE"
echo "4. **Investigate unresolved questions** that require external data or expertise" >> "$INSIGHTS_FILE"
echo "5. **Share insights** with stakeholders who need to understand the trade-offs" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"

# Add metadata footer
echo "---" >> "$INSIGHTS_FILE"
echo "" >> "$INSIGHTS_FILE"
echo "*Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)*" >> "$INSIGHTS_FILE"
echo "*Session Directory: \`$SESSION_DIR\`*" >> "$INSIGHTS_FILE"

log "Insights saved to: $INSIGHTS_FILE"

# Display insights summary
echo ""
cat "$INSIGHTS_FILE"
