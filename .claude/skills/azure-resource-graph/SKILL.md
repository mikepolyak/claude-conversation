---
name: azure-resource-graph
description: Query Azure resources using Kusto Query Language (KQL) with Azure Resource Graph. Discover VMs, networks, storage, analyze resource configurations, map dependencies, audit security (NSG rules, public IPs), check policy compliance, and detect untagged resources across subscriptions.
---

# Azure Resource Graph Queries

**Skill Category**: Data Discovery & Analysis  
**Platform**: Azure  
**Primary Tools**: `az graph query`, Azure Portal  
**Use Cases**: Resource discovery, dependency mapping, compliance auditing, cost analysis

---

## Overview

Azure Resource Graph (ARG) provides fast, efficient queries across Azure subscriptions using Kusto Query Language (KQL). Use this skill to discover resources, analyze configurations, and map dependencies at scale.

## Authentication

```bash
# Login to Azure
az login

# Set subscription (if needed)
az account set --subscription "subscription-id"

# Verify access
az account show
```

## Query Patterns

### 1. Complete Resource Inventory

```bash
az graph query -q "
Resources
| where subscriptionId in ('sub-id-1', 'sub-id-2')
| where resourceGroup !startswith 'MC_'  // Exclude AKS-managed RGs
| project 
    subscriptionId,
    resourceGroup,
    name,
    type,
    location,
    tags,
    id,
    properties
| order by resourceGroup, type, name
" --output table
```

### 2. Resource Dependencies

```bash
# Network Interface → VM dependencies
az graph query -q "
Resources
| where type =~ 'microsoft.compute/virtualmachines'
| extend nics = properties.networkProfile.networkInterfaces
| mvexpand nics
| project vmId=id, vmName=name, nicId=tostring(nics.id)
| join kind=inner (
    Resources
    | where type =~ 'microsoft.network/networkinterfaces'
    | extend subnetId = properties.ipConfigurations[0].properties.subnet.id
    | project nicId=id, nicName=name, subnetId
) on nicId
| project vmName, nicName, subnetId
"
```

### 3. Untagged Resources Audit

```bash
az graph query -q "
Resources
| where subscriptionId == 'sub-id'
| where isnull(tags) or array_length(tags) == 0
| where type !in (
    'microsoft.alertsmanagement/smartdetectoralertrules',
    'microsoft.portal/dashboards'
)
| summarize count() by resourceGroup, type
| order by count_ desc
"
```

### 4. Resources Without Locks

```bash
az graph query -q "
Resources
| where subscriptionId == 'sub-id'
| where resourceGroup startswith 'rg-prod-'
| join kind=leftouter (
    ResourceContainers
    | where type =~ 'microsoft.authorization/locks'
    | extend lockedResourceId = tolower(properties.scope)
) on \$left.id == \$right.lockedResourceId
| where isnull(lockedResourceId)
| project id, name, type, resourceGroup, location
"
```

### 5. Configuration Drift Detection

```bash
az graph query -q "
Resources
| where type =~ 'microsoft.compute/virtualmachines'
| where tags['ManagedBy'] == 'Terraform'
| extend 
    vmSize = properties.hardwareProfile.vmSize,
    osType = properties.storageProfile.osDisk.osType,
    imageReference = properties.storageProfile.imageReference
| project id, name, vmSize, osType, imageReference, tags
"
```

### 6. Public IP Exposure

```bash
az graph query -q "
Resources
| where type =~ 'microsoft.network/publicipaddresses'
| extend ipAddress = properties.ipAddress
| extend ipConfig = properties.ipConfiguration.id
| where isnotempty(ipAddress)
| project 
    name,
    resourceGroup,
    ipAddress,
    ipConfig,
    tags
"
```

### 7. Storage Account Security

```bash
az graph query -q "
Resources
| where type =~ 'microsoft.storage/storageaccounts'
| extend 
    httpsOnly = properties.supportsHttpsTrafficOnly,
    minTlsVersion = properties.minimumTlsVersion,
    publicAccess = properties.allowBlobPublicAccess
| project 
    name,
    resourceGroup,
    httpsOnly,
    minTlsVersion,
    publicAccess,
    tags
| where httpsOnly == false or publicAccess == true
"
```

### 8. Cost Analysis by Tag

```bash
az graph query -q "
Resources
| extend environment = tags['environment']
| extend costCenter = tags['cost-center']
| summarize resourceCount = count() by environment, costCenter, type
| order by resourceCount desc
"
```

### 9. VM Inventory with Details

