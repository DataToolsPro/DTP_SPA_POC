# DataTools Pro — Decisions & Next Steps

> **Purpose:** A comprehensive map of undecided items and actionable next steps to complete this repo.  
> **Last updated:** 2026-02-22  
> **Source:** Scan of all project MD files and `scripts/tickets.json`

---

## Executive Summary

| Category | Count | Blocking? |
|----------|-------|-----------|
| **Infrastructure decisions** | 5 | Yes — blocks provisioning |
| **Backend technical decisions** | 4 | Partial |
| **Frontend technical decisions** | 7 | Partial |
| **Product / tool open questions** | 32+ | Varies |
| **Setup tasks** | 8 | Yes — blocks deployment |
| **Process / naming** | 2 | Low |

---

## Part 1: Infrastructure Decisions (from `scripts/tickets.json`)

These block provisioning of servers, databases, and pipelines.

### 1.1 Jira Project Key Convention ✅ Decided (MBT-1324 closed)

**Status:** Decided — standardize on MBT-XX  
**Doc:** `docs/WORKFLOW.md`, `.cursor/rules/git-workflow.mdc`

| Option | Pros | Cons |
|--------|------|------|
| **A)** Rename MBT → DTP in Jira | Single prefix everywhere | Requires Jira admin; key rename is irreversible |
| **B)** Create new Jira project "DTP" | Clean slate | Loses ticket history; two boards |
| **C)** Standardize on MBT-XX in repo | No Jira changes | Inconsistent with "DTP" branding |

**Outcome:** Option C — standardize on MBT-XX. Repo updated.

---

### 1.2 Team Secret Manager

**Status:** Assumed 1Password, not confirmed  
**Doc:** `docs/SECRETS.md`  
**Blocking:** Waqar onboarding, local dev setup

| Option | Pros | Cons |
|--------|------|------|
| **A)** 1Password Teams | Rich feature set, already referenced | Cost; Waqar needs access |
| **B)** Bitwarden Organizations | Cheaper, open source | Migration effort |
| **C)** AWS Secrets Manager | Cloud-native | Less ergonomic for local dev |

**Action:** Select tool → create vault/org → share with @rmgoodm and @waqarcs11 → update `docs/SECRETS.md`.

---

### 1.3 AWS RDS Database Engine

**Status:** Undecided  
**Doc:** `docs/architecture/backend.md`, `docs/architecture/README.md`  
**Blocking:** RDS provisioning tasks

| Option | Pros | Cons |
|--------|------|------|
| **A)** MySQL 8.x | Widest Laravel/Cloudways support, common | Weaker JSON, less strict |
| **B)** PostgreSQL 15 | Better JSON, stronger constraints, analytics-friendly | Less Cloudways default |

**Action:** Choose engine → set `DB_CONNECTION` in `.env.example` → update `docs/architecture/README.md`.

---

### 1.4 Cloudways Server Sizing and Topology

**Status:** Undecided  
**Doc:** `docs/ENVIRONMENTS.md`  
**Blocking:** Cloudways provisioning tasks

| Decision | Options |
|----------|---------|
| Cloud provider | DigitalOcean, AWS, GCP, Vultr, Linode (via Cloudways) |
| Staging RAM | 1GB (smallest) or 2GB |
| Production RAM | 2GB, 4GB, or higher |
| Account structure | Same account for both envs, or separate? |

**Action:** Decide → document in `docs/ENVIRONMENTS.md` under staging and production.

---

### 1.5 Release Versioning Strategy

**Status:** Both options documented; "pick one" not done  
**Doc:** `docs/RELEASE.md`  
**Blocking:** First real release clarity

| Option | Example | Best for |
|--------|---------|----------|
| **A)** Date-based | `v2026.02.23` | Simplicity, no version semantics |
| **B)** Semver | `v1.0.0` | Communicates magnitude; industry standard |

**Action:** Choose → remove "pick one and stick to it" from `docs/RELEASE.md` → show only chosen format in deploy workflow.

---

## Part 2: Backend Technical Decisions

**Doc:** `docs/architecture/backend.md`

| # | Item | Options / Notes |
|---|------|-----------------|
| 1 | API versioning | Confirm `/api/v1/` prefix (likely yes) |
| 2 | Queue driver | Redis, SQS, or database — for background jobs (Salesforce sync, Metrics Analyst, etc.) |
| 3 | File storage | S3 bucket name, `FILESYSTEM_DISK` env var — for CSV imports, exports |
| 4 | RDS engine | See 1.3 — MySQL vs Postgres |

**Action:** Resolve each → update `docs/architecture/backend.md` → implement in config.

