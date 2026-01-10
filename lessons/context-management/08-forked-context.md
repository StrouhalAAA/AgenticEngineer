# Module 10: Forked Context Execution

> **Isolate complex analysis workflows while preserving conversation awareness.**

---

## What is `context: fork`?

Introduced in Claude Code 2.1.0, the `context: fork` frontmatter option creates an **isolated execution environment** that:

1. **Inherits full conversation context** — Unlike subagents that start empty, forked commands see everything from the current session
2. **Discards execution output** — After completion, tool calls and intermediate reasoning don't persist in main context
3. **Returns only the final result** — Main context receives a clean summary, not execution traces

```
┌─────────────────────────────────────────────────────────────┐
│                 CONTEXT FORK FLOW                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Main Context (200K)                                         │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ User: "Analyze the auth module"                      │    │
│  │ Claude: *spawns forked context*                      │    │
│  └─────────────────────────────────────────────────────┘    │
│                         │                                    │
│                         ▼                                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ Forked Context (inherits full history)              │    │
│  │                                                      │    │
│  │ • Reads 30 files                                    │    │
│  │ • Runs grep patterns                                │    │
│  │ • Analyzes git history                              │    │
│  │ • Generates detailed report                         │    │
│  │                                                      │    │
│  │ All this work stays HERE (isolated)                 │    │
│  └─────────────────────────────────────────────────────┘    │
│                         │                                    │
│                         ▼                                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ Main Context receives: Clean summary (~500 tokens)   │    │
│  │ NOT: 30 file reads, grep results, git logs          │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Fork vs Subagent vs Main Context

This is the critical distinction for context management:

| Aspect | Main Context | Subagent | `context: fork` |
|--------|--------------|----------|-----------------|
| **Starting state** | Your conversation | Empty slate | Full conversation history |
| **Tool calls visible** | Yes (pollutes context) | In subagent only | In fork only |
| **Reasoning retained** | Yes | Summarized | Discarded |
| **Knows session history** | Yes | No | Yes |
| **Use case** | Normal work | Parallel specialized tasks | Context-aware cleanup |

### When Each Makes Sense

```
┌─────────────────────────────────────────────────────────────┐
│                 DECISION MATRIX                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  "I need to explore the codebase deeply"                    │
│   → Subagent (Explore) — Doesn't need session history        │
│                                                              │
│  "Summarize what we accomplished this session"              │
│   → context: fork — Needs history, output goes elsewhere     │
│                                                              │
│  "Implement this feature step by step"                      │
│   → Main context — You need to see the work                  │
│                                                              │
│  "Review this PR for security issues"                       │
│   → context: fork — Deep analysis, clean summary back        │
│                                                              │
│  "Research how authentication works here"                   │
│   → Subagent (Plan) — Parallel research, no history needed   │
│                                                              │
│  "Validate my PRD against the actual codebase"              │
│   → context: fork — Needs PRD from context, heavy analysis   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Syntax and Frontmatter

### Basic Usage

```yaml
---
description: Analyze code quality and generate detailed reports
context: fork
---
```

### Full Frontmatter Options

```yaml
---
name: deep-analysis
description: Comprehensive codebase analysis with quality metrics
context: fork
allowed-tools: Read, Grep, Glob, Bash(git:*)
model: claude-sonnet-4-20250514
---
```

### Works With Both Commands and Skills

**Commands** (user-invoked):
```
.claude/commands/analyse.md
```

**Skills** (auto-invoked):
```
.claude/skills/codebase-research/SKILL.md
```

---

## Implementation Examples

The following examples demonstrate practical applications of `context: fork` for PM and development workflows.

### Example 1: Feature Analysis Command (`/feature`)

Analyzes feature requests, researches codebase patterns, generates implementation plans—all without cluttering main context.

```markdown
---
description: Analyze feature request and generate implementation plan
argument-hint: <feature-description>
context: fork
allowed-tools: Read, Grep, Glob, Bash(git log:*), Bash(git diff:*)
model: claude-sonnet-4-20250514
---

# Feature Analysis & Implementation Plan

## Input
Feature request: $ARGUMENTS

## Current Context
- Project root: !`pwd`
- Recent commits: !`git log --oneline -5`
- Tech stack from package.json: @package.json

## Analysis Process

### Step 1: Codebase Pattern Discovery
Search the codebase for similar implementations:
1. Find related components using Glob
2. Analyze existing patterns with Read
3. Check recent changes with git log

### Step 2: Dependency Analysis
Identify affected areas:
- Which modules will this touch?
- What existing APIs can we leverage?
- Are there shared utilities that apply?

### Step 3: Generate Implementation Plan

Output a structured plan with:

**Summary** (2-3 sentences)

**Affected Files**
- List files that need modification
- List new files to create

**Implementation Steps**
1. Numbered steps with specific file references
2. Include validation gates between steps

**Testing Strategy**
- Unit tests required
- Integration test scenarios
- Edge cases to cover

**Risks & Dependencies**
- External dependencies
- Breaking change potential
- Performance considerations

**Estimated Complexity**: Simple | Medium | Complex
```

