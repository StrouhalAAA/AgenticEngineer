# Plugin Reference: Examples & Templates

> Practical examples and templates for creating Claude Code plugins.

---

## Complete Plugin Example: PR Workflow

A comprehensive plugin for pull request automation:

```
pr-workflow/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── pr-create.md
│   └── pr-review.md
├── agents/
│   └── code-reviewer.md
├── skills/
│   └── pr-best-practices/
│       └── SKILL.md
├── hooks/
│   ├── hooks.json
│   └── scripts/
│       └── pre-commit-check.sh
└── README.md
```

### plugin.json

```json
{
  "name": "pr-workflow",
  "version": "1.0.0",
  "description": "Pull request creation, review, and automation tools",
  "author": {
    "name": "Your Team"
  },
  "repository": "https://github.com/your-org/pr-workflow-plugin",
  "license": "MIT",
  "keywords": ["pr", "review", "git", "automation"]
}
```

### commands/pr-create.md

```markdown
---
description: Create a well-structured pull request
---

# Create Pull Request

## Steps

1. Review staged changes with `git diff --staged`
2. Generate a descriptive title based on changes
3. Create PR description with:
   - Summary of changes
   - Motivation/context
   - Testing done
   - Checklist items
4. Use the pr-best-practices skill for formatting
5. Create PR via GitHub MCP or provide CLI command

## Output Format

```
## Summary
[Brief description]

## Changes
- [Change 1]
- [Change 2]

## Testing
- [ ] Unit tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
```
```

### commands/pr-review.md

```markdown
---
description: Perform thorough code review on a PR
---

# Code Review

Use the code-reviewer agent to analyze the PR.

Focus areas:
1. **Security** - Injection, auth, data exposure
2. **Performance** - N+1 queries, memory leaks
3. **Readability** - Naming, complexity, comments
4. **Testing** - Coverage, edge cases
5. **Standards** - Team conventions, patterns

$ARGUMENTS should contain PR number or branch name.
```

### agents/code-reviewer.md

```markdown
---
name: code-reviewer
description: Reviews code for security, performance, and quality
model: sonnet
tools:
  - Read
  - Bash(git:*)
  - LSP
---

# Code Reviewer Agent

You are an expert code reviewer focusing on:

## Security Review
- SQL injection vulnerabilities
- XSS attack vectors
- Authentication/authorization issues
- Sensitive data exposure
- Input validation

## Performance Review
- Database query efficiency
- Memory management
- Algorithm complexity
- Caching opportunities

## Quality Review
- Code readability
- Naming conventions
- Function length/complexity
- DRY violations
- Test coverage gaps

## Output Format

For each finding:
```
### [SEVERITY] Issue Title
**File**: path/to/file.ts:42
**Type**: Security | Performance | Quality
**Description**: What the issue is
**Suggestion**: How to fix it
**Code**: 
```suggestion
fixed code here
```
```
```

### skills/pr-best-practices/SKILL.md

```markdown
---
name: pr-best-practices
description: Best practices for creating and reviewing pull requests
tools: Read
---

# PR Best Practices

## Ideal PR Size
- 200-400 lines of changes
- Single responsibility
- Reviewable in 30-60 minutes

## Title Format
```
type(scope): brief description

Types: feat, fix, refactor, docs, test, chore
Example: feat(auth): add OAuth2 login flow
```

## Description Template
```markdown
## Summary
[2-3 sentences explaining what and why]

## Changes
- [Bullet points of specific changes]

## Screenshots
[If UI changes]

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing done

## Notes for Reviewer
[Any context that helps review]
```

## Review Guidelines
- Review within 24 hours
- Be constructive, not critical
- Approve with minor comments when possible
- Request changes only for blocking issues
```

### hooks/hooks.json

```json
{
  "description": "PR workflow automation hooks",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/pre-commit-check.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### hooks/scripts/pre-commit-check.sh

```bash
#!/bin/bash
# Pre-commit validation hook

# Read tool input from stdin
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.file_path // empty')

# Check if modifying protected files
PROTECTED_FILES=(".env" "secrets.json" "credentials.yaml")
for protected in "${PROTECTED_FILES[@]}"; do
  if [[ "$FILE" == *"$protected"* ]]; then
    echo "⚠️ Warning: Modifying protected file: $FILE" >&2
    exit 2  # Return feedback but continue
  fi
done

