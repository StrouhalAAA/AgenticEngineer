# Module 01: Core Concepts

> **Understand what Claude Code is, how it thinks, and why it works the way it does.**

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01-10 | Initial release |

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

### Context Schema: What Actually Loads

```
CONTEXT LOADING ORDER (each session)
─────────────────────────────────────

1. SYSTEM LAYER (~10K tokens) — Always present
   ├── Claude Code base instructions
   ├── Safety & permission rules
   ├── Tool definitions
   ├── MCP server connections
   └── Sub-agent definitions

2. PROJECT LAYER (~5-20K tokens) — Your customization
   ├── CLAUDE.md (project root)           ← Primary context
   ├── .claude/settings.json              ← Permissions
   ├── .claude/commands/**/*.md           ← Skill summaries only
   │   └── (full skill loads when invoked)
   └── .mcp.json                          ← MCP server configs

3. CONVERSATION LAYER (variable) — Grows during session
   ├── User message #1
   ├── Claude response #1
   │   └── Tool calls & results
   ├── User message #2
   ├── Claude response #2
   │   └── Read file (full contents!)
   │   └── Grep results
   │   └── Bash output
   └── ... continues growing ...

4. COMPRESSION LAYER — When context fills
   └── Older messages → summarized
   └── Tool traces → condensed
   └── File contents → may be dropped
```

> ⚠️ **Context Budget Warning**: MCP servers and sub-agent definitions consume tokens before you even start working. If you have many MCP connections or complex sub-agent configs, your effective working context shrinks. Keep your setup lean—only enable what you need for the current task.

**Key insight**: File reads and tool outputs consume the most tokens. This is why **One Agent = One Job** keeps context clean—each agent starts fresh without accumulated tool traces.

### Why Context Matters

1. **Front-loading**: Information at the start of context gets more attention
2. **Pollution**: Irrelevant content wastes tokens and degrades quality
3. **Fresh starts**: Open a new terminal session for a clean agent
4. **One Agent = One Job**: The best practice for context management

### 🔑 Key Practice: One Agent = One Job

**Instead of** using `/compact` to squeeze more into a single session, **practice the discipline of One Agent = One Job with separate terminal sessions**:

```
┌─────────────────────────────────────────────────────────────┐
│              ONE AGENT = ONE JOB PRINCIPLE                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ❌ Anti-pattern: Kitchen Sink Agent                       │
│   ─────────────────────────────────                         │
│   1. Analyze the codebase                                   │
│   2. Plan the feature                                       │
│   3. Implement the feature                                  │
│   4. Write tests                                            │
│   5. Fix bugs                                               │
│   6. /compact (running out of space!)                       │
│   7. Document everything                                    │
│   8. Create PR                                              │
│   → Context polluted, quality degrades                      │
│                                                              │
│   ✅ Best practice: Separate Terminal Sessions              │
│   ─────────────────────────────────────────                 │
│   Terminal 1: $ claude                                      │
│               > /feature "add user auth" → specs/*.md       │
│               (done, close or leave open)                   │
│                                                              │
│   Terminal 2: $ claude  ← fresh session, no prior context   │
│               > /implement specs/auth.md → writes code      │
│                                                              │
│   Terminal 3: $ claude  ← fresh session                     │
│               > "Run tests and fix" → validates             │
│                                                              │
│   → Each agent starts completely clean                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Why separate sessions work better than /clear**:
- Guaranteed clean slate — no residual context artifacts
- Each agent has maximum context for its specific task
- No accumulated noise from previous steps
- Outputs are structured for the next agent to consume
- Easier to retry a single step if something goes wrong
- You can run multiple agents in parallel (different terminals)

### Practical Implications

| Situation | What Happens | Solution |
|-----------|-------------|----------|
| Complex feature | Multiple concerns | Break into chain: analyze → plan → implement (separate terminals) |
| Reading large files | Uses many tokens | Use subagents with `context: fork` |
| Many tool results | Clutters context | Use subagents (isolated context) |
| Task complete | Context no longer needed | Open new terminal for next task |

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

Claude Code has three permission scopes with clear precedence:

```
┌─────────────────────────────────────────────────────────────┐
│                 PERMISSION SCOPES                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   1. INDIVIDUAL (Per-session)                               │
│   ───────────────────────────                               │
│   Location: Interactive prompts during session              │
│   Scope: This session only                                  │
│   Use case: One-time approval for specific action           │
│   Example: "Allow Claude to run `npm install`? [y/n]"       │
│                                                              │
│   2. PROJECT (Team-wide)                                    │
│   ───────────────────────────                               │
│   Location: .claude/settings.json (committed to repo)       │
│   Scope: Everyone working on this project                   │
│   Use case: Standard permissions for this codebase          │
│   Example: All devs can run tests, lint, build              │
│                                                              │
│   3. USER (Personal global)                                 │
│   ───────────────────────────                               │
│   Location: ~/.claude/settings.json                         │
│   Scope: All your projects on this machine                  │
│   Use case: Your personal defaults                          │
│   Example: Always allow Read operations                     │
│                                                              │
│   PRECEDENCE: Individual > Project > User                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Project Permissions (Team Settings)

In `.claude/settings.json` (commit this to your repo):

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

### User Permissions (Personal Defaults)

In `~/.claude/settings.json` (your machine only):

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep"
    ]
  }
}
```

### When to Use Which

| Scope | When to Use | Example |
|-------|-------------|---------|
| **Individual** | Untrusted or one-off actions | Running unknown script |
| **Project** | Standard team workflows | Run tests, build, lint |
| **User** | Your personal preferences | Always allow read-only |

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

**Terminal Examples**:

```bash
# Basic: Run a single task
$ claude -p "List all TODO comments in the codebase"

