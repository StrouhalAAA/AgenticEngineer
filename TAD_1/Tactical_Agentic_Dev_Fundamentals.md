# Tactical Agentic Development (TAD) - Lesson 1

> **INTERNAL USE ONLY** — AuresHoldings employees only. Do not distribute externally.

---

## Changelog

| Version | Date       | Changes                                           |
|---------|------------|---------------------------------------------------|
| 1.0     | 2025-01-02 | Initial version                                   |

---

# PART 1: The Basics

*Before we dive into "Agentic Engineering", let's make sure everyone understands the fundamental tools.*

---

## What Are AI Coding Assistants?

AI coding assistants are command-line tools that let you talk to AI models (like Claude or GPT) to help you write code, run commands, and automate tasks.

Think of them as **a developer colleague who lives in your terminal** - you describe what you want, and they do it.

### Popular AI Coding Tools

| Tool | Who Makes It | What It Does |
|------|-------------|--------------|
| **Claude Code** | Anthropic | AI assistant that can read/write files, run commands, use git |
| **Codex CLI** | OpenAI | Similar capabilities, powered by GPT models |
| **Gemini CLI** | Google | Google's AI assistant for coding |
| **Aider** | Open Source | Popular free alternative |

**For this guide, we'll use Claude Code in examples, but the concepts apply to all tools.**

---

## What Is a Terminal?

The **terminal** (also called "command line" or "shell") is a text-based interface for your computer.

```
┌─────────────────────────────────────────────────────────────────┐
│  Terminal                                                   ─ □ x │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  $ cd my-project                                                │
│  $ ls                                                           │
│  README.md  src/  package.json                                  │
│  $ _                                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

Instead of clicking buttons, you type commands. Examples:
- `cd my-project` → Go into a folder
- `ls` → List files in current folder
- `git status` → Check what files changed

**Why does this matter?** AI coding tools run in the terminal. You'll type commands to talk to them.

---

## How to Use Claude Code (Interactive Mode)

When you run `claude` in your terminal, you start an **interactive conversation**:

```
┌─────────────────────────────────────────────────────────────────┐
│  Terminal - Interactive Claude Code Session                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  $ claude                                                       │
│                                                                 │
│  ╭─────────────────────────────────────────────────────────╮    │
│  │ Claude Code                                             │    │
│  │ How can I help you today?                               │    │
│  ╰─────────────────────────────────────────────────────────╯    │
│                                                                 │
│  > Create a Python file that prints "Hello World"               │
│                                                                 │
│  I'll create that file for you.                                 │
│  [Creates hello.py]                                             │
│  Done! I've created hello.py with the print statement.          │
│                                                                 │
│  > Now run it                                                   │
│                                                                 │
│  [Runs: python hello.py]                                        │
│  Output: Hello World                                            │
│                                                                 │
│  > _                                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

This is **interactive mode** - you type, AI responds, you type again. It's like chatting.

---

## What Is a "Prompt"?

A **prompt** is simply **the instruction you give to the AI**.

```
┌─────────────────────────────────────────────────────────────────┐
│  PROMPT = What you tell the AI to do                            │
└─────────────────────────────────────────────────────────────────┘

Examples of prompts:

  "Create a Python file that prints Hello World"

  "Fix the bug in src/login.py"

  "Write tests for the UserService class"

  "Refactor this code to use async/await"
```

Prompts can be:
- **Simple**: "Create a file called test.py"
- **Complex**: A multi-step workflow with detailed instructions

---

## What Is a "Meta Prompt"?

A **meta prompt** is a prompt that defines **a reusable workflow** - not just a single task.

```
┌─────────────────────────────────────────────────────────────────┐
│  Simple Prompt vs Meta Prompt                                   │
└─────────────────────────────────────────────────────────────────┘

SIMPLE PROMPT:
  "Create a Python file that prints Hello World"
  → One task, done once

META PROMPT (saved in a file called prompt.md):
  "1. Create a new git branch
   2. Create main.py with a hello function
   3. Run the file
   4. Commit the changes
   5. Report what you did"
  → Multi-step workflow, reusable, automatable
```

