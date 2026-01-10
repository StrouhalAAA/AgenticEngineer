# Module 05: CLAUDE.md Mastery

> **Engineer optimal context for every Claude Code session.**

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
~/.claude/CLAUDE.md          ← Global (all projects)
        │
        ▼
/project/CLAUDE.md           ← Project root (team shared)
        │
        ▼
/project/CLAUDE.local.md     ← Personal override
        │
        ▼
/project/src/CLAUDE.md       ← Subdirectory specific
```

### When to Use Each Level

| Location | Scope | Use For |
|----------|-------|---------|
| `~/.claude/CLAUDE.md` | All projects | Personal style, global tools |
| `./CLAUDE.md` | Project (team) | Tech stack, conventions, commands |
| `./CLAUDE.local.md` | Project (you) | Personal preferences |
| `./src/CLAUDE.md` | Subdirectory | Module-specific rules |

---

## Optimal CLAUDE.md Structure

Keep CLAUDE.md **under 100 lines** (500 max). Front-load critical information:

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

## Known Issues
- Prisma requires `npx prisma generate` after schema changes
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

## File Imports with @syntax

Include other files to keep CLAUDE.md focused:

```markdown
# Project Name

## Tech Stack
@docs/tech-stack.md

## Code Style
@docs/code-style.md

## API Documentation
@docs/api/README.md
```

### Benefits

1. **Keeps CLAUDE.md lean** - Under 100 lines
2. **Single source of truth** - Update docs once
3. **Modular organization** - Separate concerns

---

## Using the # Shortcut

During a session, press `#` to add instructions:

```
> # Always use semicolons in TypeScript
> # Prefer functional components
```

Claude will remember these for the current session.

---

## Hands-On Exercises

### Exercise 5.1: Create Your First CLAUDE.md

1. In project root, create CLAUDE.md:
   ```markdown
   # My Project

   ## Tech Stack
   - Node.js 20
   - TypeScript 5

   ## Commands
   - `npm run dev` - Start dev server
   - `npm test` - Run tests

   ## Code Style
   - Use 2 spaces for indentation
   - Prefer const over let
   ```

2. Start Claude Code and verify:
   ```
   > What do you know about this project?
   ```

### Exercise 5.2: Test Emphasis Patterns

1. Add critical rules:
   ```markdown
   ## Critical Rules
   
   **ALWAYS** respond in bullet points
   **NEVER** use emojis
   ```

2. Test adherence with a question

---

## CLAUDE.md Checklist

Before finalizing:

- [ ] Under 100 lines (500 max)?
- [ ] Tech stack clearly stated?
- [ ] Essential commands documented?
- [ ] Critical rules emphasized (ALWAYS/NEVER)?
- [ ] No conflicting instructions?
- [ ] Added to git (not .gitignore)?

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Purpose** | Persistent project context |
| **Location** | `./CLAUDE.md` (project), `~/.claude/CLAUDE.md` (global) |
| **Length** | Under 100 lines optimal, 500 max |
| **Order** | Front-load critical information |
| **Emphasis** | ALWAYS, NEVER, IMPORTANT, MUST |
| **Imports** | Use `@path/to/file.md` for details |

---

## Next Module

Continue to [06-hooks.md](./06-hooks.md) to learn event-driven automation.
