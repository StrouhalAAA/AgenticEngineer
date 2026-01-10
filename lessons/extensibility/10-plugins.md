# Module 09: Plugin System

> **Bundle, share, and distribute Claude Code customizations across your team.**

---

## What Are Plugins?

**Plugins** are shareable packages that bundle commands, agents, skills, hooks, and MCP servers into single installable units. They solve the "works on my machine" problem for Claude Code setups.

```
┌─────────────────────────────────────────────────────────────┐
│                    PLUGIN ARCHITECTURE                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  BEFORE PLUGINS                    AFTER PLUGINS            │
│  ──────────────                    ─────────────            │
│                                                              │
│  Developer A's setup:              Shared plugin:           │
│  ├── .claude/commands/             my-team-tools/           │
│  ├── .claude/agents/               ├── commands/            │
│  ├── .claude/skills/               ├── agents/              │
│  └── .claude/settings.json         ├── skills/              │
│                                    ├── hooks/               │
│  Developer B: "How do I            └── .claude-plugin/      │
│  get your setup?"                       └── plugin.json     │
│                                                              │
│  Developer A: "Uh... copy          Team: /plugin install    │
│  these files... and edit..."            team-tools@internal │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Plugin Components

A plugin can bundle any combination of these extension types:

| Component | Purpose | Location |
|-----------|---------|----------|
| **Commands** | Custom slash commands | `commands/*.md` |
| **Agents** | Specialized subagents | `agents/*.md` |
| **Skills** | Auto-activating knowledge | `skills/*/SKILL.md` |
| **Hooks** | Event handlers | `hooks/hooks.json` |
| **MCP Servers** | External connections | `.mcp.json` |
| **LSP Servers** | Code intelligence | `.lsp.json` |

---

## Plugin Directory Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Required: Plugin manifest
├── commands/                 # Slash commands
│   ├── review.md
│   └── deploy.md
├── agents/                   # Subagent definitions
│   └── security-reviewer.md
├── skills/                   # Agent skills
│   └── migration-patterns/
│       └── SKILL.md
├── hooks/
│   ├── hooks.json           # Hook configuration
│   └── scripts/
│       └── lint-check.sh
├── .mcp.json                # MCP server definitions
└── README.md
```

**Critical Rule**: All component directories MUST be at plugin root level, NOT inside `.claude-plugin/`. Only `plugin.json` goes inside `.claude-plugin/`.

---

## The Plugin Manifest

Every plugin requires a `plugin.json`:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Plugin description for discovery",
  "author": {
    "name": "Your Name"
  },
  "repository": "https://github.com/org/repo",
  "license": "MIT",
  "keywords": ["code-review", "testing", "automation"]
}
```

---

## Installation Scopes

Plugins install at three scopes (precedence order):

```
┌─────────────────────────────────────────────────────────────┐
│                    SCOPE HIERARCHY                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  LOCAL (highest)     .claude/settings.local.json            │
│  ─────────────       Personal overrides, git-ignored        │
│       │              "I need different settings here"       │
│       ▼                                                      │
│  PROJECT             .claude/settings.json                   │
│  ───────             Team-shared, committed to repo          │
│       │              "Everyone on team should have this"     │
│       ▼                                                      │
│  USER (lowest)       ~/.claude/settings.json                 │
│  ────                Personal preferences, all projects      │
│                      "I want this everywhere I work"         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

Install with explicit scope:
```bash
/plugin install my-plugin@marketplace --scope user     # Personal
/plugin install my-plugin@marketplace --scope project  # Team
/plugin install my-plugin@marketplace --scope local    # Override
```

---

## Working with Marketplaces

### Official Marketplace (Built-in)

```bash
# Already available - just browse
/plugin                      # Opens plugin manager
                            # Navigate to Discover tab

# Install from official
/plugin install typescript-lsp@claude-plugins-official
```

### Adding Community Marketplaces

```bash
# Add GitHub marketplace
/plugin marketplace add owner/repo-name

# Add Git URL
/plugin marketplace add https://github.com/org/plugins.git

# List your marketplaces
/plugin marketplace list

# Remove a marketplace
/plugin marketplace remove owner/repo-name
```

### Browsing and Installing

```bash
# Interactive browser
/plugin                      # Tab through: Discover, Installed, Errors

# Direct install
/plugin install plugin-name@marketplace-name

# Install from URL
/plugin install https://github.com/team/my-plugin
```

---

## LSP Plugins (Code Intelligence)

LSP plugins provide IDE-like code intelligence — the same technology that powers VS Code's "Go to Definition", "Find All References", and real-time error detection. **Introduced in v2.0.74.**