**Key insight**: Meta prompts are saved in files (like `prompt.md`) so they can be reused and automated.

---

## Interactive vs Programmatic Mode

Here's the crucial difference that enables "Agentic Engineering":

### Interactive Mode (Default)
```bash
$ claude
# Opens a chat session
# You type, AI responds, you type again
# Requires human present at keyboard
```

### Programmatic Mode (The `-p` Flag)
```bash
$ claude -p "Create a file called hello.py"
# AI executes immediately
# No chat session
# No human interaction needed
# Perfect for automation
```

```
┌─────────────────────────────────────────────────────────────────┐
│  THE -p FLAG IS THE KEY TO AUTOMATION                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Interactive:  claude           ← Opens chat, waits for you     │
│  Programmatic: claude -p "..."  ← Runs immediately, no waiting  │
│                                                                 │
│  Same flag exists in other tools:                               │
│  • Gemini CLI:  gemini -p "..."                                 │
│  • Codex CLI:   codex --prompt "..."                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Summary: Part 1

| Concept | What It Means |
|---------|---------------|
| **Terminal** | Text-based interface where you type commands |
| **AI Coding Tool** | Claude Code, Codex, Gemini - AI assistants in your terminal |
| **Prompt** | The instruction you give to the AI |
| **Meta Prompt** | A reusable, multi-step workflow saved in a file |
| **Interactive Mode** | Chat with AI, requires human at keyboard |
| **Programmatic Mode** | `-p` flag - AI runs without human interaction |

---

# PART 2: Agentic Engineering

*Now that you understand the basics, let's learn what makes AI "agentic" and how to control it.*

---

## What Is Agentic Engineering?

**Agentic Engineering** is the practice of giving AI the **capabilities and permissions** to work autonomously - to actually DO things, not just suggest them.

The key question is: **What is the AI agent ALLOWED to do?**

---

## Agent Capabilities: What Can It Do?

An AI coding agent's power comes from its **permissions** - what actions you allow it to perform.

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENT CAPABILITY LEVELS                      │
└─────────────────────────────────────────────────────────────────┘

    LEVEL 1: READ ONLY (Safest)
    ─────────────────────────────
    ✓ Read files
    ✓ Analyze code
    ✓ Answer questions
    ✗ Cannot modify anything

    LEVEL 2: EDIT FILES
    ─────────────────────────────
    ✓ Everything in Level 1
    ✓ Create new files
    ✓ Modify existing files
    ✗ Cannot run commands

    LEVEL 3: RUN COMMANDS
    ─────────────────────────────
    ✓ Everything in Level 2
    ✓ Execute shell commands
    ✓ Run tests, builds, scripts
    ✗ Cannot use git

    LEVEL 4: FULL AUTONOMY
    ─────────────────────────────
    ✓ Everything in Level 3
    ✓ Git operations (commit, branch, push)
    ✓ Complete end-to-end workflows
```

**The more permissions you give, the more the agent can accomplish autonomously.**

---

## Settings: Controlling Agent Permissions

AI coding tools use **settings files** to define what the agent is allowed to do.

### Example: Claude Code Settings (`.claude/settings.json`)

```json
{
  "permissions": {
    "allow": [
      "Read",           // Can read files
      "Edit",           // Can modify files
      "Write",          // Can create new files
      "Bash",           // Can run shell commands
      "WebSearch"       // Can search the web
    ]
  }
}
```

### What Each Permission Enables

| Permission | What It Allows | Example Actions |
|------------|---------------|-----------------|
| **Read** | View file contents | Analyze code, answer questions |
| **Edit** | Modify existing files | Fix bugs, refactor code |
| **Write** | Create new files | Generate new components, tests |
| **Bash** | Run shell commands | `npm install`, `python script.py`, `git status` |
| **Git** | Git operations | Commit, branch, push changes |

`💡 Key Insight: Permissions Define Autonomy ─────────────────────`
**What makes an agent "agentic"** is not a special mode - it's the permissions you grant.
An agent with Read-only permission can only observe.
An agent with full permissions can complete entire workflows.
`─────────────────────────────────────────────────────────────────`

