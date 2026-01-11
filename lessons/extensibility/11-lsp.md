# Module 11: Language Server Protocol (LSP)

> **Give Claude Code the same code intelligence your IDE uses — go-to-definition, find references, and real-time diagnostics.**

---

## What is LSP?

**Language Server Protocol** is what powers the smart features in your code editor:

- **Ctrl+Click** to jump to a function definition? That's LSP.
- **Right-click → Find All References**? That's LSP.
- **Red squiggly lines** showing errors before you run code? That's LSP.
- **Autocomplete** with correct parameters? That's LSP.

Microsoft created LSP so that code intelligence could be built once and work everywhere. Your TypeScript language server works in VS Code, Cursor, JetBrains — and now in Claude Code too.

```
┌─────────────────────────────────────────────────────────────┐
│                    BEFORE vs AFTER LSP                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WITHOUT LSP                       WITH LSP                  │
│  ───────────                       ────────                  │
│                                                              │
│  You: "Find where this             You: "Find where this     │
│        function is defined"              function is defined"│
│                                                              │
│  Claude: *greps through files*     Claude: *queries server*  │
│  Claude: *parses text patterns*    Claude: *gets exact loc*  │
│  Claude: *reads 50 files*          Claude: *instant lookup*  │
│                                                              │
│  Time: ~45 seconds                 Time: ~50ms               │
│  Accuracy: May miss edge cases     Accuracy: Exact match     │
│                                                              │
│  ─────────────────────────────────────────────────────────── │
│                                                              │
│  You: "Find all references         You: "Find all references │
│        to handleSubmit"                  to handleSubmit"    │
│                                                              │
│  Claude: *searches file by file*   Claude: *LSP query*       │
│  Time: Minutes (large codebase)    Time: Milliseconds        │
│  Result: Text matches              Result: Actual usages     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Key insight**: Before LSP, Claude was reconstructing semantic understanding from raw text. Now it queries the same language servers that power your IDE — identical to how you navigate code professionally.

---

## Why This Matters

LSP transforms Claude Code from a sophisticated text search engine into a tool that understands your code semantically:

| Capability | Without LSP | With LSP |
|------------|-------------|----------|
| Find definition | Grep + pattern matching | Exact file:line lookup |
| Find references | Read many files | Query all usages instantly |
| Understand types | Guess from context | Read actual signatures |
| Catch errors | Wait for runtime | See immediately after edit |
| Navigate codebase | Sequential file reading | Instant symbol lookup |

**When to use LSP:**
- Large codebases (100+ files)
- Refactoring (need to know what breaks)
- Debugging across multiple files
- Understanding unfamiliar code
- Working with typed languages

**When regular search is fine:**
- Small projects / quick scripts
- Simple "find this string" tasks
- Grep-style text queries

---

## Setup Guide

### Step 1: Enable LSP Tools (Required)

LSP support requires an environment variable. Add this to your shell profile:

```bash
# Add to ~/.zshrc, ~/.bashrc, or equivalent
export ENABLE_LSP_TOOLS=1
```

Apply the change:
```bash
source ~/.zshrc  # or restart your terminal
```

> ⚠️ **Critical**: Without this env var, LSP plugins install but tools won't be available.

### Step 2: Install Plugin + Language Server

The plugin connects Claude Code to the language server. The language server binary does the actual work. **You need both.**

**TypeScript / JavaScript:**
```bash
# Install Claude Code plugin
/plugin install typescript-lsp@claude-plugins-official

# Install language server binary
npm install -g @vtsls/language-server typescript
```

**Python:**
```bash
# Install Claude Code plugin
/plugin install pyright-lsp@claude-plugins-official

# Install language server binary
pip install pyright
```

**Go:**
```bash
# Install language server binary
go install golang.org/x/tools/gopls@latest
```

**Rust:**
```bash
# Install language server binary
rustup component add rust-analyzer
```

### Step 3: Restart Claude Code

After installing plugin and binary:
```bash
claude
```

### Step 4: Verify It's Working

```bash
# Check plugin is installed
/plugin  # Navigate to "Installed" tab

# Verify binary is in PATH
which pyright      # Python
which vtsls        # TypeScript
which gopls        # Go
which rust-analyzer # Rust

# Test with a query
> Find all references to handleSubmit using LSP
```

---

## LSP Operations

Once configured, Claude Code gains access to five powerful operations:

### 1. goToDefinition — Jump to Where Code is Defined

The equivalent of Ctrl+Click (Cmd+Click on Mac) in your IDE.

```
> Where is the processRequest function defined? Use LSP
```

Claude queries the language server and returns the exact file and line number — no scanning through files.

### 2. findReferences — Find All Usages

The killer feature for debugging and refactoring.

```
> Find all references to displayError using LSP
```

Instead of reading dozens of files, Claude queries the language server for every place a function, variable, or class is used.

**Use cases:**
- Refactoring: Know what will break before changing code
- Debugging: Track down where a bug was introduced
- Understanding: See how a function is used across the project

### 3. hover — Get Documentation and Type Info

When you hover over a function in VS Code, you see its signature, parameters, and docs. Claude can do the same.

```
> What parameters does handleSubmit accept? Use LSP
```

Returns:
- Required parameters
- Optional parameters
- Parameter types
- Descriptions and documentation

**Especially powerful** for dynamically typed languages where Claude might otherwise guess incorrectly.

### 4. documentSymbol — List All Symbols in a File

Quick overview of everything in a file — classes, functions, variables.

```
> Show me all symbols in backend/index.js using LSP
```

Returns a structured list of every symbol defined in that file.

### 5. workspaceSymbol — Search Symbols Across the Project

Project-wide search for actual code symbols, not just text.

```
> Find all methods that contain innerHTML
```

Searches function names, class names, constants — not text patterns.

### Bonus: Real-Time Diagnostics

After every edit, the language server reports errors, warnings, and hints back to Claude Code. Claude can:

- See type errors immediately after writing code
- Catch missing imports before you run anything
- Identify issues that would only show up at runtime

---

## Prompt Patterns

LSP tools work best when you're explicit:

```
# Be explicit about using LSP
> Find all references to processRequest using LSP
> Where is displayError defined? Use LSP
> What parameters does handleSubmit accept? Use LSP

