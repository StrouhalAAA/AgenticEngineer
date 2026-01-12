# Settings & Permissions Reference

> 🆕 **Updated for Claude Code 2.1.0** — Includes wildcard Bash permissions and agent disabling.

---

## Settings File Locations

| Location | Scope | Priority |
|----------|-------|----------|
| `.claude/settings.json` | Project | Highest |
| `.claude/settings.local.json` | Project (gitignored) | High |
| `~/.claude/settings.json` | User global | Lower |
| Managed settings | Enterprise | Lowest |

Settings merge with project settings taking precedence.

---

## Permission Types

| Permission | Description |
|------------|-------------|
| `Read` | Read any file |
| `Write` | Create new files |
| `Edit` | Modify existing files |
| `Bash(cmd:*)` | Run specific bash commands |
| `WebSearch` | Search the web |
| `WebFetch` | Fetch URL content |
| `Task(AgentName)` | Control agent invocation (2.1.0+) |

---

## New in 2.1.0: Wildcard Bash Permissions

Pre-approve entire command families using wildcards:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(npm test *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(pytest:*)",
      "Bash(make *)"
    ],
    "deny": [
      "Bash(npm publish *)",
      "Bash(git push *)",
      "Bash(rm -rf *)"
    ]
  }
}
```

### Pattern Syntax

| Pattern | Matches |
|---------|---------|
| `Bash(npm run *)` | Any `npm run` command |
| `Bash(git *)` | Any git command |
| `Bash(* --help)` | Any command ending with `--help` |
| `Bash(pytest:*)` | pytest with any arguments |

### Important Limitations

1. **Shell operators recognized**: `Bash(safe-cmd:*)` won't match `safe-cmd && malicious-cmd`
2. **Environment variable prefixes**: Don't match patterns (e.g., `VAR=value cmd`)
3. **Deny takes precedence**: If both allow and deny match, deny wins

### Team Configuration Example

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(npm test *)",
      "Bash(npm install --save-dev *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git branch *)",
      "Bash(dotnet build *)",
      "Bash(dotnet test *)"
    ],
    "deny": [
      "Bash(npm publish *)",
      "Bash(git push *)",
      "Bash(git reset --hard *)",
      "Bash(rm -rf *)",
      "Bash(sudo *)"
    ]
  }
}
```

---

## New in 2.1.0: Disable Specific Agents

Control which agents can be invoked using `Task(AgentName)` syntax:

```json
{
  "permissions": {
    "deny": [
      "Task(deployer)",
      "Task(database-migrator)"
    ]
  }
}
```

### Use Cases

**Junior Developer Profile:**
```json
{
  "permissions": {
    "deny": [
      "Task(deployer)",
      "Task(database-admin)",
      "Bash(git push *)"
    ]
  }
}
```

**CI/CD Environment:**
```json
{
  "permissions": {
    "allow": [
      "Task(tester)",
      "Task(linter)",
      "Task(builder)"
    ],
    "deny": [
      "Task(*)"
    ]
  }
}
```

**Read-Only Analysis:**
```json
{
  "permissions": {
    "allow": [
      "Read",
      "Grep",
      "Glob"
    ],
    "deny": [
      "Write",
      "Edit",
      "Bash(*)"
    ]
  }
}
```

---

## Configuration Best Practices

### 1. Layer Your Settings

```
~/.claude/settings.json          # Personal defaults
├── .claude/settings.json        # Project standards (committed)
└── .claude/settings.local.json  # Local overrides (gitignored)
```

### 2. Start Restrictive, Open Gradually

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Bash(git status)",
      "Bash(npm run lint)"
    ]
  }
}
```

Then add permissions as needed during development.

### 3. Document Why Permissions Exist

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(git diff *)"
    ]
  }
}
```

Add a comment in your project README explaining the permission strategy.

---

## Other Settings

### Model Selection

```json
{
  "model": "claude-sonnet-4-20250514",
  "planningModel": "claude-sonnet-4-20250514"
}
```

### Response Language (2.1.0+)

```json
{
  "language": "japanese"
}
```

### Git Ignore Respect (2.1.0+)

```json
{
  "respectGitignore": true
}
```

### Available Tools Restriction (2.1.0+)

From CLI: `claude --tools "Read,Write,Edit"`

---

## Example Configuration

See [settings.json.example](./settings.json.example) for a complete template.

---

## Related

- [06-hooks.md](../../lessons/configuration/06-hooks.md) — Hooks for automation
- [Release Notes 2.1.0](../../learn/claude-code/release-notes/2026-01-07-v2.1.0.md) — Full feature list