**Why fork?** Feature analysis involves extensive file searching, pattern matching, and git history exploration. Without forking, all these tool calls consume main context. With forking, you get a clean implementation plan injected back.

---

### Example 2: Code Analysis Command (`/analyse`)

Deep code quality analysis for developers needing comprehensive reports.

```markdown
---
description: Deep code analysis with quality metrics and recommendations
argument-hint: <file-or-directory-path>
context: fork
allowed-tools: Read, Grep, Glob, Bash(npx:*), Bash(npm run:*)
---

# Code Analysis Report

## Target
Analyzing: $ARGUMENTS

## Current State
- Files in scope: !`find $1 -type f -name "*.ts" -o -name "*.tsx" 2>/dev/null | head -20`

## Analysis Dimensions

### 1. Structural Analysis
- File organization and naming conventions
- Import/export patterns
- Module boundaries and coupling

### 2. Type Safety Audit
Run TypeScript strict checks if available

### 3. Complexity Metrics
Identify high-complexity functions:
- Functions over 30 lines
- Deeply nested conditionals (>3 levels)
- Functions with >5 parameters

### 4. Test Coverage Assessment
Check for corresponding test files:
- Missing test coverage
- Test file naming conventions

### 5. Security Scan
Look for common issues:
- Hardcoded secrets patterns
- SQL injection vulnerabilities
- XSS attack vectors

## Output Format

**Executive Summary**
One paragraph overview of code health

**Critical Issues** (must fix)
- Issue with file:line reference
- Suggested remediation

**Improvements** (should fix)
- Prioritized list with effort estimates

**Technical Debt**
- Areas needing refactoring

**Positive Patterns**
- Well-implemented areas worth preserving

**Action Items**
Numbered list ready for task tracking
```

---

### Example 3: PR Review Command (`/review`)

Comprehensive PR review with security, performance, and style checks.

```markdown
---
description: Comprehensive PR review with security and quality checks
argument-hint: [branch-name]
context: fork
allowed-tools: Read, Grep, Glob, Bash(git:*), Bash(gh:*)
---

# Pull Request Review

## Target
Reviewing: $ARGUMENTS (default: current branch vs main)

## Context Gathering
- Current branch: !`git branch --show-current`
- Diff stats: !`git diff --stat origin/main...HEAD 2>/dev/null || echo "Run from git repo"`
- Changed files: !`git diff --name-only origin/main...HEAD 2>/dev/null`

## Review Checklist

### 1. Change Scope Assessment
- Is the change appropriately scoped?
- Are there unrelated changes mixed in?
- Does the commit history tell a clear story?

### 2. Security Review
For each changed file, check:
- No hardcoded credentials
- Input validation on user data
- Proper authentication/authorization
- No SQL injection vectors
- XSS prevention in place

### 3. Performance Analysis
- No N+1 query patterns
- Appropriate caching
- No blocking operations in hot paths

### 4. Code Quality
- Follows project conventions
- Proper error handling
- Adequate logging

### 5. Test Coverage
- New functionality has tests
- Edge cases covered

## Output Format

**Review Summary**
✅ Approved | ⚠️ Approved with comments | ❌ Changes requested

**Security Findings**: [Critical/High/Medium/Low or None]

**Performance Concerns**: [List or None]

**Code Quality Notes**: [Specific feedback with file:line]

**Required Changes** (if any)
Numbered list that must be addressed before merge
```

---

### Example 4: Impact Analysis Command (`/impact`)

For PMs assessing the blast radius of proposed changes.

```markdown
---
description: Analyze impact of proposed changes across the codebase
argument-hint: <component-or-file-path>
context: fork
allowed-tools: Read, Grep, Glob, Bash(git:*)
---

# Impact Analysis Report

## Target Component
Analyzing impact of changes to: $ARGUMENTS

## Dependency Mapping

### Direct Dependents
Files that directly import/reference this component

### Transitive Impact
Second-level dependents that could be affected

### External Contracts
- API endpoints affected
- Database schema dependencies
- External service integrations

## Risk Assessment

### Breaking Change Potential
- Public API changes
- Type signature modifications
- Behavioral changes

### Test Impact
- Unit tests to update
- Integration tests affected
- E2E scenarios impacted

### Deployment Considerations
- Migration requirements
- Feature flag needs
- Rollback complexity

## Output

**Impact Summary**: [High/Medium/Low] with explanation

**Affected Components**: Hierarchical list

**Stakeholder Notification**: Teams/people to inform

**Recommended Approach**
- Phased rollout?
- Feature flag?
- Direct deployment?

**Estimated Effort**
- Development: X days
- Testing: X days
```

---

### Example 5: Session Summary Command (`/standup`)

Summarizes session work for notes or standup—needs full context but output goes elsewhere.

