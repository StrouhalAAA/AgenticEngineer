# Sub-Agents & The Task Tool in Claude Code

## What Are Sub-Agents?

Sub-agents are **isolated execution contexts** that Claude can spawn to handle specialized tasks. Think of them as hiring a specialist contractor for a specific job—they work independently, have their own tools, and report back when done.

```
┌─────────────────────────────────────────────────────────┐
│                    Main Claude Context                   │
│                                                          │
│  User: "Review my auth module for security issues"       │
│                    │                                     │
│                    ▼                                     │
│           ┌──────────────┐                              │
│           │  Task Tool   │                              │
│           └──────────────┘                              │
│                    │                                     │
└────────────────────┼────────────────────────────────────┘
                     ▼
        ┌─────────────────────────────┐
        │   Sub-Agent (Isolated)      │
        │                             │
        │  • Own context window       │
        │  • Specialized tools        │
        │  • Focused prompt           │
        │  • Returns summary only     │
        └─────────────────────────────┘
```

---

## The Task Tool Structure

The Task tool is how Claude spawns sub-agents. Here's the anatomy:

```python
sub_task = {
    "name": "Task",
    "parameters": {
        "description": "Find authentication handlers",      # Short label (3-5 words)
        "prompt": "Search for auth handler functions...",   # Detailed instruction
        "subagent_type": "Explore",                         # Which agent type to use
        "model": "haiku",                                   # Optional: model override
        "run_in_background": False                          # Optional: async execution
    }
}
```

### Parameter Breakdown

| Parameter | Required | Purpose |
|-----------|----------|---------|
| `description` | Yes | Short label for tracking (3-5 words) |
| `prompt` | Yes | Detailed instructions for the sub-agent |
| `subagent_type` | Yes | Which specialized agent to use |
| `model` | No | Override model (haiku, sonnet, opus) |
| `run_in_background` | No | Run async, check later with TaskOutput |

---

## Built-In Sub-Agent Types

### 1. Explore Agent
**Purpose**: Fast, read-only codebase exploration
**Model**: Haiku (fast, cheap)
**Tools**: Glob, Grep, Read, Bash (read-only)

```python
{
    "subagent_type": "Explore",
    "prompt": "Find all files that handle user authentication. Return file paths only."
}
```

**When to use**:
- Searching for code patterns
- Understanding codebase structure
- Finding file locations
- No modifications needed

### 2. General-Purpose Agent
**Purpose**: Complex multi-step tasks requiring exploration AND action
**Model**: Sonnet (balanced)
**Tools**: All tools available

```python
{
    "subagent_type": "general-purpose",
    "prompt": "Find all deprecated API calls and update them to the new format."
}
```

**When to use**:
- Tasks requiring both search and modification
- Complex reasoning needed
- Multiple strategies may be required

### 3. Plan Agent
**Purpose**: Research and context gathering for planning
**Model**: Sonnet
**Tools**: Read, Glob, Grep, Bash (read-only)

Used automatically in plan mode (`--permission-mode plan`).

---

## When to Use Sub-Agents vs Direct Tools

### Use Sub-Agents When:

| Scenario | Why |
|----------|-----|
| **Specialized expertise needed** | Security review, debugging, performance analysis |
| **Context pollution concern** | Large searches would clutter main conversation |
| **Parallel workflows** | Multiple independent tasks can run simultaneously |
| **Tool restriction needed** | Agent should only have read access |
| **Reusable workflow** | Same process used across projects |

### Use Direct Tool Calls When:

| Scenario | Why |
|----------|-----|
| **Simple, immediate task** | "What's in this file?" |
| **Results inform next step** | Read file, then edit it |
| **Single command** | Just running `git status` |

---

## Integrating Sub-Agents with /Commands

The real power comes from combining sub-agents with slash commands to create reusable workflows.

### Example 1: Security Audit Command

Create `.claude/commands/security-audit.md`:

```markdown
---
description: Run security audit on specified module
argument-hint: [module-path]
allowed-tools: Read, Grep, Glob
---

# Security Audit

Use the Explore subagent to analyze the $ARGUMENTS module for:

1. Hardcoded secrets or API keys
2. SQL injection vulnerabilities
3. Input validation issues
4. Authentication bypass risks
5. Sensitive data exposure

Report findings with:
- Severity level (Critical/High/Medium/Low)
- File path and line number
- Code snippet showing the issue
- Recommended fix
```

**Usage**: `/security-audit src/auth/`

### Example 2: Code Review Pipeline

Create `.claude/commands/full-review.md`:

