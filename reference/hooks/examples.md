# Hooks Reference

## What are Hooks?

Hooks are shell commands that run automatically in response to Claude Code events.

## Hook Types

| Hook | Triggers When |
|------|---------------|
| `PreToolUse` | Before a tool runs |
| `PostToolUse` | After a tool completes |
| `Notification` | When Claude sends notification |

## Configuration

In `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "command": "echo 'Writing file...'"
      }
    ]
  }
}
```

## Examples

### Auto-format on file write
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "command": "prettier --write \"$CLAUDE_FILE_PATH\""
      }
    ]
  }
}
```
