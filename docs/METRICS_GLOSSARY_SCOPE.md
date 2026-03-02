# Metrics Glossary — Feature Scope & Technical Documentation

> **Generated:** February 18, 2026  
> **Codebase:** DTP_Bootstap_V2_Baseline  
> **Purpose:** Complete reference for the current state of the Metrics Glossary feature

---

## Table of Contents

1. [Feature Overview](#1-feature-overview)
2. [Entry Points & Navigation](#2-entry-points--navigation)
3. [Metrics Analyst Wizard (AI-Powered Discovery)](#3-metrics-analyst-wizard-ai-powered-discovery)
4. [Suggested Metrics — Review & Accept Flow](#4-suggested-metrics--review--accept-flow)
5. [Categorization Step](#5-categorization-step)
6. [Main Metrics Glossary Index](#6-main-metrics-glossary-index)
7. [Glossary Sandbox (Admin Tool)](#7-glossary-sandbox-admin-tool)
8. [AI Services Architecture](#8-ai-services-architecture)
9. [Data Models](#9-data-models)
10. [Full Route Reference](#10-full-route-reference)
11. [Controllers Reference](#11-controllers-reference)
12. [Permissions & Feature Flags](#12-permissions--feature-flags)
13. [Gamification](#13-gamification)
14. [Known Limitations & Notes](#14-known-limitations--notes)

---

## 1. Feature Overview

The **Metrics Glossary** is the core data model management system in DataTools Pro. It allows teams to:

- **Discover** metrics embedded in Salesforce dashboards and reports using AI
- **Stage and review** AI-generated metric suggestions before they enter the glossary
- **Manually define** metrics with rich metadata (definitions, formulas, aliases, categories)
- **Categorize** metrics by line of business and custom taxonomies
- **Link** metrics to source dashboards, reports, and other tools (Tableau, Snowflake, HubSpot)
- **Merge** duplicate or overlapping metric suggestions into a single canonical record

The system is organized around two primary surfaces:
1. **Metrics Analyst** — a guided, AI-assisted wizard for discovering and onboarding metrics
2. **Metrics Index** — the full glossary management table where all canonical metrics live

---

## 2. Entry Points & Navigation

| Surface | URL | Description |
|---------|-----|-------------|
| Metrics Analyst Wizard | `/metric-analyst` | 4-step guided AI discovery flow |
| Metrics Glossary Index | `/metrics` | Full table of all canonical metrics |
| Single Metric Detail | `/metrics/{id}` | Per-metric detail/edit page |
| Glossary Sandbox | `/metric-analyst/glossary-sandbox` | Admin-only API debug tool |

Navigation context is determined by a `?tools=` query parameter (`salesforce`, `tableau`, `snowflake`, `hubspot`), which swaps the tool-specific sub-navigation bar.

Permission check: The Metrics Analyst wizard is gated behind `canListMetric`. Users without permission see a "contact your administrator" message rather than the wizard.

---

## 3. Metrics Analyst Wizard (AI-Powered Discovery)

**View:** `resources/views/metric_analyst/index.blade.php`  
**Controller:** `app/Http/Controllers/MetricAnalystController.php`  
**Primary Route:** `GET /metric-analyst`

This is a single-page, JavaScript-driven multi-step wizard. It handles two paths: **dashboard-driven** (AI full pipeline) and **report-driven** (simple manual onboarding).

---

### Step Indicator (Visual Progress Bar)

The wizard renders a 4-step indicator at the top:

| # | Label | Notes |
|---|-------|-------|
| 1 | Enter Metric | Always complete once user begins |
| 2 | Select Analytic | Active during dashboard/report selection; shows clock icon while loading |
| 3 | Explore Metrics | Active during AI analysis results display |
| 4 | Categorize | Active during categorization; shown after metrics are accepted |

---

### Step 1 — Enter Metric Name

- User types a metric name (e.g., `Revenue`).
- "Find Dashboards" button is disabled until input is non-empty.
- Pressing **Enter** also submits.
- On submit → calls `POST /metric-analyst/search` which performs a **LIKE** search (case-insensitive) on:
  - `dashboards.title` (returns up to 3 matching, `custom_type = 0`)
  - `reports.name` (returns up to 3 matching, `custom_type = 0`)
- Returns both sets of results; first goes to **Dashboard Selection** step.

---

### Step 2 — Dashboard Selection

Displays up to 3 matching Salesforce dashboards as selectable cards. Each card shows:
- Dashboard title
- Description
- Last Modified Date (formatted `n/j/Y`)
- **Salesforce deep-link button** (opens the dashboard in Salesforce Lightning in a new tab)

**Buttons available:**
| Button | Condition | Action |
|--------|-----------|--------|
| Proceed with Selected Dashboard | Dashboard selected | Triggers 3-call AI pipeline |
| Locate Dashboards Manually | No dashboards found | Opens full DataTable of all dashboards |
| Fetch latest dashboards | No dashboards found | Calls `POST /dashboards/refresh` then resets to Step 1 |
| Search in Reports Instead | Always visible | Falls through to Report Selection step |

If **Locate Dashboards Manually** is clicked, a DataTable (`analyze_dashboards_with_openai`) is rendered populated via `GET /get-not-added-dash-to-analyze`. Each row has an "Add" button that triggers `handleProceedWithDashboard` directly.

---

### Step 3A — Loading / AI Processing (Dashboard Path)

When a dashboard is selected and "Proceed" is clicked, three sequential AJAX calls are made, with a rotating loading screen shown throughout:

#### Call 1 — Analyze Dashboard Metadata
```
POST /metric-analyst/analyz
```
- Calls Salesforce REST API: `GET /analytics/dashboards/{DId}`
- Saves dashboard `meta_data` to `analyze_dashboards` table
- For each component in the dashboard, fetches report metadata from Salesforce: `GET /analytics/reports/{reportId}/describe`
- Saves each report's metadata to `analyze_dashboards_reports` table
- If a report does not yet exist in the local `reports` table, fetches full report details via SOQL and inserts it
- Handles `INVALID_SESSION_ID` (Salesforce session expiry) with a popup

#### Call 2 — Analyze Widgets (Service 1)
```
GET /metric-analyst/analyze-widgets
```
- Assembles dashboard + report metadata JSON
- Stores payload as `metric_api_responses.payload_first_api`
- POSTs to **Service 1** (`service_one_stage` env variable) with bearer token `jwt-auth-datatoolspro`
- Service 1 returns structured widget-level data
- Stores each widget as an `api_response_widgets` record with fields: `dboard_name`, `dboard_id`, `dwidgetid`, `header`, `visualization_type`, `reportFormat`, `report_id`, `agg_col`, `agg_type`, `col_explain`, `report_name`, `label`, `col`, `report_filters`, `agg`
- Stores raw response as `metric_api_responses.first_api_response`

#### Call 3 — Generate Business Metrics Glossary (Service 2)
```
GET /metric-analyst/business-metrics-glossary
```
- Collects all non-ignored widgets from `api_response_widgets`
- Collects all existing team metrics from the `metrics` table (including their aliases, categories/taxonomies)
- Builds a combined payload:
  ```json
  {
    "metric": [ /* existing metrics with name, definition, description, logic, aliases, categories */ ],
    "analyze": [ /* widget-level data from Service 1 */ ]
  }
  ```
- POSTs to **Service 2** (`service_two_dev` env variable) with 300-second timeout
- Stores payload as `metric_api_responses.payload_second_api`
- Service 2 returns an array of metric suggestions, each containing:
  - `Metric Name`
  - `Metric Description (LLM)`
  - `Metric Formula (LLM)`
  - `Topic`
  - `Dashboard IDs`
  - `Report ID`
  - `Report Name`
  - `Classification`
  - `Known Metric`
  - `Known Formula`
  - `Known Metric by Formula`
- **Auto-ignore logic**: If `Known Metric` equals `Known Metric by Formula` (case-insensitive), the suggestion is stored with `ignore = 1` (it already exists in the glossary)
- All suggestions stored as `api_response_metrics` records
- Counts returned to UI: `ignoreCount`, `suggestedCount`
- Loading messages cycle every 6 seconds: "generating metric definitions" → "discovering overlapping metrics" → "formulating recommendations" → "considering any duplicates"

---

### Step 3B — Report Path (No AI)

When the user chooses "Search in Reports Instead" or no dashboards exist:

1. The same metric name search results are used (reports returned in Step 1).
2. User selects a report card (same layout as dashboard cards, with Salesforce deep-link button).
3. Clicking **"Relate this Report to my Metric"** calls:
   ```
   POST /metric-analyst/add
   ```
4. This directly creates a `Metric` record with:
   - `name` = the entered metric name
   - `creation_method` = `input`
   - Links the selected report via `metric_reports`
5. No AI calls are made in this path.
6. After creation, the user proceeds to the **Categorize** step.

---

## 4. Suggested Metrics — Review & Accept Flow

After the AI pipeline completes, the **Suggested Metrics** table is rendered dynamically inside the Analysis step (`#ananlyz-resource-grid`). It is loaded via:

```
GET /suggested_metrics
```
which returns all `api_response_metrics` where `ignore = 0` for the current team's `MetricApiResponse`.

### Table Structure

| Column | Notes |
|--------|-------|
| Checkbox | For bulk selection (only shown when >1 suggestion) |
| Action | `+` (Add) and `-` (Dismiss) buttons |
| Metric | `metric_name` field |
| Description | `metric_description_llm` — **inline editable** |

Deduplication is applied client-side: only the first occurrence of each `metric_name` (trimmed) is shown.

---

### Action: Add Single (`+` button)

```
POST /metrics/add-response-metric  { id: <api_response_metric_id> }
```

- Creates a new `Metric` with `name` and `definition` (from LLM description)
- `creation_method` = `api_metric`
- Assigns `Topic` to the `topic` taxonomy if present
- Links the Salesforce Dashboard (via `metric_dashboards` table)
- Links the Salesforce Report (via `metric_reports` table)
- Deletes the `api_response_metrics` record
- Returns `created_metric_ids` → unlocks "Categorize Your Metric" CTA button

---

### Action: Dismiss (`-` button)

```
POST /metrics/metric-ignore  { id: <api_response_metric_id> }
```
Sets `api_response_metrics.ignore = 1`. The row is removed from the UI. Can be restored later via `POST /metrics/metric-ignore-restore`.

---

### Action: Inline Description Edit

- Click or double-click on any description cell, or click the pencil icon
- A `<textarea>` appears in-place
- On `blur` or `Enter`, saves to the API:
  ```
  POST /metrics/update-description  { metric_id, description }
  ```
  Updates `api_response_metrics.metric_description_llm`
- `Escape` cancels the edit

---

### Action: Bulk Add (Multiple Selected)

```
POST /metrics/add-multiple-responsive-metric  { metric_ids: [id1, id2, ...] }
```
Creates a separate `Metric` record for each selected suggestion. Same field mapping as single Add. All created metric IDs returned to client for categorization.

---

### Action: Merge (Offcanvas Panel)

When 2+ suggestions are selected and "Merge" is clicked, a **Bootstrap Offcanvas panel** slides in from the right offering two paths:

#### Path A — Create New Merged Metric
```
POST /metrics/merge-response-metric
{
  primary_metric: <api_response_metric_id>,  // becomes the new metric name
  merge_metric: [<id1>, <id2>, ...]           // become aliases
}
```
- Creates a new `Metric` using the **primary** suggestion's name and LLM description
- Each **merge** suggestion's name is created as an `Alias` and attached via `metric_aliases` pivot (with `is_primary = false`)
- Dashboards and reports from all merged suggestions are linked to the new metric
- Topic taxonomy assigned from the primary
- All merged `api_response_metrics` rows deleted
- Returns `created_metric_ids`

#### Path B — Merge into Existing Metric
```
POST /metrics/merge-response-metric-with-existing-metric
{
  metric_id: <existing_metric.id>,
  merge_metric: [<api_response_metric_id1>, ...]
}
```
- Finds the existing `Metric` by ID
- Each suggestion becomes an `Alias` on the existing metric
- Dashboards and reports from suggestions are linked to the existing metric
- Suggestions deleted
- Returns `created_metric_ids`

---

## 5. Categorization Step

After any accept/merge action, the **"Categorize Your Metric"** button appears. Clicking it transitions to the Categorize step.

### Pre-defined Line of Business Options

| Category | Description |
|----------|-------------|
| Sales | Revenue, leads, conversions, pipeline metrics |
| Marketing | Campaigns, attribution, ROI, brand metrics |
| Operations | Efficiency, process, quality, service metrics |
| Executive | Strategic, financial, performance KPIs |
| Other | Free-text custom category |

**Rules:**
- Multiple categories can be selected simultaneously (except "Other" is exclusive)
- Selecting "Other" deselects all other options and shows a free-text input
- "Categorize" button remains disabled until at least one valid selection is made

### Submission
```
POST /metrics/categorize-selected-metrics
{
  metric_ids: [id1, id2, ...],
  categories: ["Sales", "Marketing", ...]
}
```
- Looks up the `line_of_business` taxonomy for the current user
- `firstOrCreate`s a `TaxonomyValue` for each category label
- Creates `MetricTaxonomy` join records linking each metric to each taxonomy value
- On success → redirects to the **Metrics Index** page (`/metrics`)

---

## 6. Main Metrics Glossary Index

**View:** `resources/views/pages/metrics.blade.php`  
**Controller:** `app/Http/Controllers/MetricsController.php`  
**Route:** `GET /metrics`

This is the canonical glossary management page — all accepted metrics live here.

### Key UI Features

- **Add Metrics** dropdown: manual text input, GA4 import, and tool-specific imports
- **DataTable** of all team metrics (ordered alphabetically by name)
- **Taxonomy columns** dynamically rendered per the team's `Taxonomy` configuration
- **Show Data Details** toggle
- **Field change history** (clock icon) — opens a log of all changes to metric fields
- **Tool context** (query param `?tools=`): changes the sub-nav bar for Salesforce, Tableau, Snowflake, HubSpot

### Metric Fields (from `Metric` model)

| Field | Notes |
|-------|-------|
| `name` | Canonical metric name |
| `definition` | Business definition |
| `description` | Additional description |
| `logic` | General logic description |
| `status` | `scoping`, `review`, `production`, `retired` — shown as a color-coded dropdown |
| `business_owner` | Owner name |
| `related_date_time` | Date field reference |
| `target_interval` | Measurement interval |
| `date_field_name` | Associated date field |
| `creation_method` | `input`, `api_metric`, `ga4`, `tableau`, etc. |
| `dt_metric_id` | Random 8-digit internal ID |
| `team_id` | Multi-tenant team scoping |

### Metric Relationships

| Relationship | Join Table | Description |
|---|---|---|
| Aliases | `metric_aliases` (via `Alias` model) | Alternate names, with `is_primary` flag |
| Taxonomy Values | `metric_taxonomies` | Categories/LOB/Topic assignments |
| Reports | `metric_reports` | Linked Salesforce reports |
| Dashboards | `metric_dashboards` | Linked Salesforce dashboards |
| Tableau Dashboards | `metric_tableau` | Linked Tableau dashboards |
| Linked Metrics | `metric_links` | Metric-to-metric relationships (with `RelationshipType`) |
| Logic Implementations | `metric_logic_implementations` | Per-system logic definitions |
| Semantic Views | `metric_semantic_views` | Linked Snowflake Semantic Models |
| Change Logs | `metric_logs` | Full field change audit trail |

### Status Dropdown Colors

| Status | Color |
|--------|-------|
| Default / active | Teal (`#20b2aa`) |
| Scoping | Amber (`#fbb034`) |
| Review | Red (`#ff7b7b`) |
| Production | Green (`#51cf66`) |
| Retired | Gray (`#868e96`) |

---

## 7. Glossary Sandbox (Admin Tool)

**View:** `resources/views/metric_analyst/glossary_sandbox.blade.php`  
**Route:** `GET /metric-analyst/glossary-sandbox` (middleware: `is_admin`)  
**Run Endpoint:** `GET /metric-analyst/glossary-sandbox/run` (middleware: `is_admin`)

A developer/admin debugging tool that allows inspection and re-running of both AI service calls without persisting results.

### Features

- **Service 1 Section**: Shows the exact JSON payload that was last sent to `service_one_stage`, calls the service live, and displays the response
- **Service 2 Section**: Builds the Service 2 payload (same logic as the production flow: existing metrics + non-ignored widgets), calls `service_two_dev` live, displays response
- **Endpoint override inputs**: Allows overriding either service URL per-run (useful for testing staging vs. prod endpoints)
- **Copy-to-clipboard** buttons on all payload and response textareas
- HTTP status code shown per service call
- Error display if either service fails

> **Note:** The sandbox reads the stored `payload_first_api` from the most recent `MetricApiResponse` record for the team. Requires "Analyze Widgets" to have been run first.

---

## 8. AI Services Architecture

The Metrics Glossary AI pipeline depends on two external microservices configured via environment variables.

### Service 1 — Widget Extractor (`service_one_stage`)

**Purpose:** Parse raw Salesforce dashboard and report metadata into structured widget records.

**Input:** Array of `[dashboard_metadata, report_metadata, report_metadata, ...]` arrays (one per analyzed dashboard).

**Output:** Array of widget objects, each containing:

```json
{
  "dboard_name": "...",
  "dboard_id": "...",
  "id": "widget_id",
  "header": "Widget Title",
  "visualizationType": "metric|chart|table|...",
  "reportFormat": "...",
  "reportId": "...",
  "aggCol": "column_name",
  "aggType": "SUM|COUNT|AVG|...",
  "col_explain": "human readable column explanation",
  "reportName": "...",
  "label": "...",
  "col": "raw_column_name",
  "reportFilters": {...},
  "agg": "..."
}
```

**Authentication:** Bearer token `jwt-auth-datatoolspro`

---

### Service 2 — LLM Metric Generator (`service_two_dev`)

**Purpose:** Using existing team metrics as context, generate a normalized Business Metrics Glossary from widget data.

**Input:**
```json
{
  "metric": [ /* existing metrics: name, definition, description, logic, aliases, categories */ ],
  "analyze": [ /* widget objects from Service 1, ignore=0 only */ ]
}
```

**Output:** Array of suggested metric objects:
```json
{
  "Metric Name": "...",
  "Metric Description (LLM)": "...",
  "Metric Formula (LLM)": "...",
  "Topic": "...",
  "Dashboard IDs": "...",
  "Report ID": "...",
  "Report Name": "...",
  "Classification": "...",
  "Known Metric": "...",
  "Known Formula": "...",
  "Known Metric by Formula": "..."
}
```

**Auto-ignore:** If `Known Metric == Known Metric by Formula` (case-insensitive), the suggestion is stored with `ignore=1` (already exists in the glossary in the same or equivalent form).

**Timeout:** 300 seconds (5 minutes)

**AI feature kill switch:** `AppSetting::get('ai_features_disabled')` — if `'1'`, the Service 2 call is blocked and returns a user-facing error.

---

## 9. Data Models

### Core Models

| Model | Table | Purpose |
|-------|-------|---------|
| `Metric` | `metrics` | Canonical metric record |
| `Alias` | `aliases` | Alternate metric names |
| `Taxonomy` | `taxonomies` | Category dimension definitions (e.g., Line of Business, Topic) |
| `TaxonomyValue` | `taxonomy_values` | Specific values within a taxonomy |
| `MetricTaxonomy` | `metric_taxonomies` | Metric ↔ TaxonomyValue join |
| `MetricReport` | `metric_reports` | Metric ↔ Report join |
| `MetricDashboard` | `metric_dashboards` | Metric ↔ Dashboard join |
| `MetricLink` | `metric_links` | Metric ↔ Metric relationship |
| `RelationshipType` | `relationship_types` | Types of metric-to-metric relationships |
| `MetricLog` | `metric_logs` | Field change audit trail |
| `MetricLogicImplementation` | `metric_logic_implementations` | Per-system (SFDC, Snowflake, etc.) logic |

### AI Pipeline Models

| Model | Table | Purpose |
|-------|-------|---------|
| `MetricApiResponse` | `metric_api_responses` | Per-team storage of API payloads and responses |
| `ApiResponseWidget` | `api_response_widgets` | Widget-level output from Service 1 |
| `ApiResponseMetric` | `api_response_metrics` | Staged/pending metric suggestions from Service 2 |
| `AnalyzeDashboard` | `analyze_dashboards` | Dashboards selected for analysis |
| `AnalyzeDashboardsReport` | `analyze_dashboards_reports` | Reports within analyzed dashboards |

### `ApiResponseMetric` Key Fields

| Field | Description |
|-------|-------------|
| `metric_name` | AI-suggested name |
| `metric_description_llm` | AI-generated description (inline-editable before acceptance) |
| `metric_formula_llm` | AI-generated formula |
| `Topic` | Suggested topic/category |
| `dashboard_id` | Source Salesforce Dashboard ID |
| `reports` | Source Salesforce Report ID |
| `report_name` | Report name |
| `classification` | AI classification |
| `known_metric` | Matched existing metric name |
| `known_formula` | Matched existing formula |
| `known_metric_by_formula` | Metric identified by formula match |
| `ignore` | `0` = active suggestion, `1` = dismissed or auto-ignored |
| `api_responses_id` | FK to `metric_api_responses` |

---

## 10. Full Route Reference

### Metrics Analyst Routes

| Method | URL | Route Name | Controller | Description |
|--------|-----|------------|------------|-------------|
| GET | `/metric-analyst` | `metric.analyst` | MetricAnalystController@index | Wizard page |
| POST | `/metric-analyst/search` | `metric.analyst.search` | MetricAnalystController@search | Search dashboards/reports by name |
| POST | `/metric-analyst/analyz` | `analyzForMetricAnalyst` | MetricAnalystController@analyzForMetricAnalyst | Fetch SF metadata for selected dashboard |
| GET | `/metric-analyst/analyze-widgets` | `analyzeWidgets` | MetricAnalystController@analyzeWidgets | Call Service 1 |
| GET | `/metric-analyst/business-metrics-glossary` | `businessMetricGlossary` | MetricAnalystController@businessMetricGlossary | Call Service 2 |
| GET | `/metric-analyst/glossary-sandbox` | `metricAnalystGlossarySandbox` | MetricAnalystController@glossarySandbox | Admin sandbox (is_admin) |
| GET | `/metric-analyst/glossary-sandbox/run` | `metricAnalystGlossarySandboxRun` | MetricAnalystController@runGlossarySandbox | Admin run sandbox (is_admin) |
| POST | `/metric-analyst/add` | `metricAnalystAddMetric` | MetricAnalystController@addMetric | Add metric from report flow |

### Suggested Metrics Lifecycle Routes

| Method | URL | Route Name | Controller | Description |
|--------|-----|------------|------------|-------------|
| GET | `/suggested_metrics` | `suggestedMetrics` | AnalyzeDashboardController@suggestedMetrics | List active suggestions |
| GET | `/ignored-metrics` | `ignoredMetrics` | AnalyzeDashboardController@ignoredMetrics | List dismissed suggestions |
| POST | `/metrics/metric-ignore` | `igoreResponseMetric` | AnalyzeDashboardController@igoreResponseMetric | Dismiss a suggestion |
| POST | `/metrics/metric-ignore-restore` | `igoreResponseMetricRestore` | AnalyzeDashboardController@igoreResponseMetricRestore | Restore dismissed suggestion |
| POST | `/metrics/ignore-widget` | `igoreResponseWidget` | AnalyzeDashboardController@igoreResponseWidget | Suppress a widget |
| POST | `/metrics/add-response-metric` | `addResponseMetric` | AnalyzeDashboardController@addResponseMetric | Accept single suggestion |
| POST | `/metrics/add-multiple-responsive-metric` | `addMultipleResponsiveMetric` | AnalyzeDashboardController@addMultipleResponsiveMetric | Accept multiple suggestions |
| POST | `/metrics/merge-response-metric` | `mergeResponseMetric` | AnalyzeDashboardController@mergeResponseMetric | Merge into new metric |
| POST | `/metrics/merge-response-metric-with-existing-metric` | `mergeResponseMetricWithExistingMetrics` | AnalyzeDashboardController@mergeResponseMetricWithExistingMetrics | Merge into existing metric |
| POST | `/metrics/update-description` | `updateMetricDescription` | AnalyzeDashboardController@updateDescription | Inline edit LLM description |
| POST | `/metrics/categorize-selected-metrics` | `categorizeSelectedMetrics` | AnalyzeDashboardController@categorizeSelectedMetrics | Assign LOB taxonomy |

### Main Glossary Routes

| Method | URL | Route Name | Controller | Description |
|--------|-----|------------|------------|-------------|
| GET | `/metrics` | `metrics.index` | MetricsController@index | Main glossary page |
| POST | `/get-all-metrics` | `getMetrics` | MetricsController@getMetrics | Get metrics list (for merge panel) |
| GET | `/generate-business-metrics-glossary` | `generateBusinessMetricsGlossary` | AnalyzeDashboardController@generateBusinessMetricsGlossary | Legacy endpoint for Service 2 |

---

## 11. Controllers Reference

### `MetricAnalystController`
(`app/Http/Controllers/MetricAnalystController.php`)

| Method | Description |
|--------|-------------|
| `index()` | Renders the wizard page |
| `search(Request)` | LIKE search on dashboards + reports |
| `analyzForMetricAnalyst(Request)` | Salesforce API metadata fetch + store |
| `analyzeWidgets()` | Service 1 call + widget storage |
| `businessMetricGlossary()` | Service 2 call + suggestion storage |
| `glossarySandbox()` | Admin sandbox view |
| `runGlossarySandbox(Request)` | Admin: run both services live |
| `addMetric(Request)` | Direct metric creation from report path |

### `AnalyzeDashboardController`
(`app/Http/Controllers/AnalyzeDashboardController.php`)

| Method | Description |
|--------|-------------|
| `generateBusinessMetricsGlossary()` | Legacy Service 2 call (checks AI kill switch) |
| `suggestedMetrics()` | Returns non-ignored `ApiResponseMetric` records |
| `ignoredMetrics()` | Returns ignored `ApiResponseMetric` records |
| `suggestedCategories()` | Returns distinct topics from suggestions |
| `igoreResponseMetric(Request)` | Sets `ignore=1` on a suggestion |
| `igoreResponseMetricRestore(Request)` | Sets `ignore=0` on a suggestion |
| `igoreResponseWidget(Request)` | Suppresses a widget |
| `addResponseMetric(Request)` | Creates `Metric` from single suggestion |
| `addMultipleResponsiveMetric(Request)` | Creates `Metric` from multiple suggestions |
| `mergeResponseMetric(Request)` | Creates merged `Metric` from suggestions |
| `mergeResponseMetricWithExistingMetrics(Request)` | Merges suggestions into existing `Metric` |
| `categorizeSelectedMetrics(Request)` | Assigns `line_of_business` taxonomy values |
| `updateDescription(Request)` | Updates `metric_description_llm` inline |
| `fetchTransformedMetrics($system)` | Returns structured metrics for OpenAPI/external use |

### `MetricsController`
(`app/Http/Controllers/MetricsController.php`)

| Method | Description |
|--------|-------------|
| `index(Request)` | Glossary index page with taxonomies |
| `store(Request)` | Create metric via manual input |
| `addGa4Metric(Request)` | Import metric from GA4 source |
| `getMetrics()` | Returns metrics list for merge offcanvas |

---

## 12. Permissions & Feature Flags

| Check | Mechanism | Effect |
|-------|-----------|--------|
| `canListMetric` | `$user->hasPermission('create-metric', $team->id)` | Gates Metrics Analyst wizard UI |
| `canAddMetric` | `$user->hasPermission('create-metric', $team->id)` | Gates Add Metrics button on Index |
| `canEditMetric` | `$user->hasPermission('edit-metric', $team->id)` | Gates inline edits on Index |
| `canPushToNotion` | Passed from controller to blade | Shows/hides Notion push button |
| Admin-only sandbox | `is_admin` middleware | Blocks non-admins from Glossary Sandbox |
| AI kill switch | `AppSetting::get('ai_features_disabled') === '1'` | Blocks Service 2 call; returns user-facing error |

---

## 13. Gamification

Two badge events are triggered in the Metrics Glossary flow:

| Event | Trigger | Badge Name |
|-------|---------|------------|
| `Add First Metric` | First metric created (via any `store` or `addMetric` call) | "Add First Metric" badge |
| `Metrics Analyst` | Successful completion of Service 2 glossary generation | "Metrics Analyst" badge |

On badge award:
- Server returns `showConfetti: "yes"` and `badge: { name, image_url }`
- Client fires `confetti()` animation
- Modal `#confetti_popup` opens showing badge name and image

---

## 14. Known Limitations & Notes

1. **Single team session for AI pipeline**: `MetricApiResponse` stores one record per team (`updateOrCreate`). Running the wizard for a new metric **overwrites** the previous AI session's widgets and suggestions for that team.

2. **Duplicate `MetricAnalystController::businessMetricGlossary` vs `AnalyzeDashboardController::generateBusinessMetricsGlossary`**: Both methods implement nearly identical Service 2 logic. The `AnalyzeDashboardController` version includes the AI kill-switch check and better error logging (`NoResultLog`). The `MetricAnalystController` version is called from the wizard UI; the `AnalyzeDashboardController` version is on the legacy route `/generate-business-metrics-glossary`.

3. **Multiple catch blocks with same type**: `MetricAnalystController::businessMetricGlossary` has three consecutive `catch (\Exception $e)` blocks — only the first one will ever execute (the others are unreachable). The `AnalyzeDashboardController` version correctly uses distinct exception types (`ConnectException`, `RequestException`, `\Exception`).

4. **No pagination on suggested metrics**: All active suggestions are loaded at once. For large Salesforce orgs with many widgets, this could produce a very long list.

5. **Widget ignore is soft**: Suppressed widgets (via `igoreResponseWidget`) are excluded from future Service 2 runs but remain in the database.

6. **`AnalyzeDashboard::query()->delete()` in wizard**: The `analyzForMetricAnalyst` call in `MetricAnalystController` deletes **all** previously analyzed dashboards before inserting the new selection. This is a global reset of the analysis state for all teams.

7. **Service 1 and Service 2 URLs are environment-specific**: `service_one_stage` and `service_two_dev` are env variables — the naming suggests staging/dev endpoints are currently used even in production flows.

8. **Taxonomy API name dependencies**: The categorize flow hard-codes the `api_name` of `line_of_business` to find the correct taxonomy. If this taxonomy doesn't exist for a user, categorization will fail with a 400 error.
