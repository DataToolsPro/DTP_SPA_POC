# DataTools Pro — Integrations

DataTools Pro connects to the broader data and analytics ecosystem through two categories of integrations:

- **Data In** — source systems that feed data, metrics, and metadata into DataTools Pro
- **Data Out** — distribution channels that push DataTools content to other tools and consumers

---

## Data In — Source Integrations

### Salesforce ✅ Live
**Type:** Connected App (Salesforce AppExchange)
**Used By:** All five tools

DataTools Pro is a Salesforce AppExchange connected app. Salesforce is the primary data source for the entire platform:
- Objects and fields → Data Dictionary
- Object relationships → ERD
- Reports and dashboards → Metrics Analyst + Report Management
- Org metadata → Migration target mapping

All connections use OAuth. DataTools reads Salesforce metadata — it does not write schema back to Salesforce.

---

### Tableau Pulse ✅ Live
**Type:** Native integration
**Used By:** Metrics Glossary (import)

DataTools Pro natively connects to and consumes Tableau Pulse metrics. Tableau Pulse is a metrics management and analysis solution that automatically trends, analyzes, and predicts future trends. DataTools imports Tableau Pulse metrics into the Metrics Glossary for centralized governance and deduplication.

**Metric `source` value:** `tableau_import`

---

### Google Analytics 4 ✅ Live
**Type:** Native integration
**Used By:** Metrics Glossary (import)

Connects to Google Analytics 4 to import web and marketing funnel metrics. Users select from the officially supported GA4 metrics list to build a comprehensive inventory of funnel metrics alongside their Salesforce metrics.

**Metric `source` value:** `ga_import`

**Use case:** Marketing teams governing their full funnel — from GA4 web metrics through to Salesforce pipeline metrics — in one unified glossary.

---

### Zapier ✅ Live
**Type:** Zapier connector
**Used By:** Metrics Glossary (import)

Streams metrics from any data, analytics, or productivity tool supported by Zapier into DataTools Pro. Extends import coverage beyond the natively supported sources (Salesforce, Tableau, GA4).

**Metric `source` value:** `manual` (imported via Zapier automation)

**Use case:** Teams using tools not natively supported (HubSpot, Mixpanel, Amplitude, etc.) can pipe metrics into the glossary via Zapier workflows.

---

### Excel / CSV ✅ Live
**Type:** File import
**Used By:** Metrics Glossary (import), Data Migration (source schema import)

Manual import path for teams with existing metrics documentation in spreadsheets, or source system schemas exported as CSV.

**Metric `source` value:** `excel_import`

---

## Data Out — Distribution Integrations

### REST API ✅ Live
**Type:** HTTP REST API
**Used By:** Any external application or AI copilot

DataTools Pro exposes its governed metrics glossary via a REST API. Enables:
- Embedding metric definitions in internal business applications
- Feeding AI copilots with governed, authoritative metric context
- Programmatic access for custom integrations not covered by native connectors

**Primary use case:** AI copilots and data portals that need a trusted, governed metrics definition layer.

---

### Coda ✅ Live
**Type:** Coda Pack (native)
**Used By:** Business stakeholders consuming the Metrics Glossary

The DataTools Pro Coda Pack provides direct connectivity from Coda documents to the live metrics glossary. Business stakeholders get an always-up-to-date view of metrics per line of business and/or business topic — embedded directly in their Coda workspace.

---

### Notion 🗓 Coming Soon
**Type:** Native push integration
**Used By:** Business stakeholders consuming the Metrics Glossary

Push the metrics glossary from DataTools Pro directly to Notion with a single click. DataTools handles the pipeline — including versioning — so stakeholders can consume metrics in their existing Notion workspace and teams can track where glossaries reside.

---

### GitHub 🗓 Coming Soon
**Type:** Native Git integration
**Used By:** Data Migration Tools (SQL code output)

The Data Migration SQL code generator will integrate directly with GitHub to apply version control to generated mapping code out of the box. Engineers get versioned SQL migration scripts without a manual copy-paste step.

**Use case:** Migration engineers can generate updated SQL as mappings are confirmed, commit directly to a feature branch, and track changes over time.

---

## Integration Summary Table

| Integration | Direction | Status | Used By |
|---|---|---|---|
| Salesforce | In | ✅ Live | All tools |
| Tableau Pulse | In | ✅ Live | Metrics Glossary |
| Google Analytics 4 | In | ✅ Live | Metrics Glossary |
| Zapier | In | ✅ Live | Metrics Glossary |
| Excel / CSV | In | ✅ Live | Metrics Glossary, Data Migration |
| REST API | Out | ✅ Live | Any external app / AI copilot |
| Coda | Out | ✅ Live | Metrics Glossary consumers |
| Notion | Out | 🗓 Coming Soon | Metrics Glossary consumers |
| GitHub | Out | 🗓 Coming Soon | Data Migration SQL output |

---

## Notes for the AI

When writing code that touches integrations:
- Salesforce connection always uses OAuth — never store raw credentials; use the `access_token`/`refresh_token` on `SalesforceOrg`
- Import integrations (Tableau, GA4, Zapier, Excel) always result in `Metric` records with the appropriate `source` value
- Distribution integrations (REST API, Coda, Notion) read from the published metrics glossary — they should only surface `status = published` metrics
- GitHub integration is scoped to Data Migration SQL output only — not general code export
- Zapier connector exposes DataTools as both a trigger and action source (exact spec TBD)
