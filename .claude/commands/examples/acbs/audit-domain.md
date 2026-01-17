---
description: Audit all components in a business domain
argument-hint: <domain>
allowed-tools: Read, Glob, Grep
---

# Audit Domain: $ARGUMENTS

## Context

Read @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml to understand:
- Valid domain names (`agent_design.vocabulary.domain`)
- Resolution patterns (`agent_design.resolution_patterns.<domain>`)
- Path patterns (`structure.Backend.pattern`, `structure.Frontend.pattern`, `structure.DB.pattern`)

## Instructions

### Step 1: Parse and Validate Domain

Extract the domain from `$ARGUMENTS`.

**Valid domains**: customer, vehicle, sales, financial, document, communication, auth, settings, reporting, integration

If the provided domain is not in this list:
- Display the list of valid domains
- Stop execution

### Step 2: Resolve Components

From the YAML `agent_design.resolution_patterns.<domain>` section, extract:

1. **Backend services**: List of service names
2. **Frontend products**: List of product names
3. **Database schemas**: List of schema names

### Step 3: Audit Each Component

#### For Backend Services

For each service in the backend list:
1. Check path exists: `Backend/{ServiceName}/`
2. Look for key files:
   - `{ServiceName}.csproj` (project file)
   - `Controllers/` directory
   - `Services/` directory
3. Get service details from `services.<ServiceName>`:
   - Purpose
   - Integrations
   - Type (api, bff, repository, etc.)

#### For Frontend Products

For each product in the frontend list:
1. Check path exists: `Frontend/{ProductName}/`
2. Look for key files:
   - `package.json`
   - `src/` directory
3. Get product details from `frontend.<ProductName>`:
   - Purpose
   - Tech stack
   - Status

#### For Database Schemas

For each schema in the db list:
1. Check path exists: `DB/{SchemaName}/`
2. Count:
   - Tables in `TABLE/` directory
   - Procedures in `PROCEDURE/` directory

### Step 4: Identify Issues

Flag any of the following:
- Missing paths (component defined but directory doesn't exist)
- Empty directories
- Missing documentation (no README)
- Services without tests

## Output Format

### Domain Audit: {domain}

**Description**: {domain description from domains.<domain>.description}

---

#### Backend Services ({count})

| Service | Type | Path | Status | Integrations |
|---------|------|------|--------|--------------|
| {ServiceName} | {type} | `Backend/{ServiceName}/` | ✓ Found / ⚠ Missing | {comma-separated integrations} |

---

#### Frontend Products ({count})

| Product | Tech Stack | Path | Status |
|---------|------------|------|--------|
| {ProductName} | {tech stack summary} | `Frontend/{ProductName}/` | ✓ Found / ⚠ Missing |

---

#### Database Schemas ({count})

| Schema | Tables | Procedures | Path | Status |
|--------|--------|------------|------|--------|
| {SchemaName} | {count} | {count} | `DB/{SchemaName}/` | ✓ Found / ⚠ Missing |

---

### Summary

- **Total Components**: {backend + frontend + db count}
- **Found**: {count with ✓}
- **Missing**: {count with ⚠}
- **Domain Keywords**: {keywords from domains.<domain>.keywords}

### Recommendations

- {Any issues found}
- {Suggestions for improvement}

---

## Example Usage

```
/audit-domain sales
```

Expected output: Audit report for InterestService, DealService, CalendarService, CRM, kiosek, interest schema, Deal schema.
