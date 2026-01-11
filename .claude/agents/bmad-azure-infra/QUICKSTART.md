# BMAD Azure Infrastructure - Quick Start Guide

**Get started with the BMAD multi-agent system in 5 minutes.**

---

## 🚀 Your First Engagement in 3 Steps

### Step 1: Start with Atlas (30 seconds)

**Prompt:**
```
Atlas, I need to plan an Azure infrastructure project. We need to:
- Deploy a production-ready Azure landing zone
- Migrate 50 existing resources from manual deployment
- Timeline: 8 weeks
- Budget: $150K implementation + $5K/month ongoing

Create an engagement plan.
```

**What Atlas Does:**
- Creates engagement charter with phases and milestones
- Assigns specialist agents to workstreams
- Identifies key decision points
- Sets up status tracking

---

### Step 2: Gather Requirements with User (10 minutes)

**Prompt:**
```
User, facilitate a requirements workshop for this Azure landing zone project.

Context:
- Company: FinTech startup (Series B)
- Team: 15 developers, 3 ops engineers
- Workloads: API backend (Node.js), PostgreSQL database, Redis cache
- Compliance: SOC2 required
- Current state: Resources spread across 3 subscriptions, no IaC
```

**What User Does:**
- Asks clarifying questions about business goals
- Documents functional and non-functional requirements
- Identifies stakeholders and decision-makers
- Creates prioritized requirements list (MoSCoW)

---

### Step 3: Get Technical Design (30 minutes)

**Prompt:**
```
Based on the requirements, I need:

Astra: Design the Azure landing zone architecture
Rhea: Assess the 50 existing resources and create import strategy
Nina: Design network topology
Cora: Design security and RBAC model
Finn: Estimate costs and create budget
```

**What You Get:**
- Hub-spoke network architecture diagram
- Brownfield resource inventory and migration waves
- Network design with IP addressing
- RBAC model and security policies
- Cost breakdown and 3-year TCO

---

## 📋 Common Use Cases - Copy & Paste

### Use Case 1: Greenfield Azure Landing Zone

```
I'm starting fresh on Azure. I need:
- Enterprise-scale landing zone with hub-spoke network
- Support for 3 environments (dev, staging, prod)
- Budget: $10K/month
- Compliance: None initially, plan for SOC2 in 6 months
- Team size: 5 engineers

Atlas: Create engagement plan
Astra: Design landing zone architecture
Nina: Design network with CIDR blocks
Cora: Design basic RBAC (no compliance yet)
Terra: Design Terraform Stack structure
Finn: Project costs and optimize for budget
```

---

### Use Case 2: Brownfield Migration to Terraform

```
We have 100+ Azure resources created manually over 2 years. We want Terraform management.

Resources include:
- 15 VMs, 5 AKS clusters, 3 Azure SQL databases
- Virtual networks with peerings
- Key Vaults, Storage Accounts, App Services
- No consistent naming or tagging

Rhea: Discover all resources and dependencies
Atlas: Plan migration in waves (low-risk first)
Terra: Design Terraform Stack to organize imported resources
Gabe: Set up CI/CD for Terraform PRs
```

---

### Use Case 3: Security Review & Hardening

```
Our Azure environment needs security review before SOC2 audit.

Current state:
- 5 subscriptions, 50+ resource groups
- Mix of manual and Terraform-managed resources
- No consistent RBAC strategy
- Secrets scattered across Key Vaults

Cora: Audit current security posture (RBAC, policies, secrets)
Nina: Review network security (NSGs, firewall rules, Private Link)
Astra: Recommend security improvements aligned with CAF
Atlas: Prioritize remediation (critical → high → medium)
```

---

### Use Case 4: Cost Optimization

```
Our Azure bill is $30K/month and growing. We need to optimize.

Finn: Analyze current spend and identify waste
- Right-size over-provisioned resources
- Find unused resources (orphaned disks, IPs, etc.)
- Reserved Instance recommendations

Odin: Review monitoring costs (Log Analytics data ingestion)
Terra: Implement cost-saving changes via Terraform
Gabe: Add cost gates to CI/CD (prevent expensive changes)
```

---

### Use Case 5: Disaster Recovery Planning

```
We need DR strategy for production workloads.

Requirements:
- RTO: 4 hours
- RPO: 15 minutes
- Primary: East US, DR: West US
- Workloads: AKS, Azure SQL, Storage Accounts

Odin: Design DR strategy with failover procedures
Astra: Design multi-region architecture
Nina: Design cross-region networking (VNet peering, Traffic Manager)
Gabe: Automate DR testing in CI/CD
```

---

## 🎯 Agent Cheat Sheet - When to Use Who

| Need | Agent | Example Prompt |
|------|-------|----------------|
| **Kick off project** | Atlas | "Create engagement plan for [project]" |
| **Gather requirements** | User | "Run requirements workshop for [scenario]" |
| **Design architecture** | Astra | "Design landing zone for [requirements]" |
| **Discover existing resources** | Rhea | "Inventory all resources in [subscriptions]" |
| **Import to Terraform** | Rhea + Terra | "Import [resources] and organize in Stacks" |
| **Design Terraform code** | Terra | "Design Stack components for [architecture]" |
| **HCP Integration** | Hashi | "Design HCP Terraform workspaces and Sentinel policies" |
| **Secrets management** | Hashi + Cora | "Design HCP Vault vs Azure Key Vault strategy" |
| **Set up CI/CD** | Gabe | "Create GitHub Actions workflow for Terraform" |
| **Design security** | Cora | "Design RBAC model for [scenario]" |
| **Design network** | Nina | "Design hub-spoke with [requirements]" |
| **Set up monitoring** | Odin | "Design observability for [workloads]" |
| **Estimate costs** | Finn | "What will [architecture] cost?" |
| **Make decision** | Atlas + User | "Should we use [Option A] or [Option B]?" |

