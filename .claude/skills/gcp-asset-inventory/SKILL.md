---
name: gcp-asset-inventory
description: Discover and analyze GCP resources across organizations, folders, and projects using Cloud Asset Inventory. Perform organization-wide resource discovery, IAM policy analysis, Shared VPC discovery, security analysis (public resources, external IPs), and export to BigQuery for analysis.
---

# GCP Cloud Asset Inventory Queries

**Skill Category**: Data Discovery & Analysis  
**Platform**: Google Cloud Platform  
**Primary Tools**: `gcloud asset`, `gcloud` CLI  
**Use Cases**: Resource discovery, dependency mapping, security auditing, compliance

---

## Overview

Cloud Asset Inventory provides a comprehensive view of GCP resources across organizations, folders, and projects. Use this skill to discover assets, analyze configurations, track changes, and ensure governance.

## Authentication

```bash
# Login to GCP
gcloud auth login

# Set project (if needed)
gcloud config set project PROJECT_ID

# Verify access
gcloud config list

# Check available organizations
gcloud organizations list
```

## Query Patterns

### 1. Complete Resource Inventory

```bash
# Search all resources in an organization
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --format="table(name,assetType,location,labels,createTime)"

# Search resources in a specific project
gcloud asset search-all-resources \
  --scope="projects/PROJECT_ID" \
  --format="table(name,assetType,location,labels)"

# Export to JSON for analysis
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --format=json > inventory.json
```

### 2. Resource Discovery by Type

```bash
# Find all Compute Engine instances
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="compute.googleapis.com/Instance" \
  --format="table(name,location,labels)"

# Find all VPC networks
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="compute.googleapis.com/Network" \
  --format=json > networks.json

# Find all GKE clusters
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="container.googleapis.com/Cluster" \
  --format="table(name,location,labels.environment)"

# Find all Cloud SQL instances
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="sqladmin.googleapis.com/Instance" \
  --format="table(name,location)"

# Find all BigQuery datasets
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="bigquery.googleapis.com/Dataset" \
  --format="table(name,location,labels)"

# Find all Cloud Storage buckets
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="storage.googleapis.com/Bucket" \
  --format="table(name,location,storageClass)"
```

### 3. IAM Policy Analysis

```bash
# Search all IAM policies in organization
gcloud asset search-all-iam-policies \
  --scope="organizations/ORG_ID" \
  --format="table(resource,policy.bindings.role,policy.bindings.members)"

# Find who has specific role
gcloud asset search-all-iam-policies \
  --scope="organizations/ORG_ID" \
  --query="policy:roles/owner" \
  --format="table(resource,policy.bindings.members)"

# Find all service accounts with IAM bindings
gcloud asset search-all-iam-policies \
  --scope="organizations/ORG_ID" \
  --query="policy:(serviceAccount:*)" \
  --format="table(resource,policy.bindings.role)"

# Find IAM policies at project level
gcloud asset search-all-iam-policies \
  --scope="projects/PROJECT_ID" \
  --format="table(resource,policy.bindings.role,policy.bindings.members)"
```

### 4. Shared VPC Discovery

```bash
# Find Shared VPC host projects
gcloud compute shared-vpc list-host-projects \
  --organization=ORG_ID

# Find service projects attached to host
gcloud compute shared-vpc list-associated-resources \
  HOST_PROJECT_ID

# Get Shared VPC configuration for a project
gcloud compute shared-vpc get-host-project SERVICE_PROJECT_ID
```

### 5. Resources by Label

```bash
# Find resources with specific label
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --query="labels.environment=production" \
  --format="table(name,assetType,labels)"

# Find untagged resources
gcloud asset search-all-resources \
  --scope="projects/PROJECT_ID" \
  --query="NOT labels:*" \
  --format="table(name,assetType,location)"

# Find resources by cost center
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --query="labels.cost-center=engineering" \
  --format="table(name,assetType,labels)"
```

### 6. Security Analysis

```bash
# Find VMs with external IPs
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="compute.googleapis.com/Instance" \
  --query="networkInterfaces.accessConfigs.natIP:*" \
  --format="table(name,location)"

# Find public Cloud Storage buckets
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="storage.googleapis.com/Bucket" \
  --query="iamPolicy.bindings.members:(allUsers OR allAuthenticatedUsers)" \
  --format="table(name,location)"

# Find resources in non-compliant regions
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --query="location:(europe-* OR asia-*)" \
  --format="table(name,assetType,location)"
```

### 7. Firewall Rules Audit

```bash
# List all firewall rules
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="compute.googleapis.com/Firewall" \
  --format=json > firewall_rules.json

# Find firewall rules allowing all traffic
gcloud compute firewall-rules list \
  --filter="sourceRanges:0.0.0.0/0" \
  --format="table(name,network,direction,sourceRanges,allowed)"
```

### 8. Organization Hierarchy

```bash
# List all folders in organization
gcloud resource-manager folders list \
  --organization=ORG_ID \
  --format="table(name,displayName)"

# List all projects in folder
gcloud projects list \
  --filter="parent.id=FOLDER_ID" \
  --format="table(projectId,name,projectNumber)"

# Get project ancestry (project -> folder -> org)
gcloud projects get-ancestors PROJECT_ID
```

### 9. Resource Changes Over Time

