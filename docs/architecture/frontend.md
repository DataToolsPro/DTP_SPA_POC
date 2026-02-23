# Frontend Architecture — React SPA

---

## Overview

The SPA lives in `dtp/` and is built with React + TypeScript + Vite.
It is deployed as a **static site to Cloudflare Pages** — no server-side rendering.
All dynamic data comes from the Laravel API (`VITE_API_URL`).

---

## Feature-First Structure

The SPA uses a **feature module** pattern — all code for a feature lives together.

```
dtp/src/
├── components/           ← Shared UI primitives (Button, Modal, Table, etc.)
├── features/             ← One directory per product feature area
│   └── <feature-name>/
│       ├── components/   ← Components used only by this feature
│       ├── hooks/        ← Data-fetching and logic hooks
│       ├── api.ts        ← All API calls for this feature
│       ├── types.ts      ← TypeScript types for this feature
│       └── index.ts      ← Re-exports (public API of this module)
├── hooks/                ← Shared hooks (useAuth, useToast, etc.)
├── lib/
│   ├── api/              ← API client setup (base URL, auth headers, interceptors)
│   └── utils/            ← Pure utility functions
├── pages/                ← One component per route
├── router/               ← Route definitions and auth guards
└── types/                ← Global types (User, ApiResponse, etc.)
```

---

## Routing & Auth Gates

**Structure:** Root redirects. `/login` is public. Everything under `/app/` is gated.

```
/                     → Redirect: not authenticated → /login; authenticated → /app
/login                → Login page (public)
/register             → Registration (public, if used)
/forgot-password      → Password reset (public, if used)

/app                  → Redirect to /app (or /app/dashboard)
/app/*                → All gated — requires auth
  /app                → Dashboard (or tool selector)
  /app/reports        → Reports list
  /app/reports/:id    → Report detail
  /app/metrics        → Metrics Glossary
  /app/dictionary     → Data Dictionary
  /app/erd            → Entity Diagram
  /app/migration      → Data Migration
  /app/settings       → Settings
```

**Rules:**
- **Public:** `/login`, `/register`, `/forgot-password` only
- **Root `/`:** Always redirect — never render content. Unauthenticated → `/login`; authenticated → `/app`
- **Gated:** All routes under `/app/` require auth. Unauthenticated access → redirect to `/login`
- **404:** Redirect to `/app` (if authenticated) or `/login` (if not)

---

## Authentication Flow (SPA ↔ Laravel Sanctum)

```
1. User hits / or any gated route
   → Check session (GET /api/v1/user)
   → 200: authenticated → allow /app/* or redirect / to /app
   → 401: not authenticated → redirect to /login (except public: /login, /register, etc.)

2. User hits /login, submits form → POST /login
   ├── 200: session created → redirect to /app
   └── 422: validation error → show field errors

3. All API requests send cookie automatically (same-domain)
   + CSRF token in X-XSRF-TOKEN header (Axios handles this automatically)
   + 401 interceptor → redirect to /login

4. Logout → POST /logout → clear session → redirect to /login
```

---

## State Management

<!-- Update this section when a state management decision is made -->

**Current decision:** [TBD — document when chosen]

Candidates:
- **TanStack Query** — server state (API data, caching, background refresh)
- **Zustand** — global client state (UI state, user preferences)
- **React Context** — auth context, theme

> Rule of thumb: most state should be server state (TanStack Query).
> Client-only state (UI open/close, form steps) can be `useState` locally.

---

## API Client

All API calls go through a centralized client in `dtp/src/lib/api/`.

```typescript
// Base setup — src/lib/api/client.ts
const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  withCredentials: true,    // sends session cookie
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  }
});

// Add CSRF token interceptor
// Add 401 → redirect to login interceptor
```

Feature-level API calls in `features/<feature>/api.ts`:
```typescript
export const reportsApi = {
  list: () => apiClient.get<{ data: Report[] }>('/v1/reports'),
  get: (id: string) => apiClient.get<{ data: Report }>(`/v1/reports/${id}`),
  create: (data: CreateReportData) => apiClient.post('/v1/reports', data),
};
```

---

## Build & Deploy

**Canonical commands** (from repo root):

```bash
# Local dev
cd dtp && npm run dev          # Vite dev server on :5173

# Production build
cd dtp && npm install && npm run build   # outputs to dtp/dist/

# Preview production build locally
cd dtp && npm run preview
```

**Cloudflare Pages** (dashboard → Build configuration) — pick one:

| Root directory | Build command | Output directory |
|----------------|---------------|------------------|
| *(blank)* | `cd dtp && npm install && npm run build` | `dtp/dist` |
| `dtp` | `npm install && npm run build` | `dist` |

If build fails with `cd: can't cd to dtp`, Root directory is set to `dtp` — use the second row. Use `npm install` (not `npm ci`) to avoid package-lock.json issues on Cloudflare.

Environment variables (`VITE_API_URL`, etc.) in Cloudflare Pages → Settings → Environment variables.

**GitHub Actions** (`deploy-staging.yml`, `deploy-production.yml`) use the same build steps. See `docs/ENVIRONMENTS.md` for full deploy flow.

---

## Testing

```bash
cd dtp && npm run test          # Vitest
npm run test:coverage           # with coverage report
```

---

## Open Questions / TODOs

- [ ] Confirm state management choice (TanStack Query + Zustand?)
- [ ] Confirm HTTP client (Axios vs native fetch)
- [ ] Confirm styling approach (Tailwind CSS?)
- [ ] Confirm form library (React Hook Form?)
- [ ] Set up Storybook for component development? (optional)
- [ ] Define error boundary strategy
- [ ] Define loading/skeleton state conventions
