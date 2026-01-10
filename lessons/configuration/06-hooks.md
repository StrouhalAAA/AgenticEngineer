# Module 06: Hooks System

> **Automate actions before and after Claude Code operations.**

> 🆕 **Updated for Claude Code 2.1.0** — Includes agent-scoped hooks, `once: true`, and new patterns.

---

## What Are Hooks?

Hooks are **automated scripts** that run at specific points in Claude Code's execution:

```
┌─────────────────────────────────────────────────────────────┐
│                 HOOK LIFECYCLE                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Claude wants to run: npm install lodash                    │
│                                                              │
│     ┌──────────────────┐                                    │
│     │   PreToolUse     │  ← "Should this be allowed?"       │
│     │   Hook fires     │                                    │
│     └────────┬─────────┘                                    │
│              ▼                                               │
│     ┌──────────────────┐                                    │
│     │   Tool Executes  │  ← npm install lodash              │
│     └────────┬─────────┘                                    │
│              ▼                                               │
│     ┌──────────────────┐                                    │
│     │   PostToolUse    │  ← "Format, log, validate"         │
│     │   Hook fires     │                                    │
│     └──────────────────┘                                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Hook Events

| Event | When It Fires | Common Uses |
|-------|---------------|-------------|
| **PreToolUse** | Before any tool runs | Validation, approval, input modification |
| **PostToolUse** | After tool completes | Formatting, logging, verification |
| **UserPromptSubmit** | When user sends message | Input processing, routing |
| **Stop** | When Claude finishes | Cleanup, notifications, summaries |

---

## Hook Configuration

Configure in `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash(npm install:*)",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/approve-dependency.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write(*.ts)",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write $CLAUDE_FILE_PATHS",
            "once": true
          }
        ]
      }
    ]
  }
}
```

---

## Matcher Patterns

| Matcher | Matches |
|---------|---------|
| `Write(*.ts)` | Any TypeScript file write |
| `Bash(npm install:*)` | npm install commands |
| `Bash(git commit:*)` | git commit commands |
| `Edit(src/**/*.js)` | JS files in src/ |
| `*` | All tools |

---

## Environment Variables

Hooks receive context via environment variables:

| Variable | Description |
|----------|-------------|
| `CLAUDE_PROJECT_DIR` | Project root path |
| `CLAUDE_TOOL_NAME` | Name of tool being used |
| `CLAUDE_TOOL_INPUT` | JSON of tool parameters |
| `CLAUDE_FILE_PATHS` | Space-separated file paths |

---

## Exit Codes

| Exit Code | Meaning | Claude Behavior |
|-----------|---------|-----------------|
| **0** | Success | Continue execution |
| **2** | Feedback | Return stderr to Claude (for adjustment) |
| **Non-zero** | Error | Show error to user, may halt execution |

### Exit Code 2: Feedback Loop

```bash
#!/bin/bash
# scripts/validate-commit.sh

if ! git diff --staged | grep -q "test"; then
    echo "Warning: No test changes detected." >&2
    exit 2  # Claude receives this feedback
fi

exit 0
```

---

## New in 2.1.0: Agent-Scoped Hooks

Define hooks directly in agent/skill/command **frontmatter**. These hooks only run during that agent's lifecycle:

```yaml
# .claude/agents/deployer.md
---
name: deployer
description: Handles production deployments
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/check-prod-safety.sh"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
          once: true
  Stop:
    - matcher: "*"
      hooks:
        - type: command
          command: "./scripts/notify-slack.sh deployment-complete"
---
```

### Why Agent-Scoped Hooks?

```
┌─────────────────────────────────────────────────────────────┐
│            GLOBAL vs AGENT-SCOPED HOOKS                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  GLOBAL HOOKS (settings.json)                               │
│  • Fire for ALL agents and operations                       │
│  • Good for project-wide rules (formatting, logging)        │
│  • Configured once, applies everywhere                      │
│                                                              │
│  AGENT-SCOPED HOOKS (frontmatter)                           │
│  • Fire ONLY for that specific agent                        │
│  • Good for agent-specific behavior                         │
│  • Security checks on deployer, not on analyzer             │
│  • Notifications only when build completes                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Example Use Cases:**
- Security validation only for deployer agent
- Slack notifications only when build agent completes  
- Auto-formatting only for code-writing skills
- SQL validation only for database-operations skill

---

## New in 2.1.0: `once: true` Configuration

Prevents hooks from running repeatedly during intensive operations:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npm run lint:staged",
            "once": true
          }
        ]
      }
    ]
  }
}
```

**Behavior:**
- First matching tool call: hook runs
- Subsequent calls in same session: hook skipped
- New session: hook runs again

**Use `once: true` for:**
- Linting after first edit (not after every edit)
- Environment setup on first bash command
- One-time validation checks
- Dependency installation verification

---

## Practical Examples

### Auto-Format on Write

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.ts)|Write(*.tsx)",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write $CLAUDE_FILE_PATHS"
          }
        ]
      }
    ]
  }
}
```

### Pre-Commit Validation

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash(git commit:*)",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/pre-commit-check.sh",
            "timeout": 120
          }
        ]
      }
    ]
  }
}
```

### Agent-Scoped Security Check (2.1.0+)

```yaml
# .claude/skills/database-operations/SKILL.md
---
name: database-operations
description: Execute database queries safely
hooks:
  PreToolUse:
    - matcher: "Bash(sqlcmd:*)"
      hooks:
        - type: command
          command: "./scripts/validate-sql.sh"
---
```

### One-Time Environment Setup (2.1.0+)

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/ensure-env.sh",
            "once": true
          }
        ]
      }
    ]
  }
}
```

### Action Logging

```bash
#!/bin/bash
# scripts/log-action.sh
echo "$(date) | $CLAUDE_TOOL_NAME | $CLAUDE_FILE_PATHS" >> .claude.log
```

---

## Hands-On Exercises

### Exercise 6.1: Auto-Format Hook

1. Create formatting script:
   ```bash
   mkdir -p scripts
   cat > scripts/format.sh << 'EOF'
   #!/bin/bash
   for file in $CLAUDE_FILE_PATHS; do
       npx prettier --write "$file" 2>/dev/null || true
   done
   EOF
   chmod +x scripts/format.sh
   ```

2. Add hook to settings.json

3. Test by creating a TypeScript file

### Exercise 6.2: Agent-Scoped Hook (2.1.0+)

1. Create a skill with a PreToolUse hook in frontmatter
2. Run the skill and verify the hook fires
3. Run a different skill and verify the hook does NOT fire

### Exercise 6.3: One-Time Hook

1. Add a `once: true` hook for Bash commands
2. Run multiple bash commands
3. Verify hook only ran once (check logs)

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Hooks** | Automated scripts at execution points |
| **PreToolUse** | Before tool runs (validation) |
| **PostToolUse** | After tool completes (formatting) |
| **Stop** | When Claude finishes (cleanup, notify) |
| **Matchers** | Pattern matching for tools/files |
| **Exit Code 0** | Continue execution |
| **Exit Code 2** | Send feedback to Claude |
| **Agent-Scoped** | Hooks in frontmatter, agent lifecycle only (2.1.0+) |
| **`once: true`** | Single execution per session (2.1.0+) |

---

## Next Module

Continue to [07-subagents.md](../context-management/07-subagents.md) to learn subagent orchestration.
