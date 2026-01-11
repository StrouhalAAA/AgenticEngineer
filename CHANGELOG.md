# Changelog

All notable changes to this repository.

| Date | Version | Priority | Changes |
|------|---------|----------|---------|
| 2026-01-11 | 2.4.0 | ⭐ | Added Module 11: LSP (Language Server Protocol) |
| 2026-01-10 | 2.3.0 | | Added team notification system |
| 2025-01-10 | 2.2.0 | | Reorganized lessons into thematic sections |
| 2025-01-10 | 2.1.0 | | Added Forked Context, enhanced `/feature` command |
| 2025-01-10 | 2.0.0 | | Simplified structure, added START_HERE.md |
| 2025-01-10 | 1.0.0 | | Initial release with fundamentals |

> **Priority column**: Updates marked with ⭐ contain important changes your team should review.

---

## [2.4.0] - 2026-01-11

### Added
- **Module 11: LSP** (`lessons/extensibility/11-lsp.md`)
  - Dedicated lesson for Language Server Protocol support (Claude Code v2.0.74+)
  - Complete setup guide: env var, plugin, binary, verification
  - All 5 LSP operations explained with use cases
  - Prompt patterns for triggering LSP explicitly
  - Supported languages table (TypeScript, Python, Go, Rust, etc.)
  - `.lsp.json` configuration templates
  - Troubleshooting guide with debug checklist
  - 3 hands-on exercises
  - Team action items and success metrics

### Changed
- **Enhanced `lessons/extensibility/10-plugins.md`** with expanded LSP section
  - Added required `ENABLE_LSP_TOOLS=1` env var step
  - Added "When to use LSP vs Regular Search" decision table
  - Added prompt tips and limitations
  - Cross-reference to new Module 11
- **Updated `lessons/README.md`** - Now 11 lessons (~3.5 hours)
- **Updated `reference/plugins/examples.md`** with complete LSP setup by language
- **Updated `learn/claude-code/changelog/CHANGELOG_INDEX.md`** with v2.0.74 LSP note

### Why This Matters
LSP transforms Claude Code from text pattern matching to semantic code understanding.
The critical setup step (`ENABLE_LSP_TOOLS=1`) is often missed — this lesson ensures
your team configures LSP correctly from day one.

---

## [2.3.0] - 2026-01-10

### Added
- **Team notification system** for cross-repo update awareness
  - SessionStart hook pattern for checking playbook updates
  - Changelog format with priority markers
  - Team template in `team-template/` directory

### Why This Matters
Teams maintaining this playbook separately from their working repos can now
be automatically notified of important updates when starting Claude Code sessions.

## [2.2.0] - 2025-01-10

### Changed
- **Reorganized lessons into 4 thematic sections**:
  - `foundations/` - Core concepts, commands, skills (01-03)
  - `configuration/` - Settings, CLAUDE.md, hooks (04-06)
  - `context-management/` - Subagents, forked context (07-08)
  - `extensibility/` - MCP, plugins (09-10)
- **Renumbered lessons** for logical flow:
  - Hooks: 07 → 06 (now in configuration)
  - Subagents: 06 → 07 (now in context-management)
  - Forked Context: 10 → 08 (now in context-management)
  - MCP: 08 → 09 (now in extensibility)
  - Plugins: 09 → 10 (now in extensibility)

### Added
- `lessons/README.md` - Learning path overview with thematic navigation
- `lessons/context-management/README.md` - Decision guide for isolation strategies

### Technical Notes
- All cross-references updated to new paths
- Git history preserved via `git mv`
- Reference files updated with new lesson paths

## [2.1.0] - 2025-01-10

### Added
- **Module 10: Forked Context** (`lessons/10-context-fork.md`)
  - Deep dive on `context: fork` frontmatter (Claude Code 2.1.0 feature)
  - Comparison: Main context vs Subagents vs Forked context
  - Decision matrix for choosing isolation strategy
  - 6 production-ready command examples:
    - `/feature` - Feature analysis with forked context
    - `/analyse` - Deep code analysis
    - `/review` - PR review
    - `/impact` - Change impact analysis
    - `/standup` - Session summary
    - `/security-scan` - Security audit
  - 2 skill examples with forked context:
    - `codebase-research` - Pattern discovery skill
    - `prd-validator` - PRD validation skill

### Changed
- **Enhanced `/feature` command** with `context: fork` for cleaner analysis
  - Extensive codebase research without context pollution
  - Added analysis process section
  - Added complexity assessment to output
- **Updated `lessons/03-skills.md`** with "Advanced: Forked Context" section
- **Updated `lessons/06-subagents.md`** with comparison section
- **Updated `reference/skills/examples.md`** with forked context patterns
- **Updated `CLAUDE.md`** with Module 10 reference and context isolation summary

### Technical Notes
- `context: fork` requires Claude Code 2.1.0+
- Fork inherits conversation history (unlike subagents)
- Fork discards execution traces (unlike main context)
- Best for: analysis, review, research that needs history but shouldn't pollute

## [2.0.0] - 2025-01-10

### Changed
- Simplified from 30 directories to ~8
- Single entry point: START_HERE.md
- Flat lesson structure

### Added
- Reference section for skills, subagents, hooks, settings
- Agentic coding section for TAD training
- Changelog table

### Removed
- Gemini CLI, Codex CLI sections (focus on Claude Code)
- Nested directory structure
- Multiple README files