```
┌─────────────────────────────────────────────────────────────┐
│              LSP PERFORMANCE COMPARISON                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WITHOUT LSP                       WITH LSP                  │
│  ───────────                       ────────                  │
│                                                              │
│  "Find where this                  "Find where this          │
│   function is defined"              function is defined"     │
│                                                              │
│  Claude: *greps codebase*          Claude: *LSP lookup*      │
│  Time: ~45 seconds                 Time: ~50ms               │
│  Result: May miss cases            Result: Exact match       │
│                                                              │
│  "Find all references"             "Find all references"     │
│  Claude: *reads 100 files*         Claude: *queries server*  │
│  Time: minutes                     Time: milliseconds        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Why this matters**: Before LSP, Claude Code was doing sophisticated grep searches through text patterns. Now it can query language servers directly — the same way you Ctrl+Click in your IDE.

### Step 1: Enable LSP Tools (Required)

```bash
# Add to your shell profile (.bashrc, .zshrc, etc.)
export ENABLE_LSP_TOOLS=1

# Apply the change
source ~/.zshrc  # or restart your terminal
```

### Step 2: Install LSP Plugins

```bash
# TypeScript/JavaScript
/plugin install typescript-lsp@claude-plugins-official
npm install -g @vtsls/language-server typescript

# Python
/plugin install pyright-lsp@claude-plugins-official
pip install pyright

# Rust
/plugin install rust-analyzer-lsp@claude-plugins-official
rustup component add rust-analyzer

# Go
go install golang.org/x/tools/gopls@latest
```

### Step 3: Verify Setup

```bash
# Check plugin is installed
/plugin  # Navigate to "Installed" tab

# Verify binary is in PATH
which pyright  # or vtsls, gopls, etc.

# Test with a prompt
> Find all references to handleSubmit using LSP
```

### LSP Operations

| Operation | What It Does | Use Case |
|-----------|-------------|----------|
| `goToDefinition` | Jump to exact file/line where symbol is defined | Navigating unfamiliar codebases |
| `findReferences` | Find every usage across entire project | Refactoring, impact analysis |
| `hover` | Return type hints, parameters, documentation | Understanding function signatures |
| `documentSymbol` | List all symbols in a file | Quick file overview |
| `workspaceSymbol` | Search symbols project-wide | Finding methods/classes by name |
| `getDiagnostics` | Real-time errors and warnings | Catching errors before runtime |

### When to Use LSP vs. Regular Search

| Use LSP When... | Use Regular Search When... |
|-----------------|---------------------------|
| Large codebases (100s of files) | Small projects, quick scripts |
| Need precise function signatures | Simple "find this string" tasks |
| Refactoring (need to know what breaks) | Grep-style text queries |
| Debugging across multiple files | |

### LSP Prompt Tips

```
# Be explicit when you want LSP
> Find all references to processRequest using LSP
> Where is displayError defined? Use LSP
> What parameters does handleSubmit accept? Use LSP
```

### Current Limitations

1. **No visual indicator** — No status bar showing LSP is running
2. **Binary required separately** — Plugin alone isn't enough
3. **Check PATH** — If "No LSP server available", run `which pyright` to verify

---

## Creating Your Own Plugin

### Step 1: Start with .claude/ Configuration

Build and test locally first:
```bash
mkdir -p .claude/commands
mkdir -p .claude/agents
# Create your commands, agents, skills...
```

### Step 2: Convert to Plugin Structure

```bash
mkdir my-plugin
mkdir my-plugin/.claude-plugin

# Copy components
cp -r .claude/commands my-plugin/
cp -r .claude/agents my-plugin/
cp -r .claude/skills my-plugin/

# Create manifest
cat > my-plugin/.claude-plugin/plugin.json << 'EOF'
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My team's workflow automation"
}
EOF
```

### Step 3: Test Locally

```bash
claude --plugin-dir ./my-plugin
```

### Step 4: Publish

Push to GitHub and share the repo URL, or create a marketplace.

---

## Using ${CLAUDE_PLUGIN_ROOT}

Always use this variable for paths inside your plugin:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "${CLAUDE_PLUGIN_ROOT}/scripts/lint.sh"
      }]
    }]
  }
}
```

**Why?** Plugins install in different locations depending on scope and method. Relative paths break; `${CLAUDE_PLUGIN_ROOT}` always resolves correctly.

---

## Creating a Marketplace

For distributing multiple plugins:

```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json     # Marketplace catalog
└── plugins/
    ├── pr-workflow/
    │   └── .claude-plugin/
    │       └── plugin.json
    └── db-migration/
        └── .claude-plugin/
            └── plugin.json
```

**marketplace.json**:
```json
{
  "name": "my-team-plugins",
  "description": "Internal team tools",
  "plugins": [
    {
      "name": "pr-workflow",
      "path": "./plugins/pr-workflow",
      "description": "PR automation"
    },
    {
      "name": "db-migration",
      "path": "./plugins/db-migration",
      "description": "Database migration tools"
    }
  ]
}
```

