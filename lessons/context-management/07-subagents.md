# Module 06: Agents & Subagents

> **Delegate specialized work to isolated agent contexts.**

---

## What Are Subagents?

Subagents are **isolated execution contexts** that Claude spawns to handle specific tasks. Think of them as specialists you hire for particular jobs.

```
┌─────────────────────────────────────────────────────────────┐
│                 SUBAGENT ARCHITECTURE                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│                    ┌─────────────────┐                      │
│                    │   Main Claude   │  ← Your conversation │
│                    │    (200K ctx)   │                      │
│                    └────────┬────────┘                      │
│                             │                                │
│              ┌──────────────┼──────────────┐                │
│              ▼              ▼              ▼                 │
│       ┌──────────┐   ┌──────────┐   ┌──────────┐           │
│       │ Subagent │   │ Subagent │   │ Subagent │           │
│       │ (50K ctx)│   │ (50K ctx)│   │ (50K ctx)│           │
│       │ Explore  │   │ Analyze  │   │ Research │           │
│       └────┬─────┘   └────┬─────┘   └────┬─────┘           │
│            │              │              │                   │
│            └──────────────┴──────────────┘                  │
│                    Returns: Summary (~1-2K tokens)          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Key Insight**: Subagents explore deeply but return condensed summaries, keeping your main context clean.

---

## Why Use Subagents?

### Problem: Context Pollution

Without subagents:
```
You: "Search for all auth-related files"
Claude: *reads 50 files* → *100K tokens added* → *context fills up*
```

### Solution: Isolated Exploration

With subagents:
```
You: "Search for all auth-related files"
Claude: *spawns Explore subagent*
Subagent: *reads 50 files* → *returns 500-token summary*
Main context: stays clean
```

---

## Built-In Subagent Types

| Type | Purpose | Model | Tools |
|------|---------|-------|-------|
| **Explore** | Fast, read-only codebase exploration | Haiku | Glob, Grep, Read |
| **Plan** | Research and context gathering | Sonnet | Read, Glob, Grep |
| **General-Purpose** | Complex multi-step tasks | Sonnet | All tools |

---

## Creating Custom Agents

Custom agents live in `.claude/agents/`:

```markdown
---
name: security-auditor
description: Reviews code for security vulnerabilities
tools: Read, Grep, Glob
model: sonnet
---

# Security Audit Agent

You are a senior security engineer auditing code.

## Your Mission

Analyze the specified code for:
1. OWASP Top 10 vulnerabilities
2. Hardcoded credentials
3. SQL injection risks
4. XSS vulnerabilities

## Output Format

### [SEVERITY] Issue Title
- **Location**: `file:line`
- **Description**: What's wrong
- **Fix**: How to remediate
```

### Frontmatter Options

| Option | Purpose | Example |
|--------|---------|---------|
| `name` | Agent identifier | `security-auditor` |
| `description` | When to use | `"Reviews code for security..."` |
| `tools` | Available tools | `Read, Grep, Glob` |
| `model` | Model to use | `sonnet`, `haiku`, `opus` |
| `context` | Context strategy | `inherit` or `fork` |

---

## Tool Restrictions by Role

Match tools to agent responsibilities:

| Agent Type | Tools | Use For |
|------------|-------|---------|
| **Read-Only** | Read, Grep, Glob | Code review, security audit |
| **Code Writer** | Read, Write, Edit, Bash | Implementation, bug fixing |
| **Researcher** | Read, WebSearch, WebFetch | Finding documentation |

---

## Orchestration Patterns

### Hub-and-Spoke Pattern

```
┌─────────────────┐
│  Orchestrator   │
└────────┬────────┘
    ┌────┴────┬────────┐
    ▼         ▼        ▼
┌───────┐ ┌───────┐ ┌───────┐
│Security│ │Quality│ │ Perf  │
└───────┘ └───────┘ └───────┘
```

### Sequential Chain

```
Research → Design → Implement → Test → Review
```

---

## Subagents vs Forked Context

Claude Code 2.1.0 introduced `context: fork`—a different isolation strategy. Understanding when to use each is critical:

```
┌─────────────────────────────────────────────────────────────┐
│                 ISOLATION STRATEGIES                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SUBAGENT                        FORKED CONTEXT              │
│  ────────                        ──────────────              │
│                                                              │
│  Starts with empty context       Inherits full conversation  │
│  "Fresh specialist"              "Informed assistant"        │
│                                                              │
│  Cannot see session history      Sees everything you said    │
│  "What project?"                 "I know the PRD we discussed"│
│                                                              │
│  Use for parallel tasks          Use for context-aware tasks │
│  that don't need history         that shouldn't pollute      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Decision Matrix

| Scenario | Use Subagent | Use `context: fork` |
|----------|--------------|---------------------|
| Codebase exploration | ✅ Doesn't need history | |
| Session summary for notes | | ✅ Needs to see conversation |
| Parallel security audit | ✅ Independent analysis | |
| PRD validation against code | | ✅ Must know the PRD |
| Research similar patterns | ✅ Fresh perspective | |
| Deep code review | | ✅ Context-aware feedback |

### Syntax Comparison

**Subagent** (via Task tool):
```
Claude spawns automatically when delegating complex tasks
```

**Forked Context** (in frontmatter):
```yaml
---
description: Deep analysis that needs conversation context
context: fork
---
```

→ **Deep dive**: See [Module 08: Forked Context](./08-forked-context.md) for implementation patterns.

---

## Hands-On Exercises

### Exercise 6.1: Use Built-In Explore Agent

1. Start Claude Code:
   ```bash
   claude
   ```

2. Request exploration:
   ```
   > Find all API endpoint handlers in this project
   ```

3. Notice Claude spawns Explore agent, returns summary.

### Exercise 6.2: Create a Custom Agent

1. Create agent file:
   ```bash
   mkdir -p .claude/agents
   ```

2. Create `commit-helper.md`:
   ```markdown
   ---
   name: commit-helper
   description: Analyzes changes and suggests commit messages
   tools: Read, Bash(git:*)
   model: haiku
   ---

   # Commit Message Helper

   1. Run `git diff --staged`
   2. Analyze changes
   3. Suggest conventional commit message
   ```

3. Test it:
   ```
   > Use commit-helper to suggest a message
   ```

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Subagents** | Isolated contexts for specialized tasks |
| **Explore** | Fast, read-only codebase analysis |
| **Plan** | Research for planning decisions |
| **General-Purpose** | Complex multi-step tasks |
| **Custom Agents** | `.claude/agents/<n>.md` |
| **Tools** | Match to role (read-only vs. full) |
| **vs Fork** | Subagents start empty; fork inherits context |

---

## Next Module

Continue to [08-forked-context.md](./08-forked-context.md) to master history-aware isolation.
