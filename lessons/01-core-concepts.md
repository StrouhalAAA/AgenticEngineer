# Module 01: Core Concepts

> **Understand what Claude Code is, how it thinks, and why it works the way it does.**

---

## What Is Claude Code?

Claude Code is an **agentic coding assistant** that runs in your terminal. Unlike chat-based AI (where you ask questions and get answers), Claude Code can:

- **Read** your files and understand your codebase
- **Write** new files and modify existing ones
- **Execute** shell commands (npm, git, python, etc.)
- **Search** the web for documentation
- **Orchestrate** complex multi-step workflows

```
┌─────────────────────────────────────────────────────────────┐
│                    CLAUDE CODE CAPABILITIES                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Traditional Chat AI          Claude Code (Agentic)        │
│   ─────────────────            ─────────────────────        │
│                                                              │
│   You: "How do I fix          You: "Fix this bug"           │
│        this bug?"                                            │
│                                                              │
│   AI: "Try changing           Claude Code:                  │
│        line 42 to..."         1. Reads the file             │
│                                2. Understands the issue      │
│   You: *manually edit*        3. Edits the file             │
│                                4. Runs tests                 │
│   You: "Did that work?"       5. Reports: "Fixed. Tests pass"│
│                                                              │
│   AI: "Let me see..."         (You reviewed 1 diff instead  │
│                                of 5 back-and-forth messages) │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Key Insight**: Claude Code is a colleague, not a search engine. You describe outcomes, it handles execution.

---

## The Context Window

Everything Claude Code knows during a session exists in the **context window** — a fixed-size memory buffer.

### What Goes Into Context

```
┌─────────────────────────────────────────────────────────────┐
│                     CONTEXT WINDOW                           │
│                     (~200K tokens)                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐  Loaded automatically at start         │
│  │  System Prompt   │  (Claude Code's base instructions)     │
│  │  CLAUDE.md       │  (your project context)                │
│  │  Skill Summaries │  (100-token descriptions)              │
│  └──────────────────┘                                        │
│                                                              │
│  ┌──────────────────┐  Added during conversation             │
│  │  Your Messages   │  (prompts you type)                    │
│  │  Claude Responses│  (what Claude says/does)               │
│  │  File Contents   │  (when Claude reads files)             │
│  │  Command Output  │  (results of bash commands)            │
│  │  Tool Results    │  (search results, etc.)                │
│  └──────────────────┘                                        │
│                                                              │
│  ┌──────────────────┐  As window fills up                    │
│  │  Older content   │  ← Gets compressed or dropped          │
│  └──────────────────┘                                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Why Context Matters

1. **Front-loading**: Information at the start of context gets more attention
2. **Pollution**: Irrelevant content wastes tokens and degrades quality
3. **Compaction**: Use `/compact` to summarize and free space
4. **Fresh starts**: Use `/clear` to reset completely

### Practical Implications

| Situation | What Happens | Solution |
|-----------|-------------|----------|
| Long session | Context fills up | `/compact` or `/clear` |
| Reading large files | Uses many tokens | Read specific sections |
| Many tool results | Clutters context | Use subagents (isolated context) |
| Repeated errors | Claude keeps old context | `/clear` and restart |

---

## Permission Model

Claude Code operates on a **permission-based security model**. You control exactly what it can do.

### Permission Levels

```
┌─────────────────────────────────────────────────────────────┐
│                    PERMISSION LEVELS                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  LEVEL 1: READ ONLY                                         │
│  ──────────────────                                         │
│  Tools: Read, Glob, Grep                                    │
│  Can: View files, search patterns, understand codebase      │
│  Cannot: Modify anything                                     │
│  Use for: Code review, exploration, Q&A                     │
│                                                              │
│  LEVEL 2: EDIT FILES                                        │
│  ──────────────────                                         │
│  Tools: Read, Write, Edit + Level 1                         │
│  Can: Create and modify files                               │
│  Cannot: Run commands, use git                              │
│  Use for: Writing code with manual testing                  │
│                                                              │
│  LEVEL 3: RUN COMMANDS                                      │
│  ──────────────────                                         │
│  Tools: Bash + Level 2                                      │
│  Can: Run npm, python, tests, builds                        │
│  Cannot: Git operations (by default)                        │
│  Use for: Full development with AI                          │
│                                                              │
│  LEVEL 4: FULL AUTONOMY                                     │
│  ──────────────────                                         │
│  Tools: All tools including Git                             │
│  Can: Commit, branch, push, complete workflows              │
│  Caution: Review changes before pushing                     │
│  Use for: Automated pipelines, CI/CD                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### How Permissions Work

In `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Edit", 
      "Write",
      "Bash(npm:*)",
      "Bash(git status)",
      "Bash(git diff)"
    ],
    "deny": [
      "Bash(rm -rf:*)",
      "Bash(git push:*)"
    ]
  }
}
```

**Pattern matching**: Use wildcards for flexibility
- `Bash(npm:*)` — allows all npm commands
- `Bash(git:*)` — allows all git commands
- `Bash(git status)` — allows only git status

---

## Interactive vs Programmatic Mode

Two ways to use Claude Code, each for different situations.

### Interactive Mode (Default)

```bash
$ claude
# Opens a conversation
# You type, Claude responds, you type again
# You're at the keyboard guiding each step
```

**When to use**:
- Exploring a new codebase
- Complex tasks requiring human judgment
- Learning how Claude Code works
- Sensitive changes needing review

### Programmatic Mode (-p flag)

```bash
$ claude -p "Run tests and fix any failures"
# Claude executes immediately
# No conversation, no human input
# Runs to completion autonomously
```

**When to use**:
- CI/CD pipelines
- Scheduled automation
- Batch processing
- Known, repeatable tasks

### Comparison

| Aspect | Interactive | Programmatic |
|--------|-------------|--------------|
| Human required | Yes | No |
| Guidance | Step-by-step | Upfront only |
| Permission prompts | Yes (by default) | Configurable |
| Use case | Development | Automation |
| Command | `claude` | `claude -p "..."` |

---

## Tools Available

Claude Code has access to these built-in tools:

| Tool | Purpose | Example |
|------|---------|---------|
| **Read** | View file contents | Read src/index.ts |
| **Write** | Create new files | Create new component |
| **Edit** | Modify existing files | Fix bug in function |
| **Glob** | Find files by pattern | Find all *.test.ts files |
| **Grep** | Search file contents | Find usages of function |
| **Bash** | Run shell commands | npm test, git status |
| **WebSearch** | Search the internet | Find documentation |
| **WebFetch** | Fetch web pages | Read API docs |
| **Task** | Spawn subagent | Delegate specialized work |

### Tool Selection

Claude automatically selects appropriate tools. You can also restrict tools:

```markdown
---
allowed-tools: Read, Grep, Glob
---
# This command can only read, not modify
```

---

## Key Mental Models

### 1. Claude Code as a Junior Developer

Think of Claude Code as a capable but literal junior developer:
- **Follows instructions precisely** — be specific
- **Doesn't infer hidden requirements** — state everything
- **Works best with clear scope** — break down large tasks
- **Benefits from examples** — show what you want

### 2. Context = Working Memory

Everything in context is "in mind":
- Keep context clean and relevant
- Front-load important information
- Use CLAUDE.md for persistent context
- Use subagents for isolated tasks

### 3. Permissions = Trust Boundaries

Grant minimum necessary permissions:
- Start restrictive, add as needed
- Use wildcards thoughtfully
- Deny dangerous operations explicitly
- Review before granting git push

---

## Hands-On Exercise

### Exercise 1.1: Explore Permission Levels

1. Start Claude Code in your project:
   ```bash
   claude
   ```

2. Ask Claude what tools it has available:
   ```
   > What tools do you have access to?
   ```

3. Try a read-only operation:
   ```
   > List all TypeScript files in this project
   ```

4. Try a modification (watch for permission prompt):
   ```
   > Create a file called test.txt with "Hello World"
   ```

5. Check your settings:
   ```
   > Show me your current permission settings
   ```

### Exercise 1.2: Context Awareness

1. Start a fresh session:
   ```bash
   claude
   ```

2. Ask about context:
   ```
   > How many tokens are in your current context?
   ```

3. Read a large file:
   ```
   > Read the largest file in this project
   ```

4. Check context again:
   ```
   > How has your context changed?
   ```

5. Try compacting:
   ```
   > /compact
   ```

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Agentic** | Claude Code acts, not just advises |
| **Context Window** | Fixed memory; manage it carefully |
| **Permissions** | You control what Claude can do |
| **Interactive** | Human-in-the-loop guidance |
| **Programmatic** | Autonomous execution |
| **Tools** | Read, Write, Edit, Bash, Search, etc. |

---

## Next Module

Continue to [02-commands.md](./02-commands.md) to learn the slash command system.
