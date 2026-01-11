# Claude Code Skills

This directory contains reusable skills that agents can reference for platform-specific data queries and operations.

## Available Skills

### 1. Azure Resource Graph (`azure-resource-graph.md`)
**Platform**: Azure  
**Use Cases**: Resource discovery, dependency mapping, compliance auditing, cost analysis

Query Azure resources using Kusto Query Language (KQL) with Azure Resource Graph. Discover VMs, networks, storage, and analyze resource configurations at scale.

**Key Capabilities**:
- Complete resource inventory
- Resource dependencies mapping
- Security auditing (NSG rules, public IPs)
- Policy compliance checks
- Untagged resources detection

---

### 2. GCP Asset Inventory (`gcp-asset-inventory.md`)
**Platform**: Google Cloud Platform  
**Use Cases**: Resource discovery, dependency mapping, security auditing, compliance

Discover and analyze GCP resources across organizations, folders, and projects using Cloud Asset Inventory.

**Key Capabilities**:
- Organization-wide resource discovery
- IAM policy analysis
- Shared VPC discovery
- Security analysis (public resources, external IPs)
- Export to BigQuery for analysis

---

### 3. HCP Terraform API (`hcp-terraform-api.md`)
**Platform**: HashiCorp Cloud Platform  
**Use Cases**: Workspace management, run automation, policy enforcement, state analysis

Manage HCP Terraform workspaces, runs, and policies via API for automation and monitoring.

**Key Capabilities**:
- Workspace and run management
- State file operations
- Sentinel policy management
- Cost estimation
- Team and access management
- Audit trail analysis

---

### 4. GitHub API (`github-api.md`)
**Platform**: GitHub  
**Use Cases**: Repository management, PR automation, workflow monitoring, security scanning

Automate GitHub operations for CI/CD pipelines, PR management, and workflow monitoring.

**Key Capabilities**:
- Repository and branch management
- Pull request automation
- GitHub Actions workflow monitoring
- Security and Dependabot alerts
- Team and permission management
- GraphQL queries for complex data

---

### 5. BigQuery Analysis (`bigquery-analysis.md`)
**Platform**: Google Cloud Platform  
**Use Cases**: Cost analysis, data warehouse queries, billing insights, resource analytics

Analyze GCP billing data, query cost trends, and generate insights from BigQuery.

**Key Capabilities**:
- GCP billing cost analysis
- Cost by labels/tags
- Cost anomaly detection
- Compute and storage cost breakdown
- Query optimization
- Scheduled queries

---

## How Agents Use Skills

Agents in the infrastructure systems (bmad-azure-infra, bmad-gcloud-infra) can reference these skills when they need to:

1. **Query Real Data**: Get actual resource configurations, costs, or status
2. **Discover Resources**: Find existing infrastructure for brownfield analysis
3. **Monitor Status**: Check workflow runs, policy compliance, or resource health
4. **Analyze Costs**: Query billing data for FinOps analysis
5. **Automate Operations**: Trigger runs, manage workspaces, or update resources

### Example Usage

When an agent needs to discover Azure resources:
```
Agent: "I need to discover all VMs in production resource groups"
Skill: azure-resource-graph.md → Section "VM Inventory with Details"
Result: KQL query to list all VMs with configuration details
```

When an agent needs to analyze GCP costs:
```
Agent: "Show me cost breakdown by project for last 30 days"
Skill: bigquery-analysis.md → Section "Cost Analysis Queries"
Result: BigQuery SQL to analyze billing data
```

## Authentication Requirements

Each skill requires appropriate authentication:

- **Azure**: `az login` (Azure CLI)
- **GCP**: `gcloud auth login` (gcloud CLI)
- **HCP**: `TFE_TOKEN` environment variable
- **GitHub**: `gh auth login` or `GITHUB_TOKEN`
- **BigQuery**: `gcloud auth application-default login`

## Best Practices

1. **Progressive Disclosure**: Skills are loaded only when needed
2. **Scoped Queries**: Start with narrow scopes, expand as needed
3. **Cost Awareness**: Monitor API usage and query costs
4. **Rate Limiting**: Respect API rate limits
5. **Caching**: Cache query results for reuse
6. **Security**: Protect authentication tokens and credentials

## Agent Skill Mapping

### Azure Agents
- **Rhea** (Discovery): azure-resource-graph.md
- **Finn** (FinOps): azure-resource-graph.md (for resource analysis)
- **Gabe** (CI/CD): github-api.md
- **Hashi** (HCP): hcp-terraform-api.md

### GCP Agents
- **Rhea** (Discovery): gcp-asset-inventory.md
- **Astra** (Data Architect): bigquery-analysis.md
- **Finn** (FinOps): bigquery-analysis.md
- **Gabe** (CI/CD): github-api.md
- **Hashi** (HCP): hcp-terraform-api.md

---

**Note**: These skills provide query patterns and commands. Agents use Claude Code's `run_shell_command` tool to execute them and analyze results.
