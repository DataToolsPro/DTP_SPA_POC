# DataTools Pro — Claude Code Project Context

> **Read this first.** Claude Code auto-loads this file. For Cursor, see `.cursor/rules/`.

---

## Project Overview

DataTools Pro **3.0** — the third major release. A Salesforce-connected governance platform: Laravel API backend + React SPA frontend. Monorepo with `app/` (Laravel), `dtp/` (React/Vite), and `ai/` (prompts, evals). Five tools share one data model: Metrics Glossary, ERD, Data Dictionary, Data Migration, Report Management. Stack: PHP 8.3, Laravel, React, TypeScript, Vite, Cloudflare Pages, Cloudways, AWS RDS.

---

## Critical: Check Lessons Learned

**Before making changes**, read [`docs/LESSONS_LEARNED.md`](docs/LESSONS_LEARNED.md). It captures mistakes, gotchas, and anti-patterns. Do not repeat past mistakes.

**When you fix a bug or discover a gotcha**, add an entry to `docs/LESSONS_LEARNED.md` so it is not repeated.

---

## Common Commands

```bash
# Backend
composer install && cp .env.example .env && php artisan key:generate
php artisan migrate && php artisan serve

# Frontend
cd dtp && npm install && cp .env.example .env.local && npm run dev

# Tests
php artisan test
cd dtp && npm run test

# AI evals
cd ai/evals && promptfoo eval --view
```

---

## Architecture & Conventions

**Backend:** Thin controllers → Service → Model. Business logic in `app/Services/`. No logic in controllers.

**Frontend:** Feature-first. `dtp/src/features/<name>/` contains components, hooks, api.ts, types.ts.

**AI:** All prompts in `ai/prompts/`. Each prompt has an eval in `ai/evals/`. Never inline prompts in code.

**Scratch code:** Never in `app/`, `dtp/`, `routes/`, `database/`. Use `scratch/` or `/tmp/`. Delete after use.

**Jira:** Every change tied to MBT-XX ticket. Branch: `feature/MBT-XX-slug`. PR title: `[MBT-XX] ...`

---

## Key Files

| Path | Purpose |
|------|---------|
| `docs/LESSONS_LEARNED.md` | Mistakes, gotchas — check before similar work; add when fixing bugs |
| `docs/DECISIONS_AND_NEXT_STEPS.md` | Undecided items, next steps |
| `docs/product/glossary.md` | Domain terms — use these exact terms |
| `docs/architecture/backend.md` | Laravel patterns |
| `docs/architecture/frontend.md` | SPA structure |
| `docs/SECRETS.md` | Where secrets live |
| `.cursor/rules/` | Cursor-specific AI rules |

---

## Standards

- **API:** Laravel API Resources, `/api/v1/` prefix, Form Requests for validation
- **Auth:** Laravel Sanctum, cookie-based for SPA
- **Commits:** Conventional Commits (`feat:`, `fix:`, etc.)
- **Prompts:** Must have evals; min 5 test cases; 100% threshold default

---

## Notes & Gotchas

- **MCP:** Atlassian MCP may show "enabled" in UI but not be in the AI's available tools. See LESSONS_LEARNED.
- **Jira key:** Repo has DTP/MBT inconsistency. MBT is the active project. See DECISIONS doc.
- **Scratch vs source:** Never commit scratch code. See agentic-workflow rules.
- **Secrets:** Never commit `.env`. `.env.example` is the contract.
