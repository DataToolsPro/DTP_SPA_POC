# Release Runbook

Everything you need to ship code from development to production.

---

## The Full Release Lifecycle

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  1. Branch     feature/MBT-XX-slug  (from main)                    │
│       │                                                             │
│  2. PR         Opens → Cloudflare Pages auto-creates preview URL   │
│       │         CI runs (lint / tests / build)                     │
│       │         @rmgoodm + @waqarcs11 review                       │
│       │                                                             │
│  3. Merge      Squash merge → main                                  │
│       │                                                             │
│  4. Staging    Auto-deploys in ~3 min                               │
│       │         SPA → Cloudflare Pages (staging channel)           │
│       │         API → Cloudways staging server (SSH)               │
│       │         Cache → Cloudflare zone purged                     │
│       │                                                             │
│  5. Verify     Smoke test on staging.datatoolspro.com              │
│       │                                                             │
│  6. Promote    GitHub Actions → "Deploy — Production"              │
│       │         Enter tag: v2026.02.23                              │
│       │         Approval gate → @rmgoodm or @waqarcs11 approves   │
│       │                                                             │
│  7. Production SPA → Cloudflare Pages (production)                 │
│                API → Cloudways production server (SSH)             │
│                Cache → Cloudflare zone purged                      │
│                GitHub Release created with tag                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Standard Release (Step by Step)

### Step 1 — Verify Staging Is Good

Before promoting, confirm the latest merge is behaving on staging:

- [ ] Open `https://staging.datatoolspro.com` — app loads
- [ ] Check `https://staging.datatoolspro.com/api/health` — API responds
- [ ] Spot-check the feature(s) that just merged
- [ ] No errors in Cloudways logs for the staging server

### Step 2 — Trigger the Production Deploy

