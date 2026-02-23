# Scripts Directory

Utility scripts for DTP_APP_V3 project setup and maintenance.

## create-jira-tickets.ps1

Creates all 13 Jira tickets (5 decision tasks + 8 setup tasks) for the DTP_APP_V3 infrastructure setup.

### Prerequisites

1. **Get your Jira API token:**
   - Go to: https://id.atlassian.com/manage-api-tokens
   - Click "Create API token"
   - Name it (e.g., "cursor-jira-script")
   - Copy the token (you won't see it again)

2. **Know your Jira email address** (the one you use to log into `goodmangroup.atlassian.net`)

### Usage

```powershell
cd C:\code\datatoolspro\DTP_APP_V3
.\scripts\create-jira-tickets.ps1
```

The script will:
1. Prompt for your Jira email
2. Prompt for your Jira API token (hidden input)
3. Create all 13 tickets in the MBT project
4. Display the created ticket keys

### Alternative: Pass credentials as parameters

```powershell
.\scripts\create-jira-tickets.ps1 -JiraEmail "your@email.com" -JiraApiToken "your-token-here"
```

### Output

The script creates:
- **5 Decision Tasks** (labeled `decision`):
  - Decision: Jira project key convention
  - Decision: Team secret manager selection
  - Decision: AWS RDS database engine
  - Decision: Cloudways server sizing and topology
  - Decision: Versioning strategy for releases

- **8 Setup Tasks** (labeled `setup`):
  - Onboard Waqar as co-owner
  - Provision Cloudways staging server and wire deploy pipeline
  - Provision Cloudways production server and wire deploy pipeline
  - Provision AWS RDS staging database
  - Provision AWS RDS production database
  - Create Cloudflare Pages project and configure custom domains
  - Populate all GitHub Actions secrets and variables
  - Configure Jira MCP for both developers

### View Created Tickets

After running, view your tickets at:
https://goodmangroup.atlassian.net/jira/software/projects/MBT/boards/2

### Troubleshooting

**Error: "401 Unauthorized"**
- Check your email and API token are correct
- Ensure your Jira account has permission to create issues in the MBT project

**Error: "400 Bad Request" / "JSON parsing error"**
- The script uses Jira API v3 ADF format for descriptions
- If issues persist, check that the `tickets.json` file is valid JSON

**Error: "Read-Host not available"**
- Run the script in an interactive PowerShell window (not via automation)
- Or pass credentials as parameters (see Alternative usage above)
