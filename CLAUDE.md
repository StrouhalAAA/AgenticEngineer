# Agentic Engineer Playbook

## Purpose
Educational repository teaching Claude Code fundamentals to development teams.

> 🆕 **Updated for Claude Code 2.1.0** — January 2026

## Structure
- `START_HERE.md` - Begin here
- `lessons/` - 10 core lessons in 4 sections
  - `foundations/` - Core concepts, commands, skills (01-03)
  - `configuration/` - Settings, CLAUDE.md, hooks (04-06)
  - `context-management/` - Subagents, forked context (07-08)
  - `extensibility/` - MCP, plugins (09-10)
- `reference/` - Quick lookup for skills, subagents, hooks, settings
- `learn/claude-code/changelog/` - Version tracking
- `agentic-coding/` - Advanced TAD training
- `exercises/` - Hands-on practice

## Commands
- `/prime` - Initialize codebase
- `/feature <desc>` - Plan feature (with forked context analysis)
- `/bug <desc>` - Plan bug fix
- `/implement` - Execute implementation plan

## Key Concepts

### Context Isolation (2.1.0)
Three strategies for managing context:
1. **Main context** - Default, everything visible
2. **Subagents** - Start empty, parallel specialized work
3. **Forked context** - Inherits history, discards execution traces

See `lessons/context-management/` for deep dive.

### Skills Hot-Reload (2.1.0)
Skills now activate immediately without session restart. Edit `.claude/skills/*/SKILL.md` and test instantly.

### Agent-Scoped Hooks (2.1.0)
Define PreToolUse, PostToolUse, and Stop hooks in agent/skill frontmatter. Hooks only fire during that agent's lifecycle.

### Wildcard Permissions (2.1.0)
Pre-approve command families: `Bash(npm *)`, `Bash(git *)`. Configure in `.claude/settings.json`.

## What's New in 2.1.0

| Feature | Impact |
|---------|--------|
| Skills hot-reload | No restart to test skill changes |
| `context: fork` | Isolated execution with history |
| Agent-scoped hooks | Per-agent automation |
| `once: true` hooks | Single execution per session |
| Wildcard permissions | Pre-approve command families |
| MCP `list_changed` | Dynamic tool updates |
| `/teleport` | Cross-machine session resume |

See `learn/claude-code/changelog/2026-01-07-v2.1.0.md` for full details.

## Navigation
Start with START_HERE.md, follow lessons 1-10, then explore reference/ as needed.
