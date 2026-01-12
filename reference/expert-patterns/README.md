# Expert Patterns

> Advanced Claude Code techniques for power users.

---

## Available Patterns

| Pattern | Description | Time |
|---------|-------------|------|
| [Parallel Sessions](parallel-sessions.md) | Run 5+ Claude sessions simultaneously with notifications and handoffs | 15 min |
| [Lean Memory](lean-memory.md) | Keep CLAUDE.md under 100 lines using imports and the mistake→memory workflow | 10 min |

---

## Prerequisites

Complete these lessons first:
- [04-settings](../../lessons/configuration/04-settings.md) — Understanding configuration
- [04a-terminal-config](../../lessons/configuration/04a-terminal-config.md) — Terminal setup
- [05-claude-md](../../lessons/configuration/05-claude-md.md) — CLAUDE.md basics

---

## Quick Reference

### Parallel Sessions Setup

```bash
# 1. Enable iTerm2 notifications
# iTerm2 → Preferences → Profiles → Terminal → Enable alerts

# 2. Create status line
cat > ~/.claude/statusline.sh << 'EOF'
#!/bin/bash
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir' | xargs basename)
echo "[$MODEL] $DIR"
EOF
chmod +x ~/.claude/statusline.sh

# 3. Configure settings
# Add to .claude/settings.json:
# "statusLine": {"type": "command", "command": "~/.claude/statusline.sh"}
```

### Lean Memory Setup

```markdown
# Keep root CLAUDE.md lean (~50 lines)
# Use imports for details:

## Overview
@README.md

## Architecture
@docs/architecture.md

## Code Style
@docs/code-style.md

## Common Mistakes
- (Add when Claude makes errors)
```

---

## Related

- [Team Template](../../team-template/) — Ready-to-copy configurations
- [Settings Reference](../settings/settings.json.example) — Full settings example
