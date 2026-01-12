# Team Template

Copy these files to your team's working repositories for standardized Claude Code configuration.

---

## Contents

| File | Purpose |
|------|---------|
| `.claude/statusline.sh` | Team status line showing model, cost, git branch |
| `.claude/hooks/check-playbook-updates.sh` | Notification when playbook repo updates |
| `.claude/settings.json.example` | Example settings configuration |

---

## Quick Setup

### 1. Copy Configuration Files

```bash
# From your team's repo root
mkdir -p .claude/hooks

# Copy statusline
cp path/to/playbook/team-template/.claude/statusline.sh .claude/
chmod +x .claude/statusline.sh

# Copy playbook update checker (optional)
cp path/to/playbook/team-template/.claude/hooks/check-playbook-updates.sh .claude/hooks/
chmod +x .claude/hooks/check-playbook-updates.sh

# Copy settings example
cp path/to/playbook/team-template/.claude/settings.json.example .claude/settings.json
```

### 2. Configure settings.json

Edit `.claude/settings.json` for your project:

```json
{
  "model": "opusplan",
  "statusLine": {
    "type": "command",
    "command": ".claude/statusline.sh",
    "padding": 0
  },
  "permissions": {
    "allow": [
      "Read", "Write", "Edit",
      "Bash(npm:*)", "Bash(git:*)"
    ],
    "deny": ["Bash(rm -rf:*)"]
  }
}
```

### 3. Add to .gitignore

```bash
echo ".claude/settings.local.json" >> .gitignore
echo ".claude/.playbook-version" >> .gitignore
echo "CLAUDE.local.md" >> .gitignore
```

---

## Status Line

The status line script shows real-time session information:

```
[Opus] 📁 my-project  main | $0.0234 | +156 -23
  ▲         ▲          ▲       ▲        ▲
Model   Directory   Branch   Cost   Lines +/-
```

### Requirements

- `jq` for JSON parsing: `brew install jq` or `apt install jq`

### Customization

Edit `.claude/statusline.sh` to modify:
- Colors (ANSI codes)
- Information displayed
- Format/layout

---

## Playbook Update Notifications

Get notified when the team playbook repository has updates.

### Setup

1. Edit `.claude/hooks/check-playbook-updates.sh`:
   ```bash
   PLAYBOOK_REPO="your-org/agentic-engineer-playbook"  # Your repo
   ```

2. Add to `.claude/settings.json`:
   ```json
   {
     "hooks": {
       "SessionStart": [{
         "type": "command",
         "command": "bash .claude/hooks/check-playbook-updates.sh",
         "timeout": 5,
         "once": true
       }]
     }
   }
   ```

### What You'll See

**Regular update:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Playbook Updated
   See: https://github.com/your-org/playbook/blob/main/CHANGELOG.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Priority update (marked with ⭐ in changelog):**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 PLAYBOOK UPDATE (⭐ Priority)
   See: https://github.com/your-org/playbook/blob/main/CHANGELOG.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Recommended Project Structure

After setup, your project should have:

```
your-project/
├── .claude/
│   ├── settings.json           # Team settings (committed)
│   ├── settings.local.json     # Personal overrides (gitignored)
│   ├── statusline.sh           # Status line script
│   ├── hooks/
│   │   └── check-playbook-updates.sh
│   ├── commands/               # Team slash commands
│   └── skills/                 # Team skills
├── CLAUDE.md                   # Project context (committed)
├── CLAUDE.local.md             # Personal context (gitignored)
└── ...
```

---

## Requirements

- Claude Code 2.1.0+
- `jq` for status line
- `curl` for playbook update checker
- Public playbook repo (or configure auth for private)

---

## Troubleshooting

**Status line not appearing:**
- Check script is executable: `chmod +x .claude/statusline.sh`
- Verify jq is installed: `jq --version`
- Test manually: `echo '{}' | .claude/statusline.sh`

**Playbook notifications not appearing:**
- Check network connectivity
- Verify PLAYBOOK_REPO is set correctly
- Delete `.claude/.playbook-version` to force fresh check
- Test manually: `bash .claude/hooks/check-playbook-updates.sh`

---

## Related Documentation

- [Terminal Configuration](../lessons/configuration/04a-terminal-config.md)
- [Model Configuration](../lessons/configuration/04b-model-config.md)
- [Status Line Configuration](../lessons/configuration/04c-statusline.md)
- [Settings Reference](../reference/settings/settings.json.example)
