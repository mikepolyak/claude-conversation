#!/usr/bin/env bash
#
# bmad-party-mode.sh - BMAD Multi-Agent Party Mode Orchestrator
#
# Facilitates collaborative discussions between BMAD infrastructure agents
#
# Usage: bmad-party-mode.sh --topic "Topic" --agents "atlas,rhea,astra" [options]
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONVERSATIONS_DIR="$(cd "$SCRIPT_DIR/../conversations" && pwd)"
AGENTS_DIR="$(cd "$SCRIPT_DIR/../agents/bmad-infra" && pwd)"
INVOKE_AGENT="$SCRIPT_DIR/invoke-agent.sh"

# Available BMAD agents
AVAILABLE_AGENTS=(
    "atlas:🧭:Platform Orchestrator"
    "rhea:🧬:Brownfield Discovery"
    "astra:🏛️:Azure Architecture"
    "terra:🧱:Terraform Stacks"
    "gabe:🔁:GitHub Delivery"
    "cora:🛡️:Security & IAM"
    "nina:🌐:Networking"
    "odin:🧯:SRE & Operations"
    "finn:💰:FinOps & Capacity"
    "user:👤:User Representative"
)

# Default values
TOPIC=""
AGENTS_LIST="atlas,user"  # Default to Atlas + User
MAX_ROUNDS=3
SESSION_ID="bmad-$(date +%Y%m%d-%H%M%S)"
USER_CONTEXT=""
PHASE="Discovery"
AUTO_CONTINUE="false"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Logging
log() {
    echo -e "${GREEN}[party-mode]${NC} $*"
}

error() {
    echo -e "${RED}[party-mode ERROR]${NC} $*" >&2
}

info() {
    echo -e "${CYAN}[party-mode INFO]${NC} $*"
}

agent_speak() {
    local icon=$1
    local name=$2
    shift 2
    echo -e "${MAGENTA}${icon} ${name}:${NC} $*"
}

# Usage
usage() {
    cat <<EOF
Usage: $0 --topic "Topic" [options]

Required:
  --topic <topic>               The infrastructure planning topic

Options:
  --agents <list>                Comma-separated agent list (default: atlas,user)
  --phase <phase>                Current phase: Discovery|Design|Implementation|Operations
  --max-rounds <n>               Maximum discussion rounds (default: 3)
  --session-id <id>              Custom session identifier
  --user-context <text>          Business/technical context
  --auto-continue                Don't pause between rounds
  --list-agents                  Show available agents
  --help                         Show this help

Available Agents:
$(for agent in "${AVAILABLE_AGENTS[@]}"; do
    IFS=':' read -r name icon desc <<< "$agent"
    echo "  $icon $name - $desc"
done)

Examples:
  # Brownfield discovery session
  $0 --topic "Adopt existing Azure subscriptions into Terraform" \\
     --agents "atlas,rhea,astra,user" --phase Discovery

  # Architecture design review
  $0 --topic "Landing zone design for 3 business units" \\
     --agents "atlas,astra,cora,nina,finn,user" --phase Design

  # Migration wave planning
  $0 --topic "Wave 1 migration: Networking resources" \\
     --agents "atlas,rhea,terra,nina,odin,user" --phase Implementation

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --topic)
            TOPIC="$2"
            shift 2
            ;;
        --agents)
            AGENTS_LIST="$2"
            shift 2
            ;;
        --phase)
            PHASE="$2"
            shift 2
            ;;
        --max-rounds)
            MAX_ROUNDS="$2"
            shift 2
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
        --list-agents)
            echo "Available BMAD Agents:"
            for agent in "${AVAILABLE_AGENTS[@]}"; do
                IFS=':' read -r name icon desc <<< "$agent"
                echo "  $icon $name - $desc"
            done
            exit 0
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

# Parse agents list
IFS=',' read -ra AGENTS <<< "$AGENTS_LIST"

# Validate agents exist
for agent in "${AGENTS[@]}"; do
    agent_file="$AGENTS_DIR/${agent}-agent.md"
    if [[ ! -f "$agent_file" ]]; then
        error "Agent not found: $agent (expected $agent_file)"
        exit 1
    fi
done

