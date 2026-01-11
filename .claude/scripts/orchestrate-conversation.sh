#!/usr/bin/env bash
#
# orchestrate-conversation.sh - Orchestrate multi-agent Devil's Advocate conversations
#
# Usage: orchestrate-conversation.sh --topic "Topic" [options]
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONVERSATIONS_DIR="$(cd "$SCRIPT_DIR/../conversations" && pwd)"
INVOKE_AGENT="$SCRIPT_DIR/invoke-agent.sh"

# Default values
TOPIC=""
MAX_TURNS=10
INCLUDE_MODERATOR="true"
SESSION_ID=$(date +%Y%m%d-%H%M%S)
USER_CONTEXT=""
AUTO_CONTINUE="false"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging
log() {
    echo -e "${GREEN}[orchestrator]${NC} $*"
}

error() {
    echo -e "${RED}[orchestrator ERROR]${NC} $*" >&2
}

warn() {
    echo -e "${YELLOW}[orchestrator WARN]${NC} $*"
}

info() {
    echo -e "${CYAN}[orchestrator INFO]${NC} $*"
}

# Usage information
usage() {
    cat <<EOF
Usage: $0 --topic "Your topic" [options]

Required:
  --topic <topic>           The debate topic

Options:
  --max-turns <n>           Maximum conversation turns (default: 10)
  --include-moderator       Include moderator synthesis (default: true)
  --no-moderator            Skip moderator synthesis
  --session-id <id>         Custom session identifier
  --user-context <text>     Additional context for agents
  --auto-continue           Don't pause between turns
  --help                    Show this help message

Examples:
  # Basic conversation
  $0 --topic "Should we use microservices?"

  # Extended conversation with custom context
  $0 --topic "API design approach" --max-turns 12 --user-context "We have 3 teams"

  # Quick conversation without pauses
  $0 --topic "Database choice" --auto-continue

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --topic)
            TOPIC="$2"
            shift 2
            ;;
        --max-turns)
            MAX_TURNS="$2"
            shift 2
            ;;
        --include-moderator)
            INCLUDE_MODERATOR="true"
            shift
            ;;
        --no-moderator)
            INCLUDE_MODERATOR="false"
            shift
            ;;
        --session-id)
            SESSION_ID="$2"
            shift 2
            ;;
        --user-context)
            USER_CONTEXT="$2"
            shift 2
            ;;
        --auto-continue)
            AUTO_CONTINUE="true"
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$TOPIC" ]]; then
    error "Topic is required"
    usage
    exit 1
fi

# Create session directory
SESSION_DIR="$CONVERSATIONS_DIR/$SESSION_ID"
mkdir -p "$SESSION_DIR/checkpoints"
mkdir -p "$SESSION_DIR/responses"

log "Starting Devil's Advocate conversation"
log "Topic: $TOPIC"
log "Session ID: $SESSION_ID"
log "Session directory: $SESSION_DIR"
log "Max turns: $MAX_TURNS"
log "Include moderator: $INCLUDE_MODERATOR"

# Initialize session metadata
cat > "$SESSION_DIR/session-metadata.json" <<EOF
{
  "session_id": "$SESSION_ID",
  "topic": "$TOPIC",
  "max_turns": $MAX_TURNS,
  "include_moderator": $INCLUDE_MODERATOR,
  "user_context": "$USER_CONTEXT",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "in_progress",
  "current_turn": 0,
  "current_phase": "opening"
}
EOF

# Initialize transcript
TRANSCRIPT_FILE="$SESSION_DIR/transcript.jsonl"
touch "$TRANSCRIPT_FILE"

# Function to determine conversation phase
get_phase() {
    local turn=$1
    if [[ $turn -le 2 ]]; then
        echo "Opening"
    elif [[ $turn -ge $((MAX_TURNS - 2)) ]]; then
        echo "Synthesis"
    else
        echo "Deep Exploration"
    fi
}

# Function to get next agent
get_next_agent() {
    local turn=$1
    local phase=$2
    
    # Phase-based agent selection
    if [[ "$phase" == "Synthesis" ]] && [[ "$INCLUDE_MODERATOR" == "true" ]]; then
        echo "moderator-agent"
    elif [[ $((turn % 2)) -eq 1 ]]; then
        echo "proposer-agent"
    else
        echo "challenger-agent"
    fi
}

# Function to build agent context
build_agent_context() {
    local agent=$1
    local turn=$2
    local phase=$3
    
    local context_file="$SESSION_DIR/context-turn-$turn.txt"
    
    # Build context with conversation history
    cat > "$context_file" <<EOF
CONVERSATION_TOPIC: $TOPIC

CONVERSATION_PHASE: $phase

CURRENT_TURN: $turn

USER_CONTEXT: $USER_CONTEXT

CONVERSATION HISTORY:
EOF
    
    # Append previous turns from transcript
    if [[ -f "$TRANSCRIPT_FILE" ]] && [[ -s "$TRANSCRIPT_FILE" ]]; then
        echo "" >> "$context_file"
        echo "Previous turns:" >> "$context_file"
        
        while IFS= read -r line; do
            local turn_num=$(echo "$line" | jq -r '.turn')
            local agent_name=$(echo "$line" | jq -r '.agent')
            local role=$(echo "$line" | jq -r '.role')
            local message=$(echo "$line" | jq -r '.message')
            
            echo "" >> "$context_file"
            echo "--- Turn $turn_num: $role ($agent_name) ---" >> "$context_file"
            echo "$message" >> "$context_file"
        done < "$TRANSCRIPT_FILE"
    else
        echo "No previous turns." >> "$context_file"
    fi
    
    # Agent-specific instructions
    echo "" >> "$context_file"
    if [[ "$agent" == "proposer-agent" ]]; then
        if [[ $turn -eq 1 ]]; then
            echo "You are opening the debate. State your position clearly with supporting arguments." >> "$context_file"
        else
            echo "Respond to the Challenger's latest critiques. Address their concerns directly." >> "$context_file"
        fi
    elif [[ "$agent" == "challenger-agent" ]]; then
        echo "Challenge the Proposer's latest arguments. Identify weaknesses and propose alternatives." >> "$context_file"
    elif [[ "$agent" == "moderator-agent" ]]; then
        echo "Synthesize the debate. Identify consensus, disagreements, and actionable conclusions." >> "$context_file"
    fi
    
    echo "$context_file"
}