# Complex queries
> Using LSP, find where authenticateUser is defined and show me all its callers
> Use LSP to check what type getUserById returns

# Diagnostic queries
> Are there any LSP diagnostics in this file?
> What errors does the language server report?
```

**Tip**: If Claude isn't using LSP when you expect, add "use LSP" to nudge it toward the language server instead of grep.

---

## Supported Languages

Claude Code LSP supports 10+ languages:

| Language | Plugin | Binary | Install Command |
|----------|--------|--------|-----------------|
| TypeScript/JS | `typescript-lsp` | vtsls | `npm install -g @vtsls/language-server typescript` |
| Python | `pyright-lsp` | pyright | `pip install pyright` |
| Go | — | gopls | `go install golang.org/x/tools/gopls@latest` |
| Rust | `rust-analyzer-lsp` | rust-analyzer | `rustup component add rust-analyzer` |
| C/C++ | — | clangd | System package manager |
| Java | — | jdtls | Eclipse JDT Language Server |
| Ruby | — | solargraph | `gem install solargraph` |
| PHP | — | intelephense | `npm install -g intelephense` |

Check `/plugin` discover tab for the latest available LSP plugins.

---

## Configuration

### .lsp.json (Optional)

For custom language server configuration:

```json
{
  "typescript": {
    "command": "vtsls",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescriptreact",
      ".js": "javascript",
      ".jsx": "javascriptreact"
    }
  }
}
```

### Multi-Language Setup

```json
{
  "python": {
    "command": "pyright-langserver",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".py": "python",
      ".pyi": "python"
    }
  },
  "typescript": {
    "command": "vtsls",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescriptreact"
    }
  }
}
```

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "No LSP server available" | Binary not in PATH | Run `which pyright` (or your server) to verify |
| Plugin not loading | Need restart | Restart Claude Code after installation |
| Not using LSP | Falling back to grep | Add "use LSP" explicitly to prompt |
| No visual confirmation | Expected behavior | LSP has no status indicator — verify with test query |
| Wrong results | Server not started | Check `/plugin` Errors tab |
| Slow responses | Large codebase indexing | Wait for initial indexing to complete |

### Debug Checklist

1. ✅ `ENABLE_LSP_TOOLS=1` in shell profile?
2. ✅ Sourced profile or restarted terminal?
3. ✅ Plugin installed? (`/plugin` → Installed tab)
4. ✅ Binary in PATH? (`which <server-name>`)
5. ✅ Restarted Claude Code after setup?
6. ✅ Test query works? ("Find references to X using LSP")

---

## Hands-On Exercises

### Exercise 11.1: Basic LSP Setup

1. Enable LSP tools:
   ```bash
   echo 'export ENABLE_LSP_TOOLS=1' >> ~/.zshrc
   source ~/.zshrc
   ```

2. Install your primary language's LSP plugin

3. Verify setup:
   ```
   /plugin  # Check Installed tab
   ```

4. Test with a real query in your codebase

### Exercise 11.2: Navigation Practice

In a project you're working on:

1. Find where a key function is defined:
   ```
   > Where is [function_name] defined? Use LSP
   ```

2. Find all references to that function:
   ```
   > Find all references to [function_name] using LSP
   ```

3. Get type information:
   ```
   > What parameters does [function_name] accept? Use LSP
   ```

### Exercise 11.3: Refactoring Workflow

1. Pick a function you want to rename
2. Find all references using LSP
3. Review each usage location
4. Make the rename with confidence

Compare the experience to manually grepping through files.

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **What LSP is** | Same code intelligence that powers your IDE |
| **Why it matters** | Semantic understanding vs. text pattern matching |
| **Setup requirement** | `ENABLE_LSP_TOOLS=1` env var (critical!) |
| **Two components** | Plugin (connects) + Binary (does work) |
| **Key operations** | goToDefinition, findReferences, hover, documentSymbol, workspaceSymbol |
| **Prompt pattern** | Add "use LSP" to be explicit |
| **Best for** | Large codebases, refactoring, typed languages |

---

## Team Action Items

### Quick Wins (This Week)

- [ ] **Everyone**: Add `ENABLE_LSP_TOOLS=1` to shell profile
- [ ] **Everyone**: Install LSP plugin for primary language
- [ ] **Everyone**: Verify setup with test query
- [ ] **Tech Lead**: Document LSP setup in team onboarding

### Short-term (Next 2 Weeks)

- [ ] **Team**: Practice LSP operations in daily workflow
- [ ] **Team**: Compare LSP vs grep for "find references" tasks
- [ ] **Tech Lead**: Add LSP verification to new dev checklist

### Success Metrics

| Metric | Target |
|--------|--------|
| LSP adoption | 100% of team with LSP enabled |
| Setup time | < 10 minutes per developer |
| Usage pattern | Team defaults to "use LSP" for navigation |

---

## Next Steps

- Explore [Plugins](./10-plugins.md) for other code intelligence extensions
- Check [reference/plugins/examples.md](../../reference/plugins/examples.md) for advanced LSP configuration
- Practice with larger codebases to see the performance difference

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| LSP introduced | v2.0.74 | Native LSP support added to Claude Code |
