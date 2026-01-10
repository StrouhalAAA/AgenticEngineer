# Module 02: Commands System

> **Create reusable slash commands to standardize workflows across your team.**

---

## What Are Slash Commands?

Slash commands are **reusable prompt templates** saved as markdown files. Instead of typing the same complex instructions repeatedly, you save them once and invoke with `/command-name`.

```
┌─────────────────────────────────────────────────────────────┐
│                 WITHOUT COMMANDS                             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  You: "I need you to analyze this feature request,          │
│        research the codebase for existing patterns,         │
│        create a detailed implementation plan with           │
│        phases, save it to specs/ directory, include         │
│        testing strategy and validation commands..."         │
│                                                              │
│  (Type this every time? Error-prone and inconsistent)       │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                 WITH COMMANDS                                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  You: /feature Add dark mode support                        │
│                                                              │
│  (Same result, every time, for everyone on team)            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Command File Anatomy

Commands are markdown files with optional YAML frontmatter:

```markdown
---
description: Short description shown in /help
allowed-tools: Read, Write, Edit, Bash
model: claude-sonnet-4-20250514
argument-hint: <feature-description>
---

# Command Title

Your prompt instructions go here.

Use $ARGUMENTS to capture what the user types after the command.

## Sections help organize complex prompts

You can include:
- Step-by-step instructions
- Output format specifications
- Examples
- Constraints
```

### Frontmatter Options

| Option | Purpose | Example |
|--------|---------|---------|
| `description` | Shown in `/help` listing | `"Create implementation plan"` |
| `allowed-tools` | Restrict available tools | `Read, Grep, Glob` |
| `model` | Override default model | `claude-sonnet-4-20250514` |
| `argument-hint` | Usage hint in `/help` | `<file-path> [options]` |

---

## Built-In Variables

Claude Code provides variables for dynamic commands:

### $ARGUMENTS

Captures everything typed after the command name:

```markdown
# Analyze: $ARGUMENTS

Analyze the following and provide insights:
> $ARGUMENTS
```

Usage: `/analyze Why is this function slow?`
Result: `$ARGUMENTS` = `"Why is this function slow?"`

### Positional Parameters ($1, $2, $3...)

For structured inputs:

```markdown
# Review PR #$1 assigned to $2

Review pull request #$1
Focus on feedback for developer: $2
```

Usage: `/review 123 alice`
Result: `$1` = `123`, `$2` = `alice`

### Shell Command Injection (!`command`)

Execute shell commands inline:

```markdown
# Current Branch Status

You are on branch: !`git branch --show-current`

Recent commits:
!`git log --oneline -5`

Analyze these changes and suggest next steps.
```

### File Inclusion (@filepath)

Include file contents:

```markdown
# Code Review

Review this code:
@src/utils/auth.ts

Apply these standards:
@docs/code-standards.md
```

---

## File Locations

### Project Commands (Team-Shared)

```
.claude/commands/
├── feature.md          → /feature
├── bug.md              → /bug
├── review.md           → /review
└── workflows/
    ├── deploy.md       → /workflows:deploy
    └── release.md      → /workflows:release
```

**Commit to git** — everyone on the team gets the same commands.

### Personal Commands (User-Only)

```
~/.claude/commands/
├── my-shortcuts.md     → /my-shortcuts
└── experiments/
    └── test.md         → /experiments:test
```

**Not committed** — your personal productivity shortcuts.

### Namespace Pattern

Subdirectory paths become command prefixes:

| File Path | Command |
|-----------|---------|
| `.claude/commands/feature.md` | `/feature` |
| `.claude/commands/code/review.md` | `/code:review` |
| `.claude/commands/db/migrate.md` | `/db:migrate` |

---

## Command Design Patterns

### Pattern 1: The Planning Command

Creates a plan document without executing:

```markdown
---
description: Create detailed feature implementation plan
allowed-tools: Read, Glob, Grep, Write
argument-hint: <feature-description>
---

