# DataTools Pro — Jira Ticket Backlog

> **Purpose:** Copy-paste ready Jira ticket definitions for systematic project setup.  
> **How to use:** Create each ticket in Jira (MBT project), assign as noted, work in order.  
> **Reference:** `docs/DECISIONS_AND_NEXT_STEPS.md` for full context.  
> **Note:** Tickets created 2026-02-22. Actual Jira keys in table below.

---

## Epic / Phase Overview

| Phase | Epic Name | Ticket Count | Must Complete Before |
|-------|-----------|--------------|----------------------|
| **0** | Waqar Onboarding | 1 | Everything else (parallel with Phase 1) |
| **1** | Infrastructure Decisions | 5 | Phase 2 |
| **2** | Infrastructure Setup | 8 | Phase 3 |
| **3** | Technical Stack Decisions | 2 | Phase 4 |
| **4** | Product Scope Discovery | 5 | MVP implementation |

---

## Phase 0: Waqar Onboarding

### MBT-1323 — Onboard Waqar: Full Project Context and Environment Setup

**Type:** Task  
**Labels:** `onboarding`, `setup`  
**Assignee:** @waqarcs11  
**Reporter:** @rmgoodm  
**Priority:** Highest  

---

**Description**

Waqar (@waqarcs11) is a code owner per CODEOWNERS but needs to get fully caught up on project context, documentation, tools, and access. This ticket is a comprehensive checklist to bring him to parity with the current state so he can work independently on the backlog.

**Current Project State (as of 2026-02):**

- **Codebase:** Monorepo with Laravel backend (empty/minimal) + React SPA (empty/minimal) + AI prompts (template only). No migrations, no API routes, no feature implementation yet. Documentation and architecture are extensive and largely complete.
- **CI/CD:** GitHub Actions workflows exist for backend, frontend, AI evals. Deploy workflows documented but infrastructure not yet provisioned.
- **Infrastructure:** Cloudways, AWS RDS, Cloudflare Pages — all planned, none provisioned.
- **Decisions:** 5 infrastructure decisions, 2 technical stack decisions, 32+ product questions — all undecided. See `docs/DECISIONS_AND_NEXT_STEPS.md`.

---

**Acceptance Criteria — Part 1: Access & Accounts**

- [ ] **GitHub:** Invited to DataToolsPro org as Owner (or equivalent). Can push, create branches, open PRs, approve PRs.
- [ ] **GitHub Environments:** Added as required reviewer on `production` environment so he can approve production deploys.
- [ ] **CODEOWNERS:** Confirm he appears in `.github/CODEOWNERS` and receives PR review requests.
- [ ] **Jira:** Has access to goodmangroup.atlassian.net. Can view and create tickets in MBT project.
- [ ] **Secret Manager:** (After MBT-SECRET decision) Added to team vault (1Password/Bitwarden). Can read all dev secrets.
- [ ] **Cloudways:** (After provisioning) Added as team member. Can view staging and production app dashboards.
- [ ] **Cloudflare:** (If needed) Can view CF Pages and zone for datatoolspro.com.
- [ ] **AWS:** (If needed) Can view RDS instances (read-only acceptable initially).

---

**Acceptance Criteria — Part 2: Documentation Read-Through**

Read these docs in order. Check off as you complete each. Estimated: 2–3 hours.

- [ ] **`README.md`** — Project overview, stack, repo structure, getting started
- [ ] **`docs/WORKFLOW.md`** — Daily dev loop, branch rules, commit format, PR rules, CI checks, release flow
- [ ] **`docs/SECRETS.md`** — Where secrets live, GitHub secrets, SSH keys, Jira MCP setup
- [ ] **`docs/ENVIRONMENTS.md`** — Local, PR Preview, Staging, Production — URLs and triggers
- [ ] **`docs/RELEASE.md`** — Full release lifecycle, hotfix process, rollback
- [ ] **`docs/architecture/README.md`** — System architecture diagram, key decisions
- [ ] **`docs/architecture/backend.md`** — Laravel patterns, service layer, open questions
- [ ] **`docs/architecture/frontend.md`** — React SPA structure, open questions
- [ ] **`docs/product/README.md`** — What DataTools Pro is, five tools, roadmap
- [ ] **`docs/DECISIONS_AND_NEXT_STEPS.md`** — All undecided items and next steps
- [ ] **`docs/JIRA_TICKET_BACKLOG.md`** — This ticket backlog (you are here)
- [ ] **`.cursor/rules/`** — Skim project-overview, product-context, data-model, jira-context, git-workflow

