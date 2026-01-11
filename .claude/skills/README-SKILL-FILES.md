# Claude Desktop Skill Files

This directory contains packaged `.skill` files ready for upload to Claude Desktop.

## Available Skills

### 1. devils-advocate.skill (3.2 KB)
**Purpose**: Multi-perspective debate system with three agent personas
- 🔵 Proposer: Presents ideas and defends positions
- 🔴 Challenger: Critiques and stress-tests proposals
- 🟢 Moderator: Synthesizes insights and guides discussion

**Use When**: Testing ideas, identifying risks, exploring trade-offs, strategic planning

### 2. azure-infra-orchestrator.skill (118 KB)
**Purpose**: Complete Azure infrastructure team with 11 specialized agents
- Includes all agent reference files (11 detailed agent definitions)
- Atlas orchestration, Astra architecture, Terraform/HCP, CI/CD, Security, Networking, SRE, FinOps

**Use When**: Azure migrations, landing zone design, Terraform implementation, security audits, cost optimization

### 3. gcp-infra-orchestrator.skill (124 KB)
**Purpose**: Complete GCP infrastructure team with 11 specialized agents
- Includes all agent reference files with GCP-specific expertise
- BigQuery data warehouse design, organizational hierarchy, Terraform for GCP, security, networking

**Use When**: GCP migrations, organizational design, BigQuery implementation, multi-project architecture, cost optimization

## How to Upload to Claude Desktop

1. **Open Claude Desktop**
2. **Go to Settings** → **Custom Skills**
3. **Click "Upload Skill"**
4. **Select the `.skill` file** you want to upload
5. **Skill will be available** in your Claude Desktop conversations

## Skill Contents

Each `.skill` file is a ZIP archive containing:

### Devils Advocate
```
devils-advocate/
└── SKILL.md
```

### Azure Infrastructure Orchestrator
```
azure-infra-orchestrator/
├── SKILL.md
└── references/
    ├── atlas-agent.md (orchestration)
    ├── astra-agent.md (Azure architecture)
    ├── rhea-agent.md (brownfield discovery)
    ├── terra-agent.md (Terraform)
    ├── hashi-agent.md (HCP)
    ├── gabe-agent.md (CI/CD)
    ├── cora-agent.md (security)
    ├── nina-agent.md (networking)
    ├── odin-agent.md (SRE)
    ├── finn-agent.md (FinOps)
    └── user-agent.md (stakeholder)
```

### GCP Infrastructure Orchestrator
```
gcp-infra-orchestrator/
├── SKILL.md
└── references/
    ├── atlas-agent.md (orchestration)
    ├── astra-agent.md (GCP architecture + BigQuery)
    ├── rhea-agent.md (brownfield discovery)
    ├── terra-agent.md (Terraform for GCP)
    ├── hashi-agent.md (HCP)
    ├── gabe-agent.md (CI/CD)
    ├── cora-agent.md (GCP security)
    ├── nina-agent.md (GCP networking)
    ├── odin-agent.md (SRE)
    ├── finn-agent.md (FinOps)
    └── user-agent.md (stakeholder)
```

## Notes

- **Claude Desktop** doesn't support custom multi-agent configurations (unlike Claude Code)
- These orchestrator skills simulate multi-agent behavior by having Claude adopt different personas
- Agent personas are marked with emojis (🟡 Atlas, 🏛️ Astra, etc.)
- Reference files contain complete agent knowledge: workflows, code patterns, queries, decision frameworks
- Skills work alongside platform query skills (azure-resource-graph, gcp-asset-inventory, bigquery-analysis)

## Regenerating Skill Files

To recreate these `.skill` files from source:

```bash
cd /Users/mike/Developer/projects/claude-conversation/.claude/skills

# Devils Advocate
zip -r devils-advocate.skill devils-advocate/

# Azure Infrastructure
zip -r azure-infra-orchestrator.skill azure-infra-orchestrator/

# GCP Infrastructure
zip -r gcp-infra-orchestrator.skill gcp-infra-orchestrator/
```

## Source Files

Original multi-agent systems are located at:
- `.claude/agents/devils-advocate/`
- `.claude/agents/bmad-azure-infra/`
- `.claude/agents/bmad-gcloud-infra/`

These orchestrator skills condense the multi-agent systems into single skills compatible with Claude Desktop.
