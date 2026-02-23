# Backend Architecture — Laravel API

---

## Pattern: Thin Controller → Service → Model

All business logic flows through a service layer. Controllers are routing glue only.

```
Request
  └── Form Request (validates input)
        └── Controller (delegates to service, returns response)
              └── Service (all logic: auth checks, business rules, orchestration)
                    └── Model (Eloquent queries and relationships)
                          └── Database (MySQL / Postgres via RDS)
```

### Example

```php
// ✅ Controller — thin, clean
class ReportController extends Controller
{
    public function store(CreateReportRequest $request, ReportService $service): JsonResponse
    {
        $report = $service->create($request->user(), $request->validated());
        return (new ReportResource($report))->response()->setStatusCode(201);
    }
}

// ✅ Service — all the logic
class ReportService
{
    public function create(User $user, array $data): Report
    {
        $this->authorize($user, 'create', Report::class);
        // business logic here
        return Report::create([...$data, 'organization_id' => $user->organization_id]);
    }
}
```

---

## Directory Map

```
app/
├── Console/          ← Artisan commands
├── Exceptions/       ← Custom exception classes
├── Http/
│   ├── Controllers/  ← Thin controllers (one per resource)
│   ├── Middleware/   ← Request middleware
│   ├── Requests/     ← Form Request validation classes
│   └── Resources/    ← API response transformers
├── Models/           ← Eloquent models (data + relationships only)
├── Policies/         ← Authorization policies
├── Providers/        ← Service providers
└── Services/         ← Business logic (one per domain area)
```

---

## Routing

```
routes/
├── api.php           ← All API routes (versioned under /api/v1/)
└── web.php           ← SPA catch-all (returns index.html)
```

Route structure:
```php
// routes/api.php
Route::prefix('v1')->middleware('auth:sanctum')->group(function () {
    Route::apiResource('reports', ReportController::class);
    Route::apiResource('users', UserController::class);
});
```

---

## Authentication Flow (Sanctum SPA)

```
1. SPA hits GET /sanctum/csrf-cookie   → sets CSRF cookie
2. SPA posts POST /login               → creates session
3. All subsequent requests include session cookie + CSRF header
4. Middleware: auth:sanctum validates session
```

---

## Testing Strategy

| Type | Location | What to test |
|---|---|---|
| Feature | `tests/Feature/` | Full HTTP request/response cycle |
| Unit | `tests/Unit/` | Services, helpers in isolation |
| Database | Use `RefreshDatabase` trait | Each test runs in a clean transaction |

```bash
# Run all tests
php artisan test

# Run specific suite
php artisan test --filter=ReportTest
```

---

## Current Services

<!-- Update this table as services are built -->

| Service | Purpose |
|---|---|
| [Service] | [What it handles] |

---

## Current Models

<!-- Update this table as models are built — link to data-model.mdc for full detail -->

| Model | Table | Key Relationships |
|---|---|---|
| [Model] | [table] | [belongs to / has many] |

---

## Open Questions / TODOs

- [ ] Define API versioning strategy (`/api/v1/` prefix — confirm)
- [ ] Define queue driver for background jobs (Redis? SQS?)
- [ ] Define file storage driver (S3 bucket name, env var)
- [ ] Confirm MySQL vs Postgres for RDS