---

## Team Standardization Pattern

Share plugins via `.claude/settings.json` in your project template:

```json
{
  "extraKnownMarketplaces": {
    "internal-tools": {
      "source": "github",
      "repo": "your-org/claude-plugins"
    }
  },
  "enabledPlugins": {
    "prd-workflow@internal-tools": true,
    "code-review@internal-tools": true,
    "testing-suite@internal-tools": true
  }
}
```

**Result**: Every `git clone` gives developers identical Claude Code tooling.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Plugin not found" | Check marketplace is added: `/plugin marketplace list` |
| "Executable not found" | Install required binary (see /plugin Errors tab) |
| "Command conflicts" | Plugins use namespaced commands: `/plugin-name:command` |
| "Not loading" | Check plugin.json has valid JSON |
| "Wrong scope" | Reinstall with explicit `--scope` flag |

---

## Hands-On Exercises

### Exercise 9.1: Install Official Plugins

1. Open plugin manager:
   ```
   /plugin
   ```

2. Navigate to Discover tab (press Tab)

3. Install Context7 (real-time documentation):
   ```
   /plugin install context7@claude-plugins-official
   ```

4. Test it:
   ```
   > Explain the latest React useOptimistic hook
   ```

### Exercise 9.2: Install LSP Plugin

1. Install TypeScript LSP:
   ```
   /plugin install typescript-lsp@claude-plugins-official
   ```

2. Install language server:
   ```bash
   npm install -g @vtsls/language-server typescript
   ```

3. Test code intelligence:
   ```
   > Find all references to the handleSubmit function
   ```

### Exercise 9.3: Create Team Plugin

1. Create plugin structure:
   ```bash
   mkdir -p team-tools/.claude-plugin
   mkdir -p team-tools/commands
   ```

2. Create manifest:
   ```bash
   echo '{"name":"team-tools","version":"1.0.0","description":"Our team workflow tools"}' > team-tools/.claude-plugin/plugin.json
   ```

3. Add a command:
   ```bash
   cat > team-tools/commands/standup.md << 'EOF'
   ---
   description: Generate daily standup summary
   ---
   # Standup Summary
   
   Review git commits since yesterday and summarize:
   1. What was completed
   2. What's in progress
   3. Any blockers
   EOF
   ```

4. Test:
   ```bash
   claude --plugin-dir ./team-tools
   /team-tools:standup
   ```

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Plugins** | Shareable bundles of commands, agents, skills, hooks |
| **Manifest** | `plugin.json` in `.claude-plugin/` directory |
| **Scopes** | user → project → local (local wins) |
| **Marketplaces** | Catalogs for discovering plugins |
| **LSP Plugins** | 900x faster code intelligence |
| **${CLAUDE_PLUGIN_ROOT}** | Always use for internal paths |
| **Team sharing** | Commit `settings.json` with `enabledPlugins` |

---

## Team Action Items

### Quick Wins (Do This Week)

- [ ] **Everyone**: Install LSP plugin for your primary language
- [ ] **Everyone**: Install Context7 for documentation lookup
- [ ] **Everyone**: Run `/plugin` to explore available plugins
- [ ] **Tech Lead**: Audit team's scattered `.claude/` configs

### Short-term (Next 2 Weeks)

- [ ] **Tech Lead**: Create internal marketplace repo
- [ ] **Team**: Identify 3-5 common workflows to convert to plugins
- [ ] **Team**: Convert highest-value `.claude/commands/` to plugin format
- [ ] **Tech Lead**: Add marketplace to project template's `settings.json`

### Medium-term (Next Month)

- [ ] **Team**: Build comprehensive team plugin with:
  - [ ] PR review commands
  - [ ] Code standards skill
  - [ ] Pre-commit hooks
  - [ ] Testing workflow commands
- [ ] **Team**: Document plugin usage in team onboarding
- [ ] **Tech Lead**: Set up plugin versioning and changelog process

### Success Metrics

| Metric | Target |
|--------|--------|
| Plugin adoption | 100% of team using shared plugins |
| Setup time | New dev productive in < 30 minutes |
| Workflow consistency | Same commands available across all projects |

---

## Next Steps

Congratulations! You've completed the Claude Code Fundamentals track.

You now understand:
1. ✅ Core concepts and permission model
2. ✅ Custom slash commands
3. ✅ Skills system and progressive disclosure
4. ✅ Settings and configuration hierarchy
5. ✅ CLAUDE.md context engineering
6. ✅ Agents and subagent orchestration
7. ✅ Hooks for automation
8. ✅ MCP for external integrations
9. ✅ Plugins for team standardization

**Continue your journey:**
- Explore advanced patterns in [agentic-coding/](../agentic-coding/)
- Practice with [exercises/](../exercises/)
- Deep dive into [reference/](../reference/) documentation
