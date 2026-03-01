# DataTools Pro Documentation Reference

## Complete Folder Inventory

### `_general/` (7 files)
Role-based onboarding guides. No categories or tags.
- business-stakeholder-getting-started-guide-to-datatools-pro.json
- completing-datatools-pro-install-process.json
- data-professional-getting-started-guide-to-datatools-pro.json
- executive-getting-started-guide-to-datatools-pro.json
- getting-started-with-metrics-analyst-ai-for-salesforce-2.json
- other-getting-started-guide-to-datatools-pro.json
- product-leader-getting-started-guide-to-datatools-pro.json
- salesforce-admin-getting-started-guide.json
- salesforce-admin-getting-started-guide-2.json

### `administration/` (6 files)
Categories: `["DataTools Pro"]`
Tags: `["datatoolspro", "Administration"]`, optionally `"user management"`
- add-new-user-post-invite-process.json
- adding-multiple-salesforce-orgs-into-datatools-pro.json
- data-tools-access-and-region-availability.json
- manage-datatools-pro-account-and-users.json
- managing-datatools-pro-subscription.json
- security-policy-salesforce-connected-app.json

### `api/` (1 file)
Categories: `["DataTools Pro"]`
Tags: `["API", "datatoolspro"]`
- datatools-pro-api-documentation.json

### `data-migration/` (6 files)
Categories: `["DataTools Pro"]` or `["DataTools Pro", "Salesforce Data Migration"]`
Tags: `["datatoolspro", "Data Migration"]`, optionally `"Salesforce"`, `"Migration"`
- data-migration-scorecard-for-salesforce.json
- linking-data-migration-scorecard-to-external-resources-and-apps.json
- mapping-and-migrating-salesforce-picklists.json
- migrate-data-into-salesforce-video-series.json
- migration-export-sql.json
- salesforce-migration-field-mapping-details.json

### `dictionary/` (6 files)
Categories: `["DataTools Pro"]`
Tags: `["datatoolspro", "Dictionary"]`, optionally `"Salesforce"`, `"governance"`
- bulk-edit-multiple-metric-records.json
- datatools-pro-getting-started-guide.json
- field-history-tracking-for-salesforce.json
- object-explorer-for-datatools-pro-dictionary.json
- salesforce-field-dictionary-with-datatools-pro.json
- salesforce-object-access-in-datatools-pro.json
- schedule-salesforce-object-change-tracking.json

### `erd/` (3 files)
Categories: `["DataTools Pro"]`
Tags: `["datatoolspro", "ERD"]`, optionally `"Salesforce"`
- data-tools-erd-and-object-views.json
- datatools-erd-toolbar-overview.json
- salesforce-erd-step-by-step-guide.json

### `integrations/coda/` (1 file)
Categories: `["DataTools Pro"]`
Tags: `["coda", "datatoolspro"]`
- import-metrics-into-coda-with-datatools-pro-c.json

### `integrations/crm-analytics/` (1 file)
Categories: `["DataTools Pro"]`
Tags: `["crm analytics", "crma", "datatools", "datatoolspro"]`
- crm-analytics-dashboards-in-datatools-pro.json

### `integrations/github/` (1 file)
Categories: `["DataTools Pro"]`
Tags: `["datatoolspro", "GitHub"]`
- github-personal-access-token.json

### `integrations/notion/` (1 file)
Categories: `["DataTools Pro"]`
Tags: `["notion"]`
- export-metrics-to-notion.json

### `integrations/salesforce/` (2 files)
Categories: `["DataTools Pro"]`
Tags: `["datatoolspro", "documentation", "security"]`
- authorizing-an-salesforce-uninstalled-app.json
- salesforce-admin-install-guide.json

### `integrations/snowflake/` (4 files)
Categories: `["DataTools Pro", "Snowflake"]` or `["DataTools Pro", "DataTools Pro Explorer", "Snowflake"]`
Tags: `["Snowflake", "datatoolspro"]`, optionally `"datatools"`, `"Migration"`
- data-mapping-snowflake-to-salesforce.json
- datatools-pro-explorer.json
- datatools-pro-explorer-for-snowflake-release-notes.json
- how-to-generate-snowflake-client-id-and-secret-for-oauth.json

### `integrations/tableau/` (1 file)
Categories: `["DataTools Pro", "Tableau"]`
Tags: `["datatoolspro", "Tableau", "Tableau Pulse"]`
- tableau-pulse-import-to-datatools-pro-metrics-glossary.json

