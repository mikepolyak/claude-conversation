# Devil's Advocate Multi-Agent Conversation System

A native Claude Code system for orchestrating structured debates between AI agents using the Devil's Advocate pattern. Surface blind spots, stress-test ideas, and arrive at better solutions through rigorous multi-agent discussion.

## 🎯 Overview

This system enables **two or more Claude Code sessions** to have structured conversations where:
- **Proposer Agent** proposes and defends positions with evidence
- **Challenger Agent** questions assumptions, finds weaknesses, proposes alternatives  
- **Moderator Agent** synthesizes insights and identifies actionable conclusions

**Key Benefits:**
- 🔍 **Surface blind spots** that single-perspective analysis misses
- 💪 **Stress-test ideas** through rigorous intellectual challenge
- 🎯 **Find better solutions** by exploring trade-offs systematically
- 📝 **Document reasoning** with complete conversation transcripts
- 🔄 **Iterate quickly** on architectural and strategic decisions

## 🚀 Quick Start

### Basic Usage

```bash
# Simple debate
.claude/scripts/orchestrate-conversation.sh --topic "Should we use microservices?"

# With context
.claude/scripts/orchestrate-conversation.sh \
  --topic "Database choice for our application" \
  --user-context "3 teams, expecting 100k users, read-heavy workload"

# Extended conversation
.claude/scripts/orchestrate-conversation.sh \
  --topic "API design approach" \
  --max-turns 12 \
  --auto-continue
```

### Via Custom Command (if integrated)

```bash
claude devils-advocate --topic "Should we adopt event-driven architecture?"
claude devils-advocate --topic "React vs Vue" --max_turns 8
```

## 📁 Project Structure

```
claude-conversation/
├── .claude/
│   ├── agents/
│   │   ├── devils-advocate/              # Devil's Advocate debate agents
│   │   │   ├── proposer-agent.md
│   │   │   ├── challenger-agent.md
│   │   │   └── moderator-agent.md
│   │   └── bmad-infra/                   # BMAD infrastructure agents
│   │       ├── atlas-agent.md            # Platform orchestrator
│   │       ├── user-agent.md             # User representative
│   │       └── [8 specialist agents]
│   ├── commands/
│   │   └── devils-advocate.md
│   ├── conversations/
│   │   └── <session-id>/                 # Shared by both systems
│   └── scripts/
│       ├── orchestrate-conversation.sh   # Devil's Advocate orchestrator
│       ├── bmad-party-mode.sh            # BMAD multi-agent orchestrator
│       ├── invoke-agent.sh               # Shared agent invocation
│       └── synthesize-insights.sh        # Shared insights generation
├── examples/
│   └── example-conversation.md
├── README.md                              # Main documentation
├── BMAD-README.md                         # BMAD-specific guide
└── QUICKSTART.md
```

## 🎭 How It Works

### Conversation Flow

```
Turn 1: Proposer    → States position with arguments and evidence
Turn 2: Challenger  → Questions assumptions, identifies concerns
Turn 3: Proposer    → Addresses challenges, strengthens position
Turn 4: Challenger  → Probes deeper, proposes alternatives
Turn 5: Proposer    → Refines position based on valid critiques
Turn 6: Challenger  → Tests edge cases, explores failure modes
...
Turn N: Moderator   → Synthesizes consensus, surfaces blind spots
```

### Conversation Phases

**Opening (Turns 1-2)**
- Establish initial position
- Identify key assumptions
- Surface initial concerns

**Deep Exploration (Turns 3-8)**
- Rigorous back-and-forth debate
- Address specific critiques
- Explore alternatives
- Test edge cases

**Synthesis (Final turns)**
- Identify areas of consensus
- Map remaining disagreements
- Surface blind spots
- Provide actionable recommendations

## 🛠️ Components

### Agent Definitions

Located in `.claude/agents/devils-advocate/`:

**Proposer Agent** (`proposer-agent.md`)
- Articulates clear positions with evidence
- Defends against challenges systematically
- Acknowledges valid critiques
- Seeks truth over "winning"

**Challenger Agent** (`challenger-agent.md`)
- Questions assumptions rigorously
- Identifies weaknesses and gaps
- Proposes concrete alternatives
- Stress-tests positions

**Moderator Agent** (`moderator-agent.md`)
- Synthesizes both perspectives
- Maps consensus and disagreements
- Surfaces revealed blind spots
- Generates actionable conclusions

### Scripts

**`orchestrate-conversation.sh`**
- Manages turn-taking between agents
- Builds conversation context
- Records transcript in JSONL format
- Creates checkpoints for resumption
- Handles termination conditions

