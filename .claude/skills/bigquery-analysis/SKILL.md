---
name: bigquery-analysis
description: Analyze GCP billing data and query cost trends using BigQuery. Perform GCP billing cost analysis, analyze costs by labels/tags, detect cost anomalies, break down compute and storage costs, optimize queries, and create scheduled queries for automated reporting.
---

# BigQuery Data Analysis

**Skill Category**: Data Analytics & Cost Analysis  
**Platform**: Google Cloud Platform  
**Primary Tools**: `bq` CLI, BigQuery SQL  
**Use Cases**: Cost analysis, data warehouse queries, billing insights, resource analytics

---

## Overview

BigQuery is GCP's serverless data warehouse for analytics at scale. Use this skill to analyze GCP billing data, query cost trends, analyze resource usage, and generate insights from exported Cloud Asset Inventory data.

## Authentication

```bash
# Login to GCP
gcloud auth login
gcloud auth application-default login

# Set project
gcloud config set project PROJECT_ID

# Verify access
bq ls
```

## GCP Billing Analysis

### 1. Cost Analysis Queries

```sql
-- Total cost by project (last 30 days)
SELECT
  project.id AS project_id,
  project.name AS project_name,
  SUM(cost) AS total_cost,
  SUM(CASE WHEN cost > 0 THEN cost ELSE 0 END) AS total_charges,
  SUM(CASE WHEN cost < 0 THEN ABS(cost) ELSE 0 END) AS total_credits
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY
  project_id, project_name
ORDER BY
  total_cost DESC;

-- Cost by service (last 30 days)
SELECT
  service.description AS service,
  SUM(cost) AS total_cost,
  ROUND(SUM(cost) / (SELECT SUM(cost) 
    FROM `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID` 
    WHERE _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)) * 100, 2) AS percent_of_total
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY
  service
ORDER BY
  total_cost DESC
LIMIT 20;

-- Cost by SKU (top 20)
SELECT
  service.description AS service,
  sku.description AS sku,
  SUM(cost) AS total_cost,
  SUM(usage.amount) AS usage_amount,
  usage.unit AS usage_unit
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY
  service, sku, usage_unit
ORDER BY
  total_cost DESC
LIMIT 20;
```

### 2. Cost by Labels (Resource Tagging)

```sql
-- Cost by environment label
SELECT
  labels.value AS environment,
  SUM(cost) AS total_cost,
  COUNT(DISTINCT project.id) AS project_count
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`,
  UNNEST(labels) AS labels
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND labels.key = "environment"
GROUP BY
  environment
ORDER BY
  total_cost DESC;

-- Cost by team/cost-center
SELECT
  labels.value AS cost_center,
  SUM(cost) AS total_cost
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`,
  UNNEST(labels) AS labels
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND labels.key = "cost-center"
GROUP BY
  cost_center
ORDER BY
  total_cost DESC;

-- Untagged resources (no labels)
SELECT
  project.name AS project,
  service.description AS service,
  SUM(cost) AS total_cost
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND (labels IS NULL OR ARRAY_LENGTH(labels) = 0)
GROUP BY
  project, service
ORDER BY
  total_cost DESC
LIMIT 50;
```

### 3. Cost Anomaly Detection