# Feature Plan: $ARGUMENTS

## Instructions

1. **Research** existing patterns in the codebase
2. **Identify** files that need modification
3. **Create** detailed implementation plan
4. **Save** to `specs/<feature-name>.md`

## Plan Format

The plan must include:
- Problem statement
- Solution approach
- Files to modify/create
- Implementation steps
- Testing strategy
- Validation commands

## Constraints

- DO NOT implement yet, only plan
- Keep plan under 500 lines
- Include realistic time estimates
```

### Pattern 2: The Execution Command

Executes a previously created plan:

```markdown
---
description: Execute an implementation plan
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
argument-hint: <path-to-plan.md>
---

# Implement: $ARGUMENTS

## Instructions

1. **Read** the plan at $ARGUMENTS
2. **Execute** each step in order
3. **Run** validation commands after each phase
4. **Report** completion status

## Execution Rules

- Stop if any validation fails
- Commit after each phase (if git available)
- Ask for clarification if step is ambiguous
```

### Pattern 3: The Analysis Command

Read-only analysis with structured output:

```markdown
---
description: Analyze code for security issues
allowed-tools: Read, Grep, Glob
argument-hint: <directory-or-file>
---

# Security Audit: $ARGUMENTS

## Scan Targets

Analyze: $ARGUMENTS

## Check For

1. **Hardcoded secrets**: API keys, passwords, tokens
2. **SQL injection**: Unsanitized database queries
3. **XSS vulnerabilities**: Unescaped user input
4. **Auth issues**: Missing or weak authentication

## Output Format

For each finding:

### [SEVERITY] Issue Title
- **Location**: `file:line`
- **Description**: What's wrong
- **Risk**: Why it matters
- **Fix**: How to resolve
```

---

## When to Use Commands vs Direct Prompts

### Use Commands When:

| Scenario | Why |
|----------|-----|
| Task is repeatable | Save time, ensure consistency |
| Team needs standardization | Everyone uses same workflow |
| Complex multi-step workflow | Reduce errors |
| Specific output format needed | Enforce structure |

### Use Direct Prompts When:

| Scenario | Why |
|----------|-----|
| One-off exploration | Not worth creating command |
| Highly contextual task | Needs human judgment |
| Learning/experimenting | Flexibility needed |
| Simple question | Overhead not worth it |

---

## Hands-On Exercises

### Exercise 2.1: Create Your First Command

1. Create command directory:
   ```bash
   mkdir -p .claude/commands
   ```

2. Create a simple command:
   ```bash
   cat > .claude/commands/summarize.md << 'EOF'
   # Summarize: $ARGUMENTS

   Provide a concise summary of:
   > $ARGUMENTS

   Format:
   - 1 sentence overview
   - 3 key points
   - 1 actionable takeaway
   EOF
   ```

3. Test it:
   ```
   claude
   > /summarize The benefits of test-driven development
   ```

### Exercise 2.2: Command with Tool Restrictions

1. Create a read-only analysis command:
   ```markdown
   ---
   description: Analyze code complexity
   allowed-tools: Read, Grep, Glob
   ---

   # Complexity Analysis

   Analyze $ARGUMENTS for:
   1. Functions over 50 lines
   2. Files over 300 lines
   3. Deeply nested logic (>4 levels)

   Output a prioritized list of refactoring candidates.
   ```

2. Verify it can't modify files

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Commands** | Reusable prompt templates |
| **Location** | `.claude/commands/` (project) or `~/.claude/commands/` (personal) |
| **Variables** | `$ARGUMENTS`, `$1`, `$2`, `!`command``, `@file` |
| **Frontmatter** | `description`, `allowed-tools`, `model` |
| **Namespacing** | Subdirectories create prefixes (`/dir:command`) |

---

## Next Module

Continue to [03-skills.md](./03-skills.md) to learn how skills differ from commands.
