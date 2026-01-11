# BMAD Azure Infrastructure Multi-Agent System

**Version**: 1.1.0  
**Last Updated**: 2026-01-11  
**Total Agents**: 11  
**Total Lines**: 10,614

## Overview

The BMAD (Build, Manage, Analyze, Deploy) Azure Infrastructure multi-agent system is a comprehensive framework for planning, implementing, and managing Azure infrastructure using Terraform Stacks and HashiCorp Cloud Platform. This system employs 11 specialized AI agents that collaborate to deliver enterprise-grade Azure landing zones, brownfield migrations, greenfield deployments, and HCP integration.

## Agent Portfolio

### 1. Atlas - Orchestration & Leadership (1,013 lines)
**Role**: Chief Orchestrator & Engagement Lead  
**Color**: Gold  
**Tools**: orchestration, planning, coordination, decision_synthesis

**Core Responsibilities**:
- Multi-agent coordination and task distribution
- Engagement planning and milestone tracking
- Conflict resolution and decision synthesis
- Stakeholder alignment and communication
- Migration wave planning and risk management

**When to Engage**: Project kickoff, major decisions, agent conflicts, status reporting

---

### 2. Rhea - Brownfield Discovery & Migration (1,232 lines)
**Role**: Brownfield Discovery & Migration Specialist  
**Color**: Amber  
**Tools**: azure_cli, resource_graph, powershell, terraform_import, state_analysis

**Core Responsibilities**:
- Azure environment discovery using Resource Graph queries
- Resource inventory and dependency mapping
- Terraform import strategy and execution
- Configuration drift detection and remediation
- Migration wave sequencing and rollback planning

**When to Engage**: Existing Azure resources, import workflows, migration planning

---

### 3. Astra - Azure Architecture (522 lines)
**Role**: Azure Platform Architect  
**Color**: Sky Blue  
**Tools**: azure_services, architecture_patterns, compliance, design_validation

**Core Responsibilities**:
- Azure landing zone design (CAF/Enterprise-Scale)
- Hub-spoke network topology architecture
- Shared services design (Key Vault, Log Analytics, Private DNS)
- Multi-region and disaster recovery planning
- Architecture decision records (ADRs)

**When to Engage**: Architecture design, service selection, compliance validation

---

### 4. Terra - Terraform Stacks (1,192 lines)
**Role**: Terraform Stacks Technical Lead  
**Color**: Purple  
**Tools**: terraform, hcl, state_management, testing, providers

**Core Responsibilities**:
- Terraform Stacks architecture and component design
- State management strategies and operations
- Component testing (unit, integration, smoke)
- Drift detection and remediation workflows
- Provider version management and upgrades

**When to Engage**: Terraform code design, state operations, testing strategy

---

### 5. Gabe - CI/CD & GitHub (890 lines)
**Role**: CI/CD Pipeline & GitHub Specialist  
**Color**: Orange  
**Tools**: github_actions, pr_automation, workflow_orchestration, testing

**Core Responsibilities**:
- GitHub Actions workflow design and implementation
- PR-based Terraform workflows with plan/apply gates
- Drift detection automation and scheduled checks
- Release management and deployment orchestration
- GitHub branch protection and review policies

**When to Engage**: Pipeline design, automation, PR workflows, release management

---

### 6. Cora - Security & IAM (767 lines)
**Role**: Security, IAM & Compliance Specialist  
**Color**: Red  
**Tools**: rbac, azure_policy, key_vault, defender, compliance

**Core Responsibilities**:
- RBAC model design (custom roles, PIM, access reviews)
- Azure Policy design and governance guardrails
- Key Vault design and secret management patterns
- Microsoft Defender for Cloud configuration
- Compliance framework mapping (SOC2, HIPAA, PCI-DSS, etc.)

**When to Engage**: Security design, access control, compliance requirements

---

### 7. Nina - Networking (783 lines)
**Role**: Azure Networking Specialist  
**Color**: Green  
**Tools**: networking, vnet, firewall, routing, dns

**Core Responsibilities**:
- Hub-spoke VNet topology design and IP planning
- Azure Firewall and NSG rule design
- Private Link and Private Endpoint configuration
- VPN Gateway and ExpressRoute connectivity
- DNS architecture (Private DNS zones, resolution)

**When to Engage**: Network design, connectivity, IP addressing, DNS

---

### 8. Odin - SRE & Operations (875 lines)
**Role**: SRE & Operations Specialist  
**Color**: Steel Blue  
**Tools**: monitoring, alerting, log_analytics, workbooks, incident_response

**Core Responsibilities**:
- Azure Monitor and Log Analytics design
- Alert rules and action groups configuration
- SLI/SLO definition and tracking
- Incident response procedures and runbooks
- Disaster recovery and business continuity planning

**When to Engage**: Monitoring setup, alerting, operational readiness, DR planning

---

### 9. Finn - FinOps & Cost Management (726 lines)
**Role**: FinOps & Cost Optimization Specialist  
**Color**: Teal  
**Tools**: cost_analysis, budgets, reservations, optimization, reporting