**`invoke-agent.sh`**
- Invokes individual agents with context
- Captures agent responses
- Handles timeouts and errors
- Returns structured output

**`synthesize-insights.sh`**
- Generates conversation summary
- Analyzes key themes
- Extracts moderator synthesis
- Provides actionable next steps

## 📖 Usage Guide

### Command-Line Options

```bash
orchestrate-conversation.sh [options]

Required:
  --topic <topic>           The debate topic

Options:
  --max-turns <n>           Maximum turns (default: 10)
  --include-moderator       Include moderator synthesis (default: true)
  --no-moderator            Skip moderator synthesis
  --session-id <id>         Custom session identifier
  --user-context <text>     Additional context for agents
  --auto-continue           Don't pause between turns
  --help                    Show help message
```

### Common Use Cases

#### Architecture Decisions
```bash
# Microservices vs monolith
./claude/scripts/orchestrate-conversation.sh \
  --topic "Should we adopt microservices architecture?" \
  --user-context "Team of 15, 3 domains, current monolith has deployment bottlenecks"

# API design
./claude/scripts/orchestrate-conversation.sh \
  --topic "REST vs GraphQL for our API" \
  --max-turns 8
```

#### Technology Choices
```bash
# Database selection
./claude/scripts/orchestrate-conversation.sh \
  --topic "PostgreSQL vs MongoDB" \
  --user-context "Read-heavy workload, complex queries, need ACID"

# Frontend framework
./claude/scripts/orchestrate-conversation.sh \
  --topic "React vs Vue vs Svelte" \
  --max-turns 12
```

#### Process Decisions
```bash
# Development practices
./claude/scripts/orchestrate-conversation.sh \
  --topic "TDD vs test-after development"

# Team structure
./claude/scripts/orchestrate-conversation.sh \
  --topic "Feature teams vs component teams" \
  --user-context "40 engineers, 6 products, shared platform"
```

## 📊 Output Format

### Transcript Structure

Conversations are stored as JSONL (JSON Lines):

```json
{"turn": 1, "agent": "proposer-agent", "role": "Proposer", "message": "...", "timestamp": "2026-01-11T17:00:00Z"}
{"turn": 2, "agent": "challenger-agent", "role": "Challenger", "message": "...", "timestamp": "2026-01-11T17:02:30Z"}
```

### Session Metadata

```json
{
  "session_id": "20260111-170000",
  "topic": "Should we use microservices?",
  "max_turns": 10,
  "include_moderator": true,
  "started_at": "2026-01-11T17:00:00Z",
  "completed_at": "2026-01-11T17:45:00Z",
  "status": "complete",
  "current_turn": 9
}
```

### Insights Summary

Auto-generated markdown with:
- Session information and turn distribution
- Key themes identified
- Moderator synthesis (if included)
- Actionable next steps
- Links to full transcript

## 🔧 Configuration

### Agent Invocation

The system uses `invoke-agent.sh` which currently provides a **placeholder implementation**. To integrate with actual Claude API:

**Option 1: Claude API Direct**
```bash
# Edit invoke-agent.sh to use Claude API
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -d '{"model": "claude-3-5-sonnet-20241022", "system": "...", "messages": [...]}'
```

**Option 2: Claude CLI** (if available)
```bash
# Use Claude CLI tool
claude chat --agent-file "$AGENT_FILE" --input "$CONTEXT_FILE"
```

**Option 3: MCP Integration**
Use Model Context Protocol within Claude Code environment

**Option 4: Interactive Mode**
Open new Claude Code sessions with agent definitions loaded

### Environment Variables

```bash
# Agent invocation timeout (seconds)
export CLAUDE_AGENT_TIMEOUT=300

# Conversation storage location (optional)
export CLAUDE_CONVERSATIONS_DIR="/custom/path"
```

## 💡 Best Practices

### Topic Formulation

✅ **Good Topics**
- "Should we adopt microservices for the order processing system?"
- "PostgreSQL vs MongoDB for our analytics workload"
- "How to reduce deployment time from 45 minutes to under 10?"

❌ **Poor Topics**
- "Should we use microservices?" (too broad)
- "What's the best database?" (no context)
- "How to improve performance?" (vague)

### Context Provision

Always include relevant context:
- Team size and structure
- Scale (users, data, requests)
- Constraints (budget, timeline, expertise)
- Current pain points
- Business requirements

### Turn Allocation

- **Simple decisions**: 6-8 turns
- **Standard debates**: 10 turns (default)
- **Complex architecture**: 12-15 turns
- **Deep investigation**: 15+ turns

## 👁 Example Conversation

See [`examples/example-conversation.md`](examples/example-conversation.md) for a complete sample conversation on the microservices vs monolith debate.