```bash
az graph query -q "
Resources
| where type =~ 'microsoft.compute/virtualmachines'
| extend 
    vmSize = properties.hardwareProfile.vmSize,
    osType = properties.storageProfile.osDisk.osType,
    imagePublisher = properties.storageProfile.imageReference.publisher,
    imageOffer = properties.storageProfile.imageReference.offer,
    imageSku = properties.storageProfile.imageReference.sku
| project 
    name,
    resourceGroup,
    location,
    vmSize,
    osType,
    imagePublisher,
    imageOffer,
    imageSku,
    tags
"
```

### 10. NSG Rules Analysis

```bash
az graph query -q "
Resources
| where type =~ 'microsoft.network/networksecuritygroups'
| mvexpand rules = properties.securityRules
| extend 
    ruleName = rules.name,
    priority = rules.properties.priority,
    direction = rules.properties.direction,
    access = rules.properties.access,
    protocol = rules.properties.protocol,
    sourceAddress = rules.properties.sourceAddressPrefix,
    destAddress = rules.properties.destinationAddressPrefix,
    destPort = rules.properties.destinationPortRange
| where access == 'Allow' and direction == 'Inbound'
| where sourceAddress == '*' or sourceAddress == 'Internet'
| project 
    nsgName=name,
    resourceGroup,
    ruleName,
    priority,
    protocol,
    destPort
"
```

## Advanced Techniques

### Cross-Subscription Queries

```bash
# Query across all subscriptions you have access to
az graph query -q "
Resources
| summarize resourceCount = count() by subscriptionId, type
| join kind=leftouter (
    ResourceContainers
    | where type =~ 'microsoft.resources/subscriptions'
    | project subscriptionId, subscriptionName=name
) on subscriptionId
| project subscriptionName, type, resourceCount
| order by subscriptionName, resourceCount desc
"
```

### Time-Based Analysis

```bash
# Resources created in last 30 days
az graph query -q "
Resources
| extend createdTime = todatetime(properties.createdTime)
| where createdTime >= ago(30d)
| project name, type, resourceGroup, createdTime
| order by createdTime desc
"
```

### Policy Compliance

```bash
# Resources not compliant with policies
az graph query -q "
PolicyResources
| where type =~ 'microsoft.policyinsights/policystates'
| where properties.complianceState == 'NonCompliant'
| extend 
    policyName = properties.policyDefinitionName,
    resourceId = properties.resourceId
| project policyName, resourceId, properties.complianceState
| summarize nonCompliantCount = count() by policyName
| order by nonCompliantCount desc
"
```

## Output Formats

```bash
# Table format (human-readable)
az graph query -q "..." --output table

# JSON format (for parsing)
az graph query -q "..." --output json

# JSONC format (JSON with comments)
az graph query -q "..." --output jsonc

# TSV format (tab-separated)
az graph query -q "..." --output tsv
```

## Export Large Results

```bash
# For queries returning >1000 rows, use pagination
az graph query -q "Resources | project id, name, type" \
  --first 1000 \
  --output json > page1.json

# Use --skip-token for subsequent pages (returned in response)
```

## Best Practices

1. **Filter Early**: Apply `where` clauses as early as possible to reduce data processed
2. **Use Indexes**: Filter on indexed fields (type, location, resourceGroup)
3. **Limit Columns**: Use `project` to select only needed columns
4. **Handle Nulls**: Use `isnull()` or `isempty()` to handle missing data
5. **Test Queries**: Start with small scopes, then expand to full org
6. **Cache Results**: For large queries, export results and cache locally

## Troubleshooting

### Query Too Complex
```bash
# Error: Query exceeded resource limits
# Solution: Add filters to reduce scope
| where resourceGroup startswith 'rg-prod-'
| where location == 'eastus'
```

### Missing Permissions
```bash
# Ensure you have Reader role at appropriate scope
az role assignment list --assignee user@example.com
```

### Empty Results
```bash
# Verify subscription access
az account show

# Check if resources exist
az resource list --output table
```

## Integration with Terraform

```bash
# Export Resource Graph results for import planning
az graph query -q "
Resources
| where resourceGroup == 'rg-prod-app'
| project id, name, type
" --output json > resources_to_import.json

# Parse with jq for Terraform import commands
cat resources_to_import.json | jq -r '.data[] | 
  "terraform import \((.type | gsub("microsoft."; "azurerm_") | gsub("/"; "_")).\(.name | gsub("-"; "_")) \(.id)"'
```

## References

- [Azure Resource Graph Documentation](https://docs.microsoft.com/azure/governance/resource-graph/)
- [KQL Quick Reference](https://docs.microsoft.com/azure/data-explorer/kql-quick-reference)
- [Azure CLI Reference](https://docs.microsoft.com/cli/azure/graph)
