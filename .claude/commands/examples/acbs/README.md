# ACBS Example Commands

> Example parameterized commands demonstrating resolution patterns against the ACBS project reference.

## Purpose

These commands show how to build parameterized Claude Code commands that:
- Accept variable arguments
- Resolve variables against a YAML project reference
- Produce structured, consistent output

## Available Commands

| Command | Arguments | Description |
|---------|-----------|-------------|
| `/audit-domain` | `<domain>` | Audit all components in a business domain |
| `/analyze-product` | `<product> <layer>` | Analyze a specific product at a specific layer |
| `/find-endpoint` | `<endpoint-path>` | Find where an API endpoint is implemented |

## Usage

### Single Variable: `/audit-domain`

```bash
# Audit the sales domain
/audit-domain sales

# Audit the customer domain
/audit-domain customer
```

**What it does**:
1. Validates `sales` is a known domain
2. Resolves to: InterestService, DealService, CRM, kiosek, interest schema, Deal schema
3. Checks each component exists and reports status

### Multiple Variables: `/analyze-product`

```bash
# Analyze CRM frontend
/analyze-product CRM frontend

# Analyze InterestService backend
/analyze-product InterestService backend

# Analyze FNI database layer
/analyze-product FNI db
```

**What it does**:
1. Parses two arguments: product and layer
2. Validates both against vocabulary
3. Resolves appropriate path
4. Performs layer-specific analysis

### Search Pattern: `/find-endpoint`

```bash
# Find appointment endpoints
/find-endpoint /api/v1/interest/appointments

# Find with HTTP method filter
/find-endpoint GET interest/callbacks
```

**What it does**:
1. Normalizes the endpoint path
2. Searches backend services for route definitions
3. Reports controller, method, and implementation chain

## How These Commands Work

### 1. Context Injection

Each command starts with:

```markdown
## Context

Read @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml
```

This loads the project reference into Claude's context before execution.

### 2. Variable Resolution

Commands use the YAML's `agent_design` section:

```yaml
agent_design:
  vocabulary:
    domain: [customer, vehicle, sales, ...]
  resolution_patterns:
    sales:
      backend: [InterestService, DealService, ...]
```

### 3. Path Construction

Paths are built using `structure` patterns:

```yaml
structure:
  Backend:
    pattern: "Backend/{ServiceName}/"
  Frontend:
    pattern: "Frontend/{ProductName}/"
```

## Creating Your Own Commands

Use these as templates for your project:

1. **Copy** an example command
2. **Modify** the context injection to your reference file
3. **Update** vocabulary and resolution patterns
4. **Adjust** output format for your needs

## Learning Path

1. Read [ACBS Reference README](../../../agentic-coding/acbs-reference/README.md)
2. Try each command to see resolution in action
3. Build your own parameterized commands

## File Structure

```
.claude/commands/examples/acbs/
├── README.md           # This file
├── audit-domain.md     # Single variable example
├── analyze-product.md  # Multi-variable example
└── find-endpoint.md    # Search pattern example
```

## Related

- [ACBS Project Reference](../../../agentic-coding/acbs-reference/)
- [03-skills.md](../../../lessons/foundations/03-skills.md)
