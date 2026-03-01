---
name: datatools-pro-docs
description: Write, update, and organize DataTools Pro product documentation. Use when creating tutorials, feature docs, release notes, integration guides, or updating existing docs. Triggers on mentions of documentation, tutorials, knowledge files, docs/public/, or writing product content for DataTools Pro.
---

# DataTools Pro Documentation Authoring

## Output Format

Every doc is a single JSON file containing structured metadata and a `content_markdown` field. No separate `.md` files.

```json
{
  "post_id": null,
  "title": "Feature Name with DataTools Pro",
  "slug": "feature-name-with-datatools-pro",
  "url": "https://datatoolspro.com/tutorials/feature-name-with-datatools-pro/",
  "date": "2026-02-28T00:00:00",
  "modified": "2026-02-28T00:00:00",
  "categories": ["DataTools Pro"],
  "tags": ["datatoolspro", "Feature Tag"],
  "excerpt": "One plain-text sentence summarizing the feature and its value.",
  "content_markdown": "Full markdown body here..."
}
```

### Field Rules

| Field | Rule |
|-------|------|
| `post_id` | Use WordPress ID if known, otherwise `null` for new docs |
| `title` | Title Case. Include product name when relevant |
| `slug` | Lowercase, hyphen-separated, mirrors title |
| `url` | Always `https://datatoolspro.com/tutorials/{slug}/` |
| `date` | ISO 8601 creation timestamp |
| `modified` | ISO 8601, update on every edit |
| `categories` | Always include `"DataTools Pro"`. Add secondary category only if applicable (see folder reference) |
| `tags` | Always include `"datatoolspro"`. Add feature-specific tags matching the folder's signature tag |
| `excerpt` | 1 sentence, plain text, no markdown or HTML |
| `content_markdown` | Clean markdown, no raw HTML |

## Folder Organization

Place files in `docs/public/{folder}/` based on primary feature area:

| Folder | Content | Signature Tag | Secondary Category |
|--------|---------|---------------|--------------------|
| `_general/` | Role-based getting started guides | *(none)* | *(none)* |
| `administration/` | Account mgmt, users, subscriptions, security | `"Administration"` | — |
| `api/` | REST API documentation | `"API"` | — |
| `data-migration/` | Scorecard, field mapping, SQL export | `"Data Migration"` | `"Salesforce Data Migration"` |
| `dictionary/` | Object explorer, field dictionary, tracking | `"Dictionary"` | — |
| `erd/` | Entity relationship diagrams | `"ERD"` | — |
| `integrations/{partner}/` | Partner-specific integration docs | Partner name (e.g., `"Snowflake"`) | Partner name as category if major |
| `metrics/` | Glossary, alias, linking, merging, AI | `"metrics"` | — |
| `reports-and-dashboards-datatools/` | Reports, dashboards, tagging, export | `"Reports and Dashboards DataTools"` | — |

For integrations, create subfolders by partner: `integrations/snowflake/`, `integrations/tableau/`, `integrations/salesforce/`, `integrations/github/`, `integrations/notion/`, `integrations/coda/`, `integrations/crm-analytics/`. New partners get new subfolders.

## Voice & Tone

- **Second person** for instructions: "you can", "click on", "select the"
- **First person plural** for company voice: "we built", "our goal is", "we recommend"
- **Semi-formal**: professional but warm. Not stiff corporate, not overly casual
- **Present tense** for features. Future tense only for roadmap items
- **Imperative mood** for steps: "Click", "Select", "Navigate", "Enter"
- **Inclusive language**: "users of all skill levels", "non-technical users"
- Friendly closings when appropriate: "Let us know!", "Feel free to reach out"
- Acknowledge limitations honestly: "Currently DataTools Pro does not support..."

## Content Structure

Follow this flow for every tutorial/feature doc:

```
1. Opening paragraph — what it is + value prop + link to product page
2. [Optional] Video embed
3. [Optional] Table of Contents (for long docs)
4. [Optional] Key Features bullet list
5. How to Access / Installation steps
6. Step-by-step usage walkthrough (numbered steps + screenshots)
7. Advanced features / configuration
8. Export / output options (if applicable)
9. Security / permissions notes
10. Related links with "Learn more about..." pattern
```

### Opening Paragraph Pattern

Always name the feature, state its purpose, and hint at the value:

