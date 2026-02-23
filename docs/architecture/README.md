# DataTools Pro — Architecture Overview

This directory contains technical architecture documentation for the engineering team and AI assistant.

> **Product docs** (what the app does) → `docs/product/`
> **Architecture docs** (how it's built) → here
> **Feature docs** (how features work for users) → `docs/features/`

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│  END USER (browser)                                              │
└────────────────────┬────────────────────────────────────────────┘
                     │ HTTPS
┌────────────────────▼────────────────────────────────────────────┐
│  CLOUDFLARE (CDN + Bot Protection + DNS)                         │
│  ├── SPA assets → Cloudflare Pages (edge-served)                 │
│  └── API requests → proxied to Cloudways                         │
└────────────────────┬────────────────────────────────────────────┘
                     │
        ┌────────────┴─────────────┐
        │                          │
┌───────▼───────┐         ┌────────▼────────┐
│ CLOUDFLARE    │         │ CLOUDWAYS       │
│ PAGES         │         │ (PHP/Laravel)   │
│               │         │                 │
│ React SPA     │         │ Laravel API     │
│ (static)      │         │ app/            │
│               │         │ routes/api.php  │
└───────────────┘         └────────┬────────┘
                                   │
                          ┌────────▼────────┐
                          │  AWS RDS        │
                          │  (MySQL/Postgres)│
                          └─────────────────┘
```

---

## Repository Structure

```
DTP_APP_V3/                    ← monorepo root
├── app/                        ← Laravel: Models, Controllers, Services
├── routes/                     ← Laravel: API + web routes
├── database/                   ← Migrations, seeders, factories
├── config/                     ← Laravel config files
├── dtp/                        ← React SPA (Vite)
│   └── src/
│       ├── components/         ← Shared UI components
│       ├── features/           ← Feature modules (colocated)
│       ├── pages/              ← Route-level page components
│       └── lib/                ← Utilities, API client
├── ai/                         ← AI prompts, evals, redteam
├── .cursor/rules/              ← AI knowledge rules (always injected)
├── docs/                       ← Team documentation
└── .github/                    ← CI/CD + templates
```

---

## Key Architecture Decisions

| Decision | Choice | Why |
|---|---|---|
| Frontend delivery | Cloudflare Pages | Edge-served SPA, zero server cost, built-in CDN + protection |
| Backend hosting | Cloudways | Managed PHP/Laravel, SSH deploy, easy scaling |
| Database | AWS RDS | Managed, reliable, easy failover — separate from app server |
| Auth | Stytch | Federated login (Google, Apple, etc.), session cookies, backend middleware |
| Monorepo | Single repo | Small team, tight coupling between frontend and API |

---

## Deeper Docs

| Doc | What's in it |
|---|---|
| [`backend.md`](./backend.md) | Laravel architecture, service patterns, testing |
| [`frontend.md`](./frontend.md) | React SPA structure, state management, routing |
| [`auth.md`](./auth.md) | Stytch auth flow, redirect URLs, frontend/backend checklists |

---

## AI Rules (`.cursor/rules/`)

The AI assistant has domain-specific knowledge rules that are injected per context:

| Rule File | Applied When | Purpose |
|---|---|---|
| `project-overview.mdc` | Always | Repo structure and stack |
| `product-context.mdc` | Always | What the product IS |
| `data-model.mdc` | Always | Entities, relationships, business rules |
| `jira-context.mdc` | Always | How to use Jira context |
| `git-workflow.mdc` | Always | Branch, commit, PR rules |
| `backend-conventions.mdc` | `app/**`, `routes/**`, etc. | Laravel patterns |
| `frontend-conventions.mdc` | `dtp/**` | React/TypeScript patterns |
| `ai-prompt-management.mdc` | `ai/**` | Prompt and eval standards |