---

## 💡 Pro Tips

### Tip 1: Always Start with Atlas
Don't jump straight to specialist agents. Let Atlas orchestrate the engagement and coordinate agents.

**❌ Don't do this:**
```
Astra, design an architecture.
Nina, design the network.
Cora, design security.
```

**✅ Do this:**
```
Atlas, I need an Azure landing zone. Here's the context: [requirements].
Create an engagement plan and coordinate the team.
```

---

### Tip 2: Provide Context, Not Just Tasks
The more context you provide, the better the agents can help.

**❌ Minimal context:**
```
Design a network.
```

**✅ Rich context:**
```
Nina, design a network for:
- 3 environments (dev, staging, prod)
- On-premises connectivity via ExpressRoute
- 5 application teams needing isolated subnets
- Compliance requirement: all traffic through firewall
- Budget: $5K/month for networking
```

---

### Tip 3: Use User Agent for Stakeholder Decisions
Don't try to make business decisions yourself. Use User to facilitate.

**❌ Making decision without User:**
```
Atlas, let's go with hub-spoke because it's cheaper.
```

**✅ Using User to facilitate:**
```
User, we have two options for network topology:
- Hub-spoke: $2.5K/month, centralized security
- Mesh: $5K/month, lower latency

Present to stakeholders for decision.
```

---

### Tip 4: Invoke Devil's Advocate for Big Decisions
For high-stakes decisions, use the Devil's Advocate system to challenge assumptions.

**Example:**
```
Atlas, we need to decide on Terraform backend strategy:
- Option A: Azure Storage with state locking
- Option B: Terraform Cloud

This is a critical decision. Invoke Devil's Advocate process:
- Proposer: Present Option A with rationale
- Challenger: Identify risks and alternatives
- Moderator: Synthesize and recommend
```

---

### Tip 5: Ask for Specific Deliverables
Tell agents what format you want the output in.

**Examples:**
```
Astra, design landing zone and provide:
- Architecture diagram (ASCII art)
- Resource list with naming conventions
- ADR documenting key decisions

Finn, analyze costs and provide:
- Breakdown by service category
- 12-month projection chart
- Top 3 optimization recommendations
```

---

## 🔧 Common Workflows

### Workflow 1: Weekly Status Update

```
Atlas, provide weekly status update for stakeholders:
- Progress this week
- Blockers and risks
- Next week's plan
- Budget status
- Decisions needed

User, format Atlas's update for executive audience.
```

---

### Workflow 2: PR Review for Terraform Changes

```
Terra, review this Terraform PR:
[paste PR diff or link]

Check for:
- Code quality and best practices
- Security issues
- Cost impact
- Drift risk

Gabe, confirm this PR follows our CI/CD workflow requirements.
```

---

### Workflow 3: Incident Response

```
Odin, we have production issue:
- Symptom: API latency spiked from 200ms to 5s
- Started: 30 minutes ago
- Affected: East US production
- Recent changes: Deployed new App Service plan 1 hour ago

Guide incident response:
1. Immediate mitigation
2. Root cause analysis
3. Post-incident review

Gabe, check if CI/CD has rollback capability for this deployment.
```

---

## 📚 Next Steps

### Dive Deeper
- **Full Documentation**: See [README.md](./README.md) for complete system overview
- **Agent Details**: Read individual agent files for in-depth capabilities
- **Integration**: See [devils-advocate/README.md](../devils-advocate/README.md) for critical thinking process

### Example Scenarios
Each agent file contains detailed example scenarios showing:
- Input prompts
- Agent responses
- Deliverables produced
- Collaboration patterns

### Best Practices
Refer to README.md sections:
- Agent collaboration model
- Typical engagement workflow
- Usage guidelines
- Decision-making processes

---

## 🆘 Troubleshooting

### Problem: Too many agents responding at once
**Solution**: Use Atlas to coordinate. Say: "Atlas, organize the team. Only you respond initially, then delegate."

### Problem: Agent responses are too technical
**Solution**: Route through User agent. Say: "User, translate [agent]'s response for business stakeholders."

### Problem: Agents disagree on approach
**Solution**: Escalate to Atlas. Say: "Atlas, [Agent A] and [Agent B] have conflicting recommendations. Resolve the conflict."

### Problem: Need decision but unsure which option
**Solution**: Use decision framework. Say: "User, present options [A, B, C] with trade-off analysis. Atlas, recommend based on [criteria]."

### Problem: Overwhelming amount of detail
**Solution**: Request executive summary. Say: "Atlas, provide 3-bullet executive summary of [topic]."

---

## 🎓 Learning Path

### Beginner (Week 1)
1. Start simple engagement with Atlas
2. Use 2-3 specialist agents (Astra, Nina, Terra)
3. Practice giving context-rich prompts

### Intermediate (Week 2-3)
4. Coordinate full engagements across all agents
5. Use User for stakeholder facilitation
6. Apply decision-making frameworks

### Advanced (Week 4+)
7. Invoke Devil's Advocate for critical decisions
8. Customize agent workflows for your org
9. Create reusable templates for common scenarios

---

**Ready to start? Try the "Greenfield Azure Landing Zone" use case above!**
