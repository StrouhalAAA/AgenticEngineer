# Module 07: Hooks System

> **Automate actions before and after Claude Code operations.**

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
| **PreToolUse** | Before any tool runs | Validation, approval |
| **PostToolUse** | After tool completes | Formatting, logging |
| **UserPromptSubmit** | When user sends message | Input processing |
| **Stop** | When Claude finishes | Cleanup, notifications |

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
            "command": "npx prettier --write $CLAUDE_FILE_PATHS"
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
| **2** | Feedback | Return stderr to Claude |
| **Other** | Error | Show error to user |

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

### Action Logging

```bash
#!/bin/bash
# scripts/log-action.sh
echo "$(date) | $CLAUDE_TOOL_NAME | $CLAUDE_FILE_PATHS" >> .claude.log
```

---

## Hands-On Exercises

### Exercise 7.1: Auto-Format Hook

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

### Exercise 7.2: Action Logger

1. Create logging script
2. Add PostToolUse hook for Write|Edit
3. Make changes and check `.claude.log`

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Hooks** | Automated scripts at execution points |
| **PreToolUse** | Before tool runs (validation) |
| **PostToolUse** | After tool completes (formatting) |
| **Matchers** | Pattern matching for tools/files |
| **Exit Code 0** | Continue execution |
| **Exit Code 2** | Send feedback to Claude |

---

## Next Module

Continue to [08-mcp.md](./08-mcp.md) to learn external tool integration.