1. Go to **GitHub → DTP_APP_V3 → Actions → Deploy — Production**
2. Click **"Run workflow"** (top right)
3. Fill in:
   - **SHA**: leave blank (uses latest `main`)
   - **Tag**: `v2026.02.23` (today's date) or next semver
4. Click **"Run workflow"**

### Step 3 — Approve the Gate

Within a few seconds, GitHub will send a notification to `@rmgoodm` and `@waqarcs11`.

One of you:
1. Goes to the running workflow
2. Clicks **"Review deployments"**
3. Checks the box next to `production`
4. Clicks **"Approve and deploy"**

### Step 4 — Monitor the Deploy

Watch the workflow logs. The deploy does:
```
✅ Build SPA (or reuse staging artifact)
✅ Deploy SPA → Cloudflare Pages production
✅ SSH → Cloudways production
   → git pull origin main
   → composer install --no-dev --optimize-autoloader
   → php artisan migrate --force
   → php artisan config:cache
   → php artisan route:cache
   → php artisan view:cache
✅ Cloudflare cache purge
✅ Smoke test
✅ GitHub Release created
```

### Step 5 — Post-Deploy Verification

- [ ] Open `https://app.datatoolspro.com` — app loads cleanly
- [ ] Check `https://app.datatoolspro.com/api/health`
- [ ] Verify the key feature that was in this release works
- [ ] Check Cloudways logs for any PHP errors
- [ ] Check Cloudflare dashboard for any spike in 4xx/5xx errors

---

## Versioning

Use **date-based tags**:

| Scenario | Tag format | Example |
|---|---|---|
| Standard release | `vYYYY.MM.DD` | `v2026.02.23` |
| Second release same day | `vYYYY.MM.DD-2` | `v2026.02.23-2` |
| Hotfix | `vYYYY.MM.DD-hotfix` | `v2026.02.23-hotfix` |

Or **semver** if you prefer:

| Scenario | Tag format |
|---|---|
| Bug fix | `v1.0.1` |
| New feature | `v1.1.0` |
| Breaking change | `v2.0.0` |

**Pick one and stick to it.** The tag is created automatically by the production deploy workflow when you provide a tag name.

---

## Hotfix Process

For emergencies — a bug in production that can't wait for the normal flow:

```bash
# 1. Branch from main (NOT from a feature branch)
git checkout main
git pull origin main
git checkout -b hotfix/MBT-XX-describe-the-fix

# 2. Make the minimal fix
# Write a test if possible

# 3. Push and open PR
git push origin hotfix/MBT-XX-describe-the-fix
# Open PR on GitHub → target: main

# 4. Expedited review
# CI must still pass
# 1 approval is acceptable for critical hotfixes (team discretion)

# 5. Merge → auto-deploys to staging
# 6. Verify on staging (can be quick)
# 7. Promote to production immediately
# 8. Tag as: v2026.02.23-hotfix
```

**Never push directly to main even for hotfixes.** Branch protection is there for a reason — a bad hotfix can be worse than the original bug.

---

## Rollback

If production is broken after a deploy:

### Option A — Redeploy Previous Tag (Preferred)

1. Go to **GitHub → Actions → Deploy — Production**
2. Click **"Run workflow"**
3. Enter the **previous good SHA** (from `git log --oneline`)
4. Leave tag blank (no new tag for rollback)
5. Approve → deploys the previous version

### Option B — Cloudflare Pages Instant Rollback (SPA only)

1. Go to **Cloudflare Dashboard → Pages → dtp-app-v3**
2. Click **"Deployments"**
3. Find the last good deployment
4. Click **"Rollback to this deployment"**

This is instant — no build required. Use this if only the SPA is broken.

### Option C — Database Rollback (last resort)

```bash
# Revert the last migration
php artisan migrate:rollback

# Or rollback to a specific batch
php artisan migrate:rollback --step=2
```

⚠️ Only do this if the migration is safe to reverse and no data has been written against the new schema.

---

## Release Checklist (Printable)

Copy this into a GitHub Issue when doing a major release:

```markdown
## Release Checklist — v____.__.__

### Pre-release
- [ ] All planned PRs merged to main
- [ ] Staging auto-deployed successfully
- [ ] Staging smoke test passed (app loads, API healthy)
- [ ] Database migrations tested on staging
- [ ] No open P0/P1 bugs for this release
- [ ] .env.example up to date with any new variables
- [ ] 1Password vault updated with any new secrets

### Deploy
- [ ] Production deploy triggered (GitHub Actions)
- [ ] Approval gate signed off by @___
- [ ] All deploy steps completed green

### Post-release
- [ ] Production smoke test passed
- [ ] No spike in errors (Cloudflare dashboard)
- [ ] GitHub Release notes written
- [ ] Ticket(s) closed / transitioned to Done
- [ ] Team notified
```

---

## GitHub Actions Workflows Reference

| Workflow | File | Trigger | What it does |
|---|---|---|---|
| CI — Backend | `ci-backend.yml` | PR touching `app/`, `routes/`, etc. | PHP lint + PHPUnit |
| CI — Frontend | `ci-frontend.yml` | PR touching `dtp/` | ESLint + TS + tests + build |
| CI — AI Evals | `ci-ai-evals.yml` | PR touching `ai/` | promptfoo eval regression |
| Deploy Staging | `deploy-staging.yml` | Push to `main` | SPA → CF Pages, API → Cloudways staging |
| Deploy Production | `deploy-production.yml` | Manual / tag push | SPA → CF Pages prod, API → Cloudways prod |

---

## Useful Links (fill in once configured)

| Resource | URL |
|---|---|
| Staging app | `https://staging.datatoolspro.com` |
| Production app | `https://app.datatoolspro.com` |
| GitHub Actions | `https://github.com/DataToolsPro/DTP_APP_V3/actions` |
| GitHub Environments | `https://github.com/DataToolsPro/DTP_APP_V3/settings/environments` |
| Cloudflare Pages | `https://dash.cloudflare.com → Pages → dtp-app-v3` |
| Cloudways Staging | `https://platform.cloudways.com → your staging app` |
| Cloudways Production | `https://platform.cloudways.com → your production app` |
| AWS RDS Console | `https://console.aws.amazon.com/rds` |
