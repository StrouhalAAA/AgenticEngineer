# Expert Pattern: Parallel Sessions

> **Run multiple Claude Code sessions simultaneously for maximum productivity.**

---

## The Parallel Session Workflow

Expert users don't run a single Claude session — they run **5+ simultaneously** across terminal tabs, plus additional sessions on claude.ai/code and even mobile.

```
┌─────────────────────────────────────────────────────────────┐
│              PARALLEL SESSION ARCHITECTURE                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   TERMINAL (5 tabs)                                         │
│   ┌─────┬─────┬─────┬─────┬─────┐                          │
│   │  1  │  2  │  3  │  4  │  5  │                          │
│   │     │     │     │     │     │                          │
│   │ API │ UI  │Test │Docs │Debug│                          │
│   └─────┴─────┴─────┴─────┴─────┘                          │
│         System notifications indicate which needs attention  │
│                                                              │
│   BROWSER (claude.ai/code)                                  │
│   ┌─────────────────────────────────────────┐               │
│   │  5-10 additional sessions               │               │
│   │  Use --teleport to hand off sessions    │               │
│   └─────────────────────────────────────────┘               │
│                                                              │
│   MOBILE (Claude iOS/Android app)                           │
│   ┌─────────────────────────────────────────┐               │
│   │  Start tasks on the go                  │               │
│   │  Check progress later                   │               │
│   └─────────────────────────────────────────┘               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Setting Up Parallel Sessions

### 1. Enable System Notifications

Critical for knowing which session needs attention:

**iTerm2:**
1. Preferences → Profiles → Terminal
2. Enable "Silence bell"
3. Filter Alerts → "Send escape sequence-generated alerts"

**Custom hook (any terminal):**
```json
{
  "hooks": {
    "Stop": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "osascript -e 'display notification \"Ready for input\" with title \"Claude Tab\"'"
      }]
    }]
  }
}
```

### 2. Configure Status Line

See which model/project each tab is running:

```bash
# ~/.claude/statusline.sh
#!/bin/bash
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir' | xargs basename)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
printf "[%s] %s | \$%.3f" "$MODEL" "$DIR" "$COST"
```

### 3. Number Your Tabs

Name terminal tabs 1-5 so notifications tell you exactly which needs attention.

---

## Session Handoff with --teleport

Move sessions between terminal and browser seamlessly:

### Terminal → Browser

In your terminal session, use the `&` command or:
```bash
# Session continues on claude.ai/code
```

### Browser → Terminal

```bash
claude --teleport
```

This resumes a browser session in your terminal.

### Use Cases

- Start complex task on desktop, check progress from phone
- Hand off to teammate via shared browser session
- Move from terminal (fast) to browser (visual) as needed

---

## Plan Mode First Strategy

Start most sessions in **Plan Mode** before executing:

### Enter Plan Mode
Press **Shift+Tab** twice (or start with `--permission-mode plan`)

### In Plan Mode
- Claude can only **read** your codebase
- Have a back-and-forth conversation
- Agree on approach before any changes

### Exit and Execute
Press **Shift+Tab** twice again to allow edits

### Why This Works

```
┌────────────────────────────────────────────────────────────┐
│                                                             │
│   WITHOUT Plan Mode:                                       │
│   "Add authentication" → Claude starts writing code →      │
│   Wrong approach → Undo everything → Start over            │
│                                                             │
│   WITH Plan Mode:                                          │
│   "Add authentication" → Claude proposes approach →        │
│   Discuss trade-offs → Agree on design → Execute once      │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

Combine with `opusplan` model for Opus-quality planning, Sonnet execution.

---

## Inline Bash in Commands

Pre-compute information in slash commands to avoid token waste:

```markdown
<!-- .claude/commands/commit.md -->
Here's the current git status:
`git status`

Here are recent commits:
`git log --oneline -5`

Here's what's staged:
`git diff --staged`

Create a commit message for these changes.
```

The bash output gets injected **before** Claude processes the command — no back-and-forth asking for context.

More examples:

```markdown
<!-- .claude/commands/pr-review.md -->
Current branch: `git branch --show-current`
Changed files: `git diff --name-only origin/main`
Diff stats: `git diff --stat origin/main`

Review these changes and suggest improvements.
```

---

## Subagents for Common Tasks

Delegate repetitive work to specialized subagents:

### code-simplifier
```yaml
# .claude/agents/code-simplifier.md
---
name: code-simplifier
description: Simplify and refactor code after implementation
---
Review the code Claude just wrote and simplify it:
- Remove unnecessary complexity
- Improve naming
- Add missing error handling
```

### verify-app
```yaml
# .claude/agents/verify-app.md
---
name: verify-app
description: End-to-end verification of changes
---
Verify the application works:
1. Run tests: `npm test`
2. Check types: `npm run typecheck`
3. Start dev server and verify manually
4. Report any issues found
```

Run after tasks: `/agent verify-app`

---

## Stop Hooks for Verification

For long-running tasks, use Stop hooks to automatically verify:

```json
{
  "hooks": {
    "Stop": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "./scripts/verify-and-notify.sh"
      }]
    }]
  }
}
```

```bash
#!/bin/bash
# scripts/verify-and-notify.sh

# Run tests
npm test > /tmp/test-results.txt 2>&1
TEST_EXIT=$?

if [ $TEST_EXIT -eq 0 ]; then
    osascript -e 'display notification "✅ Tests passed" with title "Claude Complete"'
else
    osascript -e 'display notification "❌ Tests failed" with title "Claude Complete"'
fi
```

---

## Autonomous Loops

For tasks that need to run for hours without intervention:

### Permission Bypass (Sandboxed Only!)

```bash
# ONLY in isolated sandbox environments
claude --permission-mode bypassAll
# or
claude --dangerously-skip-permissions
```

### ralph-wiggum Plugin

For extended autonomous operation, the `ralph-wiggum` plugin (community) keeps Claude working in loops until success:

1. Install the plugin
2. Configure loop behavior
3. Claude retries failures automatically

**Warning**: Only use autonomous modes in sandboxed environments.

---

## Session Management Commands

Create commands for session workflow:

```markdown
<!-- .claude/commands/session-status.md -->
Show session information:
- Current model: /status
- Files changed this session
- Approximate token usage
- Time elapsed
```

```markdown
<!-- .claude/commands/session-checkpoint.md -->
Create a checkpoint of current work:
1. Commit all changes with WIP message
2. List what's been accomplished
3. Note what's remaining
```

---

## Best Practices Summary

| Practice | Why |
|----------|-----|
| **5+ parallel sessions** | Different contexts for different tasks |
| **System notifications** | Know which session needs you |
| **Status line** | Model/cost visibility per session |
| **Plan Mode first** | Agree before executing |
| **opusplan model** | Best reasoning + efficient execution |
| **Inline bash in commands** | Pre-compute context |
| **Stop hooks** | Auto-verify completed work |
| **Subagents** | Delegate repetitive tasks |

---

## Related

- [04a-terminal-config.md](../../lessons/configuration/04a-terminal-config.md) — Notification setup
- [04b-model-config.md](../../lessons/configuration/04b-model-config.md) — Model selection
- [04c-statusline.md](../../lessons/configuration/04c-statusline.md) — Status line setup
- [07-subagents.md](../../lessons/context-management/07-subagents.md) — Subagent patterns
- [06-hooks.md](../../lessons/configuration/06-hooks.md) — Hook configuration
