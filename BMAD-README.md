## BMAD Infrastructure Multi-Agent System

**B**uild **M**ore, **A**utomate **D**eep™ - Multi-agent collaboration system for Azure Terraform Stacks infrastructure planning and implementation.

## 🎯 Overview

The BMAD system provides specialized AI agents that work together to plan, design, and implement Azure infrastructure using Terraform Stacks with a brownfield-first approach.

### Available Agents

| Icon | Agent | Role | Specialty |
|------|-------|------|-----------|
| 🧭 | **Atlas** | Platform Orchestrator | Workflow coordination, standards, decisions |
| 🧬 | **Rhea** | Brownfield Discovery | Inventory, dependencies, migration planning |
| 🏛️ | **Astra** | Azure Architecture | Landing zones, target architecture |
| 🧱 | **Terra** | Terraform Stacks | IaC engineering, state management |
| 🔁 | **Gabe** | GitHub Delivery | CI/CD, PR workflows, automation |
| 🛡️ | **Cora** | Security & IAM | RBAC, compliance, policy-as-code |
| 🌐 | **Nina** | Networking | Hub/spoke, DNS, connectivity |
| 🧯 | **Odin** | SRE & Operations | Observability, reliability, DR |
| 💰 | **Finn** | FinOps & Capacity | Cost management, budgets, optimization |
| 👤 | **User** | User Representative | Answer agent questions, make decisions |

## 🚀 Quick Start

### Party Mode: Multi-Agent Collaboration

The primary way to use BMAD agents is through **Party Mode** - a facilitated multi-agent discussion:

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
  --phase Implementation \
  --user-context "3 VNets, 15 subnets, Private Link to SQL"
```

### Listing Available Agents

```bash
.claude/scripts/bmad-party-mode.sh --list-agents
```

## 📊 How Party Mode Works

### Conversation Flow

**Round 1: Opening**
- Each agent contributes their perspective
- Identifies questions they need answered
- Surfaces constraints and requirements
- User provides context and answers

**Round 2-N: Deep Exploration**
- Agents respond to each other's questions
- Address concerns and dependencies
- Refine proposals based on feedback
- User makes decisions on trade-offs

**Final Round: Synthesis**
- Atlas synthesizes discussion into actionable plan
- Consensus and action items identified
- User provides final approval/concerns
- Next steps documented

### Example Session

```bash
# Topic: Brownfield adoption of existing Azure networking
.claude/scripts/bmad-party-mode.sh \
  --topic "Import existing hub/spoke network into Terraform Stacks" \
  --agents "atlas,rhea,astra,nina,odin,user" \
  --phase Discovery \
  --max-rounds 3

# Round 1:
# - Atlas: Sets up engagement charter, defines success criteria
# - Rhea: Inventories existing VNets, subnets, NSGs, UDRs
# - Astra: Validates against Azure landing zone patterns
# - Nina: Maps network dependencies and peering topology
# - Odin: Identifies monitoring gaps and operational concerns
# - User: Answers questions about critical workloads and change windows

# Round 2:
# - Agents respond to User's answers
# - Identify import vs. refactor decisions
# - Discuss state boundary strategy
# - Surface risks and mitigation approaches

# Round 3:
# - Atlas: Synthesizes into migration wave plan
# - Agents: Validate plan from their perspectives
# - User: Approves approach or requests modifications
```

## 🎭 Agent Selection Guide

### By Phase

**Discovery Phase**:
- **Required**: Atlas, Rhea, User
- **Recommended**: Astra (architecture), Nina (networking), Cora (security)
- **Optional**: Odin (operations), Finn (cost)

**Design Phase**:
- **Required**: Atlas, Astra, User
- **Recommended**: Nina (networking), Cora (security), Odin (operations)
- **Optional**: Terra (IaC), Finn (cost)

**Implementation Phase**:
- **Required**: Atlas, Terra, User
- **Recommended**: Gabe (GitHub), Rhea (migration), Odin (cutover)
- **Optional**: Specific specialists as needed

**Operations Phase**:
- **Required**: Atlas, Odin, User
- **Recommended**: Finn (cost), Cora (security), Gabe (automation)

### By Topic

**Landing Zone / Governance**:
- Atlas, Astra, Cora, Odin, Finn, User

**Networking Changes**:
- Atlas, Nina, Astra, Odin, User

**Migration Planning**:
- Atlas, Rhea, Terra, Odin, User

**Cost Optimization**:
- Atlas, Finn, Astra, Terra, User

**Security Review**:
- Atlas, Cora, Astra, Nina, User

**IaC Stack Design**:
- Atlas, Terra, Gabe, Rhea, User

## 🛠️ Configuration

### Environment Variables

```bash
# Agent invocation timeout
export CLAUDE_AGENT_TIMEOUT=300

