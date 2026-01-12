# Module 05: CLAUDE.md Mastery

> **Engineer optimal context for every Claude Code session.**

> 🆕 **Updated** — Includes `@import` syntax and lean memory principles.

---

## What Is CLAUDE.md?

CLAUDE.md is a **persistent context file** that Claude Code loads automatically at session start. Think of it as project memory that survives between sessions.

```
┌─────────────────────────────────────────────────────────────┐
│                 CLAUDE.md PURPOSE                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Without CLAUDE.md:                                         │
│  Every session starts fresh. You re-explain the project.   │
│  Claude forgets conventions. Inconsistent behavior.         │
│                                                              │
│  With CLAUDE.md:                                            │
│  Session starts with context. Claude knows your project.   │
│  Follows your conventions. Consistent, reliable behavior.  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## CLAUDE.md Hierarchy

Claude Code discovers and loads CLAUDE.md files from multiple locations:

```
/Library/Application Support/ClaudeCode/CLAUDE.md  ← Enterprise policy (macOS)
        │
        ▼
~/.claude/CLAUDE.md          ← User (all projects)
        │
        ▼
/project/CLAUDE.md           ← Project root (team shared)
        │
        ▼
/project/CLAUDE.local.md     ← Personal override (gitignored)
        │
        ▼
/project/src/CLAUDE.md       ← Subdirectory specific
```

### When to Use Each Level

| Location | Scope | Use For |
|----------|-------|---------|
| Enterprise policy | Organization | Company-wide standards, security policies |
| `~/.claude/CLAUDE.md` | All projects | Personal style, global tools |
| `./CLAUDE.md` | Project (team) | Tech stack, conventions, commands |
| `./CLAUDE.local.md` | Project (you) | Personal preferences, local URLs |
| `./src/CLAUDE.md` | Subdirectory | Module-specific rules |

### How Discovery Works

Claude Code reads memories **recursively**: starting from cwd, it recurses up to (but not including) root, reading any CLAUDE.md or CLAUDE.local.md files found.

Subdirectory CLAUDE.md files are discovered but only loaded when Claude reads files in those subtrees.

---

## The Lean Memory Principle

**Keep CLAUDE.md under 100 lines (~2.5k tokens).**

Every message includes your CLAUDE.md. Bloated files waste tokens and pollute context.

```
┌─────────────────────────────────────────────────────────────┐
│              CLAUDE.md SIZE GUIDELINES                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ~100 lines (2.5k tokens)  ✅ Optimal                      │
│   ~300 lines                ⚠️  Getting heavy                │
│   ~500 lines                ❌ Too much                      │
│   1000+ lines               💀 Context pollution             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**What to include:**
- Essential commands (build, test, lint)
- Critical code conventions
- Common mistakes Claude makes

**What to exclude:**
- Full documentation (use imports)
- Obvious instructions
- Historical context

See [Expert Pattern: Lean Memory](../../reference/expert-patterns/lean-memory.md) for details.

---

## File Imports with @syntax

Include other files to keep CLAUDE.md focused:

```markdown
# Project Name

## Overview
@README.md

## Tech Stack
- Next.js 14 (App Router)
- TypeScript 5.3 (strict)
- PostgreSQL with Prisma

## Commands
- `npm run dev` - Start dev server
- `npm test` - Run tests

## Architecture
@docs/architecture.md

## Code Style
@docs/code-style.md

## API Documentation
@docs/api/README.md
```

### Import Path Types

```markdown
# Relative paths
@./docs/tech-stack.md
@../shared/conventions.md

# Absolute paths
@/path/to/file.md

# Home directory (personal preferences)
@~/.claude/my-project-prefs.md
```

### Import Rules

- **Max depth**: 5 hops (imports can import other files)
- **Not evaluated** inside code spans or code blocks
- **View loaded files**: Run `/memory` to see all memory files

### Team Pattern: Personal Imports

Let team members add individual preferences without modifying shared CLAUDE.md:

```markdown
# In shared CLAUDE.md
## Individual Preferences
@~/.claude/project-name-prefs.md
```

Each team member creates their own file in their home directory.

---

## Optimal CLAUDE.md Structure

Front-load critical information:

```markdown
# Project Name

## Tech Stack
- Framework: Next.js 14 (App Router)
- Language: TypeScript 5.3 (strict mode)
- Database: PostgreSQL 16 with Prisma ORM
- Testing: Vitest + Playwright

## Commands
- `npm run dev` - Start development server
- `npm run build` - Production build
- `npm run typecheck` - TypeScript validation
- `npm test` - Run unit tests

## Architecture
```
src/
├── app/           # Next.js App Router pages
├── components/    # React components
├── lib/           # Shared utilities
└── server/        # Server-side code
```

## Code Style
- Use named exports (not default)
- Prefer async/await over .then()
- Components: PascalCase
- Functions: camelCase

## Critical Rules
**ALWAYS** run `npm run typecheck` after code changes
**NEVER** modify files in `src/generated/`
**ALWAYS** add tests for new features

## Common Mistakes
- Prisma requires `npx prisma generate` after schema changes
- Always null-check user.preferences before accessing
- Use transactions for multi-table updates

## Details
@docs/architecture.md
@docs/api-reference.md
```

---

## Emphasis Patterns

Use specific words to increase instruction adherence:

| Keyword | Usage | Example |
|---------|-------|---------|
| **IMPORTANT** | Critical information | `IMPORTANT: Always validate inputs` |
| **ALWAYS** | Mandatory action | `ALWAYS run tests before committing` |
| **NEVER** | Prohibited action | `NEVER expose API keys` |
| **MUST** | Requirement | `You MUST follow PEP 8` |

---

## The Mistake → Memory Workflow

The most valuable CLAUDE.md entries come from real mistakes:

1. **Claude makes a mistake** (e.g., forgets null check)
2. **Add instruction** to Common Mistakes section
3. **Commit to git** so team benefits
4. **Claude won't repeat** the mistake

This creates a living document of project-specific gotchas.

---

## Using the # Shortcut

During a session, start your input with `#` to add quick memories:

```
> # Always use semicolons in TypeScript
> # Prefer functional components
```

You'll be prompted to select which memory file to store this in.

---

## Directly Edit with /memory

Use the `/memory` command to:
- View all loaded memory files
- Open any memory file in your editor
- See what Claude is working with

```bash
/memory
```

---

## CLAUDE.local.md

For personal project preferences that shouldn't be shared:

```markdown
# CLAUDE.local.md

## My Preferences
- I prefer verbose explanations
- My local API runs on port 3001
- Use `--verbose` flag for npm commands

## My Test Data
- Test user email: jake@test.local
- Local database: my_project_dev
```

CLAUDE.local.md is automatically added to .gitignore, making it ideal for:
- Local URLs and ports
- Personal test data
- Individual workflow preferences

---

## Hands-On Exercises

### Exercise 5.1: Create Lean CLAUDE.md

1. Create CLAUDE.md under 50 lines:
   ```markdown
   # My Project

   ## Tech Stack
   - Node.js 20, TypeScript 5

   ## Commands
   - `npm run dev` - Start dev server
   - `npm test` - Run tests

   ## Code Style
   - Use 2 spaces, const by default
   
   ## Common Mistakes
   - (Add as you find them)
   ```

2. Start Claude Code and verify:
   ```
   > What do you know about this project?
   ```

### Exercise 5.2: Use Imports

1. Create detailed docs:
   ```bash
   mkdir -p docs
   echo "# Architecture\n\nDetailed architecture..." > docs/architecture.md
   ```

2. Add import to CLAUDE.md:
   ```markdown
   ## Architecture
   @docs/architecture.md
   ```

3. Run `/memory` to verify import is loaded

### Exercise 5.3: Track a Mistake

1. Ask Claude to do something it gets wrong
2. Add the correction to Common Mistakes
3. Ask Claude the same thing again
4. Verify it now does it correctly

---

## CLAUDE.md Checklist

Before finalizing:

- [ ] Under 100 lines (500 max)?
- [ ] Tech stack clearly stated?
- [ ] Essential commands documented?
- [ ] Critical rules emphasized (ALWAYS/NEVER)?
- [ ] Using imports for detailed docs?
- [ ] No conflicting instructions?
- [ ] Added to git (not .gitignore)?
- [ ] CLAUDE.local.md for personal prefs?

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Purpose** | Persistent project context |
| **Location** | `./CLAUDE.md` (project), `~/.claude/CLAUDE.md` (global) |
| **Length** | Under 100 lines optimal (~2.5k tokens) |
| **Imports** | Use `@path/to/file.md` for details |
| **Order** | Front-load critical information |
| **Emphasis** | ALWAYS, NEVER, IMPORTANT, MUST |
| **Updates** | Add when Claude makes mistakes |
| **Local** | CLAUDE.local.md for personal prefs |

---

## Related

- [Expert Pattern: Lean Memory](../../reference/expert-patterns/lean-memory.md) — Deep dive on token optimization
- [Memory Management Docs](https://code.claude.com/docs/en/memory) — Official documentation

---

## Next Module

Continue to [06-hooks.md](./06-hooks.md) to learn event-driven automation.
