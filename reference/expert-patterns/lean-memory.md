# Expert Pattern: Lean Memory

> **Keep CLAUDE.md under 100 lines. Use imports. Update on mistakes.**

---

## The Lean Memory Principle

CLAUDE.md is not a documentation dump — it's **active working memory** that costs tokens on every message.

```
┌─────────────────────────────────────────────────────────────┐
│              TOKEN IMPACT OF CLAUDE.md                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   CLAUDE.md Size    Tokens/Message    Impact                │
│   ────────────────────────────────────────────              │
│   100 lines (~2.5k) ~800 tokens       ✅ Optimal            │
│   300 lines         ~2,400 tokens     ⚠️  Getting heavy     │
│   500 lines         ~4,000 tokens     ❌ Too much           │
│   1000+ lines       ~8,000+ tokens    💀 Context pollution  │
│                                                              │
│   Every message = system prompt + CLAUDE.md + conversation  │
│   Bloated CLAUDE.md = less room for actual work             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Target: ~2.5k Tokens (~100 Lines)

A well-structured CLAUDE.md covers:

| Section | Lines | Content |
|---------|-------|---------|
| Tech Stack | 5-10 | Framework, language, database |
| Commands | 10-15 | Essential npm/build commands |
| Architecture | 5-10 | Directory structure overview |
| Code Style | 10-15 | Critical conventions |
| Common Mistakes | 5-10 | Things Claude gets wrong |
| **Total** | **~50-60** | Plus imports for details |

---

## Use Imports for Details

The `@path/to/file` syntax lets you keep CLAUDE.md lean while still providing rich context:

```markdown
# My Project

## Overview
@README.md

## Tech Stack
- Next.js 14 (App Router)
- TypeScript 5.3 (strict)
- PostgreSQL 16 with Prisma

## Commands
- `npm run dev` - Start dev server
- `npm test` - Run tests
- `npm run build` - Production build

## Architecture
@docs/architecture.md

## Code Style
@docs/code-style.md

## API Reference
@docs/api/README.md

## Common Mistakes
- Always null-check user.preferences
- Run `npx prisma generate` after schema changes
- Use transactions for multi-table updates
```

### Import Benefits

1. **Keeps CLAUDE.md lean** — Only ~30 lines in root file
2. **Single source of truth** — Update docs once, CLAUDE.md stays current
3. **Modular** — Team members can own different doc sections
4. **Git-friendly** — Changes to docs show meaningful diffs

### Import Paths

```markdown
# Relative paths
@./docs/architecture.md
@../shared/conventions.md

# Absolute paths
@/Users/me/global-instructions.md

# Home directory (individual team member preferences)
@~/.claude/my-project-prefs.md
```

### Import Rules

- Max depth: 5 hops (imports can import other files)
- Not evaluated inside code blocks or backticks
- Use `/memory` to see all loaded memory files

---

## The Mistake → Memory Workflow

The most valuable CLAUDE.md entries come from **real mistakes**:

### When Claude Does Something Wrong

1. **Identify the pattern**: What did Claude get wrong?
2. **Add to CLAUDE.md**: Concise instruction to prevent recurrence
3. **Commit**: Team benefits from your discovery

### Example Evolution

**Week 1**: Claude keeps using `var` instead of `const`
```markdown
## Common Mistakes
- Use `const` by default, `let` only when reassignment needed
```

**Week 2**: Claude forgets to handle null in user preferences
```markdown
## Common Mistakes
- Use `const` by default, `let` only when reassignment needed
- Always null-check user.preferences before accessing
```

**Week 3**: Claude skips running tests before commits
```markdown
## Common Mistakes
- Use `const` by default, `let` only when reassignment needed
- Always null-check user.preferences before accessing
- Run `npm test` before any git commit
```

This creates a **living document** of project-specific gotchas.

---

## Team CLAUDE.md Management

### Check Into Git

Your shared CLAUDE.md should be version-controlled:

```bash
git add CLAUDE.md
git commit -m "Add null-check reminder for user.preferences"
```

### Update Frequently

Teams that maintain effective CLAUDE.md files update it **multiple times per week**.

### Personal Overrides

Use `CLAUDE.local.md` (gitignored) for personal preferences:

```markdown
# CLAUDE.local.md

## My Preferences
- I prefer verbose explanations
- My local API runs on port 3001
- Skip suggesting tests (I'll add them)
```

Or use imports from home directory:

```markdown
# In shared CLAUDE.md
@~/.claude/my-project-prefs.md
```

This lets team members customize without affecting others.

---

## What NOT to Put in CLAUDE.md

| Don't Include | Why | Alternative |
|---------------|-----|-------------|
| Full API documentation | Too long | Import or link |
| Complete style guides | Token waste | Import key rules only |
| Historical context | Rarely relevant | Keep in docs/ |
| Redundant info | Claude already knows | Remove |
| Obvious instructions | Wastes tokens | Trust Claude |

### Red Flags

Your CLAUDE.md is too long if:
- It's over 200 lines
- It duplicates README content
- It includes full code examples
- It documents things Claude never gets wrong
- It hasn't been updated in months

---

## Lean CLAUDE.md Template

```markdown
# [Project Name]

## Tech Stack
- [Framework] [version]
- [Language] [version] (strict mode)
- [Database] with [ORM]

## Commands
- `[dev command]` - Start development
- `[test command]` - Run tests
- `[build command]` - Production build

## Architecture
```
src/
├── app/       # [description]
├── lib/       # [description]
└── server/    # [description]
```

## Code Style
- [Most important rule]
- [Second most important]
- [Third most important]

## Critical Rules
**ALWAYS** [most critical action]
**NEVER** [most critical prohibition]

## Common Mistakes
- [Real mistake #1 and fix]
- [Real mistake #2 and fix]
- [Real mistake #3 and fix]

## Details
@docs/architecture.md
@docs/api-reference.md
```

---

## Measuring CLAUDE.md Effectiveness

### Signs It's Working

- Claude follows conventions without reminding
- Fewer repeated mistakes
- New team members onboard faster with Claude
- PRs from Claude-assisted work pass review

### Signs It Needs Work

- You keep correcting the same mistakes
- Claude ignores instructions in CLAUDE.md
- File is too long and unfocused
- Hasn't been updated in weeks

---

## Quick Reference

| Principle | Guideline |
|-----------|-----------|
| **Target size** | ~100 lines (~2.5k tokens) |
| **Use imports** | `@path/to/details.md` |
| **Update trigger** | When Claude makes mistakes |
| **Check into git** | Yes, team-shared |
| **Personal prefs** | CLAUDE.local.md or home imports |
| **Review cadence** | Weekly cleanup |

---

## Related

- [05-claude-md.md](../../lessons/configuration/05-claude-md.md) — CLAUDE.md lesson
- [Memory Management Docs](https://code.claude.com/docs/en/memory) — Official documentation