# Get agent metadata (icon and description)
get_agent_info() {
    local agent_name=$1
    for agent_info in "${AVAILABLE_AGENTS[@]}"; do
        IFS=':' read -r name icon desc <<< "$agent_info"
        if [[ "$name" == "$agent_name" ]]; then
            echo "$icon|$desc"
            return
        fi
    done
    echo "🤖|Unknown Agent"
}

# Create session directory
SESSION_DIR="$CONVERSATIONS_DIR/$SESSION_ID"
mkdir -p "$SESSION_DIR/rounds"

log "Starting BMAD Party Mode"
log "Topic: $TOPIC"
log "Phase: $PHASE"
log "Session ID: $SESSION_ID"
log "Agents: ${AGENTS[*]}"
log "Max Rounds: $MAX_ROUNDS"

# Initialize session metadata
cat > "$SESSION_DIR/session-metadata.json" <<EOF
{
  "session_id": "$SESSION_ID",
  "mode": "bmad-party-mode",
  "topic": "$TOPIC",
  "phase": "$PHASE",
  "agents": $(printf '%s\n' "${AGENTS[@]}" | jq -R . | jq -s .),
  "max_rounds": $MAX_ROUNDS,
  "user_context": "$USER_CONTEXT",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "in_progress",
  "current_round": 0
}
EOF

# Initialize transcript
TRANSCRIPT_FILE="$SESSION_DIR/transcript.jsonl"
touch "$TRANSCRIPT_FILE"