```sql
-- Daily cost with 7-day moving average
WITH daily_costs AS (
  SELECT
    DATE(_PARTITIONTIME) AS date,
    project.id AS project_id,
    SUM(cost) AS daily_cost
  FROM
    `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
  WHERE
    _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 60 DAY)
  GROUP BY
    date, project_id
),
averages AS (
  SELECT
    date,
    project_id,
    daily_cost,
    AVG(daily_cost) OVER (
      PARTITION BY project_id 
      ORDER BY date 
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS avg_7day,
    STDDEV(daily_cost) OVER (
      PARTITION BY project_id 
      ORDER BY date 
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS stddev_7day
  FROM
    daily_costs
)
SELECT
  date,
  project_id,
  daily_cost,
  avg_7day,
  ROUND((daily_cost - avg_7day) / NULLIF(stddev_7day, 0), 2) AS z_score
FROM
  averages
WHERE
  date >= CURRENT_DATE() - 30
  AND ABS((daily_cost - avg_7day) / NULLIF(stddev_7day, 0)) > 2  -- More than 2 std deviations
ORDER BY
  date DESC, ABS((daily_cost - avg_7day) / NULLIF(stddev_7day, 0)) DESC;

-- Month-over-month cost growth
WITH monthly_costs AS (
  SELECT
    FORMAT_DATE('%Y-%m', DATE(_PARTITIONTIME)) AS month,
    project.id AS project_id,
    SUM(cost) AS monthly_cost
  FROM
    `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
  WHERE
    _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 6 MONTH)
  GROUP BY
    month, project_id
)
SELECT
  month,
  project_id,
  monthly_cost,
  LAG(monthly_cost) OVER (PARTITION BY project_id ORDER BY month) AS prev_month_cost,
  monthly_cost - LAG(monthly_cost) OVER (PARTITION BY project_id ORDER BY month) AS cost_change,
  ROUND((monthly_cost - LAG(monthly_cost) OVER (PARTITION BY project_id ORDER BY month)) 
    / NULLIF(LAG(monthly_cost) OVER (PARTITION BY project_id ORDER BY month), 0) * 100, 2) AS percent_change
FROM
  monthly_costs
ORDER BY
  month DESC, ABS(percent_change) DESC;
```

### 4. Compute Cost Analysis

```sql
-- Compute Engine cost breakdown
SELECT
  project.name AS project,
  sku.description AS sku,
  SUM(cost) AS total_cost,
  SUM(usage.amount) AS usage_hours,
  ROUND(SUM(cost) / NULLIF(SUM(usage.amount), 0), 4) AS cost_per_hour
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND service.description = "Compute Engine"
  AND sku.description LIKE "%Instance%"
GROUP BY
  project, sku
ORDER BY
  total_cost DESC;

-- GKE cluster costs
SELECT
  project.name AS project,
  labels.value AS cluster_name,
  SUM(cost) AS total_cost
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`,
  UNNEST(labels) AS labels
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND service.description IN ("Kubernetes Engine", "Compute Engine")
  AND labels.key = "goog-gke-cluster"
GROUP BY
  project, cluster_name
ORDER BY
  total_cost DESC;
```

### 5. Storage Cost Analysis

```sql
-- Cloud Storage costs by bucket
SELECT
  project.name AS project,
  resource.name AS resource,
  SUM(cost) AS total_cost,
  SUM(usage.amount) AS usage_gb_months
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND service.description = "Cloud Storage"
GROUP BY
  project, resource
ORDER BY
  total_cost DESC;

-- BigQuery storage and query costs
SELECT
  project.name AS project,
  CASE 
    WHEN sku.description LIKE "%Storage%" THEN "Storage"
    WHEN sku.description LIKE "%Analysis%" OR sku.description LIKE "%Queries%" THEN "Query"
    ELSE "Other"
  END AS cost_type,
  SUM(cost) AS total_cost,
  SUM(usage.amount) AS usage_amount,
  usage.unit AS usage_unit
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND service.description = "BigQuery"
GROUP BY
  project, cost_type, usage_unit
ORDER BY
  project, total_cost DESC;
```

## Running Queries

### Using bq CLI

```bash
# Run query and output to table
bq query --use_legacy_sql=false '
SELECT
  project.id,
  SUM(cost) as total_cost
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY project.id
ORDER BY total_cost DESC
'

# Run query and save to CSV
bq query --use_legacy_sql=false --format=csv '...' > results.csv

# Run query and save to new table
bq query --use_legacy_sql=false \
  --destination_table=PROJECT_ID:analysis.cost_by_project \
  --replace \
  'SELECT ...'

# Run query from file
bq query --use_legacy_sql=false < query.sql
```

### Query Optimization

```sql
-- Use partitioning to reduce data scanned
WHERE _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)

-- Use clustering for better performance
WHERE project.id = "my-project-id"

-- Avoid SELECT *
SELECT project.id, cost, service.description

-- Use LIMIT for testing
LIMIT 1000

-- Use approximate aggregations for large datasets
APPROX_COUNT_DISTINCT(user_id)
APPROX_QUANTILES(cost, 100)[OFFSET(50)] AS median_cost
```

## Cost Analysis Dashboards

### Monthly Cost Summary

```sql
-- Create monthly summary table
CREATE OR REPLACE TABLE `PROJECT_ID.analysis.monthly_cost_summary` AS
SELECT
  FORMAT_DATE('%Y-%m', DATE(_PARTITIONTIME)) AS month,
  project.id AS project_id,
  service.description AS service,
  SUM(cost) AS total_cost,
  SUM(usage.amount) AS usage_amount,
  MAX(usage.unit) AS usage_unit
FROM
  `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
WHERE
  _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 12 MONTH)
GROUP BY
  month, project_id, service;

-- Query the summary
SELECT * FROM `PROJECT_ID.analysis.monthly_cost_summary`
WHERE month >= FORMAT_DATE('%Y-%m', DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH))
ORDER BY month DESC, total_cost DESC;
```

## Best Practices

1. **Use Partitioning**: Always filter on `_PARTITIONTIME` to reduce data scanned
2. **Limit Date Ranges**: Query only necessary time periods
3. **Use Clustering**: Filter on `project.id`, `service.description` for better performance
4. **Avoid SELECT ***: Select only needed columns
5. **Cache Results**: Save query results to tables for reuse
6. **Monitor Costs**: BigQuery charges $6.25/TB scanned (on-demand pricing)

## Export Billing Data

```bash
# Enable billing export to BigQuery (one-time setup)
# This is done via Cloud Console or gcloud:

# 1. Create BigQuery dataset
bq mk --dataset --location=US PROJECT_ID:billing_export

# 2. Enable billing export (via Cloud Console)
# Billing > Billing export > BigQuery export
# Select dataset: PROJECT_ID:billing_export

# 3. Verify export is working
bq ls PROJECT_ID:billing_export
bq show --schema PROJECT_ID:billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID
```

## Scheduled Queries

```bash
# Create scheduled query for daily cost alerts
bq query --use_legacy_sql=false \
  --destination_table=PROJECT_ID:analysis.daily_costs \
  --replace \
  --schedule="every 24 hours" \
  --display_name="Daily Cost Analysis" \
  'SELECT
    CURRENT_DATE() AS report_date,
    project.id,
    SUM(cost) AS daily_cost
  FROM `PROJECT_ID.billing_export.gcp_billing_export_v1_BILLING_ACCOUNT_ID`
  WHERE _PARTITIONTIME = TIMESTAMP(CURRENT_DATE())
  GROUP BY project.id'
```

## References

- [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [Billing Export Schema](https://cloud.google.com/billing/docs/how-to/export-data-bigquery-tables)
- [BigQuery Pricing](https://cloud.google.com/bigquery/pricing)
- [Standard SQL Reference](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax)