---

## Part 3: Frontend Technical Decisions

**Doc:** `docs/architecture/frontend.md`, `.cursor/rules/frontend-conventions.mdc`

| # | Item | Options | Notes |
|---|------|---------|-------|
| 1 | State management | TanStack Query (server) + Zustand (client) | Suggested in docs |
| 2 | HTTP client | Axios vs native fetch | Axios referenced in docs |
| 3 | Styling | Tailwind CSS vs CSS Modules | |
| 4 | Form library | React Hook Form vs Formik | |
| 5 | Storybook | Yes / no (optional) | Component development |
| 6 | Error boundary strategy | Define behavior for component tree failures | |
| 7 | Loading / skeleton conventions | Design system for loading states | |

**Action:** Decide each → update `docs/architecture/frontend.md` and `frontend-conventions.mdc` → scaffold in `dtp/`.

---

## Part 4: Product / Tool Open Questions

These affect UX, scope, and implementation. Grouped by tool.

### 4.1 Metrics Glossary (`docs/product/tools/metrics-glossary.md`)

| # | Question |
|---|----------|
| 1 | Is Metrics Analyst a separate paid tier or included in all plans? |
| 2 | Can the API distribute the glossary in real-time (webhook) or only on-demand pull? |
| 3 | Is there version history on metric definitions? |
| 4 | Is there an approval workflow before a metric can be published? |
| 5 | Can external Tableau/GA metrics be kept "live synced" or are they one-time imports? |
| 6 | What exactly does the Notion/Coda integration update — full page, specific blocks? |

---

### 4.2 Entity Relationship Diagram (`docs/product/tools/erd.md`)

| # | Question |
|---|----------|
| 1 | Is the ERD layout saved per-user or shared across the organization? |
| 2 | Can users pin or annotate objects/relationships with notes? |
| 3 | What happens when a Salesforce object is deleted — grey out or auto-remove? |
| 4 | Can custom (non-Salesforce) relationships be added manually for planning? |
| 5 | Size limit on objects per ERD View before performance degrades? |

---

### 4.3 Data Dictionary (`docs/product/tools/data-dictionary.md`)

| # | Question |
|---|----------|
| 1 | How often does DataTools sync with Salesforce — on demand, scheduled, or both? |
| 2 | Can users add custom fields that don't exist in Salesforce (for planning)? |
| 3 | Is there a workflow to notify field owners when impact is detected? |
| 4 | Who can edit business context — all users, or only admins? |

---

### 4.4 Data Migration Tools (`docs/product/tools/data-migration.md`)

| # | Question |
|---|----------|
| 1 | What SQL dialects does generation support — standard SQL, MySQL, Postgres, or SOQL? |
| 2 | Can source fields be bulk-imported from a CSV schema export? |
| 3 | Is there version history on mappings (rollback)? |
| 4 | Can multiple team members edit the same Migration Project simultaneously? |
| 5 | Is there a formal approval/sign-off workflow within DataTools, or Excel export only? |
| 6 | What level of SQL complexity does the generator handle? |

---

### 4.5 Report Management (`docs/product/tools/report-management.md`)

| # | Question |
|---|----------|
| 1 | What triggers initial report/dashboard sync — automatic on org connection or manual? |
| 2 | How frequently is adoption data refreshed from Salesforce? |
| 3 | Is there a bulk status-change action in the UI? |
| 4 | Can report owners receive notifications when their report is marked deprecated? |
| 5 | Is there a "bulk delete in Salesforce" integration or always manual? |
| 6 | Can DataTools suggest zombie reports automatically (e.g. "not viewed in 90 days" rule)? |

---

### 4.6 Product-Wide (`docs/product/README.md`)

| # | Question |
|---|----------|
| 1 | Field/object data refreshes — on demand, scheduled, or both? |

---

### 4.7 Integrations (`docs/product/integrations.md`)

| # | Question |
|---|----------|
| 1 | Zapier connector — exact spec for trigger and action sources (TBD) |

---

## Part 5: Setup Tasks (from `scripts/tickets.json`)

These are **action items**, not decisions. Order matters.

| # | Task | Depends On |
|---|------|------------|
| 1 | **Onboard Waqar as co-owner** | Secret manager decision (1.2) |
| 2 | **Provision Cloudways staging server** | Cloudways sizing decision (1.4) |
| 3 | **Provision Cloudways production server** | Cloudways sizing decision (1.4) |
| 4 | **Provision AWS RDS staging database** | RDS engine decision (1.3) |
| 5 | **Provision AWS RDS production database** | RDS engine decision (1.3) |
| 6 | **Create Cloudflare Pages project** | — |
| 7 | **Populate all GitHub Actions secrets and variables** | Cloudways + RDS + CF setup |
| 8 | **Configure Jira MCP for both developers** | Jira project key decision (1.1) |