### `metrics/` (8 files)
Categories: `["DataTools Pro"]`, some add `"Tableau"`
Tags: `["datatoolspro", "metrics"]`, optionally `"alias"`, `"change management"`, `"Tableau Pulse"`
- bulk-metric-import-from-excel-and-csv.json
- getting-started-with-metrics-analyst-ai-for-salesforce.json
- getting-started-with-metrics-glossary-datatools-for-salesforce.json
- linking-metrics-and-kpi-relationships.json
- link-tableau-personal-access-token-to-datatools-pro.json
- merging-metrics.json
- metrics-alias.json
- metrics-change-history.json

### `reports-and-dashboards-datatools/` (6 files)
Categories: `["DataTools Pro"]`, one adds `"Salesforce"`
Tags: `["datatoolspro", "Reports and Dashboards DataTools"]`
- export-salesforce-report-to-excel.json
- manage-salesforce-dashboard-lifecycle-with-status.json
- refresh-salesforce-analytics.json
- salesforce-report-and-dashboard-views.json
- salesforce-reports-and-dashboards.json
- tag-salesforce-reports.json

## Category → Folder Routing

| Category | Routes to folder |
|----------|-----------------|
| `"DataTools Pro"` (only) | Determined by tags / feature area |
| `"DataTools Pro"` + `"Salesforce Data Migration"` | `data-migration/` |
| `"DataTools Pro"` + `"Snowflake"` | `integrations/snowflake/` |
| `"DataTools Pro"` + `"Tableau"` | `integrations/tableau/` or `metrics/` |
| `"DataTools Pro"` + `"Salesforce"` | `integrations/salesforce/` or `reports-and-dashboards-datatools/` |
| `"DataTools Pro"` + `"DataTools Pro Explorer"` | `integrations/snowflake/` |
| No categories | `_general/` |

## Tag → Folder Routing

| Primary Tag | Routes to |
|-------------|-----------|
| `"Administration"` | `administration/` |
| `"API"` | `api/` |
| `"Data Migration"` | `data-migration/` |
| `"Dictionary"` | `dictionary/` |
| `"ERD"` | `erd/` |
| `"metrics"` | `metrics/` |
| `"Reports and Dashboards DataTools"` | `reports-and-dashboards-datatools/` |
| `"Snowflake"` | `integrations/snowflake/` |
| `"Tableau"` / `"Tableau Pulse"` | `integrations/tableau/` |
| `"GitHub"` | `integrations/github/` |
| `"notion"` | `integrations/notion/` |
| `"coda"` | `integrations/coda/` |
| `"crm analytics"` / `"crma"` | `integrations/crm-analytics/` |
| `"documentation"` / `"security"` | `integrations/salesforce/` |

## Example: Complete New Doc

```json
{
  "post_id": null,
  "title": "Bulk Export Salesforce Metadata with DataTools Pro",
  "slug": "bulk-export-salesforce-metadata-with-datatools-pro",
  "url": "https://datatoolspro.com/tutorials/bulk-export-salesforce-metadata-with-datatools-pro/",
  "date": "2026-02-28T00:00:00",
  "modified": "2026-02-28T00:00:00",
  "categories": ["DataTools Pro"],
  "tags": ["datatoolspro", "Dictionary", "Salesforce"],
  "excerpt": "Export all Salesforce field metadata across objects in a single click with DataTools Pro.",
  "content_markdown": "[DataTools Pro](https://datatoolspro.com/ \"DataTools Pro\") enables you to bulk export Salesforce field metadata across all your connected objects. This feature streamlines governance and audit workflows by giving you a complete snapshot of your org's data model.\n\n## How to Access Bulk Metadata Export\n\n1. Navigate to **Dictionary** → **Object Explorer**.\n2. Select the objects you want to include.\n3. Click **Export** in the toolbar.\n\n![Bulk metadata export toolbar](https://datatoolspro.com/wp-content/uploads/2026/02/bulk-export-toolbar.webp)\n\n## Export Options\n\n- **CSV** – Export a CSV file containing all field metadata\n- **XLS** – Export an Excel file with separate sheets per object\n- **PDF** – Export a formatted PDF for stakeholder review\n\n## Security Notes\n\nExported metadata respects your Salesforce role and profile permissions. Fields your user cannot access in Salesforce will not appear in the export.\n\n[Learn more about DataTools Pro security.](https://datatoolspro.com/datatoolspro-data-security-faq/ \"DataTools Pro Data Security FAQ\")"
}
```

Saved to: `docs/public/dictionary/bulk-export-salesforce-metadata-with-datatools-pro.json`
