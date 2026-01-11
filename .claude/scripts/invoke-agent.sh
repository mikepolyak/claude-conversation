#!/usr/bin/env bash
#
# invoke-agent.sh - Invoke a Claude agent with conversation context
#
# Usage: invoke-agent.sh <agent-name> <context-file> <output-file>
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$(cd "$SCRIPT_DIR/../agents/devils-advocate" && pwd)"
TIMEOUT_SECONDS="${CLAUDE_AGENT_TIMEOUT:-300}"

# Arguments
AGENT_NAME="${1:-}"
CONTEXT_FILE="${2:-}"
OUTPUT_FILE="${3:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[invoke-agent]${NC} $*" >&2
}

error() {
    echo -e "${RED}[invoke-agent ERROR]${NC} $*" >&2
}

warn() {
    echo -e "${YELLOW}[invoke-agent WARN]${NC} $*" >&2
}

# Validate arguments
if [[ -z "$AGENT_NAME" ]]; then
    error "Agent name is required"
    echo "Usage: $0 <agent-name> <context-file> <output-file>" >&2
    exit 1
fi

if [[ -z "$CONTEXT_FILE" ]]; then
    error "Context file is required"
    exit 1
fi

if [[ -z "$OUTPUT_FILE" ]]; then
    error "Output file is required"
    exit 1
fi

# Check if agent definition exists
AGENT_FILE="$AGENTS_DIR/${AGENT_NAME}.md"
if [[ ! -f "$AGENT_FILE" ]]; then
    error "Agent definition not found: $AGENT_FILE"
    exit 1
fi

# Check if context file exists
if [[ ! -f "$CONTEXT_FILE" ]]; then
    error "Context file not found: $CONTEXT_FILE"
    exit 1
fi

log "Invoking agent: $AGENT_NAME"
log "Context file: $CONTEXT_FILE"
log "Output file: $OUTPUT_FILE"

# Read agent definition and context
AGENT_DEFINITION=$(<"$AGENT_FILE")
CONTEXT=$(<"$CONTEXT_FILE")

# Construct prompt for agent
# The agent definition contains the system instructions
# The context contains the conversation state and specific task
PROMPT=$(cat <<EOF
You are being invoked as part of a multi-agent Devil's Advocate conversation.

$CONTEXT

Please provide your response following the guidelines in your agent definition.
EOF
)

# Create a temporary file for the full prompt
TEMP_PROMPT=$(mktemp)
trap "rm -f $TEMP_PROMPT" EXIT

echo "$PROMPT" > "$TEMP_PROMPT"

# IMPORTANT: This is a placeholder implementation
# In a real implementation, you would:
# 1. Use Claude API directly via curl/http client
# 2. Use a Claude CLI tool if available
# 3. Use MCP (Model Context Protocol) if supported
# 4. Use another agent invocation mechanism

# For now, this creates a template response that demonstrates the expected format
# Replace this with actual Claude API call

log "Generating agent response..."

# Placeholder: Simulate agent response
# In production, replace this with actual API call:
# claude_api_call "$AGENT_DEFINITION" "$PROMPT" > "$OUTPUT_FILE"

cat > "$OUTPUT_FILE" <<'RESPONSE'
## Agent Response

[This is a placeholder response. In production, this would be replaced with actual Claude API output.]

To integrate with Claude API:

1. **Option 1: Claude API Direct**
   ```bash
   curl https://api.anthropic.com/v1/messages \
     -H "content-type: application/json" \
     -H "x-api-key: $ANTHROPIC_API_KEY" \
     -H "anthropic-version: 2023-06-01" \
     -d "{
       \"model\": \"claude-3-5-sonnet-20241022\",
       \"max_tokens\": 4096,
       \"system\": \"$AGENT_DEFINITION\",
       \"messages\": [{\"role\": \"user\", \"content\": \"$PROMPT\"}]
     }"
   ```

2. **Option 2: Claude CLI** (if available)
   ```bash
   claude chat --agent-file "$AGENT_FILE" --input "$TEMP_PROMPT" > "$OUTPUT_FILE"
   ```

3. **Option 3: MCP Integration**
   Use Model Context Protocol to invoke agents within Claude Code environment

4. **Option 4: Interactive Mode**
   Open a new Claude Code session with the agent loaded and paste context

### Current Implementation Status
This script creates the invocation framework. To complete it:
- Add your ANTHROPIC_API_KEY to environment
- Uncomment and configure the appropriate integration method above
- Test agent invocation with a simple prompt

### Expected Output Format
Agents should respond with structured markdown following their role guidelines:
- Proposer: Position statements with evidence
- Challenger: Critiques with specific questions
- Moderator: Synthesis with actionable recommendations

RESPONSE

log "Agent response saved to: $OUTPUT_FILE"

# Validate output
if [[ ! -s "$OUTPUT_FILE" ]]; then
    error "Agent produced no output"
    exit 1
fi

log "Agent invocation complete"

# Return metadata about the invocation
cat <<METADATA
{
  "agent": "$AGENT_NAME",
  "context_file": "$CONTEXT_FILE",
  "output_file": "$OUTPUT_FILE",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "success"
}
METADATA
