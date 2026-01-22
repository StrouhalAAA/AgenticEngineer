# Agentic Engineer Playbook

> Your guide to mastering AI coding assistants, starting with Claude Code.

## What's New

| Date | Change | Link |
|------|--------|------|
| 2026-01-22 | Added Czech shortcuts/cheatsheet reference | [shortcuts-cz](reference/shortcuts-cz.md) |
| 2026-01-11 | Added Terminal, Model, Status Line lessons | [Learning Path](lessons/README.md) |
| 2026-01-11 | Added Expert Patterns (Parallel Sessions, Lean Memory) | [Expert Patterns](reference/expert-patterns/) |
| 2025-01-10 | Reorganized lessons into thematic sections | [Learning Path](lessons/README.md) |
| 2025-01-10 | Added Forked Context module | [08-forked-context](lessons/context-management/08-forked-context.md) |
| 2025-01-10 | Initial structure | - |

## Start Here

**New to Claude Code?** Follow the lessons in order:

### Foundations (Lessons 1-3)

| # | Lesson | Time | What You'll Learn |
|---|--------|------|-------------------|
| 1 | [Core Concepts](lessons/foundations/01-core-concepts.md) | 15 min | How Claude Code works |
| 2 | [Commands](lessons/foundations/02-commands.md) | 20 min | Create slash commands |
| 3 | [Skills](lessons/foundations/03-skills.md) | 15 min | Build reusable skills |

### Configuration (Lessons 4-6)

| # | Lesson | Time | What You'll Learn |
|---|--------|------|-------------------|
| 4 | [Settings](lessons/configuration/04-settings.md) | 10 min | Configure permissions |
| 4a | [Terminal Config](lessons/configuration/04a-terminal-config.md) | 15 min | Notifications, parallel sessions |
| 4b | [Model Config](lessons/configuration/04b-model-config.md) | 15 min | Model selection (opusplan) |
| 4c | [Status Line](lessons/configuration/04c-statusline.md) | 15 min | Custom status display |
| 5 | [CLAUDE.md](lessons/configuration/05-claude-md.md) | 15 min | Project context files |
| 6 | [Hooks](lessons/configuration/06-hooks.md) | 15 min | Automate with triggers |

### Context Management (Lessons 7-8)

| # | Lesson | Time | What You'll Learn |
|---|--------|------|-------------------|
| 7 | [Subagents](lessons/context-management/07-subagents.md) | 20 min | Delegate to specialists |
| 8 | [Forked Context](lessons/context-management/08-forked-context.md) | 25 min | History-aware isolation |
| 8a | [Forked Context Visualized](lessons/context-management/08a-forked-context-visualized.md) | 15 min | Visual deep-dive with examples |

### Extensibility (Lessons 9-11)

| # | Lesson | Time | What You'll Learn |
|---|--------|------|-------------------|
| 9 | [MCP](lessons/extensibility/09-mcp.md) | 20 min | Connect external tools |
| 10 | [Plugins](lessons/extensibility/10-plugins.md) | 25 min | Bundle & share team setups |
| 11 | [LSP](lessons/extensibility/11-lsp.md) | 20 min | Code intelligence |

**Total time**: ~4.5 hours

## Learning Tracks

### Track 1: Quick Start (1 hour)
For developers who want to get productive fast:
- 01-core-concepts → 04-settings → 05-claude-md → 02-commands

### Track 2: Power User (2 hours)
For developers already familiar with basics:
- 04a-terminal-config → 04b-model-config → 04c-statusline
- 07-subagents → 08-forked-context → Expert Patterns

### Track 3: Full Course (4.5 hours)
Complete all lessons in order.

### Track 4: Command Design (1.5 hours)
For developers building parameterized commands:
- 02-commands → 03-skills
- Practice with [ACBS Example Commands](.claude/commands/examples/acbs/)

## Quick Links

- [Visual Schema (CZ)](visual-schema.md) — Mapa učení s Mermaid diagramy
- [Learning Path Overview](lessons/README.md) — Thematic lesson navigation
- [Reference Docs](reference/) — Look up syntax and examples
- [Shortcuts (CZ)](reference/shortcuts-cz.md) — Kompletní tahák (80+ flagů, 30+ příkazů)
- [Expert Patterns](reference/expert-patterns/) — Parallel sessions, lean memory
- [Exercises](exercises/) — Hands-on practice
- [Team Template](team-template/) — Copy-paste configurations

## Expert Patterns

After completing the core lessons:

| Pattern | What You'll Learn |
|---------|-------------------|
| [Parallel Sessions](reference/expert-patterns/parallel-sessions.md) | Run 5+ Claude sessions, notifications, handoffs |
| [Lean Memory](reference/expert-patterns/lean-memory.md) | Keep CLAUDE.md under 100 lines, imports |

## Customize Your Experience

**Output Styles** control how Claude responds — from ultra-concise to detailed explanations.

| Style | Best For |
|-------|----------|
| `concise` | Quick tasks, minimal chatter |
| `explanatory` | Learning, understanding decisions |
| `verbose` | Complex debugging, detailed analysis |

Change styles anytime:
```bash
# In session
/output-style concise

# Or via CLI
claude --output-style explanatory
```

Create custom styles in `.claude/output-styles/` — see [Output Styles Guide](reference/output-styles/creating-styles.md).

## Using This Repo

```bash
cd agentic-engineer-playbook
claude
> /prime
```

### Staying in Sync

This repo receives regular updates. To sync while keeping your customizations:

```bash
git pull origin main    # Your local/ folders are gitignored, safe!
/prime                  # Refresh Claude's understanding
```

### Adding Your Customizations

| What | Where | Git Status |
|------|-------|------------|
| Personal commands | `.claude/commands/local/` | Gitignored |
| Personal agents | `.claude/agents/local/` | Gitignored |
| Local rules | `CLAUDE.local.md` | Gitignored |

Your changes in `local/` folders **never conflict** with upstream updates.

**Full guide**: [CONTRIBUTING.md](CONTRIBUTING.md)

---

**Maintainer**: Jakub Strouhal
