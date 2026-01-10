---
description: Execute a plan automatically without pausing between phases
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task
model: claude-sonnet-4-20250514
argument-hint: <path-to-plan.md>
---

# Auto-Implement Plan: $ARGUMENTS

## Your Mission

Execute the implementation plan at `$ARGUMENTS` automatically without pausing.

## Execution Protocol

1. **Read** the entire plan at `$ARGUMENTS`
2. **Count** phases and tasks, report summary
3. **Execute** all phases sequentially:
   - Run bash commands
   - Create files with specified content
   - Move/copy files as instructed
   - Run validation commands
4. **Report** progress after each phase (but don't wait)
5. **Summarize** at the end with full results

## Speed Rules

- Do NOT pause between phases
- Do NOT ask for confirmation (except for data loss)
- DO report what you're doing as you go
- DO stop if a critical error occurs

## Error Handling

- Minor errors: Log and continue
- Missing source files: Skip and note
- Permission errors: Stop and report

## Begin

Read `$ARGUMENTS` and execute all phases now.