---

## Two Ways to Run: Interactive vs Programmatic

Once you've defined what the agent CAN do (permissions), you choose HOW it runs:

```
┌─────────────────────────────────────────────────────────────────┐
│                    TWO MODES OF OPERATION                       │
└─────────────────────────────────────────────────────────────────┘

    ┌─────────────────────────────────────────────────────────┐
    │  INTERACTIVE MODE                                       │
    │  Command: claude                                        │
    ├─────────────────────────────────────────────────────────┤
    │  • You're at the keyboard                               │
    │  • Agent asks for confirmation on sensitive actions     │
    │  • Good for: exploration, learning, careful tasks       │
    │  • You see each step and can guide the agent            │
    └─────────────────────────────────────────────────────────┘

    ┌─────────────────────────────────────────────────────────┐
    │  PROGRAMMATIC MODE                                      │
    │  Command: claude -p "..."                               │
    ├─────────────────────────────────────────────────────────┤
    │  • No human at keyboard                                 │
    │  • Agent runs end-to-end without stopping               │
    │  • Good for: automation, CI/CD, scheduled tasks         │
    │  • Runs completely autonomously                         │
    └─────────────────────────────────────────────────────────┘
```

### When to Use Each Mode

| Scenario | Recommended Mode | Why |
|----------|-----------------|-----|
| Learning how the agent works | Interactive | See each step, ask questions |
| Exploring a new codebase | Interactive | Guide the agent, adjust as needed |
| Running in CI/CD pipeline | Programmatic | No human present |
| Scheduled nightly tasks | Programmatic | Must run unattended |
| Sensitive production changes | Interactive | Human oversight important |
| Batch processing 100 files | Programmatic | Efficiency at scale |

---

## Putting It Together: The Agentic Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                  THE COMPLETE PICTURE                           │
└─────────────────────────────────────────────────────────────────┘

    1. DEFINE PERMISSIONS          2. WRITE THE TASK         3. CHOOSE MODE
    (what agent CAN do)            (what agent SHOULD do)    (how it runs)

    ┌─────────────────┐            ┌─────────────────┐       ┌─────────────┐
    │ settings.json   │            │   prompt.md     │       │ Interactive │
    │                 │            │                 │       │     OR      │
    │ • Read ✓        │     +      │ "Create a file, │   +   │ Programmatic│
    │ • Edit ✓        │            │  run tests,     │       │   (-p)      │
    │ • Bash ✓        │            │  commit it"     │       │             │
    └─────────────────┘            └─────────────────┘       └─────────────┘
           │                              │                        │
           └──────────────────────────────┴────────────────────────┘
                                          │
                                          ▼
                               ┌─────────────────────┐
                               │   AGENT EXECUTES    │
                               │   (within allowed   │
                               │    permissions)     │
                               └─────────────────────┘
```

---

## Example: Full Agentic Workflow

### Step 1: Set Up Permissions

In your project's `.claude/settings.json`:
```json
{
  "permissions": {
    "allow": ["Read", "Edit", "Write", "Bash"]
  }
}
```

### Step 2: Create a Meta Prompt

Create `prompt.md`:
```markdown
Create a Python file called hello.py that:
1. Prints "Hello from Agentic Engineering!"
2. Prints the current date and time

