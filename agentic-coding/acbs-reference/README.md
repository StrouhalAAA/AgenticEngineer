# ACBS Project Reference

> A real-world monorepo specification for learning parameterized command design.

## What Is This?

The **ACBS Project Reference** (`ACBS_PROJECT_REFERENCE.yaml`) describes the complete structure of a 50+ service enterprise monorepo:

| Component | Count |
|-----------|-------|
| Business Domains | 10 (customer, vehicle, sales, financial, etc.) |
| Frontend Products | 10 (CRM, FNI, phones, kiosek, etc.) |
| Backend Services | 56 (.NET microservices) |
| Database Schemas | 16 (SQL Server) |
| Cron Jobs | 8 (Hangfire scheduled tasks) |

This is a **realistic automotive CRM system** for a Czech/Slovak car dealership chain—exactly the kind of complex codebase where parameterized commands become essential.

## Learning Objectives

By studying this reference, you'll learn to:

1. **Design parameterized commands** with variables like `/audit <domain>`
2. **Understand resolution patterns**: how `domain: sales` resolves to specific services, frontends, and databases
3. **Practice context injection**: how Claude reads YAML to understand codebase structure
4. **Build prompt chains**: multi-step workflows with variable propagation

## YAML Structure Overview

```yaml
# Key sections in ACBS_PROJECT_REFERENCE.yaml:

meta:               # Project metadata and scale
domains:            # 10 business domains with associated components
frontend:           # Frontend products with tech stack and paths
services:           # 56 backend services with integrations
database:           # Database schemas and key tables
structure:          # Repository directory patterns
tech_stack:         # Technology choices (Vue, .NET, SQL Server)
agent_design:       # Resolution patterns for command design
api_conventions:    # URL patterns, auth, Swagger locations
development_commands: # Common build/run/test commands
```

## The `agent_design` Section

This is the most important section for command design. It contains:

### Vocabulary (Valid Variable Values)

```yaml
agent_design:
  vocabulary:
    domain: [customer, vehicle, sales, financial, document, ...]
    product: [CRM, FNI, phones, kiosek, ...]
    layer: [frontend, backend, db, cronjob]
    environment: [dev, test, pp, prod]
```

### Resolution Patterns (Domain → Components)

```yaml
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

### Path Rules (Component → File Paths)

```yaml
agent_design:
  path_rules:
    backend_controller:
      pattern: "Backend/{ServiceName}/{ServiceName}/Controllers/{EntityName}Controller.cs"
    frontend_service:
      pattern: "Frontend/{product}/src/services/{ServiceName}Service.ts"
```

## How to Use This Reference

### Step 1: Study the Domain Model

Read the `domains` section to understand the business domains:

```bash
# View domains with their services
grep -A5 "^  customer:" ACBS_PROJECT_REFERENCE.yaml
grep -A5 "^  sales:" ACBS_PROJECT_REFERENCE.yaml
```

### Step 2: Understand Resolution Patterns

Study `agent_design.resolution_patterns` to see how domains map to components.

### Step 3: Follow TAD-02 Lesson

Work through [TAD-02-command-design.md](../TAD-02-command-design.md) to build commands that use this reference.

### Step 4: Practice with Example Commands

Try the example commands in `.claude/commands/examples/acbs/`:
- `/audit <domain>` - Audit all components in a domain
- `/analyze <product> <layer>` - Analyze a specific product layer
- `/find-endpoint <path>` - Find API endpoint implementation

## Example: Resolving `/audit sales`

When you run `/audit sales`, the command:

1. **Reads the YAML**: Loads `ACBS_PROJECT_REFERENCE.yaml`
2. **Extracts variable**: Parses `sales` from `$ARGUMENTS`
3. **Looks up domain**: Finds `resolution_patterns.sales`
4. **Resolves components**:
   - Backend: `InterestService`, `DealService`, `CalendarService`, etc.
   - Frontend: `CRM`, `kiosek`
   - Database: `interest`, `Deal`
5. **Constructs paths**:
   - `Backend/InterestService/`
   - `Backend/DealService/`
   - `Frontend/CRM/`
   - `DB/interest/`
6. **Reports findings** in structured format

## Key Patterns for Command Authors

### Pattern 1: Domain Resolution

```markdown
Given $ARGUMENTS containing a domain name:
1. Look up domain in `domains` section
2. Get services from `resolution_patterns.<domain>.backend`
3. Get products from `resolution_patterns.<domain>.frontend`
4. Get schemas from `resolution_patterns.<domain>.db`
```

### Pattern 2: Path Construction

```markdown
Given a service name:
1. Use pattern from `structure.Backend.pattern`
2. Substitute `{ServiceName}` with actual name
3. Result: `Backend/InterestService/`
```

### Pattern 3: API URL Construction

```markdown
Given a service and environment:
1. Use `api_conventions.base_urls.<env>.pattern`
2. Substitute `{service}` with service name (lowercase)
3. Result: `https://interest.api.dev.aures.app`
```

## Related Resources

- [TAD-02: Command Design Tutorial](../TAD-02-command-design.md) - Step-by-step command building
- [Example Commands](./../../../.claude/commands/examples/acbs/) - Working command templates
- [CLAUDE.md Example](./CLAUDE.md) - How to reference this YAML in project context

## Why This Matters

Real-world enterprise codebases have dozens of services, multiple frontends, and complex relationships. Without structured context like this YAML:

- Claude would need to **explore the entire codebase** for each command
- Commands would be **slow and context-hungry**
- Results would be **inconsistent** across runs

With structured context:

- Commands **resolve variables instantly** from YAML
- Context usage is **predictable and minimal**
- Results are **consistent and comprehensive**

This is the pattern used by teams managing large codebases with AI assistants.
