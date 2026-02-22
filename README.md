# DTP_SPA_POC

> **DataTools Pro — SPA Proof of Concept**
> Laravel API backend + React SPA + AI-powered agentic workflows.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Repository Structure](#repository-structure)
3. [Getting Started](#getting-started)
4. [Git Workflow](#git-workflow)
5. [CI/CD Pipeline](#cicd-pipeline)
6. [AI / Prompt Management](#ai--prompt-management)
7. [Environments](#environments)
8. [Configuration & Secrets](#configuration--secrets)
9. [Contributing](#contributing)
10. [Architecture Decisions](#architecture-decisions)

---

## Project Overview

This repo is the POC for the next-generation DataTools Pro single-page application. It replaces fragmented tooling with a unified SPA experience backed by a clean Laravel API and AI-assisted data workflows.

**Stack:**
| Layer | Technology |
|---|---|
| Backend API | PHP 8.3 / Laravel |
| Frontend SPA | React + TypeScript + Vite |
| AI / LLM | OpenAI GPT-4o / Anthropic Claude |
| Eval Framework | [promptfoo](https://www.promptfoo.dev/) |
| CI/CD | GitHub Actions |
| Package Manager | Composer (PHP) · npm (SPA) |

---

## Repository Structure

```
DTP_SPA_POC/
│
├── app/                        # Laravel: Controllers, Models, Services
├── bootstrap/                  # Laravel: app bootstrap + providers
├── config/                     # Laravel: all config files
├── database/
│   ├── migrations/             # DB schema migrations
│   ├── seeders/                # Dev / test seed data
│   └── factories/              # Model factories for testing
├── routes/
│   ├── api.php                 # API routes (consumed by SPA)
│   └── web.php                 # Web routes (SPA entry point)
│
├── spa/                        # React SPA (Vite)
│   ├── src/
│   │   ├── components/         # Reusable UI components
│   │   ├── pages/              # Route-level page components
│   │   ├── hooks/              # Custom React hooks
│   │   ├── services/           # API client / data fetching
│   │   └── store/              # State management
│   ├── public/                 # Static assets
│   ├── package.json
│   └── vite.config.ts
│
├── ai/                         # AI / Agentic workflows
│   ├── README.md               # AI overview + local dev guide
│   ├── prompts/                # All prompt templates (one file per prompt)
│   │   ├── _template.md        # Copy this for new prompts
│   │   └── <feature>/<name>.md
│   ├── evals/                  # Golden test cases (promptfoo)
│   │   ├── promptfooconfig.yaml
│   │   └── <name>.eval.yaml
│   └── redteam/                # Adversarial / security tests
│
├── docs/                       # Team documentation
│
├── .github/
│   ├── CODEOWNERS              # Who reviews what (enforced on PRs)
│   ├── pull_request_template.md
│   └── workflows/
│       ├── ci-backend.yml      # PHP lint + PHPUnit (path: app/, routes/, etc.)
│       ├── ci-frontend.yml     # ESLint + tests + build (path: spa/)
│       ├── ci-ai-evals.yml     # Prompt regression tests (path: ai/)
│       ├── deploy-staging.yml  # Auto-deploy to staging on merge to main
│       └── deploy-production.yml # Manual approval gate → production
│
├── .cursor/
│   └── rules/
│       ├── project-overview.mdc      # AI: always-on project context
│       ├── git-workflow.mdc          # AI: branch + PR conventions
│       └── ai-prompt-management.mdc  # AI: prompt rules (scoped to ai/**)
│
├── .gitignore
├── .env.example                # Copy → .env, fill in values
└── README.md                   # ← you are here
```

---

## Getting Started

### Prerequisites

- PHP 8.3+ with Composer
- Node.js 20+ with npm
- MySQL 8.0+ (or SQLite for local dev)
- Git 2.x

### Backend (Laravel)

```bash
# 1. Install PHP dependencies
composer install

# 2. Copy environment file
cp .env.example .env

# 3. Generate app key
php artisan key:generate

# 4. Run migrations
php artisan migrate

# 5. Start dev server
php artisan serve
```

### Frontend SPA

```bash
# 1. Navigate to SPA directory
cd spa

# 2. Install dependencies
npm install

# 3. Copy env
cp .env.example .env.local

# 4. Start dev server (proxies API to Laravel)
npm run dev
```

### AI / Evals

```bash
# 1. Install promptfoo globally
npm install -g promptfoo

# 2. Copy AI env (add your LLM keys)
cp .env.example ai/.env

# 3. Run evals
cd ai/evals
promptfoo eval --view
```

---

## Git Workflow

We use **trunk-based development** — one long-lived branch (`main`), short-lived feature branches.

### Branch Naming

| Type | Pattern | Example |
|---|---|---|
| Feature | `feature/<ticket>-<slug>` | `feature/DTP-42-user-auth` |
| Hotfix | `hotfix/<ticket>-<slug>` | `hotfix/DTP-99-token-expiry` |

### The PR Lifecycle

```
1. git checkout -b feature/DTP-XX-my-feature
2. Write code + tests
3. git push origin feature/DTP-XX-my-feature
4. Open PR against main
5. CI checks run automatically (backend / SPA / evals as relevant)
6. 1 reviewer approves (CODEOWNERS enforced for protected areas)
7. Squash merge → main
8. Branch auto-deleted
9. Staging deploys automatically
10. Promote to production via manual approval in GitHub Actions
```

### Release Tags

```bash
# Production releases are tagged on main
git tag v2026.02.22
git push origin v2026.02.22
# Or: trigger the "Deploy — Production" workflow with a tag name
```

---

## CI/CD Pipeline

### CI Checks (required on PRs)

| Workflow | Trigger (path filter) | What it checks |
|---|---|---|
| `ci-backend.yml` | `app/**`, `routes/**`, `database/**`, `composer.*` | PHP lint + PHPUnit |
| `ci-frontend.yml` | `spa/**` | ESLint + TypeScript + tests + build |
| `ci-ai-evals.yml` | `ai/**` | Prompt regression tests (promptfoo) |

Path filters mean: **only the relevant check runs for your change**. Touching only the SPA won't run the full PHP test suite.

### Deployment

| Environment | Trigger | Approval |
|---|---|---|
| **staging** | Auto on merge to `main` | None — fully automatic |
| **production** | Manual `workflow_dispatch` or tag push | ✅ Required reviewer approval |

The **same artifact** built for staging is promoted to production — no rebuilds, no branch gymnastics.

---

## AI / Prompt Management

See [`ai/README.md`](ai/README.md) for the full guide.

**Quick rules:**
- All prompts live in `ai/prompts/` — never inline in code
- Every prompt needs ≥ 5 eval cases in `ai/evals/`
- Prompt changes require PR review (CODEOWNERS enforced)
- CI Gate B runs `promptfoo eval` on every PR touching `ai/**`
- Default pass threshold: 100% (lower only with written justification)

---

## Environments

| Environment | URL | Deploy trigger | Approval needed |
|---|---|---|---|
| **staging** | `$STAGING_URL` | Auto on `main` merge | None |
| **production** | `$PRODUCTION_URL` | Manual / tag | ✅ Yes |

Configure in: **GitHub → Settings → Environments**

Production environment should have:
- ✅ Required reviewers: `@rmgoodm`
- ✅ Deployment branch restricted to `main`
- ✅ Secrets isolated (separate from staging)

---

## Configuration & Secrets

| Secret/Variable | Where it lives | Who needs it |
|---|---|---|
| `OPENAI_API_KEY` | GitHub Secrets (repo-level) | `ci-ai-evals.yml` |
| `ANTHROPIC_API_KEY` | GitHub Secrets (repo-level) | `ci-ai-evals.yml` |
| `STAGING_DEPLOY_TOKEN` | GitHub Secrets (staging env) | `deploy-staging.yml` |
| `PRODUCTION_DEPLOY_TOKEN` | GitHub Secrets (production env) | `deploy-production.yml` |
| `STAGING_URL` | GitHub Variables (staging env) | deploy + smoke tests |
| `PRODUCTION_URL` | GitHub Variables (production env) | deploy + smoke tests |
| `STAGING_API_URL` | GitHub Variables (staging env) | SPA build |
| `PRODUCTION_API_URL` | GitHub Variables (production env) | SPA build |

**Never** commit `.env` files. Use `.env.example` as the reference.

---

## Contributing

1. Read [`docs/WORKFLOW.md`](docs/WORKFLOW.md) before your first PR
2. Follow the branch naming convention above
3. Use the PR template (auto-loaded when you open a PR)
4. For AI changes: follow [`ai/README.md`](ai/README.md)
5. For questions: open a GitHub Discussion or ping `@rmgoodm`

---

## Architecture Decisions

| Decision | Choice | Reason |
|---|---|---|
| Branch model | Trunk-based (single `main`) | Simplest for 1–2 devs; avoids branch sprawl |
| Promotion model | Environment gate (not branch gate) | Keeps history clean; same artifact to prod |
| Prompt storage | `ai/prompts/` Markdown files | Reviewable, versionable, testable |
| Eval framework | promptfoo | Best CI integration; supports multi-model |
| Merge strategy | Squash merge | Linear history; atomic PR commits |
| PHP version | 8.3 | Latest stable; attributes, fibers, typed props |
| Node version | 20 LTS | Stable; matches CI runner |
