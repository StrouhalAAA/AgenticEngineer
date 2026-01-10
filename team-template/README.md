# Team Template: Playbook Update Notifications

Copy these files to your team's working repository to receive automatic notifications when the playbook is updated.

## Setup

### 1. Copy the hook script

```bash
# From your team's repo root
mkdir -p .claude/hooks
cp path/to/playbook/team-template/.claude/hooks/check-playbook-updates.sh .claude/hooks/
chmod +x .claude/hooks/check-playbook-updates.sh
```

### 2. Configure the playbook repo

Edit `.claude/hooks/check-playbook-updates.sh` and set:

```bash
PLAYBOOK_REPO="your-org/agentic-engineer-playbook"  # Your playbook repo
```

### 3. Add the hook to settings.json

Merge into your `.claude/settings.json`:

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

### 4. Add cache file to .gitignore

```bash
echo ".claude/.playbook-version" >> .gitignore
```

## How It Works

1. When a team member starts a Claude Code session, the hook runs once
2. It checks the playbook repo's latest commit via GitHub API
3. If there's a new commit since last check:
   - Shows a notification banner
   - Indicates if it's a priority update (marked with star in changelog)
   - Caches the commit SHA to avoid repeat notifications

## What You'll See

**Regular update:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Playbook Updated
   See: https://github.com/your-org/playbook/blob/main/CHANGELOG.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Priority update:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 PLAYBOOK UPDATE (⭐ Priority)
   See: https://github.com/your-org/playbook/blob/main/CHANGELOG.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Requirements

- `curl` (for GitHub API calls)
- Public playbook repo (or configure authentication for private repos)
- Claude Code 2.1.0+ (for `once: true` support)

## Troubleshooting

**No notifications appearing:**
- Check network connectivity
- Verify `PLAYBOOK_REPO` is set correctly
- Delete `.claude/.playbook-version` to force a fresh check

**Test the hook manually:**
```bash
bash .claude/hooks/check-playbook-updates.sh
```
