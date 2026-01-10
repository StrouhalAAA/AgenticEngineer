---
description: Verify repository structure against expected state
allowed-tools: Read, Bash, Glob, Grep
---

# Verify Repository Structure

## Check Current State

Run these verifications:

### 1. Directory Structure

```bash
echo "=== Directory Structure ==="
find . -type d -name ".*" -prune -o -type d -print | grep -v ".git" | sort
```

### 2. Expected Directories

Check these directories exist:
- [ ] `.claude/commands/workflows`
- [ ] `.claude/commands/tools`
- [ ] `.claude/agents`
- [ ] `docs/getting-started`
- [ ] `docs/concepts`
- [ ] `docs/reference`
- [ ] `learn/claude-code/fundamentals`
- [ ] `learn/gemini-cli`
- [ ] `learn/codex-cli`
- [ ] `learn/agentic-patterns`
- [ ] `samples`
- [ ] `templates`
- [ ] `team/onboarding`
- [ ] `team/standards`
- [ ] `team/workflows`

### 3. Expected Files

Check these files exist:
- [ ] `CLAUDE.md`
- [ ] `GEMINI.md`
- [ ] `AGENTS.md`
- [ ] `.mcp.json`
- [ ] `.claude/settings.json`
- [ ] `team/standards/CODE_STANDARDS.md`

### 4. Old Directories Removed

Verify these do NOT exist:
- [ ] `TAD_1/` (should be moved)
- [ ] `CommandsTemplates/` (should be moved)
- [ ] `SubAgents/` (should be moved)
- [ ] `DevOpsIntegration/` (should be moved)
- [ ] `OutputStyles/` (should be moved)

### 5. Commands Working

```bash
echo "=== Available Commands ==="
ls -la .claude/commands/workflows/ 2>/dev/null || echo "No workflow commands"
ls -la .claude/commands/tools/ 2>/dev/null || echo "No tool commands"
```

## Report

Summarize:
1. What's correctly in place
2. What's missing
3. What needs to be fixed

Format as a checklist with ✅ for complete, ❌ for missing.
