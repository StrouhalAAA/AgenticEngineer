# Context Management

> Choose the right isolation strategy for your workflow.

---

## The Three Strategies

Claude Code offers three ways to manage execution context:

| Strategy | Starting State | Returns | Best For |
|----------|---------------|---------|----------|
| **Main Context** | Your conversation | Everything visible | Normal work, debugging |
| **Subagents** | Empty slate | Summary only | Parallel specialized tasks |
| **Forked Context** | Full history | Summary only | Context-aware analysis |

---

## Decision Guide

```
Does the task need conversation history?
│
├─ No  → Subagent
│        (Explore, Plan, General-Purpose)
│
└─ Yes → Should execution traces be visible?
         │
         ├─ Yes → Main context
         │        (debugging, iterative work)
         │
         └─ No  → context: fork
                  (analysis, review, research)
```

---

## Quick Comparison

| Scenario | Use |
|----------|-----|
| Explore the codebase | Subagent (Explore) |
| Summarize this session | `context: fork` |
| Debug step-by-step | Main context |
| Validate PRD against code | `context: fork` |
| Run parallel security audits | Subagent |
| Review PR with full context | `context: fork` |

---

## Lessons in This Section

1. **[07-subagents.md](07-subagents.md)** — Empty-context delegation
   - Built-in agent types (Explore, Plan, General-Purpose)
   - Creating custom agents
   - Tool restrictions and orchestration patterns

2. **[08-forked-context.md](08-forked-context.md)** — History-aware isolation
   - The `context: fork` frontmatter option
   - Implementation examples (feature analysis, PR review, security scan)
   - When NOT to use fork

---

## Related Reference

- [Subagent Patterns](../../reference/subagents/patterns.md)
