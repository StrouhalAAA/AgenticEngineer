# Agentic Coding Training

> Advanced training for teams adopting AI coding assistants.

## Prerequisites

Complete all 11 lessons in [lessons/](../lessons/) first.

## Training Modules

| Module | Focus | Duration |
|--------|-------|----------|
| [TAD-01](./TAD-01-fundamentals.md) | Fundamentals | 2 hours |
| [TAD-02](./TAD-02-command-design.md) | Parameterized Command Design | 2 hours |
| TAD-03 (coming) | Team Patterns | 2 hours |

## ACBS Project Reference

The [acbs-reference/](./acbs-reference/) directory contains a real-world enterprise monorepo specification for learning:

- **Parameterized commands**: `/audit <domain>`, `/analyze <product> <layer>`
- **Variable resolution**: Domain → Services → Paths mapping
- **Context injection**: How to load YAML references into commands

| Resource | Description |
|----------|-------------|
| [acbs-reference/README.md](./acbs-reference/README.md) | How to use the reference |
| [acbs-reference/ACBS_PROJECT_REFERENCE.yaml](./acbs-reference/ACBS_PROJECT_REFERENCE.yaml) | The 1600-line monorepo spec |
| [acbs-reference/CLAUDE.md](./acbs-reference/CLAUDE.md) | Example project CLAUDE.md |

### Example Commands

Working command templates in `.claude/commands/examples/acbs/`:

| Command | Arguments | What It Demonstrates |
|---------|-----------|---------------------|
| `/audit-domain` | `<domain>` | Single variable resolution |
| `/analyze-product` | `<product> <layer>` | Multi-variable parsing |
| `/find-endpoint` | `<endpoint-path>` | Search patterns |

## Exercises

Practice exercises in [exercises/](./exercises/)
