# Secrets & Configuration Management

This document is the single source of truth for every secret and configuration variable this project uses, where it lives, and who manages it.

---

## The Three Tiers

```
┌─────────────────────────────────────────────────────────────────┐
│  TIER 1 — Local Dev                                             │
│  Your machine only. Never leaves your laptop.                   │
│  Source: 1Password vault "DTP_APP_V3 — Dev Secrets"           │
│  File: .env  (gitignored)                                       │
├─────────────────────────────────────────────────────────────────┤
│  TIER 2 — CI/CD (GitHub Actions)                                │
│  Encrypted by GitHub. Injected into workflow runs.              │
│  Managed at: GitHub → Settings → Secrets and variables         │
│  Never visible after entry.                                     │
├─────────────────────────────────────────────────────────────────┤
│  TIER 3 — Server Environment                                    │
│  Lives on the Cloudways app server as .env                      │
│  Set once during server provisioning.                           │
│  Backed up in 1Password vault.                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Rule #1

> **.env.example is the MAP. .env is the VALUES.**
>
> `.env.example` → always committed, always up to date, no real values
> `.env` → never committed, lives in 1Password + on the server

---

## GitHub Repository Secrets

**Location:** GitHub → DTP_APP_V3 → Settings → Secrets and variables → Actions

These are available to ALL GitHub Actions workflows across all environments.

| Secret Name | What It Is | How to Get It |
|---|---|---|
| `OPENAI_API_KEY` | OpenAI API key for AI eval CI runs | platform.openai.com → API Keys |
| `ANTHROPIC_API_KEY` | Anthropic API key for AI eval CI runs | console.anthropic.com → API Keys |
| `CLOUDFLARE_API_TOKEN` | Token used to deploy to Cloudflare Pages + purge cache | CF Dashboard → My Profile → API Tokens → Create Token (use "Edit Cloudflare Workers" template, add Pages permissions) |
| `CLOUDFLARE_ACCOUNT_ID` | Your Cloudflare account identifier | CF Dashboard → any domain → right sidebar |
| `CLOUDFLARE_ZONE_ID` | Zone ID for your domain | CF Dashboard → your domain → right sidebar |

> These are repo-level secrets — available in staging AND production workflows.

---

## GitHub Environment Secrets

**Location:** GitHub → DTP_APP_V3 → Settings → Environments → [staging or production] → Secrets

These are scoped per environment and only injected when that environment is being deployed.

### Staging Environment Secrets

| Secret Name | What It Is | How to Get It |
|---|---|---|
| `STAGING_SSH_HOST` | Cloudways staging server IP | Cloudways → App → SSH/SFTP tab |
| `STAGING_SSH_USER` | SSH username | Cloudways → App → SSH/SFTP tab |
| `STAGING_SSH_PORT` | SSH port (usually 22) | Cloudways → App → SSH/SFTP tab |
| `STAGING_SSH_KEY` | Private SSH key (entire PEM contents) | Generated locally — see SSH Key Setup below |
| `STAGING_APP_PATH` | App root on server | e.g. `/home/master/applications/xxxxx/public_html` |

### Production Environment Secrets

| Secret Name | What It Is | How to Get It |
|---|---|---|
| `PRODUCTION_SSH_HOST` | Cloudways production server IP | Cloudways → App → SSH/SFTP tab |
| `PRODUCTION_SSH_USER` | SSH username | Cloudways → App → SSH/SFTP tab |
| `PRODUCTION_SSH_PORT` | SSH port (usually 22) | Cloudways → App → SSH/SFTP tab |
| `PRODUCTION_SSH_KEY` | Private SSH key (entire PEM contents) | Generated locally — see SSH Key Setup below |
| `PRODUCTION_APP_PATH` | App root on server | e.g. `/home/master/applications/xxxxx/public_html` |

---

## GitHub Environment Variables (Non-Secret Config)

**Location:** GitHub → DTP_APP_V3 → Settings → Environments → [env] → Variables

| Variable Name | Staging Value | Production Value |
|---|---|---|
| `APP_URL` | `https://staging.datatoolspro.com` | `https://app.datatoolspro.com` |
| `API_URL` | `https://staging.datatoolspro.com/api` | `https://app.datatoolspro.com/api` |
| `VITE_API_URL` | `https://staging.datatoolspro.com/api` | `https://app.datatoolspro.com/api` |
| `CF_PAGES_BRANCH` | `staging` | `main` (or `production`) |

---

## Repository Variables (Non-Secret, Shared)

**Location:** GitHub → Settings → Secrets and variables → Actions → Variables tab

| Variable Name | Value |
|---|---|
| `CLOUDFLARE_PAGES_PROJECT` | `dtp-spa-poc` (your CF Pages project name) |

---

## SSH Key Setup for Cloudways Deploy

GitHub Actions deploys to Cloudways via SSH. You need to generate a dedicated deploy key and register it on the Cloudways server.

### One-Time Setup (per environment)

