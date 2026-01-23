# Example Commands

> Teaching examples demonstrating Claude Code command patterns.

## Purpose

These commands exist primarily for **learning**, not production use. Each demonstrates a specific pattern or teaching point that helps developers understand how to build their own commands.

## Available Examples

### Plan Execution

| Command | What It Teaches |
|---------|-----------------|
| `/examples:build` | **Minimal execution pattern** - Simplest possible plan executor |

Compare with `/implement` in `workflows/` to see the progression from minimal to production-ready.

### ACBS Patterns

| Command | What It Teaches |
|---------|-----------------|
| `/examples:acbs:audit-domain` | Single variable resolution |
| `/examples:acbs:analyze-product` | Multi-variable resolution |
| `/examples:acbs:find-endpoint` | Search pattern with normalization |

See [acbs/README.md](acbs/README.md) for detailed documentation.

### Context Patterns

| Command | What It Teaches |
|---------|-----------------|
| `/examples:forked-context-demo` | Using `context: fork` for isolated analysis |

## Simple vs Production Commands

The `/examples:build` command demonstrates the **minimal viable** execution pattern:

```markdown
# Build: $ARGUMENTS

1. Read the plan at `$ARGUMENTS`
2. Implement each step
3. Report with `git diff --stat`
```

Compare this with `/implement` which adds:
- Phase-by-phase execution with pause points
- Validation between phases
- Error handling and recovery options
- Progress tracking
- Backup creation for replaced files

**When to use simple:**
- Personal scripts
- Quick prototyping
- Low-risk tasks

**When to use structured:**
- Team-shared workflows
- Multi-step operations
- Production codebases

## Learning Path

1. Start with `/examples:build` to understand the core pattern
2. Try `/implement` to see production-grade features
3. Build your own using the appropriate complexity level

## Related

- [02-commands.md](../../../lessons/foundations/02-commands.md) - Command fundamentals
- [workflows/](../workflows/) - Production-ready commands
