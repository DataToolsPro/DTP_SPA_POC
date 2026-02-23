# Tool: Data Dictionary

**Part of:** DataTools Pro
**Primary users:** Salesforce Administrators, Data Analysts, Analytics Professionals

---

## What It Does

Data Dictionary provides quick, live access to every Salesforce object and field — enriched with business context. Unlike a static Excel export or a published Salesforce field list, the DataTools Data Dictionary is a **living connected asset** that:

- Stays linked to the actual Salesforce org (not a snapshot)
- Shows what changed and when
- Tracks the reporting and analytics impact of field changes
- Aligns fields and objects to business initiatives and topics

It gives analysts and admins a single place to answer: *"What does this field mean? Who uses it? What reports would break if it changed?"*

---

## Core Capabilities

| Capability | Description |
|---|---|
| **Live Object/Field Browser** | Browse all Salesforce objects and fields from the connected org |
| **Business Context Enrichment** | Add descriptions, owners, business topic tags, and usage notes to any field |
| **Change Tracking** | Record what changed (field type, label, picklist values) and when |
| **Impact Analysis** | See which reports, metrics, and migration mappings reference a given field |
| **Business Topic Alignment** | Tag objects and fields to business initiatives for contextual browsing |
| **Search** | Full-text search across all objects and fields with filters |

---

## Key Concepts

| Concept | Definition |
|---|---|
| **Salesforce Object** | A standard or custom Salesforce object (`Account`, `Lead`, `Custom__c`) |
| **Salesforce Field** | A field on a Salesforce object — sourced live from the org's metadata |
| **Business Context** | User-added documentation: description, owner, business topic, usage notes |
| **Change Log** | A record of what changed on a field or object over time |
| **Impact** | The set of metrics, reports, or migration mappings that reference a given field |
| **Business Topic** | User-defined grouping applied to objects/fields (shared across all tools) |

---

## How It Connects to Other Tools

- **ERD** — every object in an ERD view links to its Data Dictionary entry
- **Metrics Glossary** — metrics link to the specific fields that feed them
- **Data Migration** — migration mappings reference source and target fields from the Dictionary
- **Report Management** — reports link back to the fields and objects they use

---

## User Workflows

### Enriching a Field
1. Navigate to Data Dictionary → find an object → open a field
2. Add or edit: description, business owner, business topic, usage notes
3. Changes are saved and visible to all team members immediately

### Tracking Impact of a Field Change
1. Salesforce admin changes a field (type, label, picklist values)
2. DataTools detects the change on next sync
3. Impact panel shows: metrics affected, reports affected, migration mappings affected
4. Admin notifies impacted team members

### Browsing by Business Topic
1. Filter the dictionary by Business Topic (e.g. "Revenue Operations")
2. See only the objects and fields relevant to that initiative

---

## Business Rules

- [ ] Objects and fields are sourced from Salesforce — users cannot create new ones in the Dictionary
- [ ] Business context (descriptions, tags) is stored in DataTools, not written back to Salesforce
- [ ] A field can be tagged to multiple Business Topics
- [ ] Change log entries are immutable — they record what happened, when, and who triggered the sync
- [ ] Deleting a Business Topic should warn if objects/fields are currently tagged to it

<!-- Fill in confirmed business rules as they are implemented -->

---

## Open Questions

- [ ] How often does DataTools sync with Salesforce — on demand, scheduled, or both?
- [ ] Can users add custom fields to the dictionary that don't exist in Salesforce (for planning purposes)?
- [ ] Is there a workflow to notify field owners when impact is detected?
- [ ] Who can edit business context — all users, or only admins?