---

**Acceptance Criteria — Part 3: Local Development Setup**

- [ ] **Clone repo:** `git clone <repo-url> && cd DTP_SPA_POC`
- [ ] **Prerequisites installed:** PHP 8.3+, Composer, Node 20+, MySQL 8 (or SQLite for minimal dev)
- [ ] **Backend:** `composer install`, `cp .env.example .env`, `php artisan key:generate`, `php artisan migrate` (may fail if no DB — use SQLite or skip until DB provisioned)
- [ ] **Frontend:** `cd dtp && npm install`, `cp .env.example .env.local`, `npm run dev`
- [ ] **Secrets:** Pull `.env` and `dtp/.env.local` from team secret vault. Fill any missing values for local dev.
- [ ] **Verify:** Backend runs on localhost:8000, SPA on localhost:5173 (or as configured)
- [ ] **AI Evals (optional):** `npm install -g promptfoo`, copy `ai/.env` from vault, run `cd ai/evals && promptfoo eval`

---

**Acceptance Criteria — Part 4: Jira + Cursor Integration**

- [ ] **Atlassian extension OR MCP:** Install "Atlassian for VS Code/Cursor" extension, OR configure Jira MCP per `docs/SECRETS.md` → "Jira — Accessing Ticket Context"
- [ ] **Test:** Open a ticket (e.g. MBT-1) in Cursor, reference it in chat, confirm you can pull context
- [ ] **JIRA_URL:** If using MCP, ensure `.cursor/mcp.json.example` shows `https://goodmangroup.atlassian.net`

---

**Acceptance Criteria — Part 5: Workflow Verification**

- [ ] **Branch:** Create a test branch `feature/MBT-ONBOARD-waqar-setup-verify` from `main`
- [ ] **Change:** Make a trivial change (e.g. add a comment to README)
- [ ] **PR:** Open PR against `main`. Confirm PR template loads, CI runs (or skips per path filters)
- [ ] **Review:** Request review from @rmgoodm. Confirm CODEOWNERS triggers correct assignees
- [ ] **Close:** Either merge or close PR. Delete branch.

---

**Definition of Done**

- [ ] All Part 1–5 checklists completed
- [ ] Waqar can run the app locally (or documents blocker if infra not ready)
- [ ] Waqar has read core docs and can summarize project state
- [ ] Waqar confirms with @rmgoodm that he is unblocked and ready for backlog work

---

**Dependencies**

- MBT-1325 (Team Secret Manager decision) — blocks Part 1 secret vault access
- MBT-1327 (Cloudways sizing decision) — blocks Part 1 Cloudways access if not yet provisioned

**Notes for Ryan**

- Share 1Password/Bitwarden vault invite link once MBT-SECRET is decided
- Add Waqar to GitHub org and production environment reviewers before he starts
- Schedule 30-min sync after Waqar completes Part 2 to answer questions

---

## Phase 1: Infrastructure Decisions

### MBT-1324 — Decision: Jira Project Key Convention ✅ CLOSED

**Type:** Task  
**Labels:** `decision`, `infrastructure`  
**Status:** Closed — standardized on MBT-XX

---

**Description**

Repo docs and templates inconsistently used `DTP-XX` and `MBT-XX`. Decision: standardize on MBT-XX.

**Options:**