# Function to record turn in transcript
record_turn() {
    local turn=$1
    local agent=$2
    local role=$3
    local response_file=$4
    
    # Read response
    local message=$(<"$response_file")
    
    # Create JSON record
    local record=$(jq -n \
        --arg turn "$turn" \
        --arg agent "$agent" \
        --arg role "$role" \
        --arg message "$message" \
        --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        '{
            turn: ($turn | tonumber),
            agent: $agent,
            role: $role,
            message: $message,
            timestamp: $timestamp
        }')
    
    echo "$record" >> "$TRANSCRIPT_FILE"
}

# Function to display turn
display_turn() {
    local turn=$1
    local agent=$2
    local role=$3
    local response_file=$4
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Turn $turn: $role${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    cat "$response_file"
    echo ""
}

# Function to check termination conditions
should_terminate() {
    local turn=$1
    
    # Check max turns
    if [[ $turn -ge $MAX_TURNS ]]; then
        return 0
    fi
    
    # Check for consensus/conclusion signals in last response
    # (This is a simple check - could be enhanced with NLP)
    local last_response="$SESSION_DIR/responses/turn-$turn-response.md"
    if [[ -f "$last_response" ]]; then
        if grep -qi "Status.*Ready to Synthesize\|Status.*Propose Conclusion" "$last_response"; then
            return 0
        fi
    fi
    
    return 1
}

# Function to create checkpoint
create_checkpoint() {
    local turn=$1
    local checkpoint_file="$SESSION_DIR/checkpoints/checkpoint-turn-$turn.json"
    
    cp "$SESSION_DIR/session-metadata.json" "$checkpoint_file"
    log "Checkpoint created at turn $turn"
}

# Main conversation loop
info "Beginning conversation..."
echo ""

for ((turn=1; turn<=MAX_TURNS; turn++)); do
    # Update phase
    PHASE=$(get_phase $turn)
    
    # Get next agent
    AGENT=$(get_next_agent $turn "$PHASE")
    
    # Determine role name
    case $AGENT in
        proposer-agent)
            ROLE="Proposer"
            ;;
        challenger-agent)
            ROLE="Challenger"
            ;;
        moderator-agent)
            ROLE="Moderator"
            ;;
    esac
    
    log "Turn $turn/$MAX_TURNS - Phase: $PHASE - Agent: $ROLE"
    
    # Build context
    CONTEXT_FILE=$(build_agent_context "$AGENT" "$turn" "$PHASE")
    
    # Invoke agent
    RESPONSE_FILE="$SESSION_DIR/responses/turn-$turn-response.md"
    
    info "Invoking $ROLE agent..."
    if ! "$INVOKE_AGENT" "$AGENT" "$CONTEXT_FILE" "$RESPONSE_FILE" > /dev/null 2>&1; then
        error "Agent invocation failed for $AGENT at turn $turn"
        exit 1
    fi
    
    # Record turn in transcript
    record_turn "$turn" "$AGENT" "$ROLE" "$RESPONSE_FILE"
    
    # Display turn
    display_turn "$turn" "$AGENT" "$ROLE" "$RESPONSE_FILE"
    
    # Update metadata
    jq --arg turn "$turn" --arg phase "$PHASE" \
        '.current_turn = ($turn | tonumber) | .current_phase = $phase' \
        "$SESSION_DIR/session-metadata.json" > "$SESSION_DIR/session-metadata.json.tmp"
    mv "$SESSION_DIR/session-metadata.json.tmp" "$SESSION_DIR/session-metadata.json"
    
    # Create checkpoint every 2 turns
    if [[ $((turn % 2)) -eq 0 ]]; then
        create_checkpoint $turn
    fi
    
    # Check termination conditions
    if should_terminate $turn; then
        log "Conversation termination conditions met"
        break
    fi
    
    # Pause between turns (unless auto-continue)
    if [[ "$AUTO_CONTINUE" != "true" ]] && [[ $turn -lt $MAX_TURNS ]]; then
        echo ""
        read -p "Press Enter to continue to next turn (or Ctrl+C to stop)..."
    fi
done

# Mark conversation as complete
jq '.status = "complete" | .completed_at = $timestamp' \
    --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    "$SESSION_DIR/session-metadata.json" > "$SESSION_DIR/session-metadata.json.tmp"
mv "$SESSION_DIR/session-metadata.json.tmp" "$SESSION_DIR/session-metadata.json"

# Final summary
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Conversation Complete${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
log "Total turns: $turn"
log "Session directory: $SESSION_DIR"
log "Transcript: $TRANSCRIPT_FILE"
echo ""

# Optionally generate insights
if command -v "$SCRIPT_DIR/synthesize-insights.sh" &> /dev/null; then
    info "Generating insights summary..."
    "$SCRIPT_DIR/synthesize-insights.sh" "$SESSION_ID"
fi

info "You can review the full conversation at: $SESSION_DIR"