```bash
# Export asset snapshot to Cloud Storage
gcloud asset export \
  --organization=ORG_ID \
  --output-path=gs://BUCKET_NAME/assets-$(date +%Y%m%d).json \
  --content-type=resource

# Compare two snapshots for drift detection
gcloud asset analyze-iam-policy \
  --organization=ORG_ID \
  --full-resource-name="//cloudresourcemanager.googleapis.com/projects/PROJECT_ID"
```

### 10. Service Account Analysis

```bash
# Find all service accounts
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="iam.googleapis.com/ServiceAccount" \
  --format="table(name,displayName,email)"

# Find service accounts with keys
gcloud iam service-accounts list \
  --project=PROJECT_ID \
  --format="table(email,displayName)"

# Check service account key age
gcloud iam service-accounts keys list \
  --iam-account=SA_EMAIL \
  --format="table(name,validAfterTime,validBeforeTime)"
```

## Advanced Queries

### Query Syntax

```bash
# Multiple conditions (AND)
--query="labels.environment=prod AND location:us-*"

# OR conditions
--query="labels.environment=prod OR labels.environment=staging"

# NOT conditions
--query="NOT labels.managed-by=terraform"

# Wildcard matching
--query="name:*prod*"

# Field-specific search
--query="networkInterfaces.network:default"
```

### Complex Resource Discovery

```bash
# Find GKE clusters in production with Autopilot
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="container.googleapis.com/Cluster" \
  --query="labels.environment=production AND autopilot.enabled=true" \
  --format="table(name,location,labels,autopilot.enabled)"

# Find Cloud SQL instances with public IP
gcloud asset search-all-resources \
  --scope="organizations/ORG_ID" \
  --asset-types="sqladmin.googleapis.com/Instance" \
  --query="ipAddresses.ipAddress:*" \
  --format="table(name,ipAddresses,settings.ipConfiguration)"
```

## Export and Analysis

### Export to BigQuery

```bash
# Create BigQuery dataset
bq mk --dataset --location=US PROJECT_ID:asset_inventory

# Export assets to BigQuery
gcloud asset export \
  --organization=ORG_ID \
  --output-bigquery-table="projects/PROJECT_ID/datasets/asset_inventory/tables/assets_$(date +%Y%m%d)" \
  --content-type=resource
```

### BigQuery Analysis Queries

```sql
-- Count resources by type
SELECT
  asset_type,
  COUNT(*) as count
FROM `PROJECT_ID.asset_inventory.assets_*`
GROUP BY asset_type
ORDER BY count DESC;

-- Find untagged resources
SELECT
  name,
  asset_type,
  resource.location
FROM `PROJECT_ID.asset_inventory.assets_*`
WHERE ARRAY_LENGTH(resource.labels) = 0;

-- Analyze resource distribution by location
SELECT
  resource.location,
  asset_type,
  COUNT(*) as count
FROM `PROJECT_ID.asset_inventory.assets_*`
GROUP BY resource.location, asset_type
ORDER BY count DESC;
```

## Output Formats

```bash
# Table format
--format=table

# JSON format
--format=json

# YAML format
--format=yaml

# CSV format
--format=csv

# Custom format
--format="value(name,location,labels)"
```

## Best Practices

1. **Use Appropriate Scope**: Start with projects, expand to folders/org as needed
2. **Filter Early**: Use `--asset-types` and `--query` to reduce results
3. **Export Large Results**: For >1000 resources, export to JSON/BigQuery
4. **Cache Queries**: Export snapshots for offline analysis
5. **Monitor Changes**: Regular exports for drift detection
6. **Use Service Accounts**: For automation, use SA with Asset Viewer role

## Required IAM Roles

```bash
# For resource search
roles/cloudasset.viewer

# For IAM policy analysis
roles/iam.securityReviewer

# For BigQuery export
roles/bigquery.dataEditor
roles/cloudasset.viewer

# Grant role to service account
gcloud organizations add-iam-policy-binding ORG_ID \
  --member="serviceAccount:SA_EMAIL" \
  --role="roles/cloudasset.viewer"
```

## Troubleshooting

### Permission Denied

```bash
# Check your permissions
gcloud projects get-iam-policy PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.members:user:YOUR_EMAIL"

# Request access from organization admin
```

### No Results Returned

```bash
# Verify scope is correct
gcloud organizations list
gcloud projects list

# Check asset type spelling
gcloud asset search-all-resources \
  --scope="projects/PROJECT_ID" \
  --asset-types="compute.googleapis.com/Instance"
```

### Query Too Broad

```bash
# Add filters to narrow results
--query="labels.environment=prod"
--asset-types="compute.googleapis.com/Instance"
```

## Integration with Terraform

```bash
# Export resources for import planning
gcloud asset search-all-resources \
  --scope="projects/PROJECT_ID" \
  --asset-types="compute.googleapis.com/Instance" \
  --format="value(name)" > instances_to_import.txt

# Generate Terraform import commands
while read -r instance; do
  echo "terraform import google_compute_instance.$instance projects/PROJECT_ID/zones/ZONE/instances/$instance"
done < instances_to_import.txt
```

## References

- [Cloud Asset Inventory Documentation](https://cloud.google.com/asset-inventory/docs)
- [Search Query Syntax](https://cloud.google.com/asset-inventory/docs/searching-resources)
- [Asset Types Reference](https://cloud.google.com/asset-inventory/docs/supported-asset-types)
- [gcloud asset CLI Reference](https://cloud.google.com/sdk/gcloud/reference/asset)
