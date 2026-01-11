---
name: hcp-terraform-api
description: Manage HCP Terraform workspaces, runs, and policies via API. Query workspace status, manage runs (plan/apply), handle state files, manage Sentinel policies, analyze cost estimates, configure team access, and monitor audit trails for automation and compliance.
---

# HCP Terraform API Queries

**Skill Category**: Platform Management & Automation  
**Platform**: HashiCorp Cloud Platform  
**Primary Tools**: HCP Terraform API, `tfe` provider, `curl`  
**Use Cases**: Workspace management, run automation, policy enforcement, state analysis

---

## Overview

HCP Terraform (formerly Terraform Cloud) provides a comprehensive API for managing workspaces, runs, state files, and policies. Use this skill to automate operations, query workspace status, and integrate with CI/CD pipelines.

## Authentication

```bash
# Set API token as environment variable
export TFE_TOKEN="your-api-token"

# Or create credentials file
cat > ~/.terraform.d/credentials.tfrc.json <<EOF
{
  "credentials": {
    "app.terraform.io": {
      "token": "your-api-token"
    }
  }
}
EOF

# Verify access
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/account/details | jq
```

## API Patterns

### 1. Organization & Workspace Management

```bash
# List all workspaces in organization
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/organizations/ORG_NAME/workspaces" \
  | jq '.data[] | {name: .attributes.name, id: .id, state: .attributes."execution-mode"}'

# Get specific workspace details
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/organizations/ORG_NAME/workspaces/WORKSPACE_NAME" \
  | jq

# List workspace variables
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/workspaces/WORKSPACE_ID/vars" \
  | jq '.data[] | {key: .attributes.key, value: .attributes.value, sensitive: .attributes.sensitive}'

# Create workspace
curl -X POST \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --data @- \
  "https://app.terraform.io/api/v2/organizations/ORG_NAME/workspaces" <<EOF
{
  "data": {
    "type": "workspaces",
    "attributes": {
      "name": "new-workspace",
      "terraform_version": "1.6.0",
      "auto-apply": false,
      "working-directory": "environments/prod"
    }
  }
}
EOF
```

### 2. Run Management

```bash
# List runs for workspace
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/workspaces/WORKSPACE_ID/runs" \
  | jq '.data[] | {id: .id, status: .attributes.status, created: .attributes."created-at"}'

# Get run details
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/runs/RUN_ID" \
  | jq

# Create new run (plan)
curl -X POST \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --data @- \
  "https://app.terraform.io/api/v2/runs" <<EOF
{
  "data": {
    "type": "runs",
    "attributes": {
      "message": "Triggered via API",
      "is-destroy": false
    },
    "relationships": {
      "workspace": {
        "data": {
          "type": "workspaces",
          "id": "WORKSPACE_ID"
        }
      }
    }
  }
}
EOF

# Apply a run
curl -X POST \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/runs/RUN_ID/actions/apply"

# Discard a run
curl -X POST \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/runs/RUN_ID/actions/discard"
```

### 3. State File Management

```bash
# Get current state version
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/workspaces/WORKSPACE_ID/current-state-version" \
  | jq

# Download state file
STATE_URL=$(curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  "https://app.terraform.io/api/v2/workspaces/WORKSPACE_ID/current-state-version" \
  | jq -r '.data.attributes."hosted-state-download-url"')

curl -s "$STATE_URL" | jq > state.json

# List state versions (history)
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/workspaces/WORKSPACE_ID/state-versions" \
  | jq '.data[] | {serial: .attributes.serial, created: .attributes."created-at"}'

# Create state version (upload state)
curl -X POST \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --data @state_version.json \
  "https://app.terraform.io/api/v2/workspaces/WORKSPACE_ID/state-versions"
```

### 4. Policy Management (Sentinel)

```bash
# List policy sets
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/organizations/ORG_NAME/policy-sets" \
  | jq '.data[] | {name: .attributes.name, global: .attributes.global}'

# Get policy set details
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/policy-sets/POLICY_SET_ID" \
  | jq

# List policies
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/organizations/ORG_NAME/policies" \
  | jq '.data[] | {name: .attributes.name, enforcement: .attributes."enforcement-level"}'

# Create policy
curl -X POST \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --data @- \
  "https://app.terraform.io/api/v2/organizations/ORG_NAME/policies" <<EOF
{
  "data": {
    "type": "policies",
    "attributes": {
      "name": "azure-tag-enforcement",
      "enforcement-level": "hard-mandatory",
      "policy": "$(cat policy.sentinel | base64)"
    }
  }
}
EOF
```

### 5. Cost Estimation

```bash
# Get cost estimate for run
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/cost-estimates/COST_ESTIMATE_ID" \
  | jq

# Extract cost estimate from run
RUN_ID="run-abc123"
COST_ESTIMATE_ID=$(curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  "https://app.terraform.io/api/v2/runs/$RUN_ID" \
  | jq -r '.data.relationships."cost-estimate".data.id')

curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  "https://app.terraform.io/api/v2/cost-estimates/$COST_ESTIMATE_ID" \
  | jq '.data.attributes | {
      "proposed-monthly-cost": ."proposed-monthly-cost",
      "delta-monthly-cost": ."delta-monthly-cost"
    }'
```

