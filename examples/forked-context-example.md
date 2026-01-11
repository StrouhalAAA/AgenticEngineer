# Forked Context Example: Tech Debt Analyzer

> **Educational example demonstrating `context: fork` data flow and isolation.**

---

## Section 1: The Command (Meta Prompt)

Save this as `.claude/commands/tech-debt.md` to use it:

```markdown
---
description: Analyze technical debt and generate prioritized remediation plan
argument-hint: [path|module-name]
context: fork
allowed-tools: Read, Grep, Glob, Bash(git log:*), Bash(git blame:*)
model: claude-sonnet-4-20250514
---

# Technical Debt Analysis

## Target
Analyzing: $ARGUMENTS (default: entire project)

## Context From Main Session
Use any relevant context from our conversation:
- Previous discussions about architecture decisions
- Known pain points mentioned by the user
- Recent changes we've been working on together

## Analysis Process

### Step 1: Code Smell Detection
Search for common debt indicators:

1. **Long functions** (>50 lines)
   - Use Grep to find function definitions
   - Count lines in each function body

2. **TODO/FIXME comments**
   - Pattern: `TODO|FIXME|HACK|XXX`
   - Extract age from git blame

3. **Duplicated code patterns**
   - Find similar function signatures
   - Identify copy-paste indicators

4. **Complex conditionals**
   - Nested if/else > 3 levels
   - Switch statements > 10 cases

### Step 2: Dependency Health
Check for outdated or risky dependencies:
- Read package.json / requirements.txt
- Look for deprecated imports
- Identify unused dependencies

### Step 3: Test Coverage Gaps
- Find source files without corresponding tests
- Identify untested edge cases in existing tests

### Step 4: Git Archaeology
Understand debt history:
- Files with most churn (frequent changes)
- Ancient code (unchanged > 1 year)
- Hotspot analysis (high churn + high complexity)

## Output Format

Return ONLY this structured summary:

**Tech Debt Score**: [A-F] with brief justification

**Critical Issues** (blocking future development)
| Issue | Location | Age | Effort |
|-------|----------|-----|--------|
| [issue] | file:line | [days] | [S/M/L] |

**High Priority** (should address this quarter)
- [issue with file reference and remediation suggestion]

**Medium Priority** (nice to have)
- [issue with file reference]

**Quick Wins** (< 1 hour each)
- [ ] [actionable item]
- [ ] [actionable item]

**Recommended Approach**
1. [First step]
2. [Second step]
3. [Third step]

**Estimated Total Effort**: [X developer-days]
```

---

## Section 2: How Forked Context Works

### Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                        FORKED CONTEXT DATA FLOW                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ MAIN CONTEXT (Before Fork)                                    │   │
│  │                                                               │   │
│  │ Message 1: User asks about auth module                        │   │
│  │ Message 2: Claude explains the auth flow                      │   │
│  │ Message 3: User mentions "the login is slow"                  │   │
│  │ Message 4: Claude suggests caching                            │   │
│  │ Message 5: User runs /tech-debt auth/                    ◄────┼───┤ TRIGGER
│  │                                                               │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              │                                       │
│                              ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ WHAT GETS PASSED INTO FORK                                    │   │
│  │                                                               │   │
│  │ ✅ Full conversation history (Messages 1-5)                   │   │
│  │ ✅ System prompt and CLAUDE.md instructions                   │   │
│  │ ✅ $ARGUMENTS = "auth/"                                       │   │
│  │ ✅ The command template (tech-debt.md content)                │   │
│  │ ✅ Working directory and environment context                  │   │
│  │                                                               │   │
│  │ ❌ NOT passed: Previous fork execution traces                 │   │
│  │ ❌ NOT passed: Other subagent results (only summaries)        │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              │                                       │
│                              ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ FORKED EXECUTION (Isolated)                                   │   │
│  │                                                               │   │
│  │ Tool Call 1: Glob("auth/**/*.ts")         → 15 files found    │   │
│  │ Tool Call 2: Read("auth/login.ts")        → 200 lines         │   │
│  │ Tool Call 3: Read("auth/session.ts")      → 150 lines         │   │
│  │ Tool Call 4: Grep("TODO|FIXME", "auth/")  → 12 matches        │   │
│  │ Tool Call 5: Bash("git log --oneline auth/") → 50 commits     │   │
│  │ Tool Call 6: Bash("git blame auth/login.ts") → blame output   │   │
│  │ Tool Call 7: Read("auth/cache.ts")        → 80 lines          │   │
│  │ ... (20+ more tool calls)                                     │   │
│  │                                                               │   │
│  │ Claude's internal reasoning:                                  │   │
│  │ "The login.ts file has 3 TODO comments from 2023..."          │   │
│  │ "I see the user mentioned slow login - there's no caching..." │   │
│  │ "The session.ts has a 60-line function that should split..."  │   │
│  │                                                               │   │
│  │ ⚠️  ALL OF THIS STAYS IN THE FORK - NOT RETURNED              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              │                                       │
│                              ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ WHAT RETURNS TO MAIN CONTEXT                                  │   │
│  │                                                               │   │
│  │ **Tech Debt Score**: C                                        │   │
│  │                                                               │   │
│  │ **Critical Issues**                                           │   │
│  │ | Issue | Location | Age | Effort |                           │   │
│  │ | No caching in login flow | auth/login.ts:45 | 180d | M |    │   │
│  │                                                               │   │
│  │ **Quick Wins**                                                │   │
│  │ - [ ] Remove dead code in auth/legacy.ts                      │   │
│  │ - [ ] Add missing null checks in session.ts                   │   │
│  │                                                               │   │
│  │ (~500 tokens vs ~15,000 tokens of execution traces)           │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              │                                       │
│                              ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ MAIN CONTEXT (After Fork)                                     │   │
│  │                                                               │   │
│  │ Message 1-5: (unchanged - still there)                        │   │
│  │ Message 6: Clean tech debt summary (only the output)          │   │
│  │                                                               │   │
│  │ User can now ask: "Fix the login caching issue"               │   │
│  │ Claude has context from both conversation AND the analysis    │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Key Concepts Explained

