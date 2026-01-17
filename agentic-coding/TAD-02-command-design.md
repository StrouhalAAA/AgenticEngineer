# TAD-02: Parameterized Command Design

> **Learn to build commands that accept variables and resolve them against structured project references.**

---

## Prerequisites

- Completed [TAD-01: Fundamentals](./TAD-01-fundamentals.md)
- Familiarity with [03-skills.md](../lessons/foundations/03-skills.md)
- Read [ACBS Reference README](./acbs-reference/README.md)

---

## What You'll Learn

By the end of this module, you'll be able to:

1. Design commands that accept parameters (e.g., `/audit <domain>`)
2. Parse and validate arguments from `$ARGUMENTS`
3. Use YAML project references for resolution
4. Build multi-variable commands
5. Chain commands with variable propagation

---

## Part 1: Anatomy of a Parameterized Command

### The `$ARGUMENTS` Placeholder

When users invoke a command with arguments, Claude Code replaces `$ARGUMENTS` with the user's input:

```
User types:  /audit sales
Command sees: $ARGUMENTS = "sales"
```

### Command Frontmatter

```markdown
---
description: Audit all components in a business domain
argument-hint: <domain>
allowed-tools: Read, Glob, Grep
---
```

| Field | Purpose |
|-------|---------|
| `description` | Shown in `/` menu and help |
| `argument-hint` | Placeholder shown in autocomplete: `/audit <domain>` |
| `allowed-tools` | Restricts which tools the command can use |

### Variable Extraction

In the command body, instruct Claude how to parse arguments:

```markdown
## Instructions

1. Parse the domain from $ARGUMENTS
   - Expected values: customer, vehicle, sales, financial, document, communication, auth, settings, reporting, integration
   - If invalid, list valid options and stop
```

---

## Part 2: Resolution Patterns

### The Problem

Given `/audit sales`, how does Claude know which files to examine?

**Without structure**: Claude must explore the entire codebase
**With structure**: Claude looks up `sales` in a reference and gets exact paths

### The Solution: Project References

A YAML project reference maps variables to concrete paths:

```yaml
# From ACBS_PROJECT_REFERENCE.yaml
agent_design:
  resolution_patterns:
    sales:
      backend:
        - InterestService
        - DealService
        - CalendarService
      frontend:
        - CRM
        - kiosek
      db:
        - interest
        - Deal
```

### Resolution Flow

```
┌─────────────────────────────────────────────────────────────┐
│  Resolution Pattern                                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Input: /audit sales                                         │
│           │                                                  │
│           ▼                                                  │
│  1. Read YAML reference                                      │
│           │                                                  │
│           ▼                                                  │
│  2. Look up: resolution_patterns.sales                       │
│           │                                                  │
│           ▼                                                  │
│  3. Get lists:                                               │
│     • backend: [InterestService, DealService, ...]           │
│     • frontend: [CRM, kiosek]                                │
│     • db: [interest, Deal]                                   │
│           │                                                  │
│           ▼                                                  │
│  4. Apply path pattern:                                      │
│     • Backend/{ServiceName}/ → Backend/InterestService/      │
│           │                                                  │
│           ▼                                                  │
│  5. Execute audit on resolved paths                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Part 3: Building Your First Parameterized Command

### Exercise: Create `/audit-domain`

**Goal**: Build a command that audits all components in a business domain.

#### Step 1: Create the Command File

```bash
mkdir -p .claude/commands/examples/acbs
touch .claude/commands/examples/acbs/audit-domain.md
```

#### Step 2: Write the Frontmatter

```markdown
---
description: Audit all components in a business domain
argument-hint: <domain>
allowed-tools: Read, Glob, Grep
---
```

#### Step 3: Add Context Injection

```markdown
# Audit Domain: $ARGUMENTS

## Context

Read @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml to understand:
- Valid domain names (vocabulary.domain)
- Resolution patterns (resolution_patterns.<domain>)
- Path patterns (structure.Backend.pattern, structure.Frontend.pattern)
```

**Key Insight**: The `@path/to/file` syntax tells Claude to read that file before executing the command. This is **context injection**.

#### Step 4: Write Instructions

```markdown
## Instructions

1. **Parse and validate domain**
   - Extract domain from $ARGUMENTS
   - Valid domains: customer, vehicle, sales, financial, document, communication, auth, settings, reporting, integration
   - If invalid, show valid options and stop

2. **Resolve components**
   From the YAML `resolution_patterns.<domain>` section, get:
   - Backend services list
   - Frontend products list
   - Database schemas list

3. **For each component, audit**:
   - Verify path exists
   - Check for README or documentation
   - Count source files
   - Note any obvious issues

4. **Output structured report**
```

#### Step 5: Define Output Format

```markdown
## Output Format

### Domain: {domain} Audit Report

#### Backend Services

| Service | Path | Files | Has Docs | Status |
|---------|------|-------|----------|--------|
| {name} | Backend/{name}/ | {count} | Yes/No | OK/Issue |

#### Frontend Products

| Product | Path | Components | Has Tests | Status |
|---------|------|------------|-----------|--------|
| {name} | Frontend/{name}/ | {count} | Yes/No | OK/Issue |

#### Database Schemas

| Schema | Path | Tables | Procedures | Status |
|--------|------|--------|------------|--------|
| {name} | DB/{name}/ | {count} | {count} | OK/Issue |

