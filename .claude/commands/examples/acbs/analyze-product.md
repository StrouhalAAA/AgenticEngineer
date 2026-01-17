---
description: Analyze a specific product at a specific layer
argument-hint: <product> <layer>
allowed-tools: Read, Glob, Grep
---

# Analyze Product: $ARGUMENTS

## Context

Read @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml to understand:
- Valid product names (`agent_design.vocabulary.product`)
- Valid layer names (`agent_design.vocabulary.layer`)
- Product details (`frontend.<product>`)
- Path patterns (`structure.Frontend`, `structure.Backend`)

## Instructions

### Step 1: Parse Arguments

Split `$ARGUMENTS` by whitespace:
- First token = **product** (e.g., "CRM", "FNI", "phones")
- Second token = **layer** (e.g., "frontend", "backend", "db")

### Step 2: Validate Arguments

**Valid products**: CRM, FNI, new-fni-app, phones, kiosek, fotocentrum, StockGuideAdmin, DocumentScan, CebiaApp, vue-component-library

**Valid layers**: frontend, backend, db

If either argument is invalid:
- Show valid options
- Stop execution

### Step 3: Resolve Path

Based on layer:

| Layer | Path Pattern | Example |
|-------|--------------|---------|
| frontend | `Frontend/{product}/` | `Frontend/CRM/` |
| backend | `Backend/{product}/` | `Backend/CrmBff/` |
| db | Look up associated schemas | `DB/interest/` |

**Note**: For `db` layer, you need to:
1. Find which domains the product belongs to
2. Look up `resolution_patterns.<domain>.db` for schemas

### Step 4: Analyze Based on Layer

#### If layer = frontend

Analyze the Vue.js application:

1. **Project structure**:
   - Check `package.json` for dependencies
   - Check `src/` directory structure
   - Identify tech stack (Vue 2 vs Vue 3, Vite vs Vue CLI)

2. **Components breakdown**:
   - Count files in `src/components/`
   - Count files in `src/views/` or `src/pages/`
   - Count files in `src/composables/` (Vue 3) or `src/mixins/` (Vue 2)

3. **Services layer**:
   - List services in `src/services/`
   - Identify API integrations

4. **State management**:
   - Check for `src/stores/` (Pinia) or `src/store/` (Vuex)

5. **Quality indicators**:
   - Check for tests (`cypress/`, `__tests__/`, `*.spec.ts`)
   - Check for TypeScript (`tsconfig.json`)
   - Check for linting (`eslint.config.js`, `.eslintrc`)

#### If layer = backend

Analyze the .NET service:

1. **Project structure**:
   - Check `*.csproj` for dependencies
   - Check solution structure

2. **API surface**:
   - List controllers in `Controllers/`
   - Count endpoints (HttpGet, HttpPost, etc.)

3. **Business logic**:
   - List services in `Services/`
   - List repositories in `Repositories/`

4. **Data models**:
   - Count DTOs in `Models/Dto/`
   - Count DB models in `Models/Db/`

5. **Quality indicators**:
   - Check for test projects (`*.Tests/`)
   - Check for Swagger configuration

#### If layer = db

Analyze the database schema:

1. **Tables**:
   - List files in `TABLE/` directory
   - Identify key tables

2. **Procedures**:
   - List files in `PROCEDURE/` directory
   - Identify FX2 procedures (naming convention: `*_FX2.sql`)

3. **Other objects**:
   - Count functions in `FUNCTION/`
   - Count triggers in `TRIGGER/`

## Output Format

### Analysis: {product} ({layer})

**Path**: `{resolved path}`

---

#### Structure Overview

```
{directory tree showing main folders and file counts}
```

---

#### Key Findings

| Metric | Value |
|--------|-------|
| {metric name} | {value} |
| ... | ... |

---

#### Component Breakdown

{Layer-specific breakdown with tables}

---

#### Quality Assessment

| Indicator | Status | Notes |
|-----------|--------|-------|
| TypeScript | ✓/✗ | {notes} |
| Tests | ✓/✗ | {coverage info if available} |
| Documentation | ✓/✗ | {README exists?} |
| Linting | ✓/✗ | {config found?} |

---

### Recommendations

- {Suggestions based on findings}

---

## Example Usage

```bash
# Analyze CRM frontend
/analyze-product CRM frontend

# Analyze phones backend (PhonesBff)
/analyze-product phones backend

# Analyze FNI database schemas
/analyze-product FNI db
```
