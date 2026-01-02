# Custom Output Styles Guide

> Quick reference for creating and invoking Claude Code output styles.

---

## What Are Output Styles?

Output styles control **how Claude responds** - verbosity, structure, and formatting. They reduce token usage and enforce consistent output patterns across your team.

**Location:** `.claude/output-styles/<style-name>.md`

---

## Creating a Custom Output Style

### 1. File Structure

```markdown
---
name: <Display Name>
description: <One-line description of when to use this style>
---

# <Style Title>

<Instructions for Claude on how to format responses>

## Response Structure
<Define sections, headers, formatting rules>

## Formatting Rules
<Specific conventions: bullet points, code blocks, emphasis>

## Example Output
<Show Claude what a good response looks like>
```

### 2. Minimal Example

```markdown
---
name: Bullet Summary
description: Concise bullet-point responses for quick scanning
---

# Bullet Summary Style

Respond using only bullet points:
- Maximum 3 levels of nesting
- Each bullet: 1-2 lines max
- No paragraphs, no prose
- Start with summary bullet, then details
```

### 3. Key Sections to Include

| Section | Purpose |
|---------|---------|
| `name` (frontmatter) | Display name in UI/CLI |
| `description` (frontmatter) | When to use this style |
| Response Structure | Define required sections |
| Formatting Rules | Conventions for emphasis, code, lists |
| Example Output | Show the expected format |
| Exceptions | When to deviate from the rules |

---

## Invoking Output Styles

### Method 1: CLI Flag (Per Session)

```bash
# Start Claude Code with specific output style
claude --output-style <style-name>

# Examples from this codebase:
claude --output-style concise-done
claude --output-style verbose-bullet-points
claude --output-style pedagogical-knowledge-transfer
```

### Method 2: In-Session Command

```
/output-style <style-name>
```

### Method 3: Settings Configuration

In `.claude/settings.json` or `.claude/settings.local.json`:

```json
{
  "outputStyle": "pedagogical-knowledge-transfer"
}
```

### Method 4: Combined with Other Flags

```bash
# Output style + model selection + skip permissions
claude --output-style concise-done --model sonnet --dangerously-skip-permissions
```

---

## Output Styles in This Codebase

| Style | File | Use Case |
|-------|------|----------|
| `concise-done` | `concise-done.md` | Minimal output, just "Done." |
| `concise-ultra` | `concise-ultra.md` | Ultra-brief responses |
| `concise-tts` | `concise-tts.md` | Optimized for text-to-speech |
| `verbose-bullet-points` | `verbose-bullet-points.md` | Hierarchical bullet scanning |
| `verbose-yaml-structured` | `verbose-yaml-structured.md` | YAML-formatted responses |
| `pedagogical-knowledge-transfer` | `pedagogical-knowledge-transfer.md` | Teaching/team learning |

---

## Best Practices

### DO:
- **Name clearly** - Style name should indicate its purpose
- **Provide examples** - Claude follows examples better than abstract rules
- **Define exceptions** - When should Claude deviate from the style?
- **Keep focused** - One style = one output pattern

### DON'T:
- Don't mix multiple output philosophies in one style
- Don't make styles too rigid (allow for edge cases)
- Don't forget the `description` - it helps you remember when to use it

---

## Token Impact Reference

| Style Type | Typical Output | Token Savings |
|------------|---------------|---------------|
| Concise (Done) | ~5-10 tokens | 95%+ reduction |
| Concise (Ultra) | ~50 tokens | 80-90% reduction |
| Bullet Points | ~200 tokens | 50-60% reduction |
| YAML Structured | ~300 tokens | 40-50% reduction |
| Pedagogical | ~500+ tokens | Educational (verbose by design) |

> **R&D Framework Note:** Output styles are a **Reduce** technique - they minimize output tokens which compound in your context window over multiple exchanges.

---

## Quick Start Template

Copy this to `.claude/output-styles/<your-style>.md`:

```markdown
---
name: My Custom Style
description: Brief description of when to use this style
---

# My Custom Style

[Core instruction for Claude - what kind of responses to generate]

## Response Structure

[Define the sections every response should have]

## Formatting Rules

- [Rule 1]
- [Rule 2]
- [Rule 3]

## Example

[Show an example of the expected output format]
```

Then invoke with:
```bash
claude --output-style my-custom-style
```