```markdown
---
description: Comprehensive code review with multiple specialists
---

# Complete Code Review Pipeline

## Phase 1: Structure Analysis
Use the Explore subagent to understand:
- File organization
- Dependencies
- Module boundaries

## Phase 2: Code Quality Review
Use the general-purpose subagent to check:
- Code clarity and naming
- DRY principle adherence
- Error handling patterns
- Test coverage

## Phase 3: Security Scan
Use the Explore subagent to find:
- Authentication issues
- Input validation gaps
- Secret exposure risks

Provide a combined report with prioritized action items.
```

### Example 3: Smart Routing Command

Create `.claude/commands/smart-review.md`:

```markdown
---
description: Routes review to appropriate specialist based on changes
---

# Smart Review Router

First, analyze `git diff` to understand what changed.

Then route to the appropriate specialist:
- **Security changes** (auth, permissions, crypto) → Use security-focused prompts
- **Performance code** (loops, queries, caching) → Use performance analysis prompts
- **UI changes** (components, styling) → Use UX review prompts
- **Business logic** → Use standard code review prompts

Select the most relevant approach and provide findings.
```

---

## Creating Custom Sub-Agents

Place custom agents in `.claude/agents/`:

### Example: Custom Code Reviewer

Create `.claude/agents/code-reviewer.md`:

```markdown
---
name: code-reviewer
description: Expert code review specialist. Use after writing significant code.
tools: Read, Grep, Glob, Bash
model: inherit
---

# Code Review Agent

You are a senior code reviewer ensuring high standards.

## Your Process
1. Run `git diff` to see recent changes
2. Focus on modified files
3. Apply the checklist below

## Review Checklist

### Critical (Must Fix)
- [ ] Code is clear and readable
- [ ] Functions/variables well-named
- [ ] No duplicated code
- [ ] Proper error handling
- [ ] No exposed secrets

### Warnings (Should Fix)
- [ ] Test coverage adequate
- [ ] Performance considered
- [ ] Follows project patterns

### Suggestions (Consider)
- [ ] Refactoring opportunities
- [ ] Documentation gaps
- [ ] Edge cases handled

## Output Format

**Critical Issues:**
- Issue: [description]
- Location: `file:line`
- Fix: [how to fix]

**Warnings:**
- [description and recommendation]

**Suggestions:**
- [optional improvements]
```

---

## File Locations Reference

| Type | Location |
|------|----------|
| Project commands | `.claude/commands/*.md` |
| Project agents | `.claude/agents/*.md` |
| User-wide commands | `~/.claude/commands/*.md` |
| User-wide agents | `~/.claude/agents/*.md` |

---

## Practical Examples

### Example A: Finding Code Patterns

```python
# Task tool invocation to find all error handlers
{
    "name": "Task",
    "parameters": {
        "description": "Find error handling patterns",
        "prompt": "Search the codebase for try/catch blocks and error handling patterns. Return a summary of the different approaches used with file locations.",
        "subagent_type": "Explore"
    }
}
```

### Example B: Parallel Analysis

```python
# Launch multiple sub-agents simultaneously
tasks = [
    {
        "description": "Analyze auth module",
        "prompt": "Review authentication code for security issues",
        "subagent_type": "Explore",
        "run_in_background": True
    },
    {
        "description": "Analyze API module",
        "prompt": "Review API endpoints for security issues",
        "subagent_type": "Explore",
        "run_in_background": True
    }
]
# Both run in parallel, results collected later
```

### Example C: Chained Workflow

```python
# Step 1: Explore to find issues
explore_task = {
    "description": "Find deprecated patterns",
    "prompt": "Find all uses of deprecated API v1 calls",
    "subagent_type": "Explore"
}

# Step 2: General-purpose to fix them (after explore completes)
fix_task = {
    "description": "Update deprecated calls",
    "prompt": "Update the deprecated v1 API calls found to use v2 format",
    "subagent_type": "general-purpose"
}
```

---

## Key Concepts Summary

| Concept | Description |
|---------|-------------|
| **Context Isolation** | Sub-agents have separate memory, don't pollute main context |
| **Tool Restriction** | Can limit which tools a sub-agent can access |
| **Model Selection** | Choose speed (haiku) vs capability (sonnet/opus) |
| **Parallel Execution** | Multiple sub-agents can run simultaneously |
| **Specialization** | Custom agents with focused expertise |

---

## Anti-Patterns to Avoid

| Don't | Why | Do Instead |
|-------|-----|------------|
| Use sub-agents for simple reads | Overhead not worth it | Direct `Read` tool |
| Spawn sub-agents in loops | Context explosion | Batch into single agent |
| Give all tools to every agent | Security/focus risk | Restrict to needed tools |
| Vague prompts | Poor results | Specific, structured prompts |

---

## Next Steps

1. **Create your first command**: Start with a simple `/find-pattern` command
2. **Add a custom agent**: Create a specialist for your domain
3. **Combine them**: Build a pipeline that chains multiple agents
4. **Test and iterate**: Refine prompts based on results

---
