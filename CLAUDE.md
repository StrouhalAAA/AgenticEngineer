# Agentic Engineer Playbook

## Purpose
Educational repository teaching Claude Code fundamentals to development teams.

> 🆕 **Updated for Claude Code 2.1.x** — January 2026

## Structure
- `START_HERE.md` - Begin here
- `lessons/` - Core lessons in 4 sections
  - `foundations/` - Core concepts, commands, skills (01-03)
  - `configuration/` - Settings, terminal, model, statusline, CLAUDE.md, hooks (04-06)
  - `context-management/` - Subagents, forked context (07-08)
  - `extensibility/` - MCP, plugins, LSP (09-11)
- `reference/` - Quick lookup
  - `expert-patterns/` - Parallel sessions, lean memory
  - `skills/`, `subagents/`, `hooks/`, `settings/`, `plugins/`
- `learn/claude-code/changelog/` - Version tracking
- `agentic-coding/` - Advanced TAD training
- `team-template/` - Copy-paste team configurations
- `exercises/` - Hands-on practice

## Commands
- `/prime` - Initialize codebase
- `/feature <desc>` - Plan feature (with forked context analysis)
- `/bug <desc>` - Plan bug fix
- `/implement` - Execute implementation plan

## Key Concepts

### Model Configuration
- **opusplan** - Recommended default: Opus for planning, Sonnet for execution
- **Model aliases**: `sonnet`, `opus`, `haiku`, `opusplan`
- Configure in settings.json: `"model": "opusplan"`

### Terminal Optimization
- Enable iTerm2 notifications for parallel sessions
- Configure status line for model/cost visibility
- Use Shift+Enter for multi-line prompts

### Lean Memory Principle
- Keep CLAUDE.md under 100 lines (~2.5k tokens)
- Use `@path/to/file.md` imports for details
- Update when Claude makes mistakes

### Context Isolation
Three strategies for managing context:
1. **Main context** - Default, everything visible
2. **Subagents** - Start empty, parallel specialized work
3. **Forked context** - Inherits history, discards execution traces

See `lessons/context-management/` for deep dive.

## What's New in 2.1.x

| Feature | Lesson |
|---------|--------|
| Model aliases (opusplan) | [04b-model-config](lessons/configuration/04b-model-config.md) |
| Status line configuration | [04c-statusline](lessons/configuration/04c-statusline.md) |
| @import syntax in CLAUDE.md | [05-claude-md](lessons/configuration/05-claude-md.md) |
| Skills hot-reload | [03-skills](lessons/foundations/03-skills.md) |
| Agent-scoped hooks | [06-hooks](lessons/configuration/06-hooks.md) |
| `context: fork` | [08-forked-context](lessons/context-management/08-forked-context.md) |

## Expert Patterns

| Pattern | Reference |
|---------|-----------|
| Run 5+ parallel sessions | [parallel-sessions.md](reference/expert-patterns/parallel-sessions.md) |
| Keep CLAUDE.md lean | [lean-memory.md](reference/expert-patterns/lean-memory.md) |

## Navigation
Start with START_HERE.md, follow lessons 1-11, explore reference/ and expert patterns as needed.