# With output: Save result to file
$ claude -p "Analyze this codebase and list all API endpoints" > api-endpoints.md

# In scripts: Part of larger automation
$ claude -p "Run npm test and report results" && echo "Tests passed!"

# CI/CD: Use in GitHub Actions
# - name: Fix lint errors
#   run: claude -p "Fix all ESLint errors and commit"

# Chain with pipes: Feed output to next command
$ claude -p "Generate a list of unused imports" | xargs -I {} echo "Remove: {}"
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

> **💡 Tip**: Run `/tools:prime` to see all available tools and initialize codebase understanding. This command reads your project structure and reports what's available.

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

### 1. Clear Instructions = Better Outcomes

Claude Code is highly capable, but works best with clear direction:
- **Be specific** — vague prompts get vague results
- **State requirements explicitly** — don't assume implied context
- **Scope your tasks** — one focused job per agent
- **Show examples when helpful** — demonstrate the pattern you want

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

## 🔑 Key Idea: Chain of Prompts & Higher-Order Commands

**The most powerful pattern in Claude Code is chaining commands where one agent's output becomes another agent's input.**

### What is a Higher-Order Command?

A higher-order command is a command that:
1. Takes user input (the "what")
2. Has built-in instructions (the "how")
3. Uses specific tools (the "with")
4. Produces structured output (the "result")
5. **Enables the next command to execute** (the "chain")

```
┌─────────────────────────────────────────────────────────────┐
│           HIGHER-ORDER COMMAND ANATOMY                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   /feature "add user authentication"                        │
│   ─────────────────────────────────                         │
│                                                              │
│   INPUT: User's feature description                         │
│      ↓                                                       │
│   INSTRUCTIONS: Research patterns, analyze codebase         │
│      ↓                                                       │
│   TOOLS: Read, Grep, Glob (read-only analysis)              │
│      ↓                                                       │
│   SUBAGENTS: Uses `context: fork` for isolated research     │
│      ↓                                                       │
│   OUTPUT: specs/auth-feature.md (structured plan)           │
│      ↓                                                       │
│   NEXT: /implement specs/auth-feature.md                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### The Chain Pattern in Practice

```bash
# Terminal 1: Analysis Agent
$ claude
> /feature "add OAuth2 login with Google"
# → Researches codebase, outputs: specs/oauth-login.md
# → Done. Leave open or close.

# Terminal 2: Implementation Agent (NEW terminal, fresh context)
$ claude
> /implement specs/oauth-login.md
# → Reads plan, executes phase by phase
# → No analysis noise, focused on execution

# Terminal 3: Validation Agent (NEW terminal, fresh context)
$ claude
> Run all tests and fix any failures related to OAuth
# → Validates implementation, fixes issues
# → No implementation traces cluttering context
```

> **Pro tip**: Keep multiple terminal tabs/windows open. Each `$ claude` command starts a completely fresh agent with no prior context — just CLAUDE.md and your prompt.

### Why This Works

| Traditional (Single Agent) | Chain Pattern (Multi-Agent) |
|---------------------------|----------------------------|
| Context fills with analysis noise | Each agent has clean context |
| "I read 30 files..." clutters response | Only structured output passes forward |
| Hard to retry a single step | Retry any agent independently |
| Quality degrades as context grows | Consistent quality per agent |

### Practice This Pattern

**Start building the habit of:**

1. **Analyze first, implement second**
   ```
   /feature <what you want> → produces spec
   /implement <spec file>   → executes spec
   ```

2. **Structured outputs for structured inputs**
   - Analysis command → writes to `specs/*.md`
   - Implementation command → reads from `specs/*.md`

3. **Clean handoffs between agents**
   - Open a new terminal for the next phase
   - New agent reads the artifact, not the conversation
   - Never `/clear` — start fresh with `$ claude`

> **Practice**: Try running `/feature "add a health check endpoint"` and observe how it produces a structured plan that `/implement` can execute.

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

5. Use `/clear` to reset:
   ```
   > /clear
   ```

### Exercise 1.3: Practice Chain of Prompts

1. **Terminal 1** — Start a planning session:
   ```bash
   $ claude
   ```

2. Run a planning command:
   ```
   > /feature "add a simple health check endpoint that returns { status: 'ok' }"
   ```

3. Observe the output:
   - Notice it creates a file in `specs/`
   - Notice the structured format of the plan
   - Note the filename created

4. **Terminal 2** — Open a NEW terminal window/tab:
   ```bash
   $ claude
   ```

5. In this fresh session, run implementation:
   ```
   > /implement specs/<the-file-created>.md
   ```

6. Observe the difference:
   - This agent has zero knowledge of the analysis phase
   - It reads the spec file fresh
   - Has full context available for implementation
   - No "I found 15 files..." noise from planning

**Reflection**: Notice how the second agent starts completely clean? That's the power of separate sessions vs. `/clear` in the same session.

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Agentic** | Claude Code acts, not just advises |
| **Context Window** | Fixed memory; manage it carefully |
| **One Agent = One Job** | Best practice: focused agents over /compact |
| **Permission Scopes** | Individual < Project < User precedence |
| **Interactive** | Human-in-the-loop guidance |
| **Programmatic** | Autonomous execution (`claude -p "..."`) |
| **Tools** | Read, Write, Edit, Bash, Search, Task |
| **Chain of Prompts** | `/feature` → spec → `/implement` |

---

## Next Module

Continue to [02-commands.md](./02-commands.md) to learn the slash command system.
