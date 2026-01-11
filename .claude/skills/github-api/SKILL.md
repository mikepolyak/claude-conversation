---
name: github-api
description: Automate GitHub operations for CI/CD pipelines, PR management, and workflow monitoring. Manage repositories and branches, automate pull requests, monitor GitHub Actions workflows, analyze security and Dependabot alerts, manage team permissions, and use GraphQL for complex queries.
---

# GitHub API Queries

**Skill Category**: CI/CD & Repository Management  
**Platform**: GitHub  
**Primary Tools**: GitHub REST API, `gh` CLI, GraphQL API  
**Use Cases**: Repository management, PR automation, workflow monitoring, security scanning

---

## Overview

GitHub provides comprehensive APIs for managing repositories, pull requests, issues, workflows, and more. Use this skill to automate CI/CD operations, monitor workflow status, and integrate with infrastructure pipelines.

## Authentication

```bash
# Using GitHub CLI (recommended)
gh auth login

# Using Personal Access Token
export GITHUB_TOKEN="your-personal-access-token"

# Verify access
gh auth status

# Or with API
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user
```

## Repository Management

### 1. Repository Information

```bash
# Get repository details
gh repo view OWNER/REPO --json name,description,defaultBranchRef,isPrivate

# List all repositories for organization
gh repo list ORG --limit 100 --json name,pushedAt,visibility

# Get repository topics/tags
gh api repos/OWNER/REPO/topics \
  --jq '.names[]'

# Get repository languages
gh api repos/OWNER/REPO/languages \
  --jq 'to_entries | .[] | "\(.key): \(.value)"'

# Get repository collaborators
gh api repos/OWNER/REPO/collaborators \
  --jq '.[] | {login: .login, permissions: .permissions}'
```

### 2. Branch Management

```bash
# List branches
gh api repos/OWNER/REPO/branches \
  --jq '.[] | {name: .name, protected: .protected}'

# Get branch protection rules
gh api repos/OWNER/REPO/branches/main/protection

# Get default branch
gh api repos/OWNER/REPO \
  --jq '.default_branch'

# List branch protection rules
gh api repos/OWNER/REPO/branches \
  --jq '.[] | select(.protected == true) | {name: .name, protected: .protected}'
```

## Pull Request Automation

### 1. PR Queries

```bash
# List open pull requests
gh pr list --repo OWNER/REPO --state open --json number,title,author,createdAt

# Get PR details
gh pr view PR_NUMBER --repo OWNER/REPO --json title,body,state,reviews,checks

# List PRs by author
gh pr list --repo OWNER/REPO --author USERNAME --json number,title,state

# List PRs with specific label
gh pr list --repo OWNER/REPO --label "terraform" --json number,title

# Get PR diff
gh pr diff PR_NUMBER --repo OWNER/REPO

# Get PR changed files
gh api repos/OWNER/REPO/pulls/PR_NUMBER/files \
  --jq '.[] | {filename: .filename, status: .status, additions: .additions, deletions: .deletions}'
```

### 2. PR Status & Checks

```bash
# Get PR check runs
gh api repos/OWNER/REPO/commits/COMMIT_SHA/check-runs \
  --jq '.check_runs[] | {name: .name, status: .status, conclusion: .conclusion}'

# Get PR reviews
gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews \
  --jq '.[] | {user: .user.login, state: .state, submitted_at: .submitted_at}'

# Get PR review comments
gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments \
  --jq '.[] | {user: .user.login, body: .body, path: .path, line: .line}'

# Check if PR is mergeable
gh api repos/OWNER/REPO/pulls/PR_NUMBER \
  --jq '{mergeable: .mergeable, mergeable_state: .mergeable_state}'
```

### 3. PR Operations

```bash
# Create PR
gh pr create \
  --title "Infrastructure updates" \
  --body "Terraform changes for production" \
  --base main \
  --head feature-branch

# Merge PR
gh pr merge PR_NUMBER --squash --delete-branch

# Add reviewers to PR
gh pr edit PR_NUMBER --add-reviewer user1,user2

# Add labels to PR
gh pr edit PR_NUMBER --add-label "terraform,infrastructure"

# Comment on PR
gh pr comment PR_NUMBER --body "LGTM! Approved."

# Request changes
gh pr review PR_NUMBER --request-changes --body "Please fix the issues"
```

