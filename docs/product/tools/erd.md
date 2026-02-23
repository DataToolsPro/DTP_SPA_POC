# Tool: Entity Relationship Diagram (ERD)

**Part of:** DataTools Pro
**Primary users:** Salesforce Administrators, Data Analysts, Analytics Professionals, Business Stakeholders

---

## What It Does

The ERD tool generates a **live, interactive, business-oriented entity relationship diagram** directly from your connected Salesforce org — in a single click. Select the objects you want to visualize, click Entity Diagram, and DataTools Pro builds the relationships from live Salesforce metadata.

Unlike Salesforce's built-in Schema Builder (which is comprehensive but technical) or premium tools like LucidCharts (which require manual drawing), DataTools Pro ERD is designed for **visual storytelling** — making the Salesforce data model accessible to Salesforce admins, data analysts, analytics pros, AND business stakeholders, not just developers.

The ERD is a **conceptual view** of the data model — interactive, color-coded, and organized by business context rather than raw schema.

---

## Core Capabilities

| Capability | Description |
|---|---|
| **Live ERD Generation** | Select objects from your DataTools dictionary → generate the full ERD in a single click from live Salesforce metadata |
| **Interactive Visualization** | Explore and organize your object relationships interactively — not a static diagram |
| **Color Coding** | Objects color-coded intuitively to highlight relationship types and business groupings |
| **Drill to Fields** | Click any object in the ERD to drill down into its fields via the Data Dictionary |
| **Export** | Export your ERD to PNG and SVG image formats for sharing and presentations |
| **Business Topic Organization** | Organize ERD views by business topic, initiative, or application — maintain multiple focused views instead of one overwhelming diagram |

---

## Key Concepts

| Concept | Definition |
|---|---|
| **ERD View** | A saved diagram scoped to a specific set of objects, organized by Business Topic or initiative |
| **Salesforce Object** | A standard or custom Salesforce object (e.g. `Account`, `Opportunity`, `Lead`, `Custom__c`) |
| **Relationship** | A lookup, master-detail, or many-to-many relationship between two Salesforce objects — sourced directly from Salesforce metadata |
| **Business Topic** | User-defined grouping label that organizes ERD views by business domain (shared across all DataTools) |
| **Conceptual ERD** | A business-oriented, simplified view of the data model designed for visual communication — not a raw schema dump |

---

## How It Connects to Other Tools

- **Data Dictionary** — clicking any object in the ERD opens its full field list; the ERD is a visual entry point into the dictionary
- **Metrics Glossary** — objects surfaced in the ERD can be traced to the metrics that use them
- **Data Migration** — the ERD provides the source and target object map during migration planning
- **Business Topics** — the same Business Topics used across all DataTools tools organize ERD views for consistency

---

## User Workflows

### Generating an ERD
1. Connect your Salesforce org
2. Navigate to **Entity Diagram**
3. Select the objects you want to visualize (from your DataTools dictionary)
4. Click **Entity Diagram** → ERD auto-generates from live Salesforce metadata
5. Interact: pan, zoom, organize layout
6. Save as an ERD View tied to a Business Topic

### Drilling into Fields
1. In the ERD, click any object
2. Opens the Data Dictionary view for that object
3. Browse all fields, descriptions, business context, and change history

### Exporting & Sharing
1. Finalize your ERD layout
2. Export → PNG (for presentations, stakeholder decks) or SVG (for vector editing)

---

## Business Rules

- Objects and relationships are sourced from Salesforce — they cannot be manually created in the ERD
- A user can create multiple ERD Views from the same set of objects (different perspectives)
- An ERD View is scoped to an Organization (shared across the team — not per-user)
- Deleting an ERD View does not delete the underlying objects or fields from the Data Dictionary
- Object relationships shown in the ERD reflect Salesforce relationship types: lookup, master-detail, many-to-many

---

## Positioning vs. Alternatives

| Tool | What It Is | Best For |
|---|---|---|
| **Salesforce Schema Builder** | Built-in, comprehensive, technical | Admins doing schema work |
| **LucidCharts** | Premium, manual diagram tool | Polished, custom diagrams |
| **DataTools Pro ERD** | Free, live-connected, business-oriented | Visual storytelling, team alignment, interactive exploration |

---

## Open Questions

- [ ] Is the ERD layout saved per-user or shared across the whole organization?
- [ ] Can users pin or annotate objects/relationships with notes?
- [ ] What happens when a Salesforce object is deleted — does it grey out in existing ERDs or get automatically removed?
- [ ] Can custom (non-Salesforce) relationships be added manually for planning purposes?
- [ ] Is there a size limit on how many objects can be in one ERD View before performance degrades?