**Core Responsibilities**:
- Cost baseline establishment and budget creation
- Resource SKU recommendations and right-sizing
- Reserved Instance and Savings Plan analysis
- Cost allocation and chargeback models
- Continuous optimization and waste identification

**When to Engage**: Cost planning, budget constraints, optimization opportunities

---

### 10. User - Stakeholder Advocate (1,257 lines)
**Role**: User Representative & Stakeholder Advocate  
**Color**: Blue  
**Tools**: communication, requirements_gathering, decision_facilitation, documentation

**Core Responsibilities**:
- Business requirements gathering and documentation
- Decision facilitation with trade-off analysis
- Stakeholder communication and status updates
- User acceptance testing (UAT) coordination
- Change management and risk communication

**When to Engage**: Requirements gathering, stakeholder decisions, UAT, status updates

---

### 11. Hashi - HashiCorp Cloud Platform (1,357 lines)
**Role**: HashiCorp Cloud Platform (HCP) Specialist  
**Color**: Purple  
**Tools**: hcp_cli, terraform_cloud, vault, sentinel, packer, consul

**Core Responsibilities**:
- HCP Terraform workspace design and Sentinel policy-as-code
- HCP Vault secrets architecture (dynamic secrets, PKI, transit encryption)
- HCP Packer golden image pipelines
- HCP integration with Azure (OIDC, managed identities)
- Team collaboration and governance in HCP
- HCP cost management and optimization

**When to Engage**: HCP vs self-managed decisions, Sentinel policies, Vault secrets strategy, image pipelines

---

## System Architecture

### Agent Collaboration Model

```
                          ┌─────────────┐
                          │    Atlas    │
                          │ Orchestrator│
                          └──────┬──────┘
                                 │
                 ┌───────────────┼───────────────┐
                 │               │               │
          ┌──────▼──────┐ ┌─────▼─────┐ ┌──────▼──────┐
          │    User     │ │   Rhea    │ │   Astra     │
          │ Stakeholder │ │Brownfield │ │Architecture │
          └──────┬──────┘ └─────┬─────┘ └──────┬──────┘
                 │               │               │
                 └───────────────┼───────────────┘
                                 │
          ┌──────────────────────┼──────────────────────┐
          │                      │                      │
    ┌─────▼─────┐         ┌─────▼─────┐        ┌──────▼──────┐
    │   Terra   │         │   Cora    │        │    Nina     │
    │ Terraform │         │ Security  │        │  Network    │
    └─────┬─────┘         └─────┬─────┘        └──────┬──────┘
          │                     │                      │
          │                     ├──────────────────────┘
          │                     │
    ┌─────▼─────┐         ┌─────▼─────────────────────┐
    │   Hashi   │         │                           │
    │    HCP    │    ┌────▼────┐  ┌────▼────┐  ┌─────▼─────┐
    └─────┬─────┘    │  Gabe   │  │  Odin   │  │   Finn    │
          │          │  CI/CD  │  │   SRE   │  │  FinOps   │
          │          └─────────┘  └─────────┘  └───────────┘
          │                 │          │             │
          └─────────────────┴──────────┴─────────────┘
```

### Communication Patterns

**Hierarchical Escalation**: Agents escalate conflicts and major decisions to Atlas for orchestration and resolution.

**Peer Collaboration**: Agents collaborate directly on domain-specific work:
- Astra ↔ Nina: Architecture and network topology
- Cora ↔ Nina: Security groups and network policies
- Terra ↔ Gabe: Terraform code and CI/CD pipelines
- Terra ↔ Hashi: Terraform Stacks and HCP Terraform workspaces
- Cora ↔ Hashi: Azure Key Vault vs HCP Vault strategies
- Odin ↔ Finn: Monitoring costs and optimization

**User Interface**: User agent acts as the bridge between technical agents and business stakeholders.

---

## Typical Engagement Workflow

### Phase 1: Discovery & Planning (Weeks 1-2)
1. **User** gathers business requirements and stakeholder input
2. **Rhea** discovers existing Azure resources (if brownfield)
3. **Astra** designs target architecture
4. **Atlas** creates engagement plan and coordinates agents

### Phase 2: Design (Weeks 2-4)
5. **Nina** designs network topology
6. **Cora** designs security model and policies
7. **Finn** creates cost baseline and budget
8. **Terra** designs Terraform Stack component structure
9. **Hashi** designs HCP integration (workspaces, Vault, Sentinel policies)
10. **Odin** designs monitoring and operational strategy

### Phase 3: Implementation (Weeks 4-10)
11. **Terra** implements Terraform components
12. **Hashi** configures HCP Terraform workspaces and Sentinel policies
13. **Gabe** sets up CI/CD pipelines with HCP integration
14. **Rhea** executes migration waves (if brownfield)
15. **Odin** configures monitoring and alerting
16. **User** coordinates UAT with stakeholders

### Phase 4: Deployment & Handover (Weeks 10-12)
17. **Atlas** orchestrates production deployment
18. **Gabe** executes deployment pipelines
19. **Odin** validates operational readiness
20. **User** obtains stakeholder sign-off
21. **All Agents** deliver documentation and runbooks