| Option | Action | Pros | Cons |
|--------|--------|------|------|
| **A** | Rename MBT → DTP in Jira | Single prefix | Requires Jira admin; irreversible |
| **B** | Create new Jira project "DTP" | Clean slate | Loses history; two boards |
| **C** | Standardize on MBT-XX in repo | No Jira changes | Inconsistent with "DTP" product name |

**Files to update after decision:** `docs/WORKFLOW.md`, `.cursor/rules/git-workflow.mdc`, `.github/pull_request_template.md`, `.github/ISSUE_TEMPLATE/*.md`, `README.md`, `docs/RELEASE.md`, `docs/JIRA_TICKET_BACKLOG.md`

---

**Acceptance Criteria**

- [ ] Decision (A, B, or C) made and documented in `docs/WORKFLOW.md`
- [ ] All repo files updated to use chosen prefix consistently
- [ ] `.cursor/rules/git-workflow.mdc` reflects chosen prefix
- [ ] Team aligned on new branch/PR format

---

### MBT-1325 — Decision: Team Secret Manager Selection

**Type:** Task  
**Labels:** `decision`, `infrastructure`  
**Blocks:** MBT-ONBOARD (Waqar vault access), local dev setup

---

**Description**

`docs/SECRETS.md` documents a 1Password vault structure. This was assumed but not confirmed. Waqar needs access to the same vault for local dev and secrets.

**Options:**

| Option | Pros | Cons |
|--------|------|------|
| **A) 1Password Teams** | Rich features, already referenced | Cost; setup |
| **B) Bitwarden Organizations** | Cheaper, open source | Migration |
| **C) AWS Secrets Manager** | Cloud-native | Poor local dev ergonomics |

---

**Acceptance Criteria**

- [ ] Tool selected
- [ ] Vault/org created and shared with @rmgoodm and @waqarcs11
- [ ] `docs/SECRETS.md` updated with correct tool name and structure
- [ ] All local dev secrets (`.env`, `dtp/.env.local`, `ai/.env`) added to vault
- [ ] Waqar can access vault and run app locally

---

### MBT-1326 — Decision: AWS RDS Database Engine

**Type:** Task  
**Labels:** `decision`, `infrastructure`  
**Blocks:** MBT-1326 (RDS engine)-STAGING, MBT-RDS-PROD

---

**Description**

Laravel supports both. Before provisioning RDS we must choose.

**Options:**

| Option | Pros | Cons |
|--------|------|------|
| **A) MySQL 8.x** | Widest Laravel/Cloudways support | Weaker JSON |
| **B) PostgreSQL 15** | Better JSON, analytics-friendly | Less Cloudways default |

---

**Acceptance Criteria**

- [ ] Engine chosen
- [ ] `DB_CONNECTION` in `.env.example` set to `mysql` or `pgsql`
- [ ] `docs/architecture/README.md` and `docs/architecture/backend.md` updated with decision

---

### MBT-1327 — Decision: Cloudways Server Sizing and Topology

**Type:** Task  
**Labels:** `decision`, `infrastructure`  
**Blocks:** MBT-CW-STAGING, MBT-CW-PROD

---

**Description**

Two Cloudways deployments planned: staging and production. Lock topology before provisioning.

**Decisions needed:**

1. Cloud provider: DigitalOcean, AWS, GCP, Vultr, or Linode (via Cloudways)?
2. Staging: 1GB or 2GB RAM?
3. Production: 2GB, 4GB, or higher?
4. Same Cloudways account for both, or separate?

---

**Acceptance Criteria**

- [ ] All four decisions made
- [ ] `docs/ENVIRONMENTS.md` updated with provider and sizing under staging and production sections

---

### MBT-1328 — Decision: Release Versioning Strategy

**Type:** Task  
**Labels:** `decision`, `infrastructure`

---

**Description**

`docs/RELEASE.md` documents both options and says "pick one and stick to it."

**Options:**

| Option | Example | Best for |
|--------|---------|----------|
| **A) Date-based** | v2026.02.23 | Simplicity |
| **B) Semver** | v1.0.0 | Industry standard, magnitude |

