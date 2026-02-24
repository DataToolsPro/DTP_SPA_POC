# Jira Ticket Backlog & Cursor Integration

This document describes how the project integrates with Jira and how developers set up Cursor AI to read and interact with Jira tickets.

---

## Phase 2: Per-Developer MCP Setup

Each developer configures the **Atlassian MCP** (Model Context Protocol) in Cursor so the AI assistant can read Jira tickets, search issues, and add comments directly from the IDE.

### Prerequisites

- [uv](https://docs.astral.sh/uv/) installed (provides `uvx` for running MCP servers)
- Python 3.10+ (required by `mcp-atlassian`)
- Atlassian API token ([create one](https://id.atlassian.com/manage-profile/security/api-tokens))

### Steps (Per Developer)

1. **Create a copy of the example config**

   ```bash
   cp .cursor/mcp.json.example .cursor/mcp.json
   ```

2. **Edit `.cursor/mcp.json`** and replace placeholders:
   - `JIRA_USERNAME`: Your Atlassian/Jira email (e.g. `waqar@goodmangroupllc.com`)
   - `JIRA_API_TOKEN`: Your personal API token from [id.atlassian.com](https://id.atlassian.com/manage-profile/security/api-tokens)

3. **Verify `.cursor/mcp.json` is gitignored** — it contains secrets and must not be committed.

4. **Restart Cursor** (or reload the MCP servers) so the AI picks up the new config.

### Server Identifier

When the AI invokes Jira tools, the MCP server is identified as **`user-atlassian`** (not `atlassian`). Use this identifier when configuring or referencing the Atlassian MCP in Cursor.

### Example Config (Template)

See [`.cursor/mcp.json.example`](../.cursor/mcp.json.example) for the structure:

```json
{
  "mcpServers": {
    "user-atlassian": {
      "command": "uvx",
      "args": ["mcp-atlassian"],
      "env": {
        "JIRA_URL": "https://goodmangroup.atlassian.net",
        "JIRA_USERNAME": "YOUR_EMAIL@goodmangroupllc.com",
        "JIRA_API_TOKEN": "YOUR_API_TOKEN",
        "JIRA_PROJECTS_FILTER": "MBT"
      }
    }
  }
}
```

- **JIRA_URL**: Goodman Group Jira instance
- **JIRA_PROJECTS_FILTER**: Limits results to project key `MBT` (adjust if your project key differs)

### Acceptance Criteria

- [ ] Ryan and Waqar have MCP or extension working
- [ ] `.cursor/mcp.json.example` has correct `JIRA_URL` (`https://goodmangroup.atlassian.net`)

### Troubleshooting

| Issue | Solution |
|-------|----------|
| `uvx` not found | Install uv: `pip install uv` or `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| MCP server fails to start | Ensure Python 3.10+ is available (`python3 --version`) |
| 401 Unauthorized | Regenerate API token and update `JIRA_API_TOKEN` |
| No issues returned | Check `JIRA_PROJECTS_FILTER` matches your project key |
