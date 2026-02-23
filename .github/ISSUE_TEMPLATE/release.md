---
name: Release Checklist
about: Track a production release end-to-end
title: 'Release: v____.__.__'
labels: release
assignees: rmgoodm
---

## Release: `v____.__.__`

> Fill in the version tag, link the PRs included, and work through the checklist.
> See [`docs/RELEASE.md`](../../docs/RELEASE.md) for the full runbook.

---

### PRs Included in This Release

| PR | Description |
|---|---|
| #__ | |
| #__ | |

---

### Pre-Release Checklist

**Code**
- [ ] All planned PRs merged to `main`
- [ ] No open P0/P1 bugs targeting this release
- [ ] `main` CI is green

**Config & Secrets**
- [ ] `.env.example` updated for any new environment variables
- [ ] New secrets added to GitHub Environments (staging + production)
- [ ] 1Password vault updated with new secrets
- [ ] Both `@rmgoodm` and `@waqarcs11` have the updated vault entries

**Staging Verification**
- [ ] Staging auto-deployed successfully after last merge
- [ ] SPA loads at `https://staging.datatoolspro.com`
- [ ] API health check passes: `https://staging.datatoolspro.com/api/health`
- [ ] Key feature(s) in this release verified on staging
- [ ] Database migrations ran cleanly on staging
- [ ] No errors in Cloudways staging logs

---

### Deploy to Production

- [ ] Go to [GitHub Actions → Deploy — Production](../../actions/workflows/deploy-production.yml)
- [ ] Click "Run workflow"
- [ ] Enter tag: `v____.__.__`
- [ ] Approval granted by: @______
- [ ] All deploy jobs completed green

---

### Post-Release Verification

- [ ] SPA loads at `https://app.datatoolspro.com`
- [ ] API health check passes: `https://app.datatoolspro.com/api/health`
- [ ] Key feature(s) verified on production
- [ ] No error spike in Cloudflare dashboard
- [ ] Cloudways production logs clean
- [ ] GitHub Release created with tag and notes

---

### Rollback Plan (if needed)

- **SPA:** Cloudflare Pages → Deployments → Rollback (instant)
- **Full:** Re-run Deploy Production with SHA: `____________`
- **DB migration:** `php artisan migrate:rollback`

---

### Notes

<!-- Anything unusual about this release, known issues, follow-up tickets -->
