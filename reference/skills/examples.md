# Skills Reference

## What is a Skill?

A skill is a reusable prompt template that Claude Code can execute.

## Skill Location

```
.claude/commands/
├── workflows/    # Multi-step processes
└── tools/        # Single-purpose utilities
```

## Example Skill

```markdown
---
description: Quick code review
allowed-tools: Read, Grep
---

# Review Code

Review the following file for:
1. Code quality
2. Security issues
3. Performance concerns

File: $ARGUMENTS
```

## Available Skills in This Repo

| Skill | Purpose | Location |
|-------|---------|----------|
| `/prime` | Initialize codebase | `.claude/commands/tools/prime.md` |
| `/feature` | Plan feature | `.claude/commands/workflows/feature.md` |
| `/bug` | Plan bug fix | `.claude/commands/workflows/bug.md` |