---

**Acceptance Criteria**

- [ ] Strategy chosen
- [ ] `docs/RELEASE.md` updated — remove "pick one" language, show only chosen format
- [ ] Deploy workflow tag prompt aligned
- [ ] Both developers aligned

---

## Phase 2: Infrastructure Setup

### MBT-1329 — Create Cloudflare Pages Project and Configure Custom Domains

**Type:** Task  
**Labels:** `setup`, `infrastructure`  
**Dependencies:** None (can run early)

---

**Description**

Set up Cloudflare Pages for the SPA with staging and production deployment channels.

**Steps:**

1. Create Pages project in CF Dashboard — connect to DataToolsPro/DTP_SPA_POC
2. Build command: `cd dtp && npm ci && npm run build`
3. Build output: `dtp/dist`
4. Production branch → main → app.datatoolspro.com
5. Staging channel → staging.datatoolspro.com
6. Add custom domains (DNS CNAME to pages.dev)
7. Update GitHub var: `CLOUDFLARE_PAGES_PROJECT`

---

**Acceptance Criteria**

- [ ] https://app.datatoolspro.com serves the SPA
- [ ] https://staging.datatoolspro.com serves the SPA (staging channel)
- [ ] Test PR generates preview URL at pr-XX.dtp-spa-poc.pages.dev
- [ ] Cloudflare WAF + Bot protection active on both domains

---

### MBT-1330 — Provision Cloudways Staging Server and Wire Deploy Pipeline

**Type:** Task  
**Labels:** `setup`, `infrastructure`  
**Blocks:** MBT-1327 (Cloudways sizing)

---

**Description**

Create staging Cloudways app, configure SSH deploy keys, populate GitHub environment secrets.

**Steps:** See `scripts/tickets.json` — Cloudways provisioning task. Generate separate SSH key for staging. Add STAGING_SSH_* secrets to GitHub.

---

**Acceptance Criteria**

- [ ] https://staging.datatoolspro.com/api/health returns 200
- [ ] deploy-staging.yml runs end-to-end green on merge to main
- [ ] No PHP errors in Cloudways logs on boot

---

### MBT-1331 — Provision Cloudways Production Server and Wire Deploy Pipeline

**Type:** Task  
**Labels:** `setup`, `infrastructure`  
**Blocks:** MBT-1327 (Cloudways sizing)  
**Note:** Use separate SSH key from staging.

---

**Acceptance Criteria**

- [ ] https://app.datatoolspro.com/api/health returns 200
- [ ] Deploy production workflow runs (with approval gate)
- [ ] Staging and production use separate SSH keys

---

### MBT-1332 — Provision AWS RDS Staging Database

**Type:** Task  
**Labels:** `setup`, `infrastructure`  
**Blocks:** MBT-1326 (RDS engine)

---

**Description**

Create RDS instance (engine from MBT-RDS), security group (Cloudways staging IP only), staging DB + user.

---

**Acceptance Criteria**

- [ ] Laravel staging app connects to RDS
- [ ] `php artisan migrate:status` shows all Ran
- [ ] Security group blocks public access (not 0.0.0.0/0)
- [ ] Credentials in team vault

---

### MBT-1333 — Provision AWS RDS Production Database

**Type:** Task  
**Labels:** `setup`, `infrastructure`  
**Blocks:** MBT-1326 (RDS engine)

---

**Description**

Production RDS with automated backups (7-day retention), Multi-AZ if budget allows.

---

**Acceptance Criteria**

- [ ] Laravel production connects
- [ ] Automated backups confirmed in AWS console
- [ ] Security group restricts to Cloudways production IP
- [ ] Credentials in team vault

---

### MBT-1334 — Populate All GitHub Actions Secrets and Variables

**Type:** Task  
**Labels:** `setup`, `infrastructure`  
**Blocks:** MBT-CF, MBT-CW-STAGING, MBT-CW-PROD (partial)

---

**Description**

