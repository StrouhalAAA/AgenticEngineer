---
description: Initialize understanding of this codebase
allowed-tools: Read, Bash, Glob, Grep
---

# Prime Codebase Understanding

## Step 1: Repository Overview

Read the README:
@README.md

## Step 2: Project Context

Read the Claude context file:
@CLAUDE.md

## Step 3: File Structure

```bash
echo "=== All tracked files ==="
git ls-files 2>/dev/null || find . -type f -name "*.md" | head -50
```

## Step 4: Directory Structure

```bash
echo "=== Directory tree ==="
find . -type d -name ".*" -prune -o -type d -print | grep -v ".git" | head -30
```

## Step 5: Available Commands

```bash
echo "=== Workflow Commands ==="
ls .claude/commands/workflows/ 2>/dev/null || echo "None"

echo "=== Tool Commands ==="
ls .claude/commands/tools/ 2>/dev/null || echo "None"
```

## Step 6: Summarize

Provide a concise summary:
1. **Purpose**: What is this repository for?
2. **Structure**: Key directories and their purposes
3. **Tech Stack**: Languages, frameworks, tools
4. **Commands**: Available slash commands
5. **Next Steps**: What the user might want to do