# Custom conversations directory
export CLAUDE_CONVERSATIONS_DIR="/custom/path"
```

### Agent Customization

Agent definitions are in `.claude/agents/bmad-infra/`. To customize an agent:

1. Edit `<agent-name>-agent.md`
2. Modify persona, responsibilities, or output templates
3. Save and use immediately

### Adding New Agents

To add a specialized agent:

1. Create `.claude/agents/bmad-infra/newagent-agent.md`
2. Add to `AVAILABLE_AGENTS` array in `bmad-party-mode.sh`
3. Use in party mode: `--agents "atlas,newagent,user"`

## 📁 Output Structure

Party mode sessions create structured output:

```
.claude/conversations/bmad-YYYYMMDD-HHMMSS/
├── session-metadata.json      # Session info, agents, phase
├── transcript.jsonl           # Complete conversation history
├── rounds/
│   ├── r1-atlas-response.md   # Round 1 Atlas contribution
│   ├── r1-rhea-response.md    # Round 1 Rhea contribution
│   ├── r1-user-response.md    # Round 1 User response
│   ├── r2-*.md                # Round 2 contributions
│   └── r3-*.md                # Round 3 contributions
└── insights.md                # Auto-generated summary
```

## 💡 Best Practices

### Topic Formulation

✅ **Good Topics**:
- "Import existing 3-subscription Azure environment into Terraform Stacks"
- "Landing zone design with hub/spoke for 3 business units"
- "Wave 1 migration: Networking resources (5 VNets, Private Link)"

❌ **Poor Topics**:
- "Should we use Terraform?" (too broad, decision already made)
- "Fix Azure" (vague, no clear scope)
- "Infrastructure planning" (no specifics)

### User Context

Always provide relevant context with `--user-context`:

```bash
--user-context "3 Azure subscriptions, 50 VMs, 15 App Services, 
   SOC2 compliance required, $50k/month budget, 
   team of 5 engineers, 3-month timeline"
```

### Agent Selection

**Start Small**: Begin with 3-4 agents (Atlas + specialists + User)

**Add as Needed**: Bring in additional specialists for deep dives

**Always Include User**: User agent represents stakeholder input

### Round Allocation

- **Simple topics**: 2-3 rounds
- **Standard discussions**: 3-4 rounds
- **Complex planning**: 4-5 rounds
- **Deep architectural**: 5+ rounds

## 🔧 Integration with Existing Infrastructure

### Existing Agent Invocation

The system uses the same `invoke-agent.sh` as the Devil's Advocate system. Configure it once for all multi-agent systems.

### Transcript Compatibility

BMAD transcripts use the same JSONL format, compatible with:
- Devil's Advocate system
- claude-hooks transcript archiver
- Custom analysis tools

### Synthesis Integration

Automatic insights generation works across all conversation types.

## 📖 Example Use Cases

### Use Case 1: Brownfield Adoption

```bash
# Initial discovery
.claude/scripts/bmad-party-mode.sh \
  --topic "Inventory and plan adoption of existing production Azure environment" \
  --agents "atlas,rhea,astra,nina,cora,odin,user" \
  --phase Discovery \
  --max-rounds 4

# Follow-up: Specific migration wave
.claude/scripts/bmad-party-mode.sh \
  --topic "Wave 1: Import networking resources" \
  --agents "atlas,rhea,terra,nina,user" \
  --phase Implementation \
  --max-rounds 3