```bash
# 1. Generate a deploy key (no passphrase)
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/dtp_deploy_staging

# This creates two files:
#   ~/.ssh/dtp_deploy_staging       (PRIVATE — goes in GitHub Secret)
#   ~/.ssh/dtp_deploy_staging.pub   (PUBLIC — goes on Cloudways server)

# 2. Copy the PUBLIC key
cat ~/.ssh/dtp_deploy_staging.pub

# 3. Add public key to Cloudways:
#    Cloudways Dashboard → SSH Key Management → Add SSH Key → paste public key

# 4. Add PRIVATE key to GitHub Secret:
#    Copy full contents of dtp_deploy_staging
#    GitHub → Settings → Environments → staging → Secrets → STAGING_SSH_KEY

# 5. Repeat for production with a separate key pair
```

> Use **separate keys** for staging and production. If staging is compromised, production stays safe.

---

## Jira — Accessing Ticket Context (Two Options)

Both options work. Choose the one that fits your setup.

---

### Option A: Atlassian Extension (Recommended Starting Point)

The **Atlassian for VS Code/Cursor** extension is the zero-config path — no secrets needed.

1. Open the Extensions panel in Cursor
2. Search **"Atlassian"** → install the official extension
3. Click **Login with OAuth** or **Login with API Token**
4. Authenticate with your Atlassian account
5. Done — hover over `MBT-XX` anywhere in code to see the issue inline

**To give the AI ticket context:** open the ticket in the sidebar → copy the AC → paste into chat.

> No secrets to manage. Each developer authenticates through the extension UI directly.

---

### Option B: MCP Server (AI Auto-Fetch — Optional Upgrade)

The MCP server lets the Cursor AI fetch Jira tickets **automatically** without copy/pasting.
Use this when you want zero-friction AI context — just reference `MBT-42` in chat and I pull the full story.

Each developer sets this up **locally only** — the token is personal and never committed.

#### One-Time Setup Per Developer

1. **Generate your Atlassian API token**
   → https://id.atlassian.com/manage-api-tokens → Create API token → name it `cursor-mcp`

2. **Copy the MCP config template**
   ```bash
   cp .cursor/mcp.json.example .cursor/mcp.json
   ```

3. **Fill in your values in `.cursor/mcp.json`**
   ```json
   {
     "mcpServers": {
       "atlassian": {
         "env": {
           "JIRA_URL": "https://YOUR_ORG.atlassian.net",
           "JIRA_USERNAME": "your@email.com",
           "JIRA_API_TOKEN": "your-token-here"
         }
       }
     }
   }
   ```

4. **Restart Cursor** → the Atlassian MCP server will appear in the AI tools panel.

> `.cursor/mcp.json` is gitignored. The example file (`.cursor/mcp.json.example`) is the committed reference.

| Secret | Where It Lives | Who Manages It |
|---|---|---|
| `JIRA_API_TOKEN` | Your personal `.cursor/mcp.json` only | Each developer |
| `JIRA_URL` | Shared in `.cursor/mcp.json.example` | @rmgoodm |

---

## 1Password Vault Structure

**Vault name:** `DTP_APP_V3 — Dev Secrets`

Suggested organization:

```
DTP_APP_V3 — Dev Secrets/
├── 🔑 .env — Local Development
│     (complete .env file contents for local dev)
│
├── 🔑 spa/.env.local — SPA Local Development
│     (complete spa/.env.local contents)
│
├── 🔑 GitHub Actions Secrets — Repo Level
│     OPENAI_API_KEY
│     ANTHROPIC_API_KEY
│     CLOUDFLARE_API_TOKEN
│     CLOUDFLARE_ACCOUNT_ID
│     CLOUDFLARE_ZONE_ID
│
├── 🔑 GitHub Actions Secrets — Staging
│     STAGING_SSH_HOST
│     STAGING_SSH_USER
│     STAGING_SSH_KEY (full PEM)
│     STAGING_APP_PATH
│
├── 🔑 GitHub Actions Secrets — Production
│     PRODUCTION_SSH_HOST
│     PRODUCTION_SSH_USER
│     PRODUCTION_SSH_KEY (full PEM)
│     PRODUCTION_APP_PATH
│
├── 🔑 AWS RDS — Staging
│     DB_HOST, DB_NAME, DB_USERNAME, DB_PASSWORD
│
├── 🔑 AWS RDS — Production
│     DB_HOST, DB_NAME, DB_USERNAME, DB_PASSWORD
│
└── 🔑 Jira MCP (per developer — each dev's personal entry)
      JIRA_URL, JIRA_USERNAME, JIRA_API_TOKEN
```

---

## Adding a New Secret

When you add a new environment variable to the codebase:

1. **Add it to `.env.example`** with an empty value and a comment (this is the contract)
2. **Add the real value** to the 1Password vault under the correct section
3. **If CI needs it**: add to GitHub Secrets/Variables (Settings → Secrets → Actions)
4. **If it's environment-specific**: add to the correct GitHub Environment (staging / production)
5. **Notify `@waqarcs11`** that a new secret needs to be pulled from the vault

> Treat `.env.example` updates like code changes — they should be in the PR that introduces the new variable.

---

## Security Reminders

- ❌ Never log secrets — check middleware for accidental request logging
- ❌ Never put secrets in PR descriptions, commit messages, or comments
- ❌ Never share secrets over Slack/email — use 1Password vault sharing
- ✅ Rotate keys if a developer leaves the team
- ✅ Use scoped API tokens (e.g. Cloudflare token scoped to one zone only)
- ✅ Audit GitHub Actions workflow changes carefully — they have access to all secrets
