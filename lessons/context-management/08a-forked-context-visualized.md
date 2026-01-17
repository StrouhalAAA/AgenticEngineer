# Module 08a: Forked Context Visualized

> **Deep-dive visual guide to understanding context isolation in Claude Code.**

---

## Table of Contents

1. [Quick Start: Using Forked Context](#quick-start-using-forked-context) ← Start here
2. [Real-World Example: Service Refactoring](#real-world-example-service-refactoring)
3. [The Core Problem: Context Bloat](#the-core-problem-context-bloat)
4. [The Solution: Forked Context](#the-solution-forked-context)
5. [Side-by-Side Comparison](#side-by-side-comparison)
6. [Three Context Strategies Compared](#three-context-strategies-compared)
7. [Decision Guide: When to Fork](#decision-guide-when-to-fork)
8. [Key Takeaways](#key-takeaways)

---

## Quick Start: Using Forked Context

### For Command Authors (Developers, Tech Leads)

Add `context: fork` to any command's frontmatter to isolate heavy research work:

```yaml
---
description: Map all dependencies of a service
context: fork
allowed-tools: Read, Grep, Glob
---

Analyze the service named $ARGUMENTS and produce a dependency map.
Read all relevant files, trace consumers, and return a structured summary.
```

**What happens:**
- The command inherits your full conversation history
- It can read dozens of files without bloating your main context
- Only the final summary returns to your session

### For Subagent Definitions (Platform Engineers)

In `.claude/agents/your-agent.md`:

```yaml
---
name: dependency-mapper
description: Maps service dependencies across the codebase
context: fork
allowed-tools: Read, Grep, Glob, WebFetch
model: sonnet
---

You are a dependency analysis specialist. Given a service name,
thoroughly explore all consumers, database dependencies, and events.
Return a structured markdown report.
```

### For Product Managers

When requesting research tasks, ask for **forked context** when you need:
- Codebase analysis → single summary document
- Dependency mapping → architecture overview
- Impact assessment → change proposal

**Example prompt:**
> "Use a forked context command to analyze the payment flow and give me a summary of all the services involved."

This keeps the conversation lean so you can have a longer discussion afterward.

---

## Real-World Example: Service Refactoring

### Scenario

You're refactoring `IdentityService` into microservices and need to map all dependencies before writing any code.

### The Research Phase (Forked)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│    /map-service-dependencies IdentityService                                │
│                                                                             │
│    ┌─────────────────────────────────────────────────────────────────────┐  │
│    │                        FORKED CONTEXT                               │  │
│    │                                                                     │  │
│    │  Step 1: Find the service                                          │  │
│    │  ────────────────────────────                                      │  │
│    │  📁 GLOB: **/IdentityService.ts                                    │  │
│    │  📄 READ: Main service file (1,247 lines)                          │  │
│    │                                                                     │  │
│    │  Step 2: Extract endpoints                                         │  │
│    │  ────────────────────────────                                      │  │
│    │  🔍 GREP: @Get|@Post|@Put|@Delete in service                       │  │
│    │  📄 READ: Route files (320 lines)                                  │  │
│    │                                                                     │  │
│    │  Step 3: Find all consumers                                        │  │
│    │  ────────────────────────────                                      │  │
│    │  🔍 GREP: "IdentityService" → 847 matches in 234 files             │  │
│    │  📄 READ: 18 consumer client files (~3,000 lines total)            │  │
│    │                                                                     │  │
│    │  Step 4: Map database dependencies                                 │  │
│    │  ────────────────────────────                                      │  │
│    │  📄 READ: UserRepository.ts (580 lines)                            │  │
│    │  📄 READ: 12 migration files (~2,000 lines total)                  │  │
│    │                                                                     │  │
│    │  Step 5: Map event dependencies                                    │  │
│    │  ────────────────────────────                                      │  │
│    │  🔍 GREP: emit|publish|subscribe in service                        │  │
│    │  📄 READ: Event handler files                                      │  │
│    │                                                                     │  │
│    │  ─────────────────────────────────────────────────────────────     │  │
│    │  Total exploration: ~8,000 lines read                              │  │
│    │  Context consumed in fork: ~30,000 tokens                          │  │
│    │  ─────────────────────────────────────────────────────────────     │  │
│    │                                                                     │  │
│    │                         │                                           │  │
│    │                         ▼                                           │  │
│    │   ┌──────────────────────────────────────────────────────────────┐ │  │
│    │   │              CONDENSED SUMMARY                               │ │  │
│    │   │                  (~1,500 tokens)                             │ │  │
│    │   │                                                              │ │  │
│    │   │  • 23 endpoints identified                                   │ │  │
│    │   │  • 18 consumer services mapped                               │ │  │
│    │   │  • 5 database tables documented                              │ │  │
│    │   │  • 6 events catalogued                                       │ │  │
│    │   │  • Risk levels assigned                                      │ │  │
│    │   │  • Refactor sequence recommended                             │ │  │
│    │   └──────────────────────────────────────────────────────────────┘ │  │
│    │                                                                     │  │
│    └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│                         ┌─────────────────────┐                             │
│                         │  SUMMARY RETURNED   │                             │
│                         │  to main context    │                             │
│                         └─────────────────────┘                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### The Output You Receive

```markdown
# IdentityService Dependency Map

## Service Overview
- **Location**: `src/services/identity/IdentityService.ts`
- **Endpoints**: 23
- **Database Tables**: 5
- **Consumer Services**: 18

## Endpoints by Future Service

### → AuthService
| Endpoint | Method | Consumers | Daily Calls |
|----------|--------|-----------|-------------|
| `/auth/login` | POST | Web, Mobile, API | ~50,000 |
| `/auth/logout` | POST | Web, Mobile | ~12,000 |
| `/auth/refresh` | POST | All clients | ~200,000 |

### → UserService
| Endpoint | Method | Consumers | Daily Calls |
|----------|--------|-----------|-------------|
| `/users/:id` | GET | 12 services | ~500,000 |
| `/users/:id/profile` | PUT | Web, Mobile | ~8,000 |

### → PermissionService
| Endpoint | Method | Consumers | Daily Calls |
|----------|--------|-----------|-------------|
| `/permissions/check` | POST | All services | ~1,000,000 |

## High-Risk Consumers

| Service | Endpoints Used | Risk |
|---------|----------------|------|
| OrderService | 3 endpoints | 🔴 High |
| PaymentService | 2 endpoints | 🔴 High |

## Recommended Refactor Sequence

1. **Phase 1**: PermissionService (lowest risk)
2. **Phase 2**: UserService (clear boundaries)
3. **Phase 3**: AuthService (needs careful migration)
```

### Context Budget for Full Session

```
┌─────────────────────────────────────────────────────────────────────────────┐
│           FULL REFACTOR SESSION - WITH FORKED RESEARCH                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. /map-service-dependencies (forked)              ~1,600 tokens           │
│     └── (30,000 tokens of work → 1,600 summary)                             │
│                                                                             │
│  2. Discussion: Agree on approach                   ~2,000 tokens           │
│                                                                             │
│  3. Create PermissionService                       ~15,000 tokens           │
│                                                                             │
│  4. Create UserService                             ~18,000 tokens           │
│                                                                             │
│  5. Create AuthService                             ~20,000 tokens           │
│                                                                             │
│  6. Update tests                                   ~12,000 tokens           │
│                                                                             │
│  7. Update documentation                            ~5,000 tokens           │
│                                                                             │
│  ═══════════════════════════════════════════════════════════════════════    │
│  TOTAL: ~73,600 tokens (~37% of 200k window)                                │
│                                                                             │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│                                                                             │
│  ✅ Plenty of room for iterations and follow-ups!                           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

- [08-forked-context.md](08-forked-context.md) — Core concepts

## What You'll Learn

- How forked context actually works (with diagrams)
- Token flow: what's inherited vs discarded
- Real-world use cases with visual comparisons
- When to use fork vs main context vs subagents

---

## The Core Problem: Context Bloat

When Claude Code performs research tasks—reading files, searching code, analyzing patterns—every piece of information consumes tokens from your context window.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    THE CONTEXT WINDOW PROBLEM                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  200,000 token context window                                               │
│                                                                             │
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│  │                                                                       │  │
│  │  Every file read, every grep result, every analysis step             │  │
│  │  permanently consumes space until the conversation ends.              │  │
│  │                                                                       │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  Research task: "Map all dependencies of IdentityService"                   │
│                                                                             │
│  📄 Read service file .................. +4,500 tokens                      │
│  📄 Read 18 consumer files ............. +9,000 tokens                      │
│  📄 Read 12 migration files ............ +3,500 tokens                      │
│  🔍 Grep results ....................... +2,000 tokens                      │
│  📊 Analysis ........................... +500 tokens                        │
│  📝 Final summary ...................... +1,500 tokens                      │
│  ─────────────────────────────────────────────────────                      │
│  TOTAL: ~21,000 tokens (10% of window) for ONE research task                │
│                                                                             │
│  ▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│                                                                             │
│  😰 And you haven't started the actual work yet!                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## The Solution: Forked Context

Forked context creates an **isolated execution environment** that:
1. **Inherits** your conversation history (knows what you've discussed)
2. **Performs** extensive research (reads many files)
3. **Discards** execution traces (file contents, grep results)
4. **Returns** only the clean summary

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         FORKED CONTEXT FLOW                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   MAIN CONTEXT                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ • Your conversation history                                          │   │
│   │ • Previous decisions and context                                    │   │
│   │ • CLAUDE.md project instructions                                    │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                              │                                              │
│                              │ INHERITED (copied to fork)                   │
│                              ▼                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                     FORKED CONTEXT                                  │   │
│   │  ┌───────────────────────────────────────────────────────────────┐  │   │
│   │  │ ✓ Conversation history (knows what you discussed)             │  │   │
│   │  │ ✓ Project context (knows your codebase)                       │  │   │
│   │  │ ✓ CLAUDE.md instructions                                      │  │   │
│   │  └───────────────────────────────────────────────────────────────┘  │   │
│   │                              +                                      │   │
│   │  ┌───────────────────────────────────────────────────────────────┐  │   │
│   │  │ EXECUTION TRACES (new work)                                   │  │   │
│   │  │ ✗ File reads (thousands of lines)                             │  │   │
│   │  │ ✗ Glob/Grep results                                           │  │   │
│   │  │ ✗ Intermediate analysis                                       │  │   │
│   │  │ ✗ Tool call details                                           │  │   │
│   │  └───────────────────────────────────────────────────────────────┘  │   │
│   │                              │                                      │   │
│   │                              │ DISCARDED                            │   │
│   │                              ▼                                      │   │
│   │  ┌───────────────────────────────────────────────────────────────┐  │   │
│   │  │ FINAL OUTPUT (returned to main)                               │  │   │
│   │  │ ✓ Clean summary                                               │  │   │
│   │  │ ✓ Structured analysis                                         │  │   │
│   │  │ ✓ Recommendations                                             │  │   │
│   │  └───────────────────────────────────────────────────────────────┘  │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                              │                                              │
│                              │ RETURNED (~1,500 tokens)                     │
│                              ▼                                              │
│   MAIN CONTEXT (after fork)                                                 │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ • Previous messages (unchanged)                                      │   │
│   │ • + Clean summary from forked analysis                              │   │
│   │ • Ready for next task with minimal bloat                            │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Side-by-Side Comparison

### Without Fork (Main Context Only)

```
┌────────────────────────────────────┐
│     MAIN CONTEXT                   │
│     (Everything visible)           │
├────────────────────────────────────┤
│                                    │
│  User prompt         +100 tokens   │
│  ─────────────────────────────     │
│  Read file 1         +800 tokens   │
│  Read file 2         +400 tokens   │
│  Read file 3         +350 tokens   │
│  Read file 4         +200 tokens   │
│  Read file 5         +150 tokens   │
│  Glob results        +100 tokens   │
│  Grep results        +300 tokens   │
│  More analysis...    +500 tokens   │
│  ─────────────────────────────     │
│  Final summary       +500 tokens   │
│                                    │
│  ═══════════════════════════════   │
│  TOTAL: ~3,400 tokens consumed     │
│                                    │
│  Your next prompt has less room!   │
│                                    │
└────────────────────────────────────┘

     Context usage: ~3,400 tokens
     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░
```

### With Fork (Isolated Execution)

```
┌────────────────────────────────────┐
│     MAIN CONTEXT                   │
│     (Only summary visible)         │
├────────────────────────────────────┤
│                                    │
│  User prompt         +100 tokens   │
│  ─────────────────────────────     │
│                                    │
│     ┌─────────────────────┐        │
│     │   FORKED CONTEXT    │        │
│     │                     │        │
│     │  +800 (discarded)   │        │
│     │  +400 (discarded)   │        │
│     │  +350 (discarded)   │        │
│     │  +200 (discarded)   │        │
│     │  +150 (discarded)   │        │
│     │  +100 (discarded)   │        │
│     │  +300 (discarded)   │        │
│     │  +500 (discarded)   │        │
│     │                     │        │
│     │  Summary: 500 tok   │────┐   │
│     └─────────────────────┘    │   │
│                                │   │
│  ─────────────────────────────│───│
│  Only summary returned     +500│tok│
│                                    │
│  ═══════════════════════════════   │
│  TOTAL: ~600 tokens consumed       │
│                                    │
│  Main context stays lean!          │
│                                    │
└────────────────────────────────────┘

     Context usage: ~600 tokens
     ▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
```

**Savings: 82% less context consumed**

---

## Real-World Example: Service Refactoring

### Scenario

You're refactoring `IdentityService` into microservices and need to map all dependencies before writing any code.

### The Research Phase (Forked)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│    /map-service-dependencies IdentityService                                │
│                                                                             │
│    ┌─────────────────────────────────────────────────────────────────────┐  │
│    │                        FORKED CONTEXT                               │  │
│    │                                                                     │  │
│    │  Step 1: Find the service                                          │  │
│    │  ────────────────────────────                                      │  │
│    │  📁 GLOB: **/IdentityService.ts                                    │  │
│    │  📄 READ: Main service file (1,247 lines)                          │  │
│    │                                                                     │  │
│    │  Step 2: Extract endpoints                                         │  │
│    │  ────────────────────────────                                      │  │
│    │  🔍 GREP: @Get|@Post|@Put|@Delete in service                       │  │
│    │  📄 READ: Route files (320 lines)                                  │  │
│    │                                                                     │  │
│    │  Step 3: Find all consumers                                        │  │
│    │  ────────────────────────────                                      │  │
│    │  🔍 GREP: "IdentityService" → 847 matches in 234 files             │  │
│    │  📄 READ: 18 consumer client files (~3,000 lines total)            │  │
│    │                                                                     │  │
│    │  Step 4: Map database dependencies                                 │  │
│    │  ────────────────────────────                                      │  │
│    │  📄 READ: UserRepository.ts (580 lines)                            │  │
│    │  📄 READ: 12 migration files (~2,000 lines total)                  │  │
│    │                                                                     │  │
│    │  Step 5: Map event dependencies                                    │  │
│    │  ────────────────────────────                                      │  │
│    │  🔍 GREP: emit|publish|subscribe in service                        │  │
│    │  📄 READ: Event handler files                                      │  │
│    │                                                                     │  │
│    │  ─────────────────────────────────────────────────────────────     │  │
│    │  Total exploration: ~8,000 lines read                              │  │
│    │  Context consumed in fork: ~30,000 tokens                          │  │
│    │  ─────────────────────────────────────────────────────────────     │  │
│    │                                                                     │  │
│    │                         │                                           │  │
│    │                         ▼                                           │  │
│    │   ┌──────────────────────────────────────────────────────────────┐ │  │
│    │   │              CONDENSED SUMMARY                               │ │  │
│    │   │                  (~1,500 tokens)                             │ │  │
│    │   │                                                              │ │  │
│    │   │  • 23 endpoints identified                                   │ │  │
│    │   │  • 18 consumer services mapped                               │ │  │
│    │   │  • 5 database tables documented                              │ │  │
│    │   │  • 6 events catalogued                                       │ │  │
│    │   │  • Risk levels assigned                                      │ │  │
│    │   │  • Refactor sequence recommended                             │ │  │
│    │   └──────────────────────────────────────────────────────────────┘ │  │
│    │                                                                     │  │
│    └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│                         ┌─────────────────────┐                             │
│                         │  SUMMARY RETURNED   │                             │
│                         │  to main context    │                             │
│                         └─────────────────────┘                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### The Output You Receive

```markdown
# IdentityService Dependency Map

## Service Overview
- **Location**: `src/services/identity/IdentityService.ts`
- **Endpoints**: 23
- **Database Tables**: 5
- **Consumer Services**: 18

## Endpoints by Future Service

### → AuthService
| Endpoint | Method | Consumers | Daily Calls |
|----------|--------|-----------|-------------|
| `/auth/login` | POST | Web, Mobile, API | ~50,000 |
| `/auth/logout` | POST | Web, Mobile | ~12,000 |
| `/auth/refresh` | POST | All clients | ~200,000 |

### → UserService
| Endpoint | Method | Consumers | Daily Calls |
|----------|--------|-----------|-------------|
| `/users/:id` | GET | 12 services | ~500,000 |
| `/users/:id/profile` | PUT | Web, Mobile | ~8,000 |

### → PermissionService
| Endpoint | Method | Consumers | Daily Calls |
|----------|--------|-----------|-------------|
| `/permissions/check` | POST | All services | ~1,000,000 |

## High-Risk Consumers

| Service | Endpoints Used | Risk |
|---------|----------------|------|
| OrderService | 3 endpoints | 🔴 High |
| PaymentService | 2 endpoints | 🔴 High |

## Recommended Refactor Sequence

1. **Phase 1**: PermissionService (lowest risk)
2. **Phase 2**: UserService (clear boundaries)
3. **Phase 3**: AuthService (needs careful migration)
```

### Context Budget for Full Session

```
┌─────────────────────────────────────────────────────────────────────────────┐
│           FULL REFACTOR SESSION - WITH FORKED RESEARCH                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. /map-service-dependencies (forked)              ~1,600 tokens           │
│     └── (30,000 tokens of work → 1,600 summary)                             │
│                                                                             │
│  2. Discussion: Agree on approach                   ~2,000 tokens           │
│                                                                             │
│  3. Create PermissionService                       ~15,000 tokens           │
│                                                                             │
│  4. Create UserService                             ~18,000 tokens           │
│                                                                             │
│  5. Create AuthService                             ~20,000 tokens           │
│                                                                             │
│  6. Update tests                                   ~12,000 tokens           │
│                                                                             │
│  7. Update documentation                            ~5,000 tokens           │
│                                                                             │
│  ═══════════════════════════════════════════════════════════════════════    │
│  TOTAL: ~73,600 tokens (~37% of 200k window)                                │
│                                                                             │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│                                                                             │
│  ✅ Plenty of room for iterations and follow-ups!                           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Three Context Strategies Compared

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     CONTEXT STRATEGY COMPARISON                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. MAIN CONTEXT (default)                                                  │
│     ════════════════════════                                                │
│                                                                             │
│     User ←────────────────────────────────────────────→ Claude              │
│            All tool calls and results visible                               │
│                                                                             │
│     ✓ Full transparency                                                     │
│     ✓ Good for interactive work, debugging                                  │
│     ✗ Context fills up with file reads                                      │
│                                                                             │
│     Best for: Learning, debugging, small tasks                              │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  2. SUBAGENTS (start empty)                                                 │
│     ═══════════════════════                                                 │
│                                                                             │
│     User ←───→ Main Claude ←───→ Subagent                                   │
│                                  (no history)                               │
│                                                                             │
│     ✓ Parallel execution possible                                           │
│     ✓ Specialized tools per agent                                           │
│     ✗ No conversation context                                               │
│                                                                             │
│     Best for: Parallel specialized tasks, isolated work                     │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  3. FORKED CONTEXT (inherits history)                                       │
│     ═════════════════════════════════                                       │
│                                                                             │
│     User ←───→ Main Claude                                                  │
│                    │                                                        │
│                    └──→ Fork ──→ Summary only returned                      │
│                         (has history)                                       │
│                                                                             │
│     ✓ Knows conversation context                                            │
│     ✓ Returns only clean output                                             │
│     ✗ Can't show intermediate work                                          │
│                                                                             │
│     Best for: Research → single output tasks                                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Decision Guide: When to Fork

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SHOULD YOU FORK?                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                    ┌─────────────────────┐                                  │
│                    │ Will the task read  │                                  │
│                    │ more than 5 files?  │                                  │
│                    └──────────┬──────────┘                                  │
│                               │                                             │
│              ┌────────────────┴────────────────┐                            │
│              │                                 │                            │
│              ▼                                 ▼                            │
│         ┌────────┐                        ┌────────┐                        │
│         │   NO   │                        │  YES   │                        │
│         └────┬───┘                        └────┬───┘                        │
│              │                                 │                            │
│              ▼                                 ▼                            │
│    ┌─────────────────┐              ┌─────────────────────┐                 │
│    │ Use main context│              │ Does it produce a   │                 │
│    │ (transparency)  │              │ single output doc?  │                 │
│    └─────────────────┘              └──────────┬──────────┘                 │
│                                                │                            │
│                               ┌────────────────┴────────────────┐           │
│                               │                                 │           │
│                               ▼                                 ▼           │
│                          ┌────────┐                        ┌────────┐       │
│                          │  YES   │                        │   NO   │       │
│                          └────┬───┘                        └────┬───┘       │
│                               │                                 │           │
│                               ▼                                 ▼           │
│                     ┌─────────────────┐              ┌─────────────────┐    │
│                     │   USE FORK ✓    │              │ Use main context│    │
│                     │ (context: fork) │              │ (need to iterate│    │
│                     └─────────────────┘              │  on findings)   │    │
│                                                      └─────────────────┘    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Fork-Worthy Tasks

| Task | Files Read | Output | Fork? |
|------|------------|--------|-------|
| Map service dependencies | 20+ | Summary doc | ✅ Yes |
| Analyze codebase structure | 30+ | Architecture doc | ✅ Yes |
| Find all usages of function | 50+ | Usage report | ✅ Yes |
| Generate API documentation | 15+ | Single doc | ✅ Yes |
| Plan feature implementation | 10+ | Spec document | ✅ Yes |

### Don't Fork These

| Task | Why Not |
|------|---------|
| Debug a specific function | Need to see intermediate steps |
| Interactive code review | Need back-and-forth discussion |
| Implementing changes | Need to track what was modified |
| Learning/exploring | Want to see how Claude works |

---

## Key Takeaways

1. **Forked context = Research mode**
   - Inherit history, discard execution traces
   - Perfect for "read many → write one" tasks

2. **Token savings compound**
   - Each forked research task saves thousands of tokens
   - Enables longer, more complex sessions

3. **Use the decision guide**
   - 5+ files AND single output → Fork
   - Need iteration or transparency → Main context

4. **Commands can specify context**
   - `context: fork` in frontmatter
   - Automatic isolation without manual setup

---

## Related

- [08-forked-context.md](08-forked-context.md) — Core concepts
- [07-subagents.md](07-subagents.md) — Alternative: empty-context delegation
- [parallel-sessions.md](../../reference/expert-patterns/parallel-sessions.md) — Running multiple Claude instances