---

## File Structure

```
bmad-azure-infra/
├── README.md                 # This file
├── QUICKSTART.md             # Quick start guide
├── atlas-agent.md            # Orchestration & Leadership
├── rhea-agent.md             # Brownfield Discovery & Migration
├── astra-agent.md            # Azure Architecture
├── terra-agent.md            # Terraform Stacks
├── hashi-agent.md            # HashiCorp Cloud Platform
├── gabe-agent.md             # CI/CD & GitHub
├── cora-agent.md             # Security & IAM
├── nina-agent.md             # Networking
├── odin-agent.md             # SRE & Operations
├── finn-agent.md             # FinOps & Cost Management
└── user-agent.md             # Stakeholder Advocate
```

---

## Usage Guidelines

### Starting a New Engagement

1. **Kick-off with Atlas**: Begin by engaging Atlas to create the engagement plan
2. **Gather Requirements with User**: Collect business requirements and constraints
3. **Discover Environment with Rhea**: If brownfield, discover existing resources
4. **Design with Astra**: Create the target architecture
5. **Distribute Work**: Atlas coordinates agent assignments

### Making Technical Decisions

1. **Identify Decision**: Recognize when a decision needs stakeholder input
2. **Gather Options**: Technical agents provide options with pros/cons
3. **User Facilitates**: User agent presents decision to stakeholders in business terms
4. **Atlas Records**: Atlas documents the decision and rationale
5. **Implement**: Assigned agents execute the decision

### Handling Conflicts

1. **Agent Detects Conflict**: Any agent can identify conflicting requirements or approaches
2. **Escalate to Atlas**: Report conflict with context and proposed resolutions
3. **Atlas Synthesizes**: Atlas evaluates options and coordinates discussion
4. **User Engages Stakeholder**: If business decision needed, User facilitates
5. **Atlas Decides**: Atlas makes final call and documents in ADR

---

## Best Practices

### For Atlas (Orchestrator)
- Maintain clear visibility across all agents
- Don't micromanage - trust specialist agents in their domains
- Escalate to User when business decisions needed
- Document all major decisions in ADRs

### For Technical Agents
- Stay within your domain expertise
- Collaborate with peer agents on boundary issues
- Escalate conflicts to Atlas promptly
- Provide options with pros/cons, not just recommendations

### For User Agent
- Translate technical concepts to business language
- Protect stakeholders from unnecessary technical details
- Escalate user concerns to technical agents
- Manage expectations realistically

---

## Agent Capabilities Summary

| Agent | Discovery | Design | Implementation | Operations | Communication |
|-------|-----------|--------|----------------|------------|---------------|
| Atlas | ✓ | ✓ | - | ✓ | ✓✓✓ |
| Rhea | ✓✓✓ | - | ✓ | - | ✓ |
| Astra | ✓ | ✓✓✓ | - | - | ✓ |
| Terra | - | ✓ | ✓✓✓ | ✓ | ✓ |
| Hashi | - | ✓✓ | ✓✓ | ✓ | ✓ |
| Gabe | - | ✓ | ✓✓✓ | ✓ | ✓ |
| Cora | ✓ | ✓✓✓ | ✓ | ✓ | ✓ |
| Nina | ✓ | ✓✓✓ | ✓ | ✓ | ✓ |
| Odin | - | ✓ | ✓ | ✓✓✓ | ✓ |
| Finn | ✓✓ | ✓ | - | ✓✓ | ✓ |
| User | ✓✓ | ✓ | - | - | ✓✓✓ |

Legend: ✓ = Capable, ✓✓ = Strong, ✓✓✓ = Primary Focus

---

## Versioning

**Current Version**: 1.1.0

**Version History**:
- 1.1.0 (2026-01-11): Added Hashi agent for HashiCorp Cloud Platform (11 agents, 10,614 lines)
- 1.0.0 (2026-01-11): Initial comprehensive agent system with 10 agents

**Maintenance**:
- Agents are versioned independently based on capability updates
- System version reflects major architectural changes
- See individual agent files for detailed change logs

---

## Contributing

When updating agents:
1. Maintain consistent structure across all agents
2. Update line counts in this README
3. Document changes in agent-specific sections
4. Test agent collaboration scenarios
5. Update system architecture diagrams if needed

---

## Related Documentation

- **Devils Advocate System**: See `../devils-advocate/README.md` for critical thinking agents
- **Quick Start Guide**: See `QUICKSTART.md` for getting started in 5 minutes
- **Terraform Stacks**: Detailed component examples in Terra agent
- **HCP Integration**: HCP Terraform, Vault, Packer examples in Hashi agent
- **Azure Architecture**: Landing zone patterns in Astra agent
- **CI/CD Workflows**: Pipeline templates in Gabe agent

---

## Support & Contact

For questions or issues with the BMAD Azure Infrastructure agent system:
- Review individual agent documentation for specific capabilities
- Check collaboration patterns for inter-agent communication
- Consult engagement workflow for phase-specific guidance

---

**Built for enterprise Azure infrastructure at scale.**