## GitHub Actions Workflows

### 1. Workflow Runs

```bash
# List workflow runs
gh run list --repo OWNER/REPO --limit 20 --json databaseId,status,conclusion,createdAt,headBranch

# Get specific workflow run
gh run view RUN_ID --repo OWNER/REPO --json status,conclusion,jobs

# List jobs in a run
gh api repos/OWNER/REPO/actions/runs/RUN_ID/jobs \
  --jq '.jobs[] | {name: .name, status: .status, conclusion: .conclusion}'

# Download workflow logs
gh run download RUN_ID --repo OWNER/REPO

# Get workflow run logs
gh run view RUN_ID --log --repo OWNER/REPO

# Re-run failed workflow
gh run rerun RUN_ID --repo OWNER/REPO
```

### 2. Workflow Status

```bash
# Check if workflows are passing for branch
gh api repos/OWNER/REPO/commits/BRANCH_NAME/check-runs \
  --jq '.check_runs[] | {name: .name, status: .status, conclusion: .conclusion}'

# Get workflow file
gh api repos/OWNER/REPO/contents/.github/workflows/terraform.yml \
  --jq '.content' | base64 -d

# List all workflows
gh api repos/OWNER/REPO/actions/workflows \
  --jq '.workflows[] | {name: .name, path: .path, state: .state}'

# Trigger workflow dispatch
gh workflow run terraform-plan.yml \
  --repo OWNER/REPO \
  --ref main \
  -f environment=production
```

## Security & Dependabot

### 1. Security Alerts

```bash
# List security advisories
gh api repos/OWNER/REPO/vulnerability-alerts

# List Dependabot alerts
gh api repos/OWNER/REPO/dependabot/alerts \
  --jq '.[] | {package: .dependency.package.name, severity: .security_advisory.severity, state: .state}'

# Get Code Scanning alerts
gh api repos/OWNER/REPO/code-scanning/alerts \
  --jq '.[] | {rule: .rule.id, severity: .rule.security_severity_level, state: .state, location: .most_recent_instance.location}'

# Get Secret Scanning alerts
gh api repos/OWNER/REPO/secret-scanning/alerts \
  --jq '.[] | {secret_type: .secret_type, state: .state, created_at: .created_at}'
```

### 2. Dependency Management

```bash
# Get dependency graph
gh api repos/OWNER/REPO/dependency-graph/dependencies

# Get vulnerable dependencies
gh api repos/OWNER/REPO/dependabot/alerts \
  --jq '.[] | select(.state == "open") | {
    package: .dependency.package.name,
    current_version: .dependency.manifest_path,
    severity: .security_advisory.severity
  }'
```

## Repository Analytics

### 1. Commit Activity

```bash
# Get commit activity
gh api repos/OWNER/REPO/stats/commit_activity \
  --jq '.[] | {week: .week, total: .total}'

# List recent commits
gh api repos/OWNER/REPO/commits \
  --jq '.[] | {sha: .sha, author: .commit.author.name, message: .commit.message, date: .commit.author.date}' \
  | head -n 10

# Get commit details
gh api repos/OWNER/REPO/commits/COMMIT_SHA \
  --jq '{author: .commit.author, files_changed: .files | length, additions: .stats.additions, deletions: .stats.deletions}'
```

### 2. Code Frequency

```bash
# Get code frequency (additions/deletions per week)
gh api repos/OWNER/REPO/stats/code_frequency \
  --jq '.[] | {week: .[0], additions: .[1], deletions: .[2]}'

# Get contributor statistics
gh api repos/OWNER/REPO/stats/contributors \
  --jq '.[] | {author: .author.login, total_commits: .total, weeks: .weeks | length}'
```

## Team & Access Management

### 1. Organization Teams

