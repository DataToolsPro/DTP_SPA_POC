# Lessons Learned — Persistent Memory

> **Purpose:** Capture mistakes, gotchas, and anti-patterns so they are not repeated.  
> **Who updates:** Anyone (human or AI) who discovers a mistake or learns something critical.  
> **When:** Immediately when a bug is fixed, a mistake is caught, or a gotcha is discovered.  
> **AI rule:** Always check this file before making similar changes. Add to it when fixing bugs.

---

## How to Use This File

- **Before similar work:** Read the relevant sections. Don't repeat past mistakes.
- **After fixing a bug:** Add a short entry — what went wrong, why, how to avoid it.
- **After hitting a gotcha:** Add it. Future you (and AI) will thank you.
- **Keep entries scannable:** One paragraph max. Date + context. Link to PR or ticket if relevant.

---

## Mistakes & Gotchas

### MCP Server Visibility (2026-02)

**What happened:** Atlassian MCP showed as "enabled" with 40 tools in Cursor's MCP settings UI, but the AI's `call_mcp_tool` reported the server as unavailable. The available servers list did not include "atlassian."

**Why:** The MCP servers exposed to the AI agent can differ from what the UI shows — session context, workspace config, or tool-loading order may exclude some servers.

**Do instead:** If MCP "isn't working" despite UI showing enabled: try a new chat session, verify the exact server identifier, or use an alternative (e.g. Jira CSV bulk import) until MCP is confirmed working.

**Jira MCP server name:** Use `user-atlassian` (not `atlassian`) when calling `call_mcp_tool` for Jira. The UI may show "atlassian" but the server identifier in Cursor is `user-atlassian`.

---

### Cloudflare Pages: npm ci fails with "generate package-lock.json" (2026-02)

**What happened:** Cloudflare Pages build failed with `npm ci` asking to generate a package-lock.json, even though it exists in the repo.

**Why:** Cloudflare's build environment may not have package-lock.json in the expected location when using Root directory, or the branch being built lacks it (e.g. building from main before merge).

**Do instead:** Use `npm install` instead of `npm ci` in the Cloudflare Pages build command. It works without a lock file and is more resilient.

---

### Cloudflare Pages: Non-production deploy command (2026-02)

**What happened:** Build config had `npx wrangler versions upload` for non-production branch deploys.

**Why:** That command is for Cloudflare Workers versioning — not for static Pages. Pages auto-deploys the build output; no custom deploy command needed.

**Do instead:** Leave "Non-production branch deploy command" blank. See `docs/ENVIRONMENTS.md` for correct build config.

---

### (Add more entries below — newest first)

---

## Anti-Patterns — Don't Do This

| Don't | Do instead |
|-------|------------|
| Put scratch/temporary code in `app/`, `dtp/`, `routes/`, `database/` | Use `scratch/` or `/tmp/`; delete after use |
| Write scripts to replicate MCP (Jira, etc.) | Use MCP directly; troubleshoot MCP if it fails |
| Commit `.env` or secrets | Use `.env.example` as contract; secrets in vault |
| Use DTP-XX and MBT-XX inconsistently | Standardized on MBT-XX (MBT-1324 closed) |
| Add prompts inline in PHP/TypeScript | Put all prompts in `ai/prompts/` with evals |

---

## Decisions That Stuck

*Decisions that were easy to forget or second-guess. For full decision log, see `docs/DECISIONS_AND_NEXT_STEPS.md`.*

| Decision | Why it matters |
|----------|----------------|
| **Cloudflare Pages project name:** `dtp-app-v3` (dashes, lowercase) | PR preview URLs, deploy config |
| **Frontend directory is `dtp/`** (not `spa/`) | Product alignment; build/cmd paths; CI path filters; docs |
| **DataTools Pro 3.0** — this is the third major release | Product/version context; release notes; roadmap clarity |
| Scratch code never in source dirs | Prevents accidental commit of temp/debug code |
| MCP-first for Jira | Avoids script sprawl; single source of truth |
| Prompts in `ai/prompts/` | Versionable, reviewable, eval-gated |

---

## Before You... (Checklist)

**Before touching backend/auth:**  
- [ ] Read `docs/architecture/backend.md` — Sanctum SPA flow, policies

**Before adding a new integration:**  
- [ ] Check `docs/product/integrations.md` — existing patterns

**Before writing a prompt:**  
- [ ] Follow `ai/prompts/_template.md`; add eval in `ai/evals/`

**Before provisioning infra:**  
- [ ] All Phase 1 decisions in `docs/DECISIONS_AND_NEXT_STEPS.md` are done

**Before deploying to Cloudflare Pages:**  
- [ ] Check `docs/ENVIRONMENTS.md` → Build & Deploy Reference for correct config

**Before assuming MCP works:**  
- [ ] Verify server is in the AI's available tools list, not just the UI

---

*Last updated: 2026-02. Add entries as they occur.*