```markdown
[DataTools Pro](https://datatoolspro.com/ "DataTools Pro") provides a {feature description}
that {value proposition}. {Additional context about target users}.
```

### Closing Pattern

End with one or more of: security/data notes, current limitations with roadmap hints, related tutorial links, support contact.

```markdown
[Learn more about {related feature}.](https://datatoolspro.com/tutorials/{slug}/ "Title")
```

## Markdown Formatting Rules

### Headings

- `##` for major sections, `###` for subsections, `####` for tertiary detail
- **Title Case** for all headings
- En-dash (`–`) to separate title from subtitle: `## Usage – Explore Data`

### Bold Usage

| Context | Example |
|---------|---------|
| Feature/field definitions | `**Field Name** – Salesforce Field Name (API Name)` |
| UI elements in steps | `Click **Get** to install` |
| Navigation paths | `**Snowsight** → **Data Products** → **Marketplace**` |
| Callout labels | `**IMPORTANT:**`, `**NOTE:**` |

### Steps & Lists

- Numbered lists for sequential steps. Bullets for non-sequential items
- Bold the UI element being acted on within each step
- Follow each step with a screenshot when UI is involved

Two step styles:

**Instructional steps:**
```markdown
1. Navigate to **Snowsight** → **Data Products** → **Marketplace**.
2. Search for **DataTools Pro Explorer**.
3. Click **Get** to install.
```

**Feature glossary style:**
```markdown
1. **Object Explorer** – Navigate back to the object explorer
2. **Object Detail** – Navigate to another Salesforce object
```

### Images

```markdown
![Descriptive alt text](https://datatoolspro.com/wp-content/uploads/YYYY/MM/filename.webp)
```

- Prefer `.webp` format
- Alt text should use product/feature context, not visual descriptions
- Place images immediately after the step they illustrate

### Links

- **Internal**: full URL + title attribute: `[Link text](https://datatoolspro.com/tutorials/slug/ "Descriptive Title")`
- **Video embeds**: `[Video: Description](https://www.youtube.com/embed/VIDEO_ID?feature=oembed)`
- **Email**: `[support@datatoolspro.com](mailto:support@datatoolspro.com)`

### Code Blocks

Use sparingly — only for actual SQL, config, or code:

````markdown
```sql
GRANT USAGE ON DATABASE <db_name> TO APPLICATION DATATOOLS_PRO_EXPLORER;
```
````

- Always include language hint (`sql`, `python`, `json`)
- Use `<placeholder>` for user-specific values
- Include inline SQL comments for clarity

## Terminology

Always use these exact terms:

| Term | Never use |
|------|-----------|
| **DataTools Pro** | DataTools pro, datatools pro, Data Tools Pro |
| **Salesforce org** | Salesforce instance |
| **Field Dictionary** / **Data Dictionary** | field dict, data dict |
| **Metrics Glossary** | metrics dictionary |
| **Migration Scorecard** | migration tracker |
| **ERD** / **Entity Relationship Diagram** | ER diagram |
| **Object Explorer** | object browser |

## Quality Checklist

Before finalizing any doc, verify:

- [ ] JSON structure has all required fields
- [ ] `categories` includes `"DataTools Pro"`
- [ ] `tags` includes `"datatoolspro"` + feature-specific tag
- [ ] `excerpt` is 1 plain-text sentence
- [ ] File is in the correct `docs/public/` subfolder
- [ ] Slug matches filename (without `.json`)
- [ ] No raw HTML in `content_markdown`
- [ ] No HTML entities (`&amp;`, `&#8211;`)
- [ ] All links use absolute URLs with title attributes
- [ ] Code blocks have language hints
- [ ] Headings use Title Case
- [ ] Bold formatting follows the patterns above
- [ ] Screenshots follow steps they illustrate
- [ ] Terminology matches the glossary exactly

## Workflow

### Creating a New Doc

1. Determine the feature area → pick the target folder
2. Generate the JSON skeleton with all metadata fields
3. Write `content_markdown` following the content structure template
4. Apply formatting rules (headings, bold, links, images)
5. Run the quality checklist
6. Save as `docs/public/{folder}/{slug}.json`

### Updating an Existing Doc

1. Read the existing JSON file
2. Update `content_markdown` with changes
3. Update `modified` timestamp to current date
4. Run the quality checklist
5. Write the file back

For detailed folder-to-tag mappings and complete category catalog, see [reference.md](reference.md).
