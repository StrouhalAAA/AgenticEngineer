# Hooks Reference

> 🆕 **Updated for Claude Code 2.1.0** — Includes agent-scoped hooks and `once: true`.

---

## What are Hooks?

Hooks are shell commands that run automatically in response to Claude Code events.

---

## Hook Types

| Hook | Triggers When | Common Uses |
|------|---------------|-------------|
| `PreToolUse` | Before a tool runs | Validation, approval, input modification |
| `PostToolUse` | After a tool completes | Formatting, logging, verification |
| `UserPromptSubmit` | When user sends message | Input processing, routing |
| `Stop` | When Claude finishes | Cleanup, notifications, summaries |

---

## Configuration Locations

### Global Hooks (settings.json)

Fire for all operations:

```json
{
  "hooks": {
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

### Agent-Scoped Hooks (Frontmatter) — 2.1.0+

Fire only for specific agent/skill/command:

```yaml
---
name: deployer
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
  Stop:
    - matcher: "*"
      hooks:
        - type: command
          command: "./scripts/notify-complete.sh"
---
```

---

## Hook Options

| Option | Type | Description |
|--------|------|-------------|
| `matcher` | string | Pattern to match tools/files |
| `type` | string | `"command"` for shell commands |
| `command` | string | Shell command to execute |
| `timeout` | number | Max execution time in seconds |
| `once` | boolean | Run only once per session (2.1.0+) |

---

## Environment Variables

Available in hook scripts:

| Variable | Description |
|----------|-------------|
| `CLAUDE_PROJECT_DIR` | Project root path |
| `CLAUDE_TOOL_NAME` | Name of tool being used |
| `CLAUDE_TOOL_INPUT` | JSON of tool parameters |
| `CLAUDE_FILE_PATHS` | Space-separated file paths |

---

## Exit Codes

| Code | Meaning | Claude Behavior |
|------|---------|-----------------|
| `0` | Success | Continue execution |
| `2` | Feedback | Return stderr to Claude for adjustment |
| Other | Error | Show error to user |

---

## Examples

### Auto-Format TypeScript

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.ts)|Write(*.tsx)|Edit(*.ts)|Edit(*.tsx)",
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

### Agent-Scoped Security Check (2.1.0+)

```yaml
# .claude/agents/deployer.md
---
name: deployer
description: Production deployment agent
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
          command: "./scripts/notify-slack.sh"
---
```

### Skill-Scoped SQL Validation (2.1.0+)

```yaml
# .claude/skills/database-ops/SKILL.md
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

### Action Logging

```bash
#!/bin/bash
# scripts/log-action.sh
echo "$(date) | $CLAUDE_TOOL_NAME | $CLAUDE_FILE_PATHS" >> .claude.log
```

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/log-action.sh"
          }
        ]
      }
    ]
  }
}
```

### Feedback Loop (Exit Code 2)

```bash
#!/bin/bash
# scripts/validate-commit.sh

if ! git diff --staged | grep -q "test"; then
    echo "Warning: No test changes detected. Consider adding tests." >&2
    exit 2  # Claude receives this feedback and may adjust
fi

exit 0
```

### Cross-Repo Update Checker (SessionStart)

Check for updates from a separate documentation/playbook repo when starting a session:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash .claude/hooks/check-playbook-updates.sh",
        "timeout": 5,
        "once": true
      }
    ]
  }
}
```

```bash
#!/bin/bash
# .claude/hooks/check-playbook-updates.sh
# Check for updates from a separate playbook/docs repo

PLAYBOOK_REPO="your-org/agentic-engineer-playbook"  # Configure this
CACHE_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/.playbook-version"
CHANGELOG_URL="https://raw.githubusercontent.com/${PLAYBOOK_REPO}/main/CHANGELOG.md"

# Get latest commit SHA
LATEST=$(curl -sf "https://api.github.com/repos/${PLAYBOOK_REPO}/commits/main" \
  | grep -o '"sha": "[^"]*"' | head -1 | cut -d'"' -f4 | cut -c1-7)

[ -z "$LATEST" ] && exit 0  # Network error - fail silently

CACHED=$(cat "$CACHE_FILE" 2>/dev/null)

if [ "$LATEST" != "$CACHED" ]; then
  # Check for priority marker in changelog
  PRIORITY=$(curl -sf "$CHANGELOG_URL" | head -20 | grep -c "⭐")

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ "$PRIORITY" -gt 0 ]; then
    echo "📚 PLAYBOOK UPDATE (⭐ Priority)"
  else
    echo "📚 Playbook Updated"
  fi
  echo "   See: https://github.com/${PLAYBOOK_REPO}/blob/main/CHANGELOG.md"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  mkdir -p "$(dirname "$CACHE_FILE")"
  echo "$LATEST" > "$CACHE_FILE"
fi

exit 0
```

**Use case**: Notify your team when a separate educational/playbook repo has updates, without requiring them to actively check.

---

## Matcher Pattern Reference

| Pattern | Matches |
|---------|---------|
| `Write(*.ts)` | Any TypeScript file write |
| `Edit(src/**/*.js)` | JS files in src/ directory |
| `Bash(npm install:*)` | npm install commands |
| `Bash(git commit:*)` | git commit commands |
| `Bash(git *)` | Any git command |
| `Read|Write|Edit` | Multiple tools (OR) |
| `*` | All tools |

---

## Related

- [06-hooks.md](../../lessons/configuration/06-hooks.md) — Hooks lesson with exercises
- [Release Notes 2.1.0](../../learn/claude-code/release-notes/2026-01-07-v2.1.0.md) — Full 2.1.0 features
