# BMAD GCloud Infrastructure - Quick Start Guide

**Version**: 1.0.0  
**Platform**: Google Cloud Platform  
**Last Updated**: 2024-01-15

---

## Overview

BMAD GCloud Infrastructure is a comprehensive multi-agent system for designing, implementing, and operating GCP infrastructure. This system consists of 11 specialized AI agents working collaboratively to deliver enterprise-grade cloud infrastructure.

## Table of Contents

1. [Agent Overview](#agent-overview)
2. [Quick Start Scenarios](#quick-start-scenarios)
3. [Common Workflows](#common-workflows)
4. [Agent Interaction Patterns](#agent-interaction-patterns)
5. [Best Practices](#best-practices)
6. [Troubleshooting](#troubleshooting)

---

## Agent Overview

### Core Agents

| Agent | Role | Primary Focus | When to Use |
|-------|------|---------------|-------------|
| **Atlas** | Orchestrator & Leadership | Project planning, coordination | Starting a new project, complex migrations |
| **Astra** | GCP Architect & Data Specialist | Architecture design, BigQuery, data pipelines | Designing infrastructure, data warehouses, architecture reviews |
| **Terra** | Terraform Specialist | IaC implementation, Terraform stacks | Implementing infrastructure as code |
| **Rhea** | Brownfield Discovery | Existing infrastructure analysis | Discovering existing GCP resources |
| **Cora** | Security & IAM | Security, compliance, IAM | Security reviews, IAM design, compliance |
| **Nina** | Networking | VPC, load balancing, connectivity | Network design, connectivity issues |
| **Odin** | SRE & Operations | Observability, SLOs, incident response | Monitoring setup, SLO definition, incidents |
| **Finn** | FinOps | Cost optimization, budgets | Cost reduction, budget management |
| **Gabe** | CI/CD | Deployment automation | CI/CD pipelines, deployment automation |
| **Hashi** | HCP Specialist | HCP Terraform, Vault, Packer | HCP integration, secret management |
| **User** | Stakeholder Advocate | Business requirements, decisions | Business alignment, approvals |

---

## Quick Start Scenarios

### Scenario 1: New GCP Project Setup

**Objective**: Set up a new GCP project for a web application with proper organization, security, and networking.

**Agents Involved**: Atlas → Astra → Terra → Cora → Nina

**Steps**:

```
1. Start with Atlas
   "I need to set up a new GCP project for our web application. 
   Requirements:
   - Environment: Production
   - Region: us-central1
   - Application: Node.js API + React frontend
   - Database: Cloud SQL (PostgreSQL)
   - Expected traffic: 10,000 req/day
   - Budget: $2,000/month"

2. Atlas will:
   - Break down the project into phases
   - Identify required agents (Astra, Terra, Cora, Nina)
   - Create project plan
   - Coordinate execution

3. Follow Atlas's plan:
   - Phase 1: Astra designs architecture
   - Phase 2: Cora designs IAM and security
   - Phase 3: Nina designs networking (VPC, subnets)
   - Phase 4: Terra implements in Terraform
   - Phase 5: Gabe sets up CI/CD

4. Expected Deliverables:
   - GCP project with proper folder structure
   - Terraform code for all infrastructure
   - Shared VPC with subnets
   - Cloud SQL instance
   - GKE cluster (or Cloud Run)
   - IAM roles and service accounts
   - CI/CD pipeline
```

### Scenario 2: Cost Optimization

**Objective**: Reduce monthly GCP costs by 20-30%.

**Agents Involved**: Finn → Odin → Terra

**Steps**:

```
1. Start with Finn
   "Our monthly GCP cost is $50,000. We need to reduce it by 20-30% 
   without impacting performance or availability."

2. Finn will:
   - Analyze billing data (BigQuery export)
   - Identify cost drivers (Compute, Storage, Networking)
   - Find optimization opportunities:
     * Idle resources
     * Over-provisioned resources
     * Storage lifecycle opportunities
     * CUD opportunities

3. Finn will create optimization plan:
   - Delete 50 idle VMs: $3,000/mo savings
   - Right-size 100 VMs: $5,000/mo savings
   - Storage lifecycle policies: $2,000/mo savings
   - Purchase CUDs: $4,000/mo savings
   - Total: $14,000/mo savings (28%)

4. Coordinate with Odin:
   - Odin validates right-sizing won't impact performance
   - Odin monitors metrics after changes

5. Terra implements:
   - Updates Terraform to delete idle resources
   - Implements lifecycle policies
   - Purchases CUDs
```

### Scenario 3: Migrate On-Premises to GCP

**Objective**: Migrate existing on-premises application to GCP with zero downtime.

**Agents Involved**: Atlas → Rhea → Astra → Terra → Gabe

**Steps**:

```
1. Start with Atlas
   "We need to migrate our on-premises application to GCP.
   Current setup:
   - Application: Java Spring Boot
   - Database: PostgreSQL 12
   - Traffic: 100,000 req/day
   - Requirements: Zero downtime during migration"

2. Atlas coordinates discovery phase:
   - Rhea discovers existing infrastructure
   - Rhea documents dependencies
   - Rhea identifies migration challenges

3. Astra designs GCP architecture:
   - GKE for application (containerized)
   - Cloud SQL for database
   - Shared VPC for networking
   - Cloud Armor for DDoS protection

4. Atlas creates migration plan:
   - Phase 1: Set up GCP infrastructure (Terra)
   - Phase 2: Database migration (staged)
   - Phase 3: Application migration (canary)
   - Phase 4: DNS cutover
   - Phase 5: Decommission on-prem

5. Execute migration:
   - Terra implements infrastructure
   - Gabe sets up CI/CD
   - Odin monitors throughout
```

### Scenario 4: Security & Compliance Audit

**Objective**: Prepare for SOC2 Type 2 audit.

**Agents Involved**: Cora → Atlas → Odin

**Steps**:

```
1. Start with Cora
   "We're preparing for SOC2 Type 2 audit. Need to ensure 
   our GCP infrastructure is compliant."

2. Cora will:
   - Map SOC2 controls to GCP (CC6.1, CC6.6, CC6.7, CC7.2)
   - Audit existing IAM (least-privilege)
   - Review Organization Policies
   - Check Security Command Center findings
   - Review audit logging

3. Cora identifies gaps:
   - Missing IAM access reviews
   - Incomplete audit logging
   - Missing Organization Policies
   - No CMEK for Cloud Storage

4. Cora creates remediation plan:
   - Implement quarterly IAM reviews
   - Enable comprehensive audit logging
   - Deploy Organization Policies
   - Implement CMEK for sensitive data

5. Coordinate with Odin:
   - Odin sets up monitoring for compliance
   - Odin creates compliance dashboard
   - Odin monitors security findings
```

### Scenario 5: BigQuery Data Warehouse

**Objective**: Build a data warehouse in BigQuery for business analytics.

**Agents Involved**: Atlas → Astra → Terra → Cora → Finn

**Steps**:

```
1. Start with Atlas
   "We need to build a data warehouse in BigQuery for our analytics team.
   Requirements:
   - Data sources: Cloud SQL (orders), Firestore (user events), Pub/Sub (logs)
   - Data volume: 500GB historical + 10GB/day new data
   - Query patterns: Daily reports, ad-hoc analysis
   - Users: 20 analysts, 5 data scientists
   - Budget: $3,000/month
   - Governance: Row-level security, PII protection"

2. Atlas coordinates design phase:
   - Astra designs BigQuery architecture
   - Cora designs data governance and access controls
   - Finn estimates costs and recommends pricing model

3. Astra will:
   - Design data model (star schema with fact/dimension tables)
   - Design partitioning strategy (DATE partition on order_date)
   - Design clustering strategy (customer_id, product_id)
   - Design materialized views for common aggregations
   - Design data pipeline architecture:
     * Batch: Cloud Composer (Airflow) for Cloud SQL → BigQuery
     * Streaming: Pub/Sub → Dataflow → BigQuery for real-time events
   - Implement SCD Type 2 for slowly changing dimensions

4. Cora designs security:
   - Row-level security with authorized views (region-based)
   - Column-level security with policy tags (PII masking)
   - IAM roles for analysts vs data scientists
   - Data governance policies

5. Terra implements:
   - BigQuery datasets with proper organization
   - Partitioned and clustered tables
   - Materialized views
   - Authorized views
   - Cloud Composer DAGs
   - Dataflow pipelines
   - IAM bindings

6. Finn optimizes costs:
   - Validate partition pruning works
   - Validate clustering improves query performance
   - Recommend flat-rate pricing if query volume is high
   - Set up cost monitoring and alerts

7. Expected Deliverables:
   - BigQuery datasets and tables (partitioned + clustered)
   - Materialized views for common queries
   - ETL pipelines (batch + streaming)
   - Row-level and column-level security
   - Data quality monitoring
   - Cost optimization implemented
```

---

## Common Workflows

### Daily Operations

**Morning Stand-up**
```
1. Odin: Report SLO compliance, incidents, performance
2. Finn: Report cost status, budget compliance
3. Gabe: Report deployment success rate
4. Atlas: Prioritize work for the day
```

**Incident Response**
```
1. Odin: Detects incident, declares severity
2. Odin: Follows runbook, attempts mitigation
3. Atlas: Escalates to appropriate team members
4. User: Approves aggressive mitigation if needed
5. Odin: Resolves incident, schedules postmortem
```

**Cost Review (Monthly)**
```
1. Finn: Generates monthly cost report
2. Finn: Identifies anomalies and optimization opportunities
3. Atlas: Reviews with User
4. User: Approves optimization initiatives
5. Finn: Implements approved optimizations
```

### Project Phases

**Phase 1: Planning**
```
Agents: Atlas, User
- Gather requirements
- Define success criteria
- Identify constraints
- Approve budget and timeline
```

**Phase 2: Design**
```
Agents: Astra, Cora, Nina
- Architecture design (compute, storage, data)
- Security design (IAM, Organization Policies)
- Network design (VPC, connectivity)
- Design review
```

**Phase 3: Implementation**
```
Agents: Terra, Hashi
- Terraform implementation
- Secret management setup
- Code review
- Testing in development
```

**Phase 4: Deployment**
```
Agents: Gabe, Odin
- CI/CD setup
- Monitoring setup
- Staging deployment
- Production deployment
```

**Phase 5: Operations**
```
Agents: Odin, Finn
- Monitoring and alerting
- Incident response
- Cost optimization
- Performance tuning
```

---

## Agent Interaction Patterns

### Pattern 1: Sequential (Waterfall)
**Use When**: Clear dependencies, one phase must complete before next

```
User → Atlas → Astra → Terra → Gabe → Odin
(Requirements → Plan → Design → Implement → Deploy → Monitor)
```

### Pattern 2: Parallel (Concurrent)
**Use When**: Independent work streams, faster delivery

```
         ┌─→ Astra (Architecture)
Atlas ───┼─→ Cora (Security)
         └─→ Nina (Networking)
              ↓
            Terra (Implements all)
```

### Pattern 3: Iterative (Agile)
**Use When**: Uncertain requirements, need feedback loops

```
Atlas → Astra (design) → User (feedback) → Astra (refine) → User (approve) → Terra (implement)
```

### Pattern 4: Reactive (Incident)
**Use When**: Production issues, time-critical response

```
Odin (detects) → Odin (mitigates) → Atlas (coordinates) → User (escalates if needed)
```

---

## Best Practices

### When Starting a New Project

1. **Always start with Atlas**: Don't skip the orchestrator
2. **Define success criteria**: Work with User to define measurable goals
3. **Budget first**: Get User approval on budget before design
4. **Security from start**: Involve Cora early, not as an afterthought
5. **Document decisions**: Keep track of trade-off decisions

### For Cost Optimization

1. **Monthly reviews**: Regular cost reviews prevent surprises
2. **Label everything**: Labels enable cost allocation and optimization
3. **Right-size continuously**: Don't optimize once and forget
4. **Use CUDs wisely**: Only for stable, predictable workloads
5. **Delete idle resources**: Idle resources are wasted money

### For Security & Compliance

1. **Least-privilege always**: Start restrictive, loosen as needed
2. **Automate compliance**: Use Organization Policies for prevention
3. **Audit everything**: Enable comprehensive audit logging
4. **Rotate secrets**: Automate secret rotation (90-day cycle)
5. **Defense-in-depth**: Layer security controls (network, IAM, encryption)

### For Reliability

1. **Define SLOs**: Agree on availability and performance targets
2. **Monitor golden signals**: Latency, traffic, errors, saturation
3. **Automate response**: Create runbooks and auto-remediation
4. **Test failures**: Chaos engineering to validate resilience
5. **Blameless postmortems**: Focus on systems, not people

---

## Troubleshooting

### Issue: "I don't know which agent to use"

**Solution**: Always start with **Atlas**. Describe your goal, and Atlas will coordinate the appropriate agents.

Example:
```
"Atlas, I need help with [your goal]. Here's the context: [provide context]"
```

### Issue: "Agents are giving conflicting advice"

**Solution**: Escalate to **Atlas** or **User** for decision.

Example:
```
"Atlas, Finn recommends option A (cost-optimized) but Odin recommends 
option B (performance-optimized). Help me decide based on business priorities."
```

### Issue: "I need something done urgently"

**Solution**: Declare severity and involve **Atlas** immediately.

Example:
```
"Atlas, production is down (P1 incident). Odin is investigating. 
Need immediate coordination and potential User escalation."
```

### Issue: "Cost is higher than expected"

**Solution**: Engage **Finn** for cost analysis and optimization.

Example:
```
"Finn, monthly cost is $75k (expected $50k). Analyze and provide 
optimization recommendations to get back to budget."
```

### Issue: "Performance is degrading"

**Solution**: Engage **Odin** for performance analysis.

Example:
```
"Odin, P95 latency increased from 200ms to 800ms over the past week. 
Investigate root cause and recommend fixes."
```

### Issue: "Security audit found issues"

**Solution**: Engage **Cora** for security remediation.

Example:
```
"Cora, security audit found 15 critical findings (overprivileged IAM, 
missing encryption, no MFA). Create remediation plan."
```

### Issue: "BigQuery queries are expensive"

**Solution**: Engage **Astra** for BigQuery optimization, coordinate with **Finn** for cost validation.

Example:
```
"Astra, BigQuery queries are scanning terabytes of data and costing $10k/month. 
Optimize query patterns, implement partitioning/clustering, and validate with Finn."
```

### Issue: "Data pipeline is failing"

**Solution**: Engage **Astra** for pipeline design, **Odin** for monitoring.

Example:
```
"Astra, our Dataflow pipeline from Pub/Sub to BigQuery is failing with 
back-pressure errors. Investigate and recommend fixes."
```

---

## Getting Started Checklist

**Before You Begin**:
- [ ] Define your objective (what do you want to achieve?)
- [ ] Identify your constraints (budget, timeline, compliance)
- [ ] Determine your success criteria (how will you measure success?)

**Phase 1: Discovery** (if migrating from existing infrastructure):
- [ ] Engage Rhea to discover existing resources
- [ ] Document current state (architecture, costs, issues)
- [ ] Identify migration challenges

**Phase 2: Planning**:
- [ ] Engage Atlas to create project plan
- [ ] Get User approval on plan and budget
- [ ] Assign agents to work streams

**Phase 3: Design**:
- [ ] Astra: Architecture design (compute, storage, data)
- [ ] Cora: Security and IAM design
- [ ] Nina: Network design
- [ ] Finn: Cost estimation

**Phase 4: Implementation**:
- [ ] Terra: Terraform implementation
- [ ] Hashi: Secret management setup
- [ ] Gabe: CI/CD pipeline setup

**Phase 5: Validation**:
- [ ] Test in development environment
- [ ] Test in staging environment
- [ ] Load testing (Odin)
- [ ] Security audit (Cora)
- [ ] Cost validation (Finn)

**Phase 6: Deployment**:
- [ ] User: Go/no-go decision
- [ ] Gabe: Production deployment
- [ ] Odin: Monitor during deployment
- [ ] Atlas: Coordinate rollback if needed

**Phase 7: Operations**:
- [ ] Odin: Set up monitoring and alerting
- [ ] Finn: Set up cost monitoring and budgets
- [ ] Gabe: Enable continuous deployment
- [ ] Schedule regular reviews (weekly/monthly)

---

## Example: End-to-End Web Application

**Goal**: Deploy a new web application to GCP

**Timeline**: 6 weeks

**Budget**: $50,000 one-time + $5,000/month

**Requirements**:
- High availability (99.95%)
- Global latency <200ms
- SOC2 compliant
- Cost-optimized

**Week 1: Planning & Design**
```
Day 1-2: Atlas + User
- Define requirements and success criteria
- Approve budget and timeline

Day 3-5: Astra + Cora + Nina
- Astra: Design architecture (GKE, Cloud SQL, Cloud CDN)
- Cora: Design IAM and security (least-privilege, Organization Policies)
- Nina: Design network (Shared VPC, global load balancer)
```

**Week 2-3: Implementation**
```
Day 6-15: Terra + Hashi
- Terra: Implement Terraform code
  * Organization and folder structure
  * Shared VPC and subnets
  * GKE cluster
  * Cloud SQL instance
  * Cloud Load Balancer
  * Cloud Armor
- Hashi: Set up HCP Terraform workspace
- Hashi: Configure secret management
```

**Week 4: CI/CD & Monitoring**
```
Day 16-20: Gabe + Odin
- Gabe: Set up GitHub Actions
  * Build and test pipeline
  * Deploy to GKE
  * Drift detection
- Odin: Set up monitoring
  * Cloud Monitoring dashboards
  * Alert policies
  * SLO definitions
```

**Week 5: Testing & Security**
```
Day 21-25: Odin + Cora
- Odin: Load testing and performance tuning
- Cora: Security audit
  * IAM review
  * Organization Policy compliance
  * Security Command Center findings
- Terra: Address findings
```

**Week 6: Deployment & Operations**
```
Day 26-28: User + Gabe + Odin
- User: Go/no-go decision
- Gabe: Production deployment (canary → full)
- Odin: Monitor deployment
- Atlas: Coordinate rollback if needed

Day 29-30: Finn + Atlas
- Finn: Validate costs (<$5k/mo)
- Atlas: Project retrospective
- User: Celebrate success!
```

---

## Next Steps

1. **Explore Agent Files**: Read individual agent files for detailed capabilities
2. **Start Small**: Begin with a simple project to learn the system
3. **Ask Questions**: Don't hesitate to ask agents for clarification
4. **Iterate**: Use feedback loops to refine your approach
5. **Share Learnings**: Document what works and what doesn't

---

## Support

For questions or issues:
1. Start with **Atlas** for coordination
2. Consult individual agent files for specialized knowledge
3. Review **README.md** for system overview

---

**Good luck with your GCP infrastructure journey!** 🚀