---

## Part 6: Implementation State

| Area | Status | Notes |
|------|--------|-------|
| **Laravel app/** | Empty / minimal | No Services, Controllers, migrations found |
| **SPA** | Empty / minimal | No feature modules or pages found |
| **Database migrations** | None | Schema not yet created |
| **API routes** | None | `routes/api.php` not found |
| **AI prompts** | Template only | No eval files registered in `promptfooconfig.yaml` |
| **CI workflows** | Documented | Path filters exist; assumes files exist |
| **Docs / rules** | Extensive | Well-structured; many TBDs |

---

## Part 7: Recommended Order of Operations

### Phase 1 — Unblock Infrastructure (1–2 days)

1. **Decide** Jira project key (MBT vs DTP) → update all docs
2. **Decide** Secret manager → create vault, share with team
3. **Decide** RDS engine (MySQL vs Postgres)
4. **Decide** Cloudways sizing and topology
5. **Decide** Release versioning strategy
6. **Execute** Waqar onboarding (after secret manager)
7. **Execute** Populate GitHub secrets (partial — before full provisioning)

### Phase 2 — Provision Infrastructure (2–5 days)

8. Provision Cloudflare Pages project
9. Provision Cloudways staging + production
10. Provision AWS RDS staging + production
11. Wire deploy pipelines; verify staging and production health
12. Configure Jira MCP

### Phase 3 — Core Technical Decisions (1 day)

13. Backend: API versioning, queue driver, file storage
14. Frontend: State management, HTTP client, styling, forms
15. Product: Prioritize sync strategy (on-demand vs scheduled) — affects all tools

### Phase 4 — MVP Implementation (weeks)

16. Implement core auth (Sanctum) + base Laravel structure
17. Implement base SPA shell (routing, auth guard, API client)
18. Implement first tool (Metrics Glossary or Data Dictionary) as vertical slice
19. Add database migrations for chosen tool
20. Add first AI prompt + eval
21. Create first `docs/features/` entry

### Phase 5 — Product Refinement (ongoing)

22. Resolve product open questions per tool as features are built
23. Activate Red Team CI gate (optional)
24. Add remaining tools per roadmap

---

## Part 8: Quick Reference — Where to Update After Each Decision

| Decision | Files to Update |
|----------|-----------------|
| Jira key (MBT vs DTP) | `docs/WORKFLOW.md`, `.cursor/rules/git-workflow.mdc`, `.github/pull_request_template.md`, `.github/ISSUE_TEMPLATE/*.md`, `README.md`, `docs/RELEASE.md` |
| Secret manager | `docs/SECRETS.md` |
| RDS engine | `.env.example`, `docs/architecture/README.md`, `docs/architecture/backend.md` |
| Cloudways sizing | `docs/ENVIRONMENTS.md` |
| Versioning strategy | `docs/RELEASE.md`, `.github/workflows/deploy-production.yml` |
| Backend tech (queue, storage) | `docs/architecture/backend.md`, `config/queue.php`, `config/filesystems.php` |
| Frontend tech | `docs/architecture/frontend.md`, `.cursor/rules/frontend-conventions.mdc`, `dtp/package.json` |
| Sync strategy | `docs/product/README.md`, each tool doc, implementation |

---

## Appendix: Inconsistencies Found

| Item | Locations | Resolution |
|------|-----------|------------|
| ~~Jira project: MBT vs DTP~~ | ~~Resolve in Phase 1~~ | ✅ Resolved — MBT-XX standard (MBT-1324 closed) |
| SECRETS.md deploy token names | `STAGING_DEPLOY_TOKEN`, `PRODUCTION_DEPLOY_TOKEN` in README | SECRETS.md uses `STAGING_SSH_*` — confirm which naming is correct |
| Approvals | WORKFLOW: "1 approval"; RELEASE: "@rmgoodm or @waqarcs11" | Clarify if 1 or 2 reviewers required |

---

---

## Related

- **Lessons learned:** [`docs/LESSONS_LEARNED.md`](LESSONS_LEARNED.md) — Persistent memory for mistakes and gotchas. Check before similar work; add when fixing bugs.
- **Jira ticket backlog:** [`docs/JIRA_TICKET_BACKLOG.md`](JIRA_TICKET_BACKLOG.md) — Copy-paste ready ticket definitions for all decisions, setup tasks, and Waqar onboarding.

---

*Generated from project documentation scan. Update this file as decisions are made.*
