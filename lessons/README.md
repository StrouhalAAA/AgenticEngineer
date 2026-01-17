# Learning Path

> Master Claude Code in ~4.5 hours through structured lessons.

---

## Foundations (Lessons 1-3)

Start here. Understand the mental model.

| Lesson | Topic | Time | Prereqs |
|--------|-------|------|---------|
| [01-core-concepts](foundations/01-core-concepts.md) | How Claude Code works | 15 min | None |
| [02-commands](foundations/02-commands.md) | Create slash commands | 20 min | 01 |
| [03-skills](foundations/03-skills.md) | Build auto-invoked skills | 15 min | 01, 02 |

---

## Configuration (Lessons 4-6)

Customize behavior, terminal setup, and project context.

| Lesson | Topic | Time | Prereqs |
|--------|-------|------|---------|
| [04-settings](configuration/04-settings.md) | Permissions & defaults | 10 min | 01 |
| [04a-terminal-config](configuration/04a-terminal-config.md) | Terminal optimization | 15 min | 04 |
| [04b-model-config](configuration/04b-model-config.md) | Model selection | 15 min | 04 |
| [04c-statusline](configuration/04c-statusline.md) | Custom status line | 15 min | 04a |
| [05-claude-md](configuration/05-claude-md.md) | Project context files | 15 min | 01 |
| [06-hooks](configuration/06-hooks.md) | Event-driven automation | 15 min | 04 |

---

## Context Management (Lessons 7-8)

Master isolation strategies for complex workflows.

| Lesson | Topic | Time | Prereqs |
|--------|-------|------|---------|
| [07-subagents](context-management/07-subagents.md) | Delegate to specialists | 20 min | 01, 03 |
| [08-forked-context](context-management/08-forked-context.md) | History-aware isolation | 25 min | 07 |
| [08a-forked-context-visualized](context-management/08a-forked-context-visualized.md) | Visual deep-dive | 15 min | 08 |

See [Context Management Overview](context-management/README.md) for decision guidance.

---

## Extensibility (Lessons 9-11)

Connect external tools, share configurations, and enable code intelligence.

| Lesson | Topic | Time | Prereqs |
|--------|-------|------|---------|
| [09-mcp](extensibility/09-mcp.md) | Model Context Protocol | 20 min | 01 |
| [10-plugins](extensibility/10-plugins.md) | Bundle & distribute | 25 min | 02, 03 |
| [11-lsp](extensibility/11-lsp.md) | Language Server Protocol | 20 min | 10 |

---

## Quick Navigation

| I want to... | Go to |
|--------------|-------|
| Understand the basics | [01-core-concepts](foundations/01-core-concepts.md) |
| Create a slash command | [02-commands](foundations/02-commands.md) |
| Build a reusable skill | [03-skills](foundations/03-skills.md) |
| Configure permissions | [04-settings](configuration/04-settings.md) |
| Set up notifications for parallel sessions | [04a-terminal-config](configuration/04a-terminal-config.md) |
| Choose the right model | [04b-model-config](configuration/04b-model-config.md) |
| Add a custom status line | [04c-statusline](configuration/04c-statusline.md) |
| Set up project context | [05-claude-md](configuration/05-claude-md.md) |
| Automate with triggers | [06-hooks](configuration/06-hooks.md) |
| Delegate to subagents | [07-subagents](context-management/07-subagents.md) |
| Use forked context | [08-forked-context](context-management/08-forked-context.md) |
| See forked context visualized | [08a-forked-context-visualized](context-management/08a-forked-context-visualized.md) |
| Connect external tools | [09-mcp](extensibility/09-mcp.md) |
| Share team configurations | [10-plugins](extensibility/10-plugins.md) |
| Enable IDE-like code intelligence | [11-lsp](extensibility/11-lsp.md) |

---

## Expert Patterns

After completing the lessons, explore advanced patterns:

| Pattern | Description |
|---------|-------------|
| [Parallel Sessions](../reference/expert-patterns/parallel-sessions.md) | Run 5+ Claude sessions simultaneously |
| [Lean Memory](../reference/expert-patterns/lean-memory.md) | Keep CLAUDE.md under 100 lines |

---

## Learning Tracks

### Track 1: Quick Start (1 hour)
For developers who want to get productive fast:
- 01-core-concepts (15 min)
- 04-settings (10 min)
- 05-claude-md (15 min)
- 02-commands (20 min)

### Track 2: Full Course (4.5 hours)
Complete all lessons in order.

### Track 3: Power User (2 hours)
For developers already familiar with basics:
- 04a-terminal-config (15 min)
- 04b-model-config (15 min)
- 04c-statusline (15 min)
- 07-subagents (20 min)
- 08-forked-context (25 min)
- Expert Patterns (30 min)