exit 0
```

---

## Marketplace Configuration

### Single Plugin Marketplace

```json
{
  "name": "team-tools",
  "description": "Internal team development tools",
  "version": "1.0.0",
  "plugins": [
    {
      "name": "pr-workflow",
      "path": ".",
      "description": "PR creation and review tools"
    }
  ]
}
```

### Multi-Plugin Marketplace

```
team-marketplace/
├── .claude-plugin/
│   └── marketplace.json
└── plugins/
    ├── pr-workflow/
    ├── testing-suite/
    └── deployment-tools/
```

**marketplace.json**:
```json
{
  "name": "acme-team-marketplace",
  "description": "ACME Corp development tools",
  "version": "1.0.0",
  "plugins": [
    {
      "name": "pr-workflow",
      "path": "./plugins/pr-workflow",
      "description": "PR automation"
    },
    {
      "name": "testing-suite",
      "path": "./plugins/testing-suite",
      "description": "Testing commands and agents"
    },
    {
      "name": "deployment-tools",
      "path": "./plugins/deployment-tools",
      "description": "CI/CD integration"
    }
  ]
}
```

---

## LSP Plugin Configuration

### .lsp.json Template

```json
{
  "typescript": {
    "command": "vtsls",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescriptreact",
      ".js": "javascript",
      ".jsx": "javascriptreact"
    }
  }
}
```

### Multi-Language LSP

```json
{
  "python": {
    "command": "pyright-langserver",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".py": "python",
      ".pyi": "python"
    }
  },
  "typescript": {
    "command": "vtsls",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescriptreact"
    }
  }
}
```

---

## settings.json Integration

### Project-Level Plugin Configuration

```json
{
  "extraKnownMarketplaces": {
    "acme-internal": {
      "source": "github",
      "repo": "acme-corp/claude-plugins"
    },
    "community-tools": {
      "source": "github", 
      "repo": "community/awesome-claude-plugins"
    }
  },
  "enabledPlugins": {
    "pr-workflow@acme-internal": true,
    "testing-suite@acme-internal": true,
    "context7@claude-plugins-official": true,
    "typescript-lsp@claude-plugins-official": true
  }
}
```

---

## Quick Templates

### Minimal Plugin (Command Only)

```
my-command/
├── .claude-plugin/
│   └── plugin.json
└── commands/
    └── my-command.md
```

**plugin.json**:
```json
{"name": "my-command", "version": "1.0.0", "description": "Single command plugin"}
```

### Agent Plugin

```
my-agent/
├── .claude-plugin/
│   └── plugin.json
└── agents/
    └── specialist.md
```

### Skill Plugin

```
my-skill/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── domain-knowledge/
        └── SKILL.md
```

### Hook Plugin

```
my-hooks/
├── .claude-plugin/
│   └── plugin.json
└── hooks/
    ├── hooks.json
    └── scripts/
        └── validator.sh
```

---

## Common Patterns

### Using Plugin Variables in Hooks

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/log-command.sh"
      }]
    }]
  }
}
```

### Conditional Hook Activation

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/check.sh"
      }],
      "pathGlob": "src/**/*.ts"
    }]
  }
}
```

### Agent with Specific Tools

```markdown
---
name: database-agent
description: Database query and migration specialist
model: sonnet
tools:
  - Read(src/db/**)
  - Write(src/db/migrations/**)
  - Bash(npm run db:*)
  - MCP(postgres)
---
```

---

## Troubleshooting Reference

| Error | Cause | Fix |
|-------|-------|-----|
| `Plugin not found` | Marketplace not added | `/plugin marketplace add owner/repo` |
| `Executable not found in $PATH` | Binary not installed | Install language server binary |
| `Invalid plugin.json` | JSON syntax error | Validate JSON |
| `Command not loading` | File not in commands/ | Check directory structure |
| `Hook not triggering` | Matcher pattern wrong | Test with simpler matcher |
| `Permission denied` | Script not executable | `chmod +x script.sh` |

---

## Related Documentation

- [Lesson: Plugins](../lessons/09-plugins.md) - Core concepts
- [Lesson: Commands](../lessons/02-commands.md) - Command syntax
- [Lesson: Agents](../lessons/06-subagents.md) - Agent definitions
- [Lesson: Skills](../lessons/03-skills.md) - Skill structure
- [Lesson: Hooks](../lessons/07-hooks.md) - Hook configuration