```

### Use Case 2: New Landing Zone

```bash
# Architecture design
.claude/scripts/bmad-party-mode.sh \
  --topic "Design Azure landing zone for 3 business units" \
  --agents "atlas,astra,cora,nina,finn,user" \
  --phase Design \
  --max-rounds 4 \
  --user-context "3 BUs, shared services, SOC2, budget-conscious"

# Implementation planning
.claude/scripts/bmad-party-mode.sh \
  --topic "Implement landing zone foundation" \
  --agents "atlas,terra,gabe,cora,user" \
  --phase Implementation \
  --max-rounds 3
```

### Use Case 3: Cost Optimization

```bash
.claude/scripts/bmad-party-mode.sh \
  --topic "Reduce monthly Azure spend from $80k to $60k" \
  --agents "atlas,finn,astra,terra,user" \
  --phase Operations \
  --max-rounds 3 \
  --user-context "Current: 200 VMs, 50 App Services, 10 SQL databases"
```

## 🔐 Security Considerations

When using BMAD agents:

- **Do NOT** include secrets or credentials in `--user-context`
- **Do** sanitize subscription IDs and resource names if needed
- **Do** review transcripts before sharing externally
- **Do** treat agent conversations as internal documentation

## 🐛 Troubleshooting

**Agent not found**:
- Ensure agent file exists: `.claude/agents/bmad-infra/<agent>-agent.md`
- Check spelling: agent names are lowercase (e.g., `atlas` not `Atlas`)

**Invocation fails**:
- Check `invoke-agent.sh` is configured with API access
- Verify `CLAUDE_AGENT_TIMEOUT` if sessions are slow
- Review agent invocation logs in session directory

**Poor quality responses**:
- Add more context with `--user-context`
- Select agents appropriate for the topic
- Increase rounds for complex topics
- Ensure User agent participates to answer questions

## 📚 Methodology: BMAD Brownfield-First

The BMAD methodology prioritizes:

1. **Brownfield-First**: Adopt existing infrastructure safely before building new
2. **Safety by Default**: Prevent accidental destroys, require explicit approvals
3. **PR as Change Unit**: GitHub PRs drive reviewable, auditable changes
4. **Guardrails > Heroics**: Policies and automation prevent bad outcomes
5. **Blast Radius Boundaries**: State/stack boundaries align to ownership and risk
6. **Observable Changes**: Never migrate without monitoring and rollback
7. **Continuous Improvement**: Optimize costs, reliability, and standards iteratively

## 🎓 Learning Resources

### Understanding Agents

Read agent definitions to understand their perspective:
- `.claude/agents/bmad-infra/atlas-agent.md` - Orchestration patterns
- `.claude/agents/bmad-infra/user-agent.md` - How to interact effectively

### Example Sessions

Review past sessions for patterns:
- `.claude/conversations/bmad-*/` - Session transcripts
- Look for sessions matching your use case

### Azure Terraform Stacks

BMAD agents are optimized for:
- HashiCorp Terraform Stacks (HCP Terraform)
- Azure Landing Zones
- Brownfield adoption patterns
- Infrastructure-as-Code best practices

## 🤝 Contributing

To enhance the BMAD agent system:

1. **Add Agent Specializations**: Create domain-specific agents
2. **Improve Agent Prompts**: Refine agent definitions for better output
3. **Share Patterns**: Document successful multi-agent patterns
4. **Build Tools**: Create analysis tools for BMAD transcripts

## 📄 License

MIT License - Same as parent multi-agent conversation system

---

**Built for Azure Infrastructure | Designed for Brownfield Safety | Optimized for Team Collaboration**

For questions or issues, please refer to the main project documentation or open an issue.

## Quick Reference

```bash
# List agents
.claude/scripts/bmad-party-mode.sh --list-agents

# Basic session
.claude/scripts/bmad-party-mode.sh --topic "Your topic" --agents "atlas,specialist,user"

# Full-featured session
.claude/scripts/bmad-party-mode.sh \
  --topic "Detailed topic" \
  --agents "atlas,agent1,agent2,user" \
  --phase Discovery \
  --max-rounds 4 \
  --user-context "Relevant context" \
  --auto-continue

# View past sessions
ls -l .claude/conversations/bmad-*/
cat .claude/conversations/bmad-*/insights.md
```