```markdown
---
description: Generate standup summary from current session
context: fork
allowed-tools: Read, Write, Bash(git:*)
---

# Session Summary for Standup

## Review This Session

Analyze the conversation history and extract:

### Completed Work
- What tasks were finished?
- What files were created/modified?
- What decisions were made?

### In Progress
- What's partially complete?
- What blockers were encountered?

### Key Decisions
- Technical choices made
- Trade-offs discussed

## Git Activity This Session
- Recent commits: !`git log --oneline --since="8 hours ago" 2>/dev/null`
- Uncommitted changes: !`git status --short 2>/dev/null`

## Output Format

```
✅ Completed:
- [item 1]
- [item 2]

🔄 In Progress:
- [item with status]

🚧 Blockers:
- [if any]

📋 Next:
- [planned items]
```
```

---

### Example 6: Security Scan Command (`/security-scan`)

Isolated security analysis that needs context awareness but shouldn't expose findings in main conversation history.

```markdown
---
description: Comprehensive security audit of codebase
argument-hint: [path|all]
context: fork
allowed-tools: Read, Grep, Glob, Bash(npm audit:*)
---

# Security Audit

## Scope
Target: $ARGUMENTS (default: entire project)

## Automated Checks

### Dependency Vulnerabilities
Check npm audit if available

### Secret Detection
Scan for exposed credentials:
- API keys patterns
- Connection strings
- JWT tokens
- Private keys

### OWASP Top 10 Review
1. Injection vulnerabilities
2. Broken authentication
3. Sensitive data exposure
4. Broken access control
5. Security misconfiguration

## Output

**Security Score**: [A-F]

**Critical Findings** (immediate action)
- Finding with severity and remediation

**High Priority**
- Issues for next sprint

**Medium/Low Priority**
- Technical debt items

**Compliance Notes**
- GDPR, PCI-DSS considerations if applicable
```

---

## Skills with Forked Context

For auto-invoked capabilities that should run in isolation:

### Codebase Research Skill

```markdown
# .claude/skills/codebase-research/SKILL.md
---
name: codebase-research
description: Deep codebase research and pattern discovery. Use when exploring implementations, finding similar code, or understanding architecture.
context: fork
allowed-tools: Read, Grep, Glob
---

# Codebase Research

When researching the codebase:

1. **Start broad**: Use Glob to find relevant files
2. **Identify patterns**: Look for similar implementations
3. **Trace dependencies**: Follow import chains
4. **Document findings**: Summarize discoveries

Return only:
- Relevant file paths
- Key patterns found
- Recommended approach based on existing code

Do NOT include:
- Full file contents in response
- All intermediate search results
- Step-by-step tool call descriptions
```

### PRD Validator Skill

```markdown
# .claude/skills/prd-validator/SKILL.md
---
name: prd-validator
description: Validates PRD against codebase reality. Use when reviewing requirements or checking feature feasibility.
context: fork
allowed-tools: Read, Grep, Glob
---

# PRD Validation

When validating a PRD:

1. **Technical Feasibility**
   - Can existing APIs support this?
   - What new endpoints needed?
   - Database schema changes?

2. **Effort Estimation**
   - Similar features in codebase
   - Complexity comparison

3. **Risk Assessment**
   - Dependencies on other teams
   - External service requirements

Return structured validation:
- Feasibility score (1-5)
- Effort estimate (S/M/L/XL)
- Key risks identified
- Recommended clarifications
```

---

## When NOT to Use Fork

| Scenario | Why Not Fork |
|----------|--------------|
| **Debugging sessions** | You need to see execution details |
| **Iterative refinement** | Context should persist for follow-ups |
| **Simple queries** | Overhead not worth it for single file read |
| **Teaching/explaining** | The process IS the output |

---

## Team Distribution

### Project Repository (Recommended)

```
.claude/
├── commands/
│   └── workflows/
│       ├── feature.md      # Enhanced with context: fork
│       ├── analyse.md      # Forked analysis
│       ├── review.md       # Forked review
│       └── impact.md       # Forked impact analysis
└── skills/
    ├── codebase-research/
    │   └── SKILL.md        # Forked research skill
    └── prd-validator/
        └── SKILL.md        # Forked validation skill
```

### Plugin Distribution

For cross-repository standardization, package commands and skills into a plugin with `skills/` and `commands/` directories.

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **`context: fork`** | Isolated execution with full session history |
| **vs Subagents** | Subagents start empty; fork inherits context |
| **vs Main** | Fork discards execution traces; main keeps everything |
| **Best for** | Analysis, review, research that needs history but shouldn't pollute |
| **Avoid for** | Debugging, iterative work, simple queries |
| **Syntax** | `context: fork` in YAML frontmatter |

---

## Related Modules

- [03-skills.md](../foundations/03-skills.md) — Skill fundamentals and progressive disclosure
- [07-subagents.md](./07-subagents.md) — Subagent patterns and isolation strategies
- [06-hooks.md](../configuration/06-hooks.md) — Combine with hooks for validation workflows

---

## Next Module

Continue to [09-mcp.md](../extensibility/09-mcp.md) to learn external tool integration.