```bash
# List organization teams
gh api orgs/ORG/teams \
  --jq '.[] | {name: .name, slug: .slug, privacy: .privacy}'

# Get team members
gh api orgs/ORG/teams/TEAM_SLUG/members \
  --jq '.[] | {login: .login, type: .type}'

# List team repositories
gh api orgs/ORG/teams/TEAM_SLUG/repos \
  --jq '.[] | {name: .name, permissions: .permissions}'
```

### 2. Repository Permissions

```bash
# Get repository permissions for user
gh api repos/OWNER/REPO/collaborators/USERNAME/permission \
  --jq '.permission'

# List repository collaborators
gh api repos/OWNER/REPO/collaborators \
  --jq '.[] | {login: .login, permissions: .permissions}'
```

## GraphQL API Queries

```bash
# Get PR with reviews and checks
gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $number) {
        title
        state
        reviews(first: 10) {
          nodes {
            author { login }
            state
          }
        }
        commits(last: 1) {
          nodes {
            commit {
              statusCheckRollup {
                state
                contexts(first: 100) {
                  nodes {
                    ... on CheckRun {
                      name
                      conclusion
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
' -f owner=OWNER -f repo=REPO -F number=123
```

## Automation Examples

### Monitor Terraform PR Status

```bash
#!/bin/bash
# Check if Terraform plan passed for PR

PR_NUMBER=$1
REPO="org/infrastructure"

# Get check runs for PR
CHECKS=$(gh api repos/$REPO/commits/$(gh pr view $PR_NUMBER --json headRefOid -q '.headRefOid')/check-runs \
  --jq '.check_runs[] | select(.name | contains("terraform")) | {name: .name, conclusion: .conclusion}')

echo "$CHECKS" | jq -r 'select(.conclusion != "success") | "❌ \(.name): \(.conclusion)"'

if echo "$CHECKS" | jq -e 'all(.conclusion == "success")' > /dev/null; then
  echo "✅ All Terraform checks passed"
  exit 0
else
  echo "❌ Some Terraform checks failed"
  exit 1
fi
```

### Auto-label PRs based on changed files

```bash
#!/bin/bash
# Auto-label PRs that modify Terraform files

PR_NUMBER=$1
REPO="org/infrastructure"

FILES=$(gh api repos/$REPO/pulls/$PR_NUMBER/files --jq '.[].filename')

if echo "$FILES" | grep -q '\.tf$'; then
  gh pr edit $PR_NUMBER --add-label "terraform"
  echo "Added 'terraform' label"
fi

if echo "$FILES" | grep -q '^modules/'; then
  gh pr edit $PR_NUMBER --add-label "modules"
  echo "Added 'modules' label"
fi
```

## Best Practices

1. **Use Personal Access Tokens (PAT)** with minimal scopes required
2. **Implement Rate Limiting**: GitHub API has rate limits (5000 req/hour authenticated)
3. **Use GraphQL for Complex Queries**: More efficient than multiple REST calls
4. **Cache Results**: Avoid redundant API calls
5. **Use Webhooks**: For real-time notifications instead of polling
6. **Handle Pagination**: Many endpoints paginate results

## Rate Limits

```bash
# Check rate limit status
gh api rate_limit --jq '{
  limit: .rate.limit,
  remaining: .rate.remaining,
  reset: .rate.reset | strftime("%Y-%m-%d %H:%M:%S")
}'

# Check rate limit in response headers
curl -I -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user \
  | grep -i "x-ratelimit"
```

## Error Handling

```bash
# Check HTTP status and handle errors
RESPONSE=$(gh api repos/OWNER/REPO --include 2>&1)
HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP/" | awk '{print $2}')

if [ "$HTTP_CODE" != "200" ]; then
  echo "Error: HTTP $HTTP_CODE"
  echo "$RESPONSE" | jq '.message'
  exit 1
fi
```

## References

- [GitHub REST API Documentation](https://docs.github.com/en/rest)
- [GitHub GraphQL API Documentation](https://docs.github.com/en/graphql)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub Actions API](https://docs.github.com/en/rest/actions)
