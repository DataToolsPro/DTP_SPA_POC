# Authentication — Stytch + SPA + Laravel

> **Status:** Architecture documented. Implementation placeholders below — update as integration progresses.

DataTools Pro uses **Stytch** for user authentication and federated login (Google, Apple, etc.). The flow is frontend-led: Stytch redirects to the SPA after auth, and the backend validates sessions via middleware.

---

## Environment URLs (placeholders)

| Environment | SPA URL | API base | Stytch redirect path |
|-------------|---------|----------|----------------------|
| **Local** | `http://localhost:5173` | `http://localhost:8000/api` | `/authenticate` |
| **Dev** | `https://us1dev.datatoolspro.com` | `https://us1dev.datatoolspro.com/api` | `/authenticate` |
| **Staging** | `https://staging.datatoolspro.com` | `https://staging.datatoolspro.com/api` | `/authenticate` |
| **Production** | `https://us1.datatoolspro.com` | `https://us1.datatoolspro.com/api` | `/authenticate` |

> **Update** when final URLs are confirmed. Stytch Dashboard requires each redirect URL to be whitelisted.

---

## Flow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ 1. User clicks "Sign in with Google" (or other IdP)                          │
│    → Stytch JS SDK redirects to IdP                                          │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ 2. User authenticates with IdP                                               │
│    → Stytch redirects to {SPA_URL}/authenticate?stytch_token_type=oauth&...  │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ 3. Frontend /authenticate route                                              │
│    → Stytch JS SDK exchanges token with Stytch (no call to our API)          │
│    → Stytch sets session cookies (session_token, session_jwt)                │
│    → Redirect user to /app                                                   │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ 4. User on /app — SPA makes API calls (e.g. GET /api/v1/user)               │
│    → Browser sends Stytch cookies with request (same domain)                 │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ 5. Laravel middleware                                                        │
│    → Validates Stytch session (call Stytch API or verify JWT)                │
│    → 200 if valid, 401 if not                                                │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Stytch Dashboard Config (placeholders)

**Redirect URLs** — add each environment in Stytch Dashboard → Redirect URLs:

| Environment | Redirect URL |
|-------------|--------------|
| Local | `http://localhost:5173/authenticate` |
| Dev | `https://us1dev.datatoolspro.com/authenticate` |
| Staging | `https://staging.datatoolspro.com/authenticate` |
| Production | `https://us1.datatoolspro.com/authenticate` |

> **Update** when URLs are final. All must be HTTPS except localhost in Test env.

---

## Frontend Implementation Checklist

| Item | Location | Status |
|------|----------|--------|
| Stytch JS SDK init | `dtp/src/lib/stytch.ts` (or equivalent) | [ ] Placeholder |
| `/authenticate` route | `dtp/src/router/` | [ ] Placeholder |
| Authenticate page component | `dtp/src/pages/Authenticate.tsx` (or equivalent) | [ ] Placeholder |
| Token exchange on mount | Use Stytch SDK `oauth.authenticate()` or equivalent | [ ] Placeholder |
| Redirect to `/app` after success | In authenticate handler | [ ] Placeholder |
| `withCredentials: true` on API client | `dtp/src/lib/api/client.ts` | [ ] Placeholder |
| 401 interceptor → redirect to `/login` | API client | [ ] Placeholder |

---

## Backend Implementation Checklist

| Item | Location | Status |
|------|----------|--------|
| Stytch middleware | `app/Http/Middleware/ValidateStytchSession.php` | [ ] Placeholder |
| Register middleware | `app/Http/Kernel.php` or `bootstrap/app.php` | [ ] Placeholder |
| Apply to protected routes | `routes/api.php` — replace or supplement `auth:sanctum` | [ ] Placeholder |
| Stytch API client / config | `config/stytch.php`, `STYTCH_*` env vars | [ ] Placeholder |
| User sync: Stytch user → Laravel User | Service layer, first login or webhook | [ ] Placeholder |

---

## Same-Domain Requirement

SPA and API **must share a domain** so Stytch cookies are sent with API requests:

- ✅ `us1.datatoolspro.com` (SPA) + `us1.datatoolspro.com/api` (API)
- ✅ `staging.datatoolspro.com` (SPA) + `staging.datatoolspro.com/api` (API)
- ⚠️ Different subdomains (e.g. `app.example.com` + `api.example.com`) require `availableToSubdomains` in Stytch client options — cookie domain set to `.example.com`

---

## Secrets & Env Vars (placeholders)

| Variable | Where | Purpose |
|----------|-------|---------|
| `STYTCH_PUBLIC_TOKEN` | Frontend (`VITE_STYTCH_PUBLIC_TOKEN`) | Stytch JS SDK init |
| `STYTCH_SECRET` | Backend (Laravel `.env`) | Validate sessions server-side |
| `STYTCH_PROJECT_ID` | Backend | Optional, for API calls |

> Add to `docs/SECRETS.md` and `.env.example` when configuring.

---

## References

- [Stytch Redirect URLs](https://stytch.com/docs/workspace-management/redirect-urls)
- [Stytch OAuth](https://stytch.com/docs/api-reference/consumer/api/oauth/authenticate)
- [Stytch JS SDK — Cookies & session management](https://stytch.com/docs/sdks/javascript-sdk/resources/cookies-and-session-management)
- [Stytch Forum: SPA auth frontend vs backend](https://forum.stytch.com/t/should-i-authenticate-on-front-end-or-backend-building-an-spa/217)

---

*Last updated: 2026-02. Update placeholders as implementation progresses.*
