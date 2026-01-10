# Claude Code Changelog Index

> Summary of tracked Claude Code versions and key changes.

---

## Latest Version

**[2.1.3](./2026-01-10-v2.1.2.md)** — January 10, 2026 (patch)  
**[2.1.2](./2026-01-10-v2.1.2.md)** — January 9, 2026

---

## Version History

| Version | Date | Highlights |
|---------|------|------------|
| [2.1.3](./2026-01-10-v2.1.2.md) | 2026-01-10 | Agent SDK 0.2.3, minor fixes |
| [2.1.2](./2026-01-10-v2.1.2.md) | 2026-01-09 | Output preservation, security fix, plugin control, UX polish |
| [2.1.0](./2026-01-07-v2.1.0.md) | 2026-01-07 | Skills hot-reload, agent-scoped hooks, wildcard permissions, forked context |

---

## Key Features by Version

### 2.1.2 / 2.1.3 (January 9-10, 2026)

**Output Preservation:**
- Large bash outputs saved to disk (no truncation)
- Large tool outputs persisted with file references
- Full context available for SQL queries, build logs, etc.

**Plugin & Agent Control:**
- `FORCE_AUTOUPDATE_PLUGINS` env var for granular update control
- `agent_type` in SessionStart hooks for agent-aware initialization
- Unified `/plugins` view with scope-based grouping

**Developer Experience:**
- Shift+Tab for quick "auto-accept edits" in plan mode
- Image source metadata for context-aware responses
- Clickable file paths (OSC 8) in iTerm, Kitty, WezTerm
- winget support for Windows installations

**Security:**
- 🔴 Command injection vulnerability fixed (upgrade required)
- Memory leak in tree-sitter fixed
- MCP tool names sanitized in analytics

### 2.1.0 (January 7, 2026)

**Skills System:**
- Hot-reload: Skills activate immediately without restart
- `context: fork` for isolated execution
- `agent` field to specify executing agent
- `user-invocable: false` to hide from slash menu
- YAML-style `allowed-tools` lists

**Hooks System:**
- Agent-scoped hooks in frontmatter
- `once: true` for single-execution per session
- Stop hook for completion events

**Permissions:**
- Wildcard Bash patterns: `Bash(npm *)`
- Agent disabling: `Task(AgentName)`
- `--tools` flag for tool restriction

**MCP:**
- `list_changed` notifications for dynamic updates

**Session:**
- `/teleport` for cross-machine resume
- `/remote-env` for remote execution
- Subagents continue after permission denial

---

## Breaking Changes Summary

### 2.1.2
- Windows managed settings path: migrate from `C:\ProgramData\ClaudeCode\` to `C:\Program Files\ClaudeCode\`

### 2.1.0
- SDK requires zod ^4.0.0 (migration: `npx zod-v3-to-v4`)
- Windows managed settings path changed
- Removed `#` shortcut for quick memory entry

---

## Security Advisories

| Version | Issue | Action |
|---------|-------|--------|
| 2.1.2 | Command injection in bash processing | Upgrade immediately |
| 2.1.0 | OAuth/API keys exposed in debug logs | Upgrade immediately |

---

## How to Update This Index

When adding new changelog entries:

1. Create version file: `YYYY-MM-DD-vX.X.X.md`
2. Update "Latest Version" section
3. Add row to Version History table
4. Add key features section
5. Note any breaking changes
6. Add security advisories if applicable

---

## Notable Earlier Features

| Version | Feature | Notes |
|---------|---------|-------|
| 2.0.74 | **Native LSP Support** | IDE-like code intelligence via Language Server Protocol. Enables `goToDefinition`, `findReferences`, `hover`, `documentSymbol`, `workspaceSymbol`. Requires `ENABLE_LSP_TOOLS=1` env var. See [Plugins lesson](../../lessons/extensibility/10-plugins.md) for setup. |

---

## Sources

- [Official Claude Code Changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [npm @anthropic-ai/claude-code](https://www.npmjs.com/package/@anthropic-ai/claude-code)