### Summary
- Total components: {n}
- Issues found: {n}
- Recommendations: {list}
```

---

## Part 4: Multi-Variable Commands

### The Challenge

Some commands need multiple parameters:

```
/analyze CRM frontend     → product + layer
/test InterestService dev → service + environment
```

### Parsing Multiple Arguments

```markdown
## Instructions

1. **Parse arguments from $ARGUMENTS**
   - Expected format: `<product> <layer>`
   - Split on whitespace: first = product, second = layer
   - Validate product against `vocabulary.product`
   - Validate layer against `vocabulary.layer`
```

### Example: `/analyze <product> <layer>`

```markdown
---
description: Analyze a specific product at a specific layer
argument-hint: <product> <layer>
allowed-tools: Read, Glob, Grep
---

# Analyze: $ARGUMENTS

## Context

Read @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml

## Instructions

1. **Parse arguments**
   - Split $ARGUMENTS by whitespace
   - First token = product (e.g., "CRM")
   - Second token = layer (e.g., "frontend", "backend", "db")

2. **Validate**
   - Check product exists in `frontend` or `services` section
   - Check layer is valid: frontend, backend, db

3. **Resolve path**
   - If layer=frontend: Use `Frontend/{product}/`
   - If layer=backend: Use `Backend/{product}/`
   - If layer=db: Look up associated schemas from domain

4. **Analyze**
   - Count files by type
   - Identify main components
   - Check for patterns/anti-patterns
```

---

## Part 5: Context Injection Deep Dive

### When to Inject Context

| Scenario | Context Injection |
|----------|------------------|
| Command needs codebase structure | `@path/to/PROJECT_REFERENCE.yaml` |
| Command needs coding standards | `@.claude/guidelines/coding-standards.md` |
| Command needs API specs | `@docs/api-spec.yaml` |
| Command is self-contained | No injection needed |

### Injection Syntax

```markdown
## Context

Read @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml for:
- Domain resolution patterns
- Service integrations
- Path conventions

Read @.claude/guidelines/code-review.md for:
- Review checklist
- Quality standards
```

### Performance Consideration

Context injection adds tokens. Be selective:

```markdown
# Efficient - specific sections
Read the `agent_design.resolution_patterns` section from
@agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml

# Inefficient - entire file when only part needed
Read @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml
```

---

## Part 6: Practical Exercises

### Exercise 2.1: Build `/find-endpoint`

Create a command that finds where an API endpoint is implemented.

**Requirements**:
- Accepts endpoint path like `/api/v1/interest/appointments`
- Searches backend services for route definitions
- Reports controller, method, and file location

**Hints**:
- Use `grep` for `Route.*{endpoint}` or `HttpGet.*{endpoint}`
- Reference `api_conventions` section for patterns

### Exercise 2.2: Build `/test-service`

Create a command that runs tests for a backend service.

**Requirements**:
- Accepts service name like `InterestService`
- Validates service exists in reference
- Runs appropriate test command
- Reports results

**Hints**:
- Use `development_commands.backend.test` pattern
- Check service exists in `services` section

### Exercise 2.3: Build `/domain-deps`

Create a command that shows dependencies between domains.

**Requirements**:
- Accepts domain name
- Shows which other domains it depends on (via service integrations)
- Shows which domains depend on it

**Hints**:
- Each service has `integrations` field
- Cross-reference service domains

---

## Part 7: Advanced Patterns

### Pattern: Chained Commands

Commands can output in formats that feed into other commands:

```markdown
## Output

To dive deeper, run:
- `/audit {domain}` for full audit
- `/test {service}` for each service with issues
```

### Pattern: Environment-Aware Commands

```markdown
## Instructions

1. Parse environment from $ARGUMENTS (optional, default: dev)
2. Construct URLs using `api_conventions.base_urls.<env>.pattern`
3. Use appropriate credentials
```

### Pattern: Interactive Resolution

When ambiguous, ask for clarification:

```markdown
## Instructions

If $ARGUMENTS matches multiple items:
1. List matches with numbers
2. Ask user to specify
3. Wait for response before proceeding
```

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| `$ARGUMENTS` | Placeholder replaced with user input |
| `argument-hint` | Shows expected format in autocomplete |
| Context injection | `@path/to/file` loads reference data |
| Resolution patterns | YAML maps variables to components |
| Multi-variable | Split and validate each argument |
| Path construction | Combine patterns with resolved names |

---

## Next Steps

1. Complete the exercises above
2. Study example commands in `.claude/commands/examples/acbs/`
3. Build commands for your own project
4. Consider creating a project reference YAML for your codebase

---

## Quick Reference

### Command Template

```markdown
---
description: One-line description for menu
argument-hint: <arg1> [arg2]
allowed-tools: Read, Glob, Grep
---

# Command Name: $ARGUMENTS

## Context

Read @path/to/reference.yaml for structure

## Instructions

1. Parse and validate arguments
2. Resolve to concrete paths
3. Execute operations
4. Format output

## Output Format

Structured output template
```

### YAML Reference Sections

| Section | Contains |
|---------|----------|
| `vocabulary` | Valid values for each variable type |
| `resolution_patterns` | Maps domains → components |
| `path_rules` | Component type → file path patterns |
| `api_conventions` | URL patterns, auth, Swagger |
| `development_commands` | Build, test, run commands |
