---
name: Bug Report
about: Something is broken in staging or production
title: '[BUG] '
labels: bug
assignees: ''
---

## Bug Description
<!-- Clear 1-2 sentence description of what's wrong -->

## Environment
- [ ] Local
- [ ] Staging (`staging.datatoolspro.com`)
- [ ] Production (`app.datatoolspro.com`)

## Steps to Reproduce
1.
2.
3.

## Expected Behavior
<!-- What should happen -->

## Actual Behavior
<!-- What actually happens -->

## Severity
- [ ] 🔴 P0 — Production down / data loss
- [ ] 🟠 P1 — Major feature broken for all users
- [ ] 🟡 P2 — Feature degraded / workaround exists
- [ ] 🟢 P3 — Minor / cosmetic

## Additional Context
<!-- Screenshots, console errors, Cloudways logs, Cloudflare analytics -->

---

> For P0/P1: immediately ping `@rmgoodm` and follow the hotfix process in [`docs/RELEASE.md`](../../docs/RELEASE.md#hotfix-process)
