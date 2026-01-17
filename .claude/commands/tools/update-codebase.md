---
description: Analyze content and update repository structure intelligently
argument-hint: <prompt | URL | file-path> [--dry-run]
context: fork
allowed-tools: Read, Grep, Glob, WebFetch, Task
---

# Update Codebase

> Intelligently add new content to the repository with proper organization.

## Why Forked Context?

This command uses `context: fork` because:
- Analysis may read many files to understand current structure
- Only the clean plan returns to your main context
- Keeps main context lean for subsequent commands

## Input

```
$ARGUMENTS
```

## Workflow

### Step 1: Detect Input Type

Analyze the input to determine its type:

| Pattern | Type | Action |
|---------|------|--------|
| Starts with `http://` or `https://` | URL | Use WebFetch to retrieve |
| Ends with `.md` or contains `/` path | File path | Use Read to load |
| Contains `--dry-run` | Flag | Preview mode only |
| Otherwise | User prompt | Use as content description |

### Step 2: Fetch Content (if needed)

**For URLs:**
```
WebFetch the URL and extract the main content.
Summarize what was found.
```

**For File Paths:**
```
Read the file content.
Analyze its structure and purpose.
```

**For Prompts:**
```
Use the prompt as a description of what content should be added.
May need to ask clarifying questions.
```

### Step 3: Load Repository Context

Read the key hub files to understand current state:

```
@README.md
@START_HERE.md
@lessons/README.md
@learn/claude-code/release-notes/INDEX.md
```

Use Glob to find existing content patterns:
- `lessons/**/*.md` - existing lessons
- `reference/**/*.md` - existing reference docs
- `learn/claude-code/release-notes/*.md` - existing release notes

### Step 4: Invoke Codebase Curator Agent

Delegate to the `codebase-curator` agent:

```
Task(subagent: codebase-curator)

Analyze this content and determine where it belongs in the Agentic Engineer Playbook:

[CONTENT OR DESCRIPTION]

Source type: [URL | file | prompt]
Source: [original source]

Provide:
1. Content classification with confidence level
2. Target file location with rationale
3. All hub files requiring updates
4. Step-by-step execution plan
```

### Step 5: Present Results

Display the curator's analysis in a clear format:

```markdown
## Content Analysis

**Detected Type**: [type]
**Topic**: [subject]
**Source**: [URL | file | prompt]
**Confidence**: [High | Medium | Low]

## Proposed Location

📁 `[full file path]`

**Rationale**: [why this location]

## Hub Files to Update

| File | Change |
|------|--------|
| `path/to/hub.md` | [what changes] |

## Execution Plan

1. [ ] [Step 1]
2. [ ] [Step 2]
3. [ ] [Step 3]
```

### Step 6: Handle Execution

**If `--dry-run` was specified:**
```
---
**DRY RUN** - No changes made. Remove --dry-run to execute.
```

**Otherwise, ask for confirmation:**
```
---
Ready to execute? Confirm to proceed with the updates.
```

**If confirmed:**
- Execute each step in the plan
- Report success/failure for each
- Provide summary of all changes made

## Examples

### Add Release Notes from URL

```bash
/update-codebase https://github.com/anthropics/claude-code/releases/tag/v2.1.4
```

### Add New Lesson (Preview Only)

```bash
/update-codebase "New lesson about debugging Claude Code sessions" --dry-run
```

### Process Local Markdown File

```bash
/update-codebase /path/to/new-expert-pattern.md
```

### Describe What to Add

```bash
/update-codebase "Add expert pattern about managing context budget across long sessions"
```

## Error Handling

**If content type is ambiguous:**
- Ask clarifying questions before proposing location
- Suggest most likely classification with alternatives

**If duplicate content detected:**
- Report the existing similar content
- Ask if user wants to update existing or create new

**If hub file format is unexpected:**
- Report the issue
- Suggest manual intervention

## Related

- [codebase-curator agent](.claude/agents/codebase-curator.md)
- [Lesson 05: CLAUDE.md](lessons/configuration/05-claude-md.md) — Repository conventions
- [Lean Memory Pattern](reference/expert-patterns/lean-memory.md) — Why we keep CLAUDE.md small
