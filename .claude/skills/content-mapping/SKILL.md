---
name: content-mapping
description: Repository structure knowledge for content organization and routing. Auto-loads when analyzing where content belongs.
allowed-tools:
  - Read
  - Glob
  - Grep
user-invocable: false
---

# Content Mapping Knowledge

This skill provides embedded knowledge about the Agentic Engineer Playbook repository structure for content routing and organization.

## Content Type Detection Rules

### Lesson Detection

Content is a **lesson** if it:
- Contains learning objectives or "What You'll Learn"
- Has exercises or hands-on sections
- Includes time estimates (e.g., "15 min", "30 minutes")
- References prerequisites
- Follows educational structure (intro → concept → practice → summary)
- Uses pedagogical language ("you will learn", "by the end of this lesson")

**Target location**: `lessons/{section}/NN-topic.md`

### Expert Pattern Detection

Content is an **expert pattern** if it:
- Describes advanced/power-user techniques
- Assumes foundational knowledge
- Focuses on efficiency or optimization
- Contains "when to use" / "when not to use" sections
- Targets experienced Claude Code users

**Target location**: `reference/expert-patterns/{topic}.md`

### Release Notes Detection

Content is **release notes** if it:
- Contains version numbers (vX.X.X format)
- Lists features, fixes, or breaking changes
- Has date references
- Mentions changelogs, updates, or releases
- References Claude Code versions specifically

**Target location**: `learn/claude-code/release-notes/YYYY-MM-DD-vX.X.X.md`

### Reference Doc Detection

Content is a **reference doc** if it:
- Provides quick lookup information
- Contains tables of options/parameters
- Is structured for scanning, not sequential reading
- Focuses on "how to" syntax/usage
- Documents configuration or API details

**Target location**: `reference/{category}/{topic}.md`

### Command Detection

Content is a **command** if it:
- Contains YAML frontmatter with `description` and `allowed-tools`
- Has `$ARGUMENTS` placeholder
- Defines a repeatable workflow
- Follows the command file pattern

**Target location**: `.claude/commands/{tools|workflows|examples}/{name}.md`

### Agent Definition Detection

Content is an **agent definition** if it:
- Has frontmatter with `name`, `description`, `tools`, `model`
- Defines a specialized sub-agent role
- Contains "Purpose" and "Instructions" sections
- Specifies tool restrictions

**Target location**: `.claude/agents/{name}.md`

## Hub File Update Rules

### Visual Schema Updates

The `/visual-schema.md` file contains Mermaid diagrams showing repository structure. Consider updating it when:

- **Adding a new lesson** → Update "Cesta učení" (Learning Path) diagram if it adds a new section
- **Adding a new directory** → Update "Přehled adresářů" (Directory Overview) table
- **Adding a new learning track** → Update "Vyber si svou cestu" (Choose Your Track) table
- **Major structural changes** → Update all relevant diagrams

Update the changelog at the top of `visual-schema.md` with version increment and change description.

### When Adding a Lesson

Update these files in order:

1. **`/visual-schema.md`** (if structural change)
   - Update learning path diagram if new section
   - Increment version in changelog

2. **`/START_HERE.md`**
   - Add row to the appropriate section table (Foundations, Configuration, Context Management, or Extensibility)
   - Table format:
   ```markdown
   | # | Lesson | Time | What You'll Learn |
   |---|--------|------|-------------------|
   | N | [Topic](lessons/{section}/NN-topic.md) | XX min | Brief description |
   ```

2. **`/lessons/README.md`**
   - Add to the section table
   - Update Quick Navigation links

3. **`/lessons/{section}/README.md`** (if exists)
   - Add to the lessons list

### When Adding Release Notes

Update these files:

1. **`/learn/claude-code/release-notes/INDEX.md`**
   - Update "Latest Version" section at top
   - Add row to "Version History" table:
   ```markdown
   | Version | Date | Highlights |
   |---------|------|------------|
   | [X.X.X](./YYYY-MM-DD-vX.X.X.md) | YYYY-MM-DD | Key features |
   ```
   - Add to "Key Features by Version" section if major release

2. **`/CHANGELOG.md`** (optional, for significant releases)
   - Add entry with link to release notes

### When Adding Expert Pattern

Update these files:

1. **`/START_HERE.md`**
   - Add to Expert Patterns table in Track 4

2. **`/reference/expert-patterns/README.md`**
   - Add to Available Patterns table:
   ```markdown
   | Pattern | Description | Prerequisites |
   |---------|-------------|---------------|
   | [Name](pattern-name.md) | Brief description | List of prereqs |
   ```

3. **`/lessons/README.md`**
   - Add to Expert Patterns section if relevant to lessons

4. **`/visual-schema.md`** (if adds new learning track)
   - Consider adding to "Vyber si svou cestu" table
   - Increment changelog version

### When Adding Reference Doc

1. Check if `/reference/{category}/README.md` exists
2. If yes, add to the index
3. If no, consider creating a section index

### When Adding Command

Commands are **auto-discovered** — no hub updates typically needed.

Exception: If the command is user-facing and significant, add to:
- `/CLAUDE.md` Commands section

## Naming Conventions

### Lesson Numbering

```
Current sections and numbers:
- foundations: 01, 02, 03
- configuration: 04, 04a, 04b, 04c, 05, 06
- context-management: 07, 08
- extensibility: 09, 10, 11
```

**Rules:**
- Find highest existing number in target section
- Use next sequential number: `NN-kebab-case-topic.md`
- For sub-topics of existing lesson: `NNa-topic.md`, `NNb-topic.md`
- Never skip numbers in sequence

### Release Notes Naming

Format: `YYYY-MM-DD-vX.X.X.md`
- Use the **release date** (not today's date)
- Include full semver version
- Example: `2026-01-17-v2.1.4.md`

### Reference Doc Naming

- Use `kebab-case.md`
- Match terminology from existing docs
- Avoid redundant prefixes (no "reference-" prefix)
- Examples: `permissions.md`, `parallel-sessions.md`

### Command Naming

- Use `kebab-case.md`
- Descriptive action words
- Examples: `update-codebase.md`, `analyze-product.md`

## Content Validation Checks

Before proposing a location, verify:

1. **No Duplicates**
   ```bash
   Grep for similar titles/topics in target directory
   Check if content overlaps with existing files
   ```

2. **Correct Section**
   - Content matches section's stated purpose
   - Prerequisites align with section level

3. **Numbering Continuity**
   ```bash
   Glob: lessons/{section}/*.md
   Verify no gaps in numbering sequence
   ```

4. **Link Validity**
   - Proposed cross-references will resolve
   - Relative paths are correct

5. **Format Consistency**
   - Follows existing patterns in target location
   - Has required sections (for lessons: objectives, exercises, summary)

## Section Purposes

Use these to classify which section content belongs in:

| Section | Purpose | Content Characteristics |
|---------|---------|------------------------|
| `foundations` | Core concepts for beginners | What Claude Code is, how it works |
| `configuration` | Setup and customization | Settings, terminal, CLAUDE.md, hooks |
| `context-management` | Managing conversation context | Subagents, forked context, memory |
| `extensibility` | Extending Claude Code | MCP, plugins, LSP integration |
| `expert-patterns` | Advanced techniques | Power-user optimizations |
