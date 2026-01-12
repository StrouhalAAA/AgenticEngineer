# Skills Reference

> 🆕 **Updated for Claude Code 2.1.0** — Includes hot-reload, agent field, and visibility options.

---

## What are Skills?

Skills are auto-discovered capabilities that Claude loads when relevant to a task. Unlike commands (user-invoked), skills are Claude-invoked based on context matching.

---

## Skill Location

```
.claude/skills/<skill-name>/SKILL.md    # Project skills
~/.claude/skills/<skill-name>/SKILL.md  # Global skills
```

---

## SKILL.md Structure

```yaml
---
name: pdf-processing
description: Create, edit, fill, and extract PDF files
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash(python:*)
model: sonnet
context: fork                  # Optional: isolated execution (2.1.0+)
agent: general-purpose         # Optional: specify agent (2.1.0+)
user-invocable: true           # Optional: show in slash menu (2.1.0+)
---

# Skill Instructions

Instructions for Claude when this skill is activated...
```

---

## Frontmatter Options

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Skill identifier |
| `description` | string | **Critical**: Determines when skill activates |
| `allowed-tools` | list | Tools available to this skill |
| `model` | string | Model to use (optional) |
| `context` | string | `"fork"` for isolated execution (2.1.0+) |
| `agent` | string | Agent type to execute skill (2.1.0+) |
| `user-invocable` | boolean | Show in slash menu (default: true) (2.1.0+) |
| `hooks` | object | Agent-scoped hooks (2.1.0+) |

---

## 2.1.0 Features

### Hot-Reload

Skills activate immediately when created or modified—no restart required:

```bash
# Edit while Claude Code is running
vim .claude/skills/my-skill/SKILL.md

# Test immediately
> /my-skill do something
```

### Forked Context

Isolate skill execution to prevent context pollution:

```yaml
---
name: codebase-research
description: Deep research and pattern discovery
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
---
```

### Slash Menu Visibility

Hide internal skills from the `/` menu:

```yaml
---
name: internal-helper
description: Internal helper skill
user-invocable: false
---
```

### Agent-Scoped Hooks

Define hooks that only run during this skill's execution:

```yaml
---
name: database-operations
description: Execute database queries
hooks:
  PreToolUse:
    - matcher: "Bash(sqlcmd:*)"
      hooks:
        - type: command
          command: "./scripts/validate-sql.sh"
---
```

---

## Examples

### PDF Processing Skill

```yaml
---
name: pdf-processing
description: Create, edit, fill, and extract PDF files using Python
allowed-tools:
  - Read
  - Write
  - Bash(python:*)
---

# PDF Processing

## When to Use
- Generate PDF reports
- Fill PDF forms
- Extract text from PDFs

## Prerequisites
```bash
pip install reportlab PyPDF2 pdfplumber
```

## Techniques
...
```

### Research Skill with Fork

```yaml
---
name: codebase-research
description: Deep codebase research and pattern discovery
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
---

# Codebase Research

When researching:
1. Use Glob to find relevant files
2. Read and analyze patterns
3. Return concise summary only
```

### Database Skill with Hooks

```yaml
---
name: sql-queries
description: Write and execute SQL queries against databases
allowed-tools:
  - Read
  - Bash(sqlcmd:*)
hooks:
  PreToolUse:
    - matcher: "Bash(sqlcmd:*)"
      hooks:
        - type: command
          command: "./scripts/validate-no-drop.sh"
---

# SQL Query Skill

Always validate queries before execution...
```

---

## Skills vs Commands

| Aspect | Skills | Commands |
|--------|--------|----------|
| Invocation | Auto-discovered | User-invoked (`/command`) |
| Loading | Progressive (description first) | Full prompt immediately |
| Use case | Domain expertise | Workflow orchestration |

---

## Progressive Disclosure

Skills use two-phase loading to save tokens:

1. **Discovery**: Only description loaded at session start (~20 tokens)
2. **Activation**: Full SKILL.md loaded when task matches (~500+ tokens)

---

## Related

- [03-skills.md](../../lessons/foundations/03-skills.md) — Skills lesson
- [08-forked-context.md](../../lessons/context-management/08-forked-context.md) — Forked execution
- [Release Notes 2.1.0](../../learn/claude-code/release-notes/2026-01-07-v2.1.0.md) — Full features
