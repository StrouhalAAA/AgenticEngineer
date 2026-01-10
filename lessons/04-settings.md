# Module 04: Settings & Configuration

> **Control Claude Code's behavior through layered configuration files.**

---

## Configuration Hierarchy

Claude Code uses a cascading configuration system. More specific settings override general ones:

```
┌─────────────────────────────────────────────────────────────┐
│                 CONFIGURATION PRIORITY                       │
│                 (Highest to Lowest)                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. CLI Flags                                               │
│     claude --model opus --permission-mode bypassAll         │
│     (Highest priority, this session only)                   │
│                                                              │
│  2. .claude/settings.local.json                             │
│     Personal overrides, NOT committed to git                │
│     (Your preferences for this project)                     │
│                                                              │
│  3. .claude/settings.json                                   │
│     Project settings, committed to git                      │
│     (Team shared configuration)                             │
│                                                              │
│  4. ~/.claude/settings.json                                 │
│     Global settings, your machine only                      │
│     (Defaults for all projects)                             │
│                                                              │
│  5. Claude Code Defaults                                    │
│     Built-in default configuration                          │
│     (Lowest priority)                                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## settings.json Structure

### Complete Reference

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Edit",
      "Bash(npm:*)",
      "Bash(git:*)",
      "WebSearch",
      "WebFetch",
      "Task"
    ],
    "deny": [
      "Bash(rm -rf:*)",
      "Bash(sudo:*)"
    ]
  },
  "model": "claude-sonnet-4-20250514",
  "customInstructions": "Always use TypeScript strict mode",
  "env": {
    "NODE_ENV": "development"
  }
}
```

### Permission Patterns

Use wildcards for flexible permissions:

```json
{
  "allow": [
    "Bash(npm:*)",        // npm install, npm test, npm run X
    "Bash(git:*)",        // All git commands
    "Bash(python:*)",     // All python commands
    "Bash(*--help*)"      // Any command with --help
  ]
}
```

### Permission Modes (CLI)

```bash
# Prompt for each action (safest)
claude --permission-mode default

# Auto-approve within project dir
claude --permission-mode permissive

# No prompts (for automation)
claude --permission-mode bypassAll

# Read-only mode
claude --permission-mode plan
```

---

## Common Configuration Scenarios

### Scenario 1: Development Team

`.claude/settings.json` (committed):
```json
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit", "Glob", "Grep",
      "Bash(npm:*)",
      "Bash(git status)",
      "Bash(git diff)",
      "Task"
    ],
    "deny": [
      "Bash(git push:*)",
      "Bash(rm -rf:*)"
    ]
  }
}
```

### Scenario 2: CI/CD Pipeline

```json
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit",
      "Bash(npm:*)",
      "Bash(git:*)",
      "Task"
    ]
  }
}
```

Run with: `claude -p "..." --permission-mode bypassAll`

### Scenario 3: Code Review Only

```json
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep"]
  }
}
```

---

## Local Overrides

### When to Use settings.local.json

Personal preferences that shouldn't affect the team:

```json
// .claude/settings.local.json
{
  "model": "claude-opus-4-20250514",
  "permissions": {
    "allow": ["Bash(git commit:*)"]
  }
}
```

### .gitignore Setup

```gitignore
.claude/settings.local.json
CLAUDE.local.md
```

---

## Hands-On Exercises

### Exercise 4.1: Create Project Settings

1. Create settings file:
   ```bash
   mkdir -p .claude
   ```

2. Add configuration:
   ```json
   {
     "permissions": {
       "allow": ["Read", "Glob", "Grep"],
       "deny": []
     }
   }
   ```

3. Test restrictions:
   ```
   > Create a new file called test.txt
   ```
   (Should fail - Write not allowed)

### Exercise 4.2: Local Overrides

1. Create team settings with Haiku model
2. Create personal override with Sonnet model
3. Verify Claude uses Sonnet

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Hierarchy** | CLI > local > project > global > defaults |
| **settings.json** | Main configuration file |
| **permissions.allow** | What Claude CAN do |
| **permissions.deny** | What Claude CANNOT do (overrides allow) |
| **settings.local.json** | Personal overrides (not committed) |
| **Wildcards** | `Bash(npm:*)` for flexible patterns |

---

## Next Module

Continue to [05-claude-md.md](./05-claude-md.md) to master context engineering.
