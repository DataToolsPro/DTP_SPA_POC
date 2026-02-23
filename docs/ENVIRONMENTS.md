# Environments

DTP_APP_V3 runs across four environments. Each has a specific purpose, trigger, and audience.

---

## Build & Deploy Reference

**Frontend directory:** `dtp/` (React SPA)

| Action | Command |
|--------|---------|
| **Local dev** | `cd dtp && npm run dev` |
| **Production build** | `cd dtp && npm ci && npm run build` |
| **Build output** | `dtp/dist/` |

**Cloudflare Pages** — project name: `dtp-app-v3` (set `CLOUDFLARE_PAGES_PROJECT` in GitHub repo variables). Use **one** of these configs (not both):

| Setting | Option A — Repo root | Option B — Root = dtp |
|---------|----------------------|------------------------|
| Root directory | *(leave blank)* | `dtp` |
| Build command | `cd dtp && npm ci && npm run build` | `npm ci && npm run build` |
| Build output directory | `dtp/dist` | `dist` |

If you see `cd: can't cd to dtp`, you have Option B — change build command to `npm ci && npm run build` and output to `dist`.

**GitHub Actions** deploy workflows use Option A (repo root). Custom domain `us1dev.datatoolspro.com` (if configured) is managed in Cloudflare Pages dashboard.

**First-time setup:** Create a Cloudflare Pages project named `dtp-app-v3` in the Cloudflare dashboard (Workers & Pages → Create → Pages → Connect to Git). Configure build per table above. Add `CLOUDFLARE_PAGES_PROJECT=dtp-app-v3` to GitHub repo variables (Settings → Secrets and variables → Actions → Variables). See `docs/SECRETS.md`.

---

## Environment Overview

| Environment | Purpose | Audience | Triggered By |
|---|---|---|---|
| **Local** | Active development | Developer only | Manual (`npm run dev` / `php artisan serve`) |
| **PR Preview** | Per-PR visual QA | Dev + reviewer | Auto on every PR push (Cloudflare Pages) |
| **Staging** | Pre-production verification | Dev team | Auto on every merge to `main` |
| **Production** | Live users | Everyone | Manual approval gate |

---

## Local

**What it is:** Your laptop. Nothing is deployed anywhere.

| Layer | URL | Command |
|---|---|---|
| React SPA | `http://localhost:5173` | `cd dtp && npm run dev` |
| Laravel API | `http://localhost:8000` | `php artisan serve` |
| Database | `127.0.0.1:3306` | Local MySQL or SQLite |

**Setup:** See [README.md → Getting Started](../README.md#getting-started)
**Secrets:** Copy `.env.example` → `.env`, fill from 1Password vault

---

## PR Preview

**What it is:** A live, throwaway deployment of the SPA automatically created by Cloudflare Pages for every open PR. Destroyed when the PR is merged or closed.

| Layer | URL | Notes |
|---|---|---|
| React SPA | `https://pr-<number>.dtp-app-v3.pages.dev` | Auto-created per PR |
| Laravel API | Staging Cloudways server | PR previews share the staging backend |
| Database | Staging RDS | Read/write against staging data |

**Trigger:** Cloudflare Pages GitHub integration — fires on every push to a PR branch
**Cost:** Free (included in Cloudflare Pages free tier)
**Purpose:** Let reviewers click through the actual UI change before approving

> ⚠️ PR previews share the staging database. Avoid running destructive data operations from a PR preview.

---

## Staging

**What it is:** A full mirror of production. Every merge to `main` auto-deploys here. This is where you verify before going live.

| Layer | URL | Server |
|---|---|---|
| React SPA | `https://staging.datatoolspro.com` | Cloudflare Pages (staging channel) |
| Laravel API | `https://staging.datatoolspro.com/api` | Cloudways staging app server |
| Database | Staging AWS RDS instance | Separate from production |

**Trigger:** Automatic — GitHub Actions `deploy-staging.yml` fires on every push to `main`
**Deploy time:** ~3–5 minutes (SPA build + SSH deploy + cache purge)
**Access:** Team only — no real customer data

**GitHub Environment:** `staging`
- No approval gate (fully automatic)
- Secrets: `STAGING_SSH_HOST`, `STAGING_SSH_USER`, `STAGING_SSH_KEY`, etc. (see `docs/SECRETS.md`)
- Variables: `APP_URL`, `VITE_API_URL` (injected into SPA build)

**GitHub Repository Variables** (required for deploy): `CLOUDFLARE_PAGES_PROJECT` = `dtp-app-v3`. See `docs/SECRETS.md`.

---

## Production

**What it is:** Live. Real users. Treat with care.

| Layer | URL | Server |
|---|---|---|
| React SPA | `https://app.datatoolspro.com` | Cloudflare Pages (production) |
| Laravel API | `https://app.datatoolspro.com/api` | Cloudways production app server |
| Database | Production AWS RDS instance | Automated daily backups |

**Trigger:** Manual — `workflow_dispatch` in GitHub Actions OR tag push (`v*`)
**Approval gate:** At least one of `@rmgoodm` or `@waqarcs11` must approve before deploy runs
**Deploy time:** ~3–5 minutes after approval

**GitHub Environment:** `production`
- ✅ Required reviewer: `@rmgoodm` or `@waqarcs11`
- ✅ Restricted to `main` branch only
- Secrets: `PRODUCTION_DEPLOY_TOKEN`, `CLOUDFLARE_API_TOKEN`
- Variables: `PRODUCTION_URL`, `PRODUCTION_API_URL`

---

## Infrastructure Diagram

```
Developer Machine (Local)
        │
        │ git push → PR opened
        ▼
┌───────────────────────────────────────────────┐
│          CLOUDFLARE EDGE                      │
│                                               │
│  PR Preview  (pr-XX.pages.dev)  ←── auto      │
│  Staging     (staging.*)        ←── auto      │
│  Production  (app.*)            ←── approved  │
│                                               │
│  WAF + Bot Protection + SSL + CDN             │
└───────────────────────────┬───────────────────┘
                            │ /api/* proxied
              ┌─────────────┴──────────────┐
              │                            │
   ┌──────────▼──────────┐    ┌────────────▼────────────┐
   │  Cloudways Staging   │    │  Cloudways Production    │
   │  Laravel API         │    │  Laravel API             │
   └──────────┬──────────┘    └────────────┬────────────┘
              │                            │
   ┌──────────▼──────────┐    ┌────────────▼────────────┐
   │  AWS RDS (Staging)   │    │  AWS RDS (Production)    │
   └─────────────────────┘    └─────────────────────────┘
```

---

## Adding a New Environment

If you need a new environment (e.g., `demo` or `uat`):

1. Create a GitHub Environment: `Settings → Environments → New environment`
2. Add a new deploy workflow file in `.github/workflows/`
3. Add the environment to this document
4. Update `SECRETS.md` with required secrets
5. Configure Cloudflare Pages to deploy to a new channel for that environment
