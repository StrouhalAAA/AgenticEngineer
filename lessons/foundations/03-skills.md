# Module 03: Skills System

> **Understand progressive disclosure and auto-invoked capabilities.**

> 🆕 **Updated for Claude Code 2.1.0** — Includes hot-reload, agent field, and user-invocable options.

---

## Commands vs Skills: What's the Difference?

Both are markdown files, but they serve different purposes:

```
┌─────────────────────────────────────────────────────────────┐
│                 COMMANDS vs SKILLS                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  COMMANDS                        SKILLS                      │
│  ────────                        ──────                      │
│                                                              │
│  Invoked explicitly              Auto-discovered             │
│  /command-name                   Based on task context       │
│                                                              │
│  Full prompt loaded              Progressive disclosure      │
│  immediately                     (summary first, full later) │
│                                                              │
│  User-triggered                  Claude-triggered            │
│  "I want to do X"                "This task needs Y"         │
│                                                              │
│  Workflow orchestration          Domain expertise            │
│  "Plan feature"                  "How to write PDFs"         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Key Insight**: Commands are for workflows YOU initiate. Skills are expertise CLAUDE draws upon when needed.

---

## How Skills Work: Progressive Disclosure

Skills use a two-phase loading pattern to save context tokens:

### Phase 1: Discovery (Always Loaded)

At session start, Claude loads only the **description** from each skill:

```
┌─────────────────────────────────────────────────────────────┐
│  Context Window at Session Start                             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Skill: pdf-processing                                       │
│  Description: "Create, edit, fill, and extract PDF files"    │
│  (~20 tokens)                                                │
│                                                              │
│  Skill: xlsx-generation                                      │
│  Description: "Generate Excel files with formatting"         │
│  (~15 tokens)                                                │
│                                                              │
│  Total: ~35 tokens (vs ~3000 if full skills loaded)          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Phase 2: Activation (On Demand)

When a task matches a skill description, Claude loads the full SKILL.md:

```
User: "Create a PDF report from this data"

Claude thinks: "PDF task → pdf-processing skill matches"
Claude action: Loads full SKILL.md (~500 tokens)
Claude: Uses skill instructions to complete task
```

---

## Skill File Structure

Skills live in dedicated directories:

```
.claude/skills/
└── pdf-processing/
    ├── SKILL.md           # Required: Main instructions
    ├── scripts/           # Optional: Helper scripts
    │   └── pdf-merge.py
    └── templates/         # Optional: Templates
        └── report.html
```

### SKILL.md Anatomy

```markdown
---
name: pdf-processing
description: Create, edit, fill, and extract PDF files using Python
allowed-tools:                    # YAML-style list (2.1.0+)
  - Read
  - Write
  - Edit
  - Bash(python:*)
model: sonnet
context: fork                      # Optional: isolated execution (2.1.0+)
agent: general-purpose             # Optional: specify executing agent (2.1.0+)
user-invocable: true               # Optional: show in slash menu (2.1.0+)
---

# PDF Processing Skill

## When to Use This Skill

Use this skill when the user needs to:
- Generate PDF reports
- Fill PDF forms
- Extract text from PDFs
- Merge or split PDF files

## Prerequisites

Ensure these packages are available:
```bash
pip install reportlab PyPDF2 pdfplumber
```

## Core Techniques

### Creating PDFs with ReportLab

```python
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

def create_pdf(filename, content):
    c = canvas.Canvas(filename, pagesize=letter)
    c.drawString(100, 750, content)
    c.save()
```

## Best Practices

1. Always validate PDF inputs before processing
2. Use context managers for file handling
3. Handle encoding issues with error recovery
```

---

## Skills vs Commands: Decision Guide