Workflows reference specific secrets. Populate per `docs/SECRETS.md`.

**Repo-level:** CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_ZONE_ID, OPENAI_API_KEY, ANTHROPIC_API_KEY  
**Variable:** CLOUDFLARE_PAGES_PROJECT  
**Env-specific:** STAGING_SSH_*, PRODUCTION_SSH_* (from Cloudways tasks)

---

**Acceptance Criteria**

- [ ] All secret names populated (values hidden)
- [ ] ci-frontend.yml runs green on dtp/ PR
- [ ] ci-backend.yml runs green on app/ PR
- [ ] deploy-staging.yml runs green on push to main

---

### MBT-1335 — Configure Jira MCP for Both Developers

**Type:** Task  
**Labels:** `setup`, `tooling`  
**Blocks:** MBT-1324 (Jira key, for JIRA_URL)

---

**Description**

Each developer sets up Atlassian MCP or extension so Cursor AI can read Jira tickets.

**Steps:** Per developer — API token, .cursor/mcp.json, JIRA_URL = https://goodmangroup.atlassian.net

---

**Acceptance Criteria**

- [ ] Ryan: MCP or extension working
- [ ] Waqar: MCP or extension working (after onboarding)
- [ ] .cursor/mcp.json.example has correct JIRA_URL

---

### MBT-1336 — Onboard Waqar as Co-Owner (Access Only)

**Type:** Task  
**Labels:** `setup`, `onboarding`  
**Blocks:** MBT-1325 (Secret manager)  
**Note:** For access steps only. Full onboarding is MBT-ONBOARD.

---

**Description**

Grant Waqar access to all systems. Full context/setup is in MBT-ONBOARD.

**Steps:** GitHub org invite, production env reviewer, Cloudways team member, Jira access, secret vault invite.

---

**Acceptance Criteria**

- [ ] Waqar can open PR, get CODEOWNERS review request
- [ ] Waqar can approve production deploy
- [ ] Waqar has vault access and can run app locally

---

## Phase 3: Technical Stack Decisions

### MBT-1337 — Decision: Backend Technical Stack (Queue, Storage, API Versioning)

**Type:** Task  
**Labels:** `decision`, `technical`  
**Blocks:** Implementation

---

**Description**

Resolve open items in `docs/architecture/backend.md`:

1. API versioning: Confirm `/api/v1/` prefix
2. Queue driver: Redis, SQS, or database (for Salesforce sync, Metrics Analyst)
3. File storage: S3 bucket, FILESYSTEM_DISK env var (CSV imports/exports)

---

**Acceptance Criteria**

- [ ] All three decided
- [ ] `docs/architecture/backend.md` updated
- [ ] Config files updated (queue.php, filesystems.php) with placeholders or implementation

---

### MBT-1338 — Decision: Frontend Technical Stack (State, HTTP, Styling, Forms)

**Type:** Task  
**Labels:** `decision`, `technical`  
**Blocks:** SPA implementation

---

**Description**

Resolve open items in `docs/architecture/frontend.md`:

1. State: TanStack Query + Zustand (or alternative)
2. HTTP client: Axios vs fetch
3. Styling: Tailwind vs CSS Modules
4. Forms: React Hook Form vs Formik
5. Storybook: Yes/no
6. Error boundary strategy
7. Loading/skeleton conventions

---

**Acceptance Criteria**

- [ ] All items decided
- [ ] `docs/architecture/frontend.md` and `frontend-conventions.mdc` updated
- [ ] dtp/package.json has chosen deps, base scaffold if needed

---

## Phase 4: Product Scope Discovery

These can be tackled as epics or discovery tasks before/during MVP build. Grouped by tool.

### MBT-1339 — Decision: Salesforce Sync Strategy (Product-Wide)

**Type:** Task  
**Labels:** `decision`, `product`  
**Blocks:** All five tools

---

**Description**

`docs/product/README.md`: "Field/object data refreshes on demand or on a schedule (TBD)". This affects Data Dictionary, ERD, Report Management, Metrics Analyst.