#### 1. Context Inheritance
```
┌─────────────────────────────────────────────┐
│ The fork KNOWS about previous conversation  │
│                                             │
│ User said: "the login is slow"              │
│            ↓                                │
│ Fork can use this context when analyzing!   │
│ It might specifically check login perf.     │
└─────────────────────────────────────────────┘
```

Unlike a **subagent** (which starts with empty context), the forked command can reference anything from your conversation. This is why the command template says:

```markdown
## Context From Main Session
Use any relevant context from our conversation:
- Previous discussions about architecture decisions
- Known pain points mentioned by the user
```

#### 2. Execution Isolation
```
┌─────────────────────────────────────────────┐
│ The fork's WORK stays isolated              │
│                                             │
│ 25 file reads      ──┐                      │
│ 10 grep searches   ──┼──► All discarded     │
│ 5 git commands     ──┘                      │
│                                             │
│ Only the OUTPUT returns to main context     │
└─────────────────────────────────────────────┘
```

This is the key benefit: deep analysis without context pollution.

#### 3. $ARGUMENTS Variable
```
User types:    /tech-debt auth/
                         ↓
$ARGUMENTS =           "auth/"
                         ↓
Template uses: Analyzing: $ARGUMENTS
                         ↓
Fork sees:     Analyzing: auth/
```

#### 4. allowed-tools Restriction
```yaml
allowed-tools: Read, Grep, Glob, Bash(git log:*), Bash(git blame:*)
```

This restricts what the fork can do:
- ✅ `Read` - Can read any file
- ✅ `Grep` - Can search file contents
- ✅ `Glob` - Can find files by pattern
- ✅ `Bash(git log:*)` - Can run `git log` with any arguments
- ✅ `Bash(git blame:*)` - Can run `git blame` with any arguments
- ❌ `Bash(rm:*)` - Cannot delete files
- ❌ `Write` - Cannot modify files
- ❌ `Edit` - Cannot edit files

### Comparison: What If This WASN'T Forked?

Without `context: fork`, all those tool calls would appear in your main conversation:

```
Main Context WITHOUT Fork (polluted):
├── Message 1: User asks about auth
├── Message 2: Claude explains auth
├── Message 3: User mentions slow login
├── Message 4: Claude suggests caching
├── Message 5: User runs /tech-debt
├── Tool: Glob("auth/**/*.ts") → [15 files...]
├── Tool: Read("auth/login.ts") → [200 lines of code...]
├── Tool: Read("auth/session.ts") → [150 lines of code...]
├── Tool: Grep("TODO|FIXME") → [12 matches with context...]
├── Tool: git log → [50 commit messages...]
├── Tool: git blame → [200 lines of blame output...]
├── ... (20+ more tool results eating context)
├── Message 6: Tech debt analysis
└── 🚨 Context is now ~50% consumed by one analysis!
```

With `context: fork`:
```
Main Context WITH Fork (clean):
├── Message 1: User asks about auth
├── Message 2: Claude explains auth
├── Message 3: User mentions slow login
├── Message 4: Claude suggests caching
├── Message 5: User runs /tech-debt
├── Message 6: Clean tech debt summary (~500 tokens)
└── ✅ Context barely touched, ready for more work!
```

---

## Section 3: When to Use This Pattern

### Good Use Cases for `context: fork`
| Scenario | Why Fork Works |
|----------|----------------|
| Code analysis | Heavy file reading, clean report back |
| PR review | Needs PR context, returns structured feedback |
| Impact analysis | Deep dependency tracing, summary output |
| Session summaries | Needs full history, output goes elsewhere |
| Architecture audit | Extensive exploration, executive summary |

### Bad Use Cases (Don't Fork)
| Scenario | Why Not |
|----------|---------|
| Debugging | You NEED to see the execution details |
| Iterative coding | Context should persist for follow-ups |
| Quick lookups | Single file read doesn't need isolation |
| Learning/teaching | The process IS the value |

---

## Try It Yourself

1. Save Section 1 as `.claude/commands/tech-debt.md`
2. Run: `/tech-debt src/`
3. Notice: You get a clean summary, not 50 tool call results
4. Ask follow-up: "Fix the first critical issue"
5. Notice: Claude still has conversation context + analysis results