```
┌─────────────────────────────────────────────────────────────┐
│                 WHEN TO USE WHICH?                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  "I want to CREATE A PLAN for a feature"                    │
│   → Command (/feature)                                       │
│   Why: Explicit workflow, specific output format             │
│                                                              │
│  "Help me WORK WITH PDFs"                                   │
│   → Skill (pdf-processing)                                   │
│   Why: Domain expertise, Claude decides when to use          │
│                                                              │
│  "Run our DEPLOYMENT PIPELINE"                              │
│   → Command (/deploy)                                        │
│   Why: Orchestrated workflow with steps                      │
│                                                              │
│  "I need to QUERY THE DATABASE"                             │
│   → Skill (database-queries)                                 │
│   Why: Technical knowledge, applied contextually             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Quick Reference

| Create a... | When you need... |
|-------------|-----------------|
| **Command** | Explicit workflow with steps |
| **Command** | Specific output format every time |
| **Command** | User-initiated action |
| **Skill** | Domain expertise Claude should "know" |
| **Skill** | Knowledge applied contextually |
| **Skill** | Reusable patterns across many tasks |

---

## Creating Effective Skills

### Description Writing (Critical)

The description determines when Claude activates the skill:

✅ **Good descriptions:**
```yaml
description: "Create, edit, fill, and extract PDF documents using Python"
description: "Generate Excel spreadsheets with charts, formulas, and formatting"
description: "Write and execute SQL queries against PostgreSQL databases"
```

❌ **Bad descriptions:**
```yaml
description: "PDF stuff"  # Too vague
description: "This skill helps with documents"  # Not specific
description: "Use this for files"  # No clear trigger
```

---

## Hands-On Exercises

### Exercise 3.1: Explore Built-in Skills

1. Ask Claude about skills:
   ```
   > What skills do you have for document processing?
   ```

2. Trigger a skill implicitly:
   ```
   > Create an Excel file with sales data for Q1
   ```
   (Watch Claude load xlsx skill)

### Exercise 3.2: Create a Custom Skill

1. Create skill directory:
   ```bash
   mkdir -p .claude/skills/commit-messages
   ```

2. Create SKILL.md:
   ```markdown
   ---
   name: commit-messages
   description: Generate conventional commit messages from code changes
   tools: Read, Bash(git:*)
   ---

   # Commit Message Skill

   ## When to Use
   
   Activate when user needs to:
   - Write commit messages
   - Follow conventional commits format

   ## Format

   type(scope): subject

   Types: feat, fix, docs, style, refactor, test, chore
   ```

3. Test the skill:
   ```
   > Write a commit message for my staged changes
   ```

---

## New in 2.1.0: Skills Hot-Reload

Skills now **activate immediately** when created or modified—no session restart required:

```bash
# While Claude Code is running, edit a skill
vim .claude/skills/my-skill/SKILL.md

# Test immediately
> /my-skill analyze this code
# Works instantly!
```

### Why This Matters

Previously, iterating on skills required:
1. Edit skill file
2. Exit Claude Code
3. Restart session
4. Test changes
5. Repeat...

Now the feedback loop is instant—edit, save, test.

---

## New in 2.1.0: Skill Visibility Options

### Slash Command Menu

Skills now appear in the `/` autocomplete menu by default. To hide a skill:

```yaml
---
name: internal-analysis
description: Internal analysis helper
user-invocable: false    # Hidden from slash menu
---
```

**Use `user-invocable: false` when:**
- Skill is called by other skills/commands only
- Skill is auto-invoked based on context, not user command
- Internal helper that shouldn't be directly triggered

### Agent Specification

New `agent` field lets you specify which agent type executes the skill:

```yaml
---
name: research-explorer
description: Deep codebase research
agent: general-purpose    # Specify agent type
context: fork
---
```

### YAML-Style Tool Lists

Cleaner syntax for `allowed-tools`:

```yaml
# Old style (still works)
tools: Read, Write, Edit, Bash(git:*)

# New YAML-style (2.1.0+)
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash(git:*)
```

---

## Advanced: Forked Context Execution

Skills can run in **isolated forked contexts** using `context: fork` in frontmatter:

```yaml
---
name: codebase-research
description: Deep research and pattern discovery
context: fork
allowed-tools: Read, Grep, Glob
---
```

### Why Fork a Skill?

Research-heavy skills that read many files can pollute your main context with tool call traces. Forking keeps main context clean while still having access to conversation history.

```
┌─────────────────────────────────────────────────────────────┐
│  WITHOUT FORK                    WITH FORK                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Main context sees:              Main context sees:          │
│  • 30 file reads                 • Clean summary             │
│  • 15 grep results               • Key findings only         │
│  • All intermediate steps        • (~500 tokens)             │
│  • (~15K tokens consumed)                                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Fork vs Subagent

| Aspect | Subagent | `context: fork` |
|--------|----------|------------------|
| Starting context | Empty | Full conversation |
| Use when | Parallel specialized work | Context-aware analysis |

**Key insight**: Use fork when the skill needs to "know" the conversation history but shouldn't pollute it with execution traces.

→ **Deep dive**: See [Module 08: Forked Context](../context-management/08-forked-context.md) for implementation patterns and examples.

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Skills** | Auto-discovered domain expertise |
| **Progressive Disclosure** | Description loaded first, full content on match |
| **Location** | `.claude/skills/<name>/SKILL.md` |
| **Description** | Critical for discovery (~100 tokens) |
| **vs Commands** | Skills = knowledge, Commands = workflows |
| **Forked Context** | Isolate heavy analysis with `context: fork` |
| **Hot-Reload** | Edit skills without restarting (2.1.0+) |
| **user-invocable** | Control slash menu visibility (2.1.0+) |
| **agent field** | Specify executing agent type (2.1.0+) |

---

## Advanced: Parameterized Commands

Want to build commands that accept variables like `/audit <domain>` or `/analyze <product> <layer>`?

See the **ACBS example commands** for real-world patterns:
- [Example Commands](../../.claude/commands/examples/acbs/) — Working templates with `argument-hint` and context injection

---

## Next Module

Continue to [04-settings.md](../configuration/04-settings.md) to master configuration.