**Options:** On-demand only, scheduled only, or both (with config).

---

**Acceptance Criteria**

- [ ] Strategy chosen
- [ ] `docs/product/README.md` updated
- [ ] Tool-specific docs updated (Data Dictionary, Report Management) where they reference sync

---

### MBT-1340 — Discovery: Metrics Glossary Open Questions

**Type:** Task  
**Labels:** `discovery`, `product`  
**Scope:** 6 questions in `docs/product/tools/metrics-glossary.md`

---

**Description**

Resolve or document decisions for: Metrics Analyst tier, API webhooks, version history, approval workflow, Tableau/GA sync model, Notion/Coda update granularity.

---

**Acceptance Criteria**

- [ ] Each question has a decision or "deferred to Phase X" with ticket ref
- [ ] `docs/product/tools/metrics-glossary.md` Open Questions section updated

---

### MBT-1341 — Discovery: ERD Tool Open Questions

**Type:** Task  
**Labels:** `discovery`, `product`  
**Scope:** 5 questions in `docs/product/tools/erd.md`

---

**Acceptance Criteria**

- [ ] Layout (per-user vs org), annotations, deleted objects, custom relationships, size limits — decided or deferred
- [ ] `docs/product/tools/erd.md` updated

---

### MBT-1342 — Discovery: Data Dictionary Open Questions

**Type:** Task  
**Labels:** `discovery`, `product`  
**Scope:** 4 questions in `docs/product/tools/data-dictionary.md`

---

**Acceptance Criteria**

- [ ] Sync frequency, custom fields, impact notifications, edit permissions — decided or deferred
- [ ] `docs/product/tools/data-dictionary.md` updated

---

### MBT-1343 — Discovery: Data Migration + Report Management Open Questions

**Type:** Task  
**Labels:** `discovery`, `product`  
**Scope:** 12 questions across `data-migration.md` and `report-management.md`

---

**Acceptance Criteria**

- [ ] SQL dialects, bulk import, version history, sign-off workflow, sync triggers, bulk actions, etc. — decided or deferred
- [ ] Both tool docs updated

---

## Ticket Dependency Diagram

```
Phase 0 (parallel):
  MBT-1323 (Onboard Waqar) ←── MBT-1325, MBT-1336

Phase 1 (decisions, can parallelize):
  MBT-1324, MBT-1325, MBT-1326, MBT-1327, MBT-1328

Phase 2 (after Phase 1):
  MBT-1329 (no deps)
  MBT-1330, MBT-1331 ← MBT-1327
  MBT-1332, MBT-1333 ← MBT-1326
  MBT-1334 ← CF, Cloudways
  MBT-1335 ← MBT-1324
  MBT-1336 ← MBT-1325

Phase 3 (after Phase 2):
  MBT-1337, MBT-1338

Phase 4 (can overlap Phase 3):
  MBT-1339, MBT-1340, MBT-1341, MBT-1342, MBT-1343
```

---

## Summary: Ticket Count by Type

| Type | Count |
|------|-------|
| Onboarding | 2 (MBT-ONBOARD, MBT-WAQAR) |
| Decision | 7 |
| Setup | 8 |
| Discovery | 5 |
| **Total** | **22** |

---

## Creating These Tickets in Jira

1. **Manual:** Copy each ticket block into Jira → Create issue → paste Summary, Description, AC.
2. **MCP:** If Atlassian MCP supports create, use it with the structured content above.
3. **Bulk:** Jira CSV import or API — extract structured data from this doc if needed.

**Suggested Jira Structure:**

- **Epic:** "DTP Infrastructure & Setup" — link Phase 1–2 tickets
- **Epic:** "Technical Stack" — link Phase 3 tickets
- **Epic:** "Product Discovery" — link Phase 4 tickets
- **Standalone:** MBT-1323 (Waqar onboarding) — highest priority, assign to Waqar

---

*Tickets created 2026-02-22. Keys MBT-1323 through MBT-1343.*
