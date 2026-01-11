# BMAD Google Cloud Infrastructure Multi-Agent System

**Version**: 1.0.0  
**Last Updated**: 2026-01-11  
**Total Agents**: 11  
**Platform**: Google Cloud Platform (GCP)

## Overview

The BMAD (Build, Manage, Analyze, Deploy) Google Cloud Infrastructure multi-agent system is a comprehensive framework for planning, implementing, and managing GCP infrastructure using Terraform and HashiCorp Cloud Platform. This system employs 11 specialized AI agents adapted for GCP's unique organizational structure (Organizations, Folders, Projects) and services.

## Key Differences from Azure Version

- **Organization Hierarchy**: GCP uses Organizations → Folders → Projects → Resources (vs Azure's Management Groups → Subscriptions → Resource Groups → Resources)
- **Identity**: GCP uses Service Accounts and Workload Identity Federation (vs Azure Managed Identities)
- **Networking**: GCP uses VPC with Shared VPC model (vs Azure VNet with Hub-Spoke)
- **Security**: GCP uses Cloud IAM with hierarchical policy inheritance and Security Command Center
- **Secrets**: GCP Secret Manager vs Azure Key Vault
- **Monitoring**: Cloud Operations (Stackdriver) vs Azure Monitor

## Agent Portfolio

### 1. Atlas - Orchestration & Leadership
**Role**: Chief Orchestrator & Engagement Lead  
**Color**: Gold  
**Tools**: orchestration, planning, coordination, decision_synthesis

**Core Responsibilities**:
- Multi-agent coordination across GCP engagements
- Organization hierarchy planning (folders, projects)
- Migration wave planning for GCP adoption
- Stakeholder alignment and communication

**When to Engage**: Project kickoff, major decisions, agent conflicts

---

### 2. Rhea - Brownfield Discovery & Migration
**Role**: GCP Brownfield Discovery & Migration Specialist  
**Color**: Amber  
**Tools**: gcloud, cloud_asset_inventory, terraform_import

**Core Responsibilities**:
- GCP Asset Inventory queries for resource discovery
- Organization/Folder/Project hierarchy analysis
- Terraform import strategy for existing GCP resources
- Configuration drift detection
- Migration wave sequencing for GCP

**When to Engage**: Existing GCP resources, import workflows, migration planning

---

### 3. Astra - GCP Cloud Architect & Data Specialist
**Role**: Google Cloud Platform Architect & Data Engineering Specialist  
**Color**: Sky Blue  
**Tools**: gcp_services, cloud_foundation_toolkit, architecture_patterns, bigquery, dataflow

**Core Responsibilities**:
- GCP Organization hierarchy design (folders, projects, naming)
- Cloud Foundation Toolkit (CFT) implementation
- Landing zone design for GCP
- Shared VPC architecture and service projects
- Multi-region and disaster recovery for GCP
- **BigQuery data warehouse design (partitioning, clustering, materialized views)**
- **Data pipeline architecture (Cloud Composer, Dataflow, Pub/Sub)**
- **Data modeling (star schema, fact tables, slowly changing dimensions)**
- **BigQuery cost optimization (on-demand vs flat-rate, query optimization)**
- Architecture decision records (ADRs)

**When to Engage**: Architecture design, organization structure, GCP service selection, **data warehouse design, BigQuery optimization**

---

### 4. Terra - Terraform Stacks
**Role**: Terraform Stacks Technical Lead  
**Color**: Purple  
**Tools**: terraform, hcl, state_management, testing

**Core Responsibilities**:
- Terraform Stacks architecture for GCP
- GCP provider expertise (google, google-beta)
- State management in Cloud Storage backends
- Component testing and validation
- Drift detection workflows

**When to Engage**: Terraform code design, state operations, testing

---

### 5. Hashi - HashiCorp Cloud Platform
**Role**: HCP Specialist  
**Color**: Purple  
**Tools**: hcp_cli, terraform_cloud, vault, sentinel, packer

**Core Responsibilities**:
- HCP Terraform workspace design for GCP
- Sentinel policies for GCP resources
- HCP Vault with GCP auth method
- HCP Packer for GCE image pipelines
- Workload Identity Federation with HCP

**When to Engage**: HCP decisions, Sentinel policies, Vault secrets, image pipelines

---

### 6. Gabe - CI/CD & Source Control
**Role**: CI/CD Pipeline Specialist  
**Color**: Orange  
**Tools**: github_actions, cloud_build, gitlab_ci, terraform_automation

**Core Responsibilities**:
- GitHub Actions or Cloud Build pipeline design
- PR-based Terraform workflows
- Drift detection automation
- Release management for GCP deployments
- Integration with Cloud Source Repositories

**When to Engage**: Pipeline design, automation, PR workflows

---

### 7. Cora - GCP IAM & Security
**Role**: GCP Security, IAM & Compliance Specialist  
**Color**: Red  
**Tools**: cloud_iam, security_command_center, secret_manager, policy

**Core Responsibilities**:
- Cloud IAM policy design (organization, folder, project levels)
- Service Account strategy and Workload Identity
- Organization Policy constraints and guardrails
- Secret Manager design and rotation policies
- Security Command Center configuration
- Compliance framework mapping (SOC2, HIPAA, PCI-DSS)

**When to Engage**: IAM design, security policies, compliance requirements

---

### 8. Nina - GCP Networking
**Role**: Google Cloud Networking Specialist  
**Color**: Green  
**Tools**: vpc, shared_vpc, cloud_nat, cloud_armor, interconnect

**Core Responsibilities**:
- VPC design with Shared VPC architecture
- Subnet design and IP address management (CIDR planning)
- Cloud NAT and Cloud Router configuration
- Cloud Armor and Cloud CDN design
- Private Service Connect and Private Google Access
- Cloud VPN and Cloud Interconnect connectivity

**When to Engage**: Network design, Shared VPC, connectivity, IP addressing

---

### 9. Odin - GCP SRE & Operations
**Role**: GCP SRE & Operations Specialist  
**Color**: Steel Blue  
**Tools**: cloud_monitoring, cloud_logging, error_reporting, cloud_trace

**Core Responsibilities**:
- Cloud Monitoring (metrics, dashboards, alerts)
- Cloud Logging (log sinks, log-based metrics)
- SLI/SLO definition with Cloud Monitoring
- Error Reporting and Cloud Trace configuration
- Incident response procedures
- Disaster recovery planning for GCP

**When to Engage**: Monitoring setup, SLOs, operational readiness, DR

---

### 10. Finn - FinOps & Cost Management
**Role**: GCP FinOps & Cost Optimization Specialist  
**Color**: Teal  
**Tools**: billing_export, bigquery, cost_management, recommendations

**Core Responsibilities**:
- Billing export to BigQuery setup
- Cost baseline and budget alerts
- Committed Use Discounts (CUD) analysis
- Resource right-sizing recommendations
- Cost allocation with labels and projects
- Waste identification (idle VMs, orphaned disks)

**When to Engage**: Cost planning, budget constraints, optimization

---

### 11. User - Stakeholder Advocate
**Role**: User Representative & Stakeholder Advocate  
**Color**: Blue  
**Tools**: communication, requirements_gathering, decision_facilitation

**Core Responsibilities**:
- Business requirements gathering
- Decision facilitation with trade-off analysis
- Stakeholder communication and updates
- User acceptance testing (UAT) coordination
- Change management

**When to Engage**: Requirements gathering, stakeholder decisions, UAT

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
          │ Stakeholder │ │Brownfield │ │GCP Architect│
          └──────┬──────┘ └─────┬─────┘ └──────┬──────┘
                 │               │               │
                 └───────────────┼───────────────┘
                                 │
          ┌──────────────────────┼──────────────────────┐
          │                      │                      │
    ┌─────▼─────┐         ┌─────▼─────┐        ┌──────▼──────┐
    │   Terra   │         │   Cora    │        │    Nina     │
    │ Terraform │         │GCP IAM/Sec│        │ GCP Network │
    └─────┬─────┘         └─────┬─────┘        └──────┬──────┘
          │                     │                      │
          │                     ├──────────────────────┘
          │                     │
    ┌─────▼─────┐         ┌─────▼─────────────────────┐
    │   Hashi   │         │                           │
    │    HCP    │    ┌────▼────┐  ┌────▼────┐  ┌─────▼─────┐
    └─────┬─────┘    │  Gabe   │  │  Odin   │  │   Finn    │
          │          │  CI/CD  │  │GCP SRE  │  │GCP FinOps │
          │          └─────────┘  └─────────┘  └───────────┘
          │                 │          │             │
          └─────────────────┴──────────┴─────────────┘
```

## GCP-Specific Terminology

| Azure Term | GCP Equivalent | Notes |
|------------|----------------|-------|
| Management Group | Organization / Folder | GCP has Organization at root |
| Subscription | Project | Billing unit in GCP |
| Resource Group | Labels / Project | GCP uses flat structure in project |
| VNet | VPC Network | GCP VPCs are global |
| Subnet | Subnet | GCP subnets are regional |
| NSG | Firewall Rules | GCP firewall rules at VPC level |
| Azure Firewall | Cloud Armor / Cloud NAT | Different services |
| Managed Identity | Service Account | GCP's identity primitive |
| Key Vault | Secret Manager | GCP secrets service |
| Azure Monitor | Cloud Operations | Monitoring + Logging |
| Azure Policy | Organization Policy | Constraints at org/folder/project |
| Resource Graph | Cloud Asset Inventory | GCP's resource query service |

## Typical Engagement Workflow

### Phase 1: Discovery & Planning (Weeks 1-2)
1. **User** gathers business requirements
2. **Rhea** discovers existing GCP resources using Asset Inventory
3. **Astra** designs GCP organization hierarchy and landing zone
4. **Atlas** creates engagement plan

### Phase 2: Design (Weeks 2-4)
5. **Nina** designs VPC and Shared VPC architecture
6. **Cora** designs Cloud IAM policies and Organization Policies
7. **Finn** creates cost baseline with billing export
8. **Terra** designs Terraform Stack structure for GCP
9. **Hashi** designs HCP integration
10. **Odin** designs Cloud Operations strategy

### Phase 3: Implementation (Weeks 4-10)
11. **Terra** implements Terraform components with GCP provider
12. **Hashi** configures HCP Terraform workspaces
13. **Gabe** sets up Cloud Build or GitHub Actions
14. **Rhea** executes migration waves
15. **Odin** configures monitoring and logging
16. **User** coordinates UAT

### Phase 4: Deployment & Handover (Weeks 10-12)
17. **Atlas** orchestrates production deployment
18. **Gabe** executes deployment pipelines
19. **Odin** validates operational readiness
20. **User** obtains stakeholder sign-off
21. **All Agents** deliver documentation

---

## File Structure

```
bmad-gcloud-infra/
├── README.md                 # This file
├── QUICKSTART.md             # Quick start guide
├── atlas-agent.md            # Orchestration & Leadership
├── rhea-agent.md             # Brownfield Discovery (GCP)
├── astra-agent.md            # GCP Cloud Architect
├── terra-agent.md            # Terraform Stacks
├── hashi-agent.md            # HashiCorp Cloud Platform
├── gabe-agent.md             # CI/CD & Source Control
├── cora-agent.md             # GCP IAM & Security
├── nina-agent.md             # GCP Networking
├── odin-agent.md             # GCP SRE & Operations
├── finn-agent.md             # GCP FinOps
└── user-agent.md             # Stakeholder Advocate
```

---

## GCP-Specific Best Practices

### Organization Hierarchy Design
- Use Organizations for multi-tenant or enterprise-wide structure
- Use Folders for environment separation (dev, staging, prod) or business unit separation
- Use Projects as the billing and isolation boundary
- Apply Organization Policies at the appropriate level (org, folder, project)

### Shared VPC Architecture
- Designate a **host project** for Shared VPC
- Attach **service projects** to use the Shared VPC
- Centralize network administration in host project
- Distributed application deployment in service projects

### IAM Best Practices
- Use Service Accounts for workload identity (not user accounts)
- Prefer Workload Identity over Service Account keys
- Apply least-privilege at the lowest scope (project > folder > org)
- Use custom roles sparingly; prefer predefined roles
- Enable audit logging for all IAM changes

### Terraform State for GCP
- Use Cloud Storage backend with object versioning enabled
- Enable state locking (native in GCS backend)
- Use separate state files per environment/project
- Secure state bucket with IAM (don't use public access)

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

**Current Version**: 1.0.0

**Version History**:
- 1.0.0 (2026-01-11): Initial GCP multi-agent system with 11 agents

**Maintenance**:
- Agents are versioned independently
- System version reflects major architectural changes
- Adapted from bmad-azure-infra v1.1.0

---

## Related Documentation

- **Azure Version**: See `../bmad-azure-infra/README.md` for Azure-focused system
- **Devils Advocate**: See `../devils-advocate/README.md` for critical thinking agents
- **Quick Start**: See `QUICKSTART.md` for getting started with GCP agents
- **GCP Documentation**: [cloud.google.com/docs](https://cloud.google.com/docs)
- **Cloud Foundation Toolkit**: [cloud.google.com/foundation-toolkit](https://cloud.google.com/foundation-toolkit)

---

**Built for enterprise Google Cloud infrastructure at scale.**