### 6. Team & Access Management

```bash
# List teams in organization
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/organizations/ORG_NAME/teams" \
  | jq '.data[] | {name: .attributes.name, id: .id}'

# Get team access to workspace
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/team-workspaces" \
  | jq

# Grant team access to workspace
curl -X POST \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --data @- \
  "https://app.terraform.io/api/v2/team-workspaces" <<EOF
{
  "data": {
    "type": "team-workspaces",
    "attributes": {
      "access": "write"
    },
    "relationships": {
      "team": {
        "data": {
          "type": "teams",
          "id": "TEAM_ID"
        }
      },
      "workspace": {
        "data": {
          "type": "workspaces",
          "id": "WORKSPACE_ID"
        }
      }
    }
  }
}
EOF
```

### 7. Audit & Monitoring

```bash
# Get audit trail (organization events)
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/organization/audit-trail" \
  | jq

# Get run events (for monitoring)
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/runs/RUN_ID/run-events" \
  | jq '.data[] | {action: .attributes.action, timestamp: .attributes.timestamp}'

# Get workspace run statistics
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/workspaces/WORKSPACE_ID/runs?page[size]=100" \
  | jq '[.data[] | .attributes.status] | group_by(.) | 
        map({status: .[0], count: length})'
```

## Using Terraform Provider

```hcl
# Configure TFE provider
terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.51.0"
    }
  }
}

provider "tfe" {
  token = var.tfe_token
}

# Query workspace data
data "tfe_workspace" "example" {
  name         = "my-workspace"
  organization = "my-org"
}

output "workspace_id" {
  value = data.tfe_workspace.example.id
}

# Query workspace variables
data "tfe_variables" "example" {
  workspace_id = data.tfe_workspace.example.id
}

# Create workspace
resource "tfe_workspace" "new" {
  name         = "azure-prod-eastus"
  organization = "my-org"
  
  terraform_version = "1.6.0"
  working_directory = "environments/prod"
  auto_apply        = false
  
  vcs_repo {
    identifier     = "org/repo"
    oauth_token_id = var.oauth_token_id
  }
}

# Create variable
resource "tfe_variable" "example" {
  workspace_id = tfe_workspace.new.id
  key          = "environment"
  value        = "production"
  category     = "terraform"
}

# Create notification
resource "tfe_notification_configuration" "slack" {
  workspace_id     = tfe_workspace.new.id
  name             = "Slack Notifications"
  destination_type = "slack"
  url              = var.slack_webhook_url
  
  triggers = [
    "run:needs_attention",
    "run:errored"
  ]
}
```

## Batch Operations

### Query All Workspaces with Specific Tag

```bash
#!/bin/bash
ORG="my-org"

# Get all workspaces
curl -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  "https://app.terraform.io/api/v2/organizations/$ORG/workspaces?page[size]=100" \
  | jq -r '.data[] | select(.attributes.tags[]? == "azure") | {
      name: .attributes.name,
      id: .id,
      terraform_version: .attributes."terraform-version"
    }'
```

### Trigger Runs for Multiple Workspaces

```bash
#!/bin/bash
for WORKSPACE_ID in ws-abc123 ws-def456 ws-ghi789; do
  echo "Triggering run for $WORKSPACE_ID"
  curl -X POST \
    --header "Authorization: Bearer $TFE_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --data "{\"data\":{\"type\":\"runs\",\"relationships\":{\"workspace\":{\"data\":{\"type\":\"workspaces\",\"id\":\"$WORKSPACE_ID\"}}}}}" \
    "https://app.terraform.io/api/v2/runs"
  sleep 2
done
```

## Best Practices

1. **Use API Tokens Securely**: Store in environment variables or secrets manager
2. **Implement Rate Limiting**: HCP API has rate limits (30 req/sec)
3. **Pagination**: Handle pagination for large result sets (`page[size]`, `page[number]`)
4. **Error Handling**: Check HTTP status codes and parse error responses
5. **Idempotency**: Use unique identifiers to avoid duplicate operations
6. **Audit Trail**: Log all API operations for compliance

## Rate Limits

```bash
# Check rate limit headers in response
curl -i \
  --header "Authorization: Bearer $TFE_TOKEN" \
  "https://app.terraform.io/api/v2/account/details" \
  | grep -i "x-ratelimit"

# Output:
# x-ratelimit-limit: 30
# x-ratelimit-remaining: 29
# x-ratelimit-reset: 1640000000
```

## Error Handling

```bash
# Parse API errors
RESPONSE=$(curl -s -w "\n%{http_code}" \
  --header "Authorization: Bearer $TFE_TOKEN" \
  "https://app.terraform.io/api/v2/workspaces/invalid-id")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n-1)

if [ "$HTTP_CODE" != "200" ]; then
  echo "Error: HTTP $HTTP_CODE"
  echo "$BODY" | jq '.errors'
fi
```

## References

- [HCP Terraform API Documentation](https://developer.hashicorp.com/terraform/cloud-docs/api-docs)
- [TFE Provider Documentation](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)
- [API Rate Limits](https://developer.hashicorp.com/terraform/cloud-docs/api-docs#rate-limiting)
- [Sentinel Policy Documentation](https://developer.hashicorp.com/sentinel/docs)