Then run the file and show me the output.
```

### Step 3: Run (Choose Your Mode)

**Interactive** (you're at the keyboard):
```bash
$ claude
> @prompt.md   # or paste the prompt
```

**Programmatic** (runs end-to-end):
```bash
$ claude -p "$(cat prompt.md)"
```

### Step 4: Agent Works Within Permissions

The agent will:
1. ✓ Create `hello.py` (Write permission)
2. ✓ Run `python hello.py` (Bash permission)
3. ✓ Show you the output

If you hadn't granted Bash permission, the agent would create the file but couldn't run it.

---

## The Simple Automation Script

For programmatic/scheduled execution:

```bash
#!/bin/bash
PROMPT="$(cat prompt.md)"        # Read the task definition
OUTPUT="$(claude -p "$PROMPT")"  # Run agent end-to-end
echo "$OUTPUT"                   # Capture the result
```

This is useful when you need AI to run without human supervision (CI/CD, cron jobs, etc.).

---

## Why Permissions Matter

`💡 Key Insight: Control = Trust + Safety ────────────────────────`
**More permissions** = Agent can do more = Greater autonomy
**Fewer permissions** = Agent is limited = Greater safety

Start with minimal permissions, add more as you build trust.
`─────────────────────────────────────────────────────────────────`

### What You Can Do with Agentic Engineering

| Use Case | How It Works |
|----------|--------------|
| **Nightly code cleanup** | Cron job runs AI at 2am to refactor code |
| **Auto code review** | CI/CD triggers AI to review every pull request |
| **Batch file updates** | Script loops through 100 files, AI updates each |
| **Documentation generation** | AI writes docs whenever code changes |

---

## Real-World Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENTIC SYSTEM ARCHITECTURE                  │
└─────────────────────────────────────────────────────────────────┘

    TRIGGERS                      YOUR SCRIPT                 OUTCOMES
    ────────                      ───────────                 ────────

    ┌─────────┐                  ┌───────────┐              ┌─────────┐
    │ Cron    │                  │           │              │ Files   │
    │ (2am)   │────────┐         │  prompt   │              │ created │
    └─────────┘        │         │    .md    │              └─────────┘
                       │         │     │     │                   ▲
    ┌─────────┐        │         │     ▼     │                   │
    │ CI/CD   │────────┼────────▶│  Script   │───────────────────┤
    │ (on PR) │        │         │ (3 lines) │                   │
    └─────────┘        │         │     │     │              ┌─────────┐
                       │         │     ▼     │              │ Logs    │
    ┌─────────┐        │         │   AI CLI  │              │ saved   │
    │ Manual  │────────┘         │ (claude)  │              └─────────┘
    │ trigger │                  │           │                   ▲
    └─────────┘                  └───────────┘                   │
                                       │                         │
                                       └─────────────────────────┘
                                         No human needed
                                         during execution
```

---

## Scaling: The Math

```
Traditional AI Coding:
  1 human × 1 AI session = 8 productive hours/day
  (Human must be present for each interaction)

Agentic Engineering:
  1 human sets up workflows
  100 AI agents run in parallel
  = 2,400 AI-hours/day

  That's a 300x multiplier.
```

---

## Key Takeaways

### For Everyone
1. **Agentic = Permissions** - What makes an agent "agentic" is the capabilities you grant it
2. **Settings control autonomy** - Define what the agent CAN do (Read, Edit, Bash, Git, etc.)
3. **Two modes of operation** - Interactive (human at keyboard) or Programmatic (end-to-end automation)
4. **Start small, expand gradually** - Begin with Read-only, add permissions as you build trust

### For Programmers
1. Configure permissions in `.claude/settings.json` (or equivalent for other tools)
2. Write tasks in reusable meta prompt files (`prompt.md`)
3. Choose mode based on use case: interactive for exploration, programmatic for automation

### For Product Managers
1. **Permissions = Risk management** - You control exactly what AI can and cannot do
2. **Agents can work without supervision** - Programmatic mode enables lights-out automation
3. **Same workflow, different tools** - Prompts work across Claude, Gemini, Codex

---

## Try It Yourself

### 1. Start in Interactive Mode (Recommended for First Time)
```bash
$ claude
> Create a file called test.py that prints "It works!"
```
Watch how the agent asks for permission before creating the file.

### 2. Then Try Programmatic Mode
```bash
$ claude -p "Create a file called test.py that prints 'Hello!'"
```
Notice how it runs end-to-end without asking.

### 3. Explore Permission Levels
Try the same task with different permission settings and see what changes.

---

## What's Next?

| Lesson | Topic |
|--------|-------|
| **2** | Writing effective meta prompts |
| **3** | Configuring permissions for different use cases |
| **4** | CI/CD integration (GitHub Actions) |
| **5** | Multi-agent orchestration |

---

> **Remember**: Agentic Engineering is about **permissions** (what the agent CAN do) + **mode** (how it runs). Master these two concepts and you can build any automation.
