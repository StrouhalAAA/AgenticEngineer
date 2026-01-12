# Module 04c: Status Line Configuration

> **Display real-time session info at a glance — model, cost, git branch, and more.**

---

## What Is the Status Line?

The status line displays at the bottom of Claude Code, similar to how terminal prompts (PS1) work in shells like Oh-my-zsh or Starship.

```
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│   Claude Code Session                                       │
│                                                              │
│   > Working on your task...                                 │
│                                                              │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│  [Opus] 📁 my-project  main | $0.0234 | +156 lines         │
└─────────────────────────────────────────────────────────────┘
         ▲         ▲        ▲      ▲         ▲
         │         │        │      │         │
      Model    Directory  Branch  Cost   Lines Added
```

**Why it matters for parallel sessions:**
When running 5+ Claude Code sessions, you need to know at a glance:
- Which model each session is using
- Which project/branch
- How much each session has cost

---

## Quick Setup

### Option 1: Let Claude Help

```bash
/statusline
```

Claude will create a status line script for you. You can customize:

```bash
/statusline show the model name in orange and include git branch
```

### Option 2: Manual Configuration

Add to `.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
```

---

## How It Works

1. Status line updates when conversation messages change
2. Updates run at most every 300ms (no performance impact)
3. First line of stdout becomes the status line
4. ANSI color codes are supported
5. Claude passes session context as JSON to your script via stdin

---

## JSON Input Structure

Your script receives this data via stdin:

```json
{
  "hook_event_name": "Status",
  "session_id": "abc123...",
  "transcript_path": "/path/to/transcript.json",
  "cwd": "/current/working/directory",
  "model": {
    "id": "claude-opus-4-1",
    "display_name": "Opus"
  },
  "workspace": {
    "current_dir": "/current/working/directory",
    "project_dir": "/original/project/directory"
  },
  "version": "1.0.80",
  "output_style": {
    "name": "default"
  },
  "cost": {
    "total_cost_usd": 0.01234,
    "total_duration_ms": 45000,
    "total_api_duration_ms": 2300,
    "total_lines_added": 156,
    "total_lines_removed": 23
  }
}
```

### Key Fields

| Field | Description |
|-------|-------------|
| `model.display_name` | Human-readable model name |
| `workspace.current_dir` | Current working directory |
| `cost.total_cost_usd` | Session cost so far |
| `cost.total_lines_added` | Lines of code added |
| `cost.total_lines_removed` | Lines of code removed |

---

## Example Scripts

### Simple Status Line

```bash
#!/bin/bash
# ~/.claude/statusline.sh

input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir' | xargs basename)

echo "[$MODEL] 📁 $DIR"
```

### Git-Aware Status Line

```bash
#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir' | xargs basename)

# Get git branch if in repo
BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=" | 🌿 $(git branch --show-current 2>/dev/null)"
fi

echo "[$MODEL] 📁 $DIR$BRANCH"
```

### Full-Featured Status Line (Recommended)

```bash
#!/bin/bash
# ~/.claude/statusline.sh
# Shows: Model, Directory, Git Branch, Cost, Lines Added

input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir' | xargs basename)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
LINES=$(echo "$input" | jq -r '.cost.total_lines_added // 0')

# Git branch
BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=" $(git branch --show-current 2>/dev/null)"
fi

# ANSI colors
ORANGE='\033[38;5;208m'
GREEN='\033[32m'
BLUE='\033[34m'
CYAN='\033[36m'
RESET='\033[0m'

printf "${ORANGE}[%s]${RESET} ${BLUE}%s${RESET}${GREEN}%s${RESET} | ${CYAN}\$%.4f${RESET} | +%s" \
    "$MODEL" "$DIR" "$BRANCH" "$COST" "$LINES"
```

### Python Version

```python
#!/usr/bin/env python3
import json
import sys
import os

data = json.load(sys.stdin)

model = data['model']['display_name']
current_dir = os.path.basename(data['workspace']['current_dir'])
cost = data.get('cost', {}).get('total_cost_usd', 0)
lines = data.get('cost', {}).get('total_lines_added', 0)

# Check for git branch
git_branch = ""
if os.path.exists('.git'):
    try:
        with open('.git/HEAD', 'r') as f:
            ref = f.read().strip()
            if ref.startswith('ref: refs/heads/'):
                git_branch = f" {ref.replace('ref: refs/heads/', '')}"
    except:
        pass

print(f"[{model}] 📁 {current_dir}{git_branch} | ${cost:.4f} | +{lines}")
```

---

## Installation

1. **Create the script:**
   ```bash
   mkdir -p ~/.claude
   # Copy one of the scripts above to ~/.claude/statusline.sh
   chmod +x ~/.claude/statusline.sh
   ```

2. **Add to settings:**
   ```json
   // .claude/settings.json or ~/.claude/settings.json
   {
     "statusLine": {
       "type": "command",
       "command": "~/.claude/statusline.sh",
       "padding": 0
     }
   }
   ```

3. **Test manually:**
   ```bash
   echo '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/test"},"cost":{}}' | ~/.claude/statusline.sh
   ```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Status line doesn't appear | Check script is executable: `chmod +x` |
| Error messages | Ensure script outputs to stdout, not stderr |
| Missing data | Install `jq` for JSON parsing |
| Colors not showing | Verify terminal supports ANSI colors |

---

## Team Standardization

Share a common statusline script with your team:

```bash
# In your project repo
mkdir -p .claude
cp ~/.claude/statusline.sh .claude/statusline.sh
```

Update settings to use project-local script:
```json
{
  "statusLine": {
    "type": "command",
    "command": ".claude/statusline.sh"
  }
}
```

See also: [team-template/](../../team-template/) for shareable configurations.

---

## Hands-On Exercises

### Exercise 4c.1: Create Basic Status Line

1. Create `~/.claude/statusline.sh` with the simple example
2. Make executable: `chmod +x ~/.claude/statusline.sh`
3. Add statusLine config to settings.json
4. Restart Claude Code and verify status line appears

### Exercise 4c.2: Add Git Branch

1. Enhance your script with git branch detection
2. Navigate to a git repository
3. Verify branch name appears in status line
4. Switch branches and see it update

### Exercise 4c.3: Add Cost Tracking

1. Add cost display to your status line
2. Run a few tasks
3. Watch the cost increment
4. Use this awareness to optimize model selection

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Purpose** | At-a-glance session info |
| **Configuration** | `statusLine` in settings.json |
| **Script receives** | JSON with model, cost, workspace info |
| **Output** | First line of stdout = status line |
| **Colors** | ANSI codes supported |
| **Update rate** | Max every 300ms |

---

## Next Module

Continue to [05-claude-md.md](./05-claude-md.md) to master project context files.
