# Forked Context Demo: Dependency Audit

> **Team Example: How and why to use `context: fork` in your commands.**

<!--
================================================================================
TEAM DOCUMENTATION: READ THIS FIRST
================================================================================

WHAT IS context: fork?
----------------------
When a command runs with `context: fork`, it:
1. INHERITS your full conversation history (unlike subagents which start empty)
2. EXECUTES in isolation (all tool calls stay in the fork)
3. RETURNS only the final output to your main conversation

WHY USE IT?
-----------
Your workflow: /bug → creates spec → /implement picks up spec

WITHOUT fork:
  /bug reads 20 files, runs git blame, greps everywhere
  ↓
  All that noise stays in your context (~10,000 tokens consumed)
  ↓
  /implement starts with polluted context, less room to work

WITH fork:
  /bug does the same research, but in isolation
  ↓
  Only the clean spec returns to main context (~500 tokens)
  ↓
  /implement has full context available for real work

WHEN TO USE:
✅ Analysis commands that output specs/plans (/bug, /feature, /review)
✅ Research tasks that need conversation context
✅ Any command that reads many files but outputs a summary

WHEN NOT TO USE:
❌ Implementation commands (you need to see the edits)
❌ Debugging (you need to see the execution)
❌ Quick lookups (overhead not worth it)

================================================================================
-->

---
description: Audit project dependencies and generate upgrade recommendations
argument-hint: [package-name|all]
context: fork
allowed-tools: Read, Grep, Glob, Bash(npm:*), Bash(cat:*)
---

# Dependency Audit

## Target
Auditing: $ARGUMENTS (default: all dependencies)

## Why This Command Uses `context: fork`

```
┌─────────────────────────────────────────────────────────┐
│ This command will:                                      │
│ • Read package.json, package-lock.json                  │
│ • Grep for import statements across the codebase        │
│ • Run npm outdated, npm audit                           │
│ • Check multiple config files                           │
│                                                         │
│ That's 15-30 tool calls → ~8,000 tokens of noise        │
│                                                         │
│ WITH context: fork, you only get the clean report back  │
│ (~500 tokens)                                           │
└─────────────────────────────────────────────────────────┘
```

## Analysis Steps (All Isolated in Fork)

### Step 1: Inventory Current Dependencies
Read package.json and identify:
- Production dependencies
- Dev dependencies
- Peer dependencies

### Step 2: Check for Outdated Packages
Run npm outdated and categorize:
- Major version behind (breaking changes likely)
- Minor version behind (new features available)
- Patch version behind (bug fixes available)

### Step 3: Security Audit
Run npm audit and identify:
- Critical vulnerabilities
- High severity issues
- Recommended fixes

### Step 4: Usage Analysis
Grep the codebase to find:
- Unused dependencies (installed but never imported)
- Heavy dependencies (imported everywhere)
- Duplicate functionality (multiple packages doing same thing)

### Step 5: Check Compatibility
Look for known issues:
- Conflicting peer dependencies
- Node version requirements
- Breaking changes in target versions

## Output Format

Return ONLY this clean summary to main context:

**Dependency Health Score**: [A-F]

**Critical Actions** (security vulnerabilities)
| Package | Current | Issue | Action |
|---------|---------|-------|--------|
| [name] | [ver] | [CVE/issue] | [upgrade to X] |

**Recommended Upgrades**
| Package | Current | Latest | Breaking Changes |
|---------|---------|--------|------------------|
| [name] | [ver] | [ver] | [yes/no + notes] |

**Unused Dependencies** (safe to remove)
- [ ] `package-name` - not imported anywhere

**Quick Wins** (patch updates, no breaking changes)
```bash
npm update [list of packages]
```

**Upgrade Plan**
1. [First step with rationale]
2. [Second step]
3. [Third step]

---

<!--
================================================================================
DATA FLOW VISUALIZATION
================================================================================

  Your Conversation                    Forked Execution
  ──────────────────                   ─────────────────

  User: "Check our deps"
           │
           ▼
  ┌─────────────────┐                 ┌─────────────────────────┐
  │ Main Context    │ ──inherits───► │ Fork Context            │
  │                 │    history      │                         │
  │ • Past msgs     │                 │ • Sees past msgs        │
  │ • Past work     │                 │ • Read package.json     │
  │                 │                 │ • Read package-lock     │
  │                 │                 │ • npm outdated          │
  │                 │                 │ • npm audit             │
  │                 │                 │ • Grep for imports      │
  │                 │                 │ • ... (20 tool calls)   │
  │                 │                 │                         │
  │                 │ ◄──returns───── │ Final report only       │
  │ + Clean report  │    ~500 tokens  │                         │
  └─────────────────┘                 └─────────────────────────┘

  ✅ Main context stays clean for next command (/implement, etc.)

================================================================================
-->