# Display party mode banner
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}          🎭 BMAD PARTY MODE: Multi-Agent Collaboration${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Topic:${NC} $TOPIC"
echo -e "${YELLOW}Phase:${NC} $PHASE"
echo -e "${YELLOW}Agents:${NC}"
for agent in "${AGENTS[@]}"; do
    IFS='|' read -r icon desc <<< "$(get_agent_info "$agent")"
    echo -e "  $icon ${agent} - ${desc}"
done
echo ""

# Build shared context
build_party_context() {
    local round=$1
    local agent=$2
    local context_file="$SESSION_DIR/party-context-r${round}-${agent}.txt"
    
    cat > "$context_file" <<EOF
BMAD PARTY MODE: Multi-Agent Infrastructure Planning

CONVERSATION_TOPIC: $TOPIC

CURRENT_PHASE: $PHASE

CURRENT_ROUND: $round / $MAX_ROUNDS

USER_CONTEXT: $USER_CONTEXT

PARTICIPATING AGENTS:
EOF
    
    for a in "${AGENTS[@]}"; do
        IFS='|' read -r icon desc <<< "$(get_agent_info "$a")"
        echo "$icon $a - $desc" >> "$context_file"
    done
    
    echo "" >> "$context_file"
    echo "YOUR ROLE: You are the ${agent} agent." >> "$context_file"
    echo "" >> "$context_file"
    
    # Add conversation history
    if [[ -f "$TRANSCRIPT_FILE" ]] && [[ -s "$TRANSCRIPT_FILE" ]]; then
        echo "CONVERSATION HISTORY:" >> "$context_file"
        echo "" >> "$context_file"
        
        while IFS= read -r line; do
            local round_num=$(echo "$line" | jq -r '.round')
            local agent_name=$(echo "$line" | jq -r '.agent')
            local message=$(echo "$line" | jq -r '.message')
            
            IFS='|' read -r icon _desc <<< "$(get_agent_info "$agent_name")"
            
            echo "--- Round $round_num: $icon $agent_name ---" >> "$context_file"
            echo "$message" >> "$context_file"
            echo "" >> "$context_file"
        done < "$TRANSCRIPT_FILE"
    fi
    
    # Round-specific instructions
    if [[ $round -eq 1 ]]; then
        cat >> "$context_file" <<EOF

ROUND 1 INSTRUCTIONS:
This is the opening round. Contribute your perspective on the topic:
- What is your area of concern/expertise related to this topic?
- What questions do you need answered?
- What constraints or requirements are you aware of?
- What risks or opportunities do you see?

Keep your contribution focused and specific to your domain.
EOF
    elif [[ $round -eq $MAX_ROUNDS ]]; then
        cat >> "$context_file" <<EOF

FINAL ROUND INSTRUCTIONS:
This is the synthesis round. Contribute to the final decision/plan:
- What consensus have we reached?
- What are the key action items?
- What decisions still need to be made?
- What are the next steps?

If you are Atlas, synthesize the discussion into an actionable plan.
If you are User, provide final approval/concerns/questions.
EOF
    else
        cat >> "$context_file" <<EOF

ROUND $round INSTRUCTIONS:
Build on previous contributions:
- Respond to questions directed at you
- Address concerns raised by other agents
- Provide additional information or clarification
- Identify dependencies or conflicts with other agents' proposals
EOF
    fi
    
    echo "$context_file"
}

# Record agent contribution
record_contribution() {
    local round=$1
    local agent=$2
    local response_file=$3
    
    local message=$(<"$response_file")
    
    local record=$(jq -n \
        --arg round "$round" \
        --arg agent "$agent" \
        --arg message "$message" \
        --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        '{
            round: ($round | tonumber),
            agent: $agent,
            message: $message,
            timestamp: $timestamp
        }')
    
    echo "$record" >> "$TRANSCRIPT_FILE"
}

# Display agent contribution
display_contribution() {
    local round=$1
    local agent=$2
    local response_file=$3
    
    IFS='|' read -r icon desc <<< "$(get_agent_info "$agent")"
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}Round $round: $icon $agent${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    cat "$response_file"
    echo ""
}

# Main party mode loop
info "Beginning multi-agent collaboration..."
echo ""

for ((round=1; round<=MAX_ROUNDS; round++)); do
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}                    ROUND $round of $MAX_ROUNDS${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Each agent contributes in sequence
    for agent in "${AGENTS[@]}"; do
        log "Round $round - Invoking $agent agent..."
        
        # Build context for this agent
        CONTEXT_FILE=$(build_party_context "$round" "$agent")
        
        # Invoke agent
        RESPONSE_FILE="$SESSION_DIR/rounds/r${round}-${agent}-response.md"
        
        if ! "$INVOKE_AGENT" "${agent}-agent" "$CONTEXT_FILE" "$RESPONSE_FILE" > /dev/null 2>&1; then
            error "Agent invocation failed for $agent in round $round"
            exit 1
        fi
        
        # Record and display contribution
        record_contribution "$round" "$agent" "$RESPONSE_FILE"
        display_contribution "$round" "$agent" "$RESPONSE_FILE"
        
        # Pause between agents (unless auto-continue or last agent in round)
        if [[ "$AUTO_CONTINUE" != "true" ]] && [[ "$agent" != "${AGENTS[-1]}" ]]; then
            read -p "Press Enter for next agent..."
        fi
    done
    
    # Update metadata
    jq --arg round "$round" '.current_round = ($round | tonumber)' \
        "$SESSION_DIR/session-metadata.json" > "$SESSION_DIR/session-metadata.json.tmp"
    mv "$SESSION_DIR/session-metadata.json.tmp" "$SESSION_DIR/session-metadata.json"
    
    # Pause between rounds (unless auto-continue or last round)
    if [[ "$AUTO_CONTINUE" != "true" ]] && [[ $round -lt $MAX_ROUNDS ]]; then
        echo ""
        read -p "Press Enter to continue to Round $((round + 1))..."
    fi
done

# Mark as complete
jq '.status = "complete" | .completed_at = $timestamp' \
    --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    "$SESSION_DIR/session-metadata.json" > "$SESSION_DIR/session-metadata.json.tmp"
mv "$SESSION_DIR/session-metadata.json.tmp" "$SESSION_DIR/session-metadata.json"

# Final summary
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}            Party Mode Complete: $MAX_ROUNDS Rounds${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo ""
log "Session directory: $SESSION_DIR"
log "Transcript: $TRANSCRIPT_FILE"
log "Total agent contributions: $((${#AGENTS[@]} * MAX_ROUNDS))"
echo ""

# Generate summary if synthesis script exists
if command -v "$SCRIPT_DIR/synthesize-insights.sh" &> /dev/null; then
    info "Generating collaboration summary..."
    "$SCRIPT_DIR/synthesize-insights.sh" "$SESSION_ID"
fi

info "Review full transcript at: $SESSION_DIR"