## 🏛️ BMAD Infrastructure Multi-Agent System

In addition to the Devil's Advocate system, this project includes **BMAD** (Build More, Automate Deep™) - a specialized multi-agent system for Azure Terraform Stacks infrastructure planning.

### Available BMAD Agents

- 🧭 **Atlas** - Platform Orchestrator & Delivery Lead
- 🧬 **Rhea** - Brownfield Discovery & Adoption
- 🏛️ **Astra** - Azure Architecture & Landing Zone
- 🧱 **Terra** - Terraform Stacks & IaC Engineering
- 🔁 **Gabe** - GitHub Delivery & Automation
- 🛡️ **Cora** - Security, IAM & Compliance
- 🌐 **Nina** - Networking & Connectivity
- 🧯 **Odin** - SRE / Operations & Reliability
- 💰 **Finn** - FinOps & Capacity
- 👤 **User** - User Representative (answers agent questions)

### BMAD Party Mode

BMAD agents work together in "Party Mode" for collaborative infrastructure planning:

```bash
# Brownfield discovery session
.claude/scripts/bmad-party-mode.sh \
  --topic "Adopt existing Azure subscriptions into Terraform" \
  --agents "atlas,rhea,astra,user" \
  --phase Discovery

# Architecture design review
.claude/scripts/bmad-party-mode.sh \
  --topic "Landing zone design for 3 business units" \
  --agents "atlas,astra,cora,nina,finn,user" \
  --phase Design \
  --max-rounds 4

# Migration wave planning
.claude/scripts/bmad-party-mode.sh \
  --topic "Wave 1 migration: Networking resources" \
  --agents "atlas,rhea,terra,nina,odin,user" \
  --phase Implementation
```

### Key Features

- **Brownfield-First**: Safely adopt existing infrastructure before building new
- **Multi-Agent Collaboration**: Specialists work together across rounds
- **User Agent**: Interactive agent answers questions and makes decisions
- **Phase-Aware**: Discovery → Design → Implementation → Operations
- **Shared Infrastructure**: Uses same invocation and transcript system

**Full documentation**: See [`BMAD-README.md`](BMAD-README.md)

## 🤝 Integration with Claude Code

This system is designed to work seamlessly with Claude Code's native features:

- **Custom Agents**: Load agent definitions automatically
- **Custom Commands**: Invoke via `claude devils-advocate` command
- **Hooks**: Integrate with Claude Code hooks for automated debates
- **Transcript Archive**: Compatible with claude-hooks transcript system

## 🛤️ Roadmap

**Current Status: Framework Implementation**
- ✅ Agent definitions (Proposer, Challenger, Moderator)
- ✅ Orchestration script with turn management
- ✅ Transcript recording in JSONL format
- ✅ Insights synthesis
- ✅ Custom command definition
- ⚠️ Agent invocation (placeholder - needs API integration)

**Next Steps:**
- 🔄 Integrate with Claude API for actual agent invocation
- 🔄 Test with real conversations
- 🔄 Refine agent prompts based on conversation quality
- 🔄 Add conversation resumption from checkpoints
- 🔄 Create web UI for conversation visualization

## 📝 Requirements

- **bash** 4.0+ (for associative arrays)
- **jq** - JSON processor (`brew install jq` or `apt install jq`)
- **Claude API access** (for production agent invocation)

## 🤔 FAQ

**Q: How is this different from AutoGen or CrewAI?**
A: This system is built natively for Claude Code's ecosystem, using custom agents and commands rather than external frameworks. It's simpler, more focused on the Devil's Advocate pattern, and integrates seamlessly with Claude Code workflows.

**Q: Can I customize the agents?**
A: Yes! Edit the agent definition markdown files in `.claude/agents/devils-advocate/` to customize agent behavior, tone, and tactics.

**Q: Can I add more agents?**
A: Absolutely. Create new agent definition files and modify the orchestrator's `get_next_agent()` function to include them in the turn rotation.

**Q: How do I resume a conversation?**
A: Conversations create checkpoints every 2 turns. You can restore from a checkpoint by loading the session state and continuing from that turn (resumption logic to be implemented).

**Q: Can agents access external data?**
A: Agents can access anything included in their context. You can enhance `build_agent_context()` to include file contents, codebase information, or API data.

## 📄 License

MIT License - feel free to use, modify, and distribute.

## 🙏 Acknowledgments

Inspired by:
- Adversarial collaboration in research
- Red team / blue team cybersecurity practices
- Structured argumentation frameworks
- Multi-agent systems research

---

**Built for Claude Code | Designed for rigorous thinking | Optimized for better decisions**

For questions, issues, or contributions, please open an issue in the repository.
