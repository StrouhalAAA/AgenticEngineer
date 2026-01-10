---
description: Execute a structured implementation plan phase by phase
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task
model: claude-sonnet-4-20250514
argument-hint: <path-to-plan.md>
---

# Implement Plan: $ARGUMENTS

## Your Mission

Execute the implementation plan at `$ARGUMENTS` systematically, phase by phase.

## Execution Protocol

### Step 1: Read and Understand the Plan

1. Read the entire plan file at `$ARGUMENTS`
2. Identify all phases (look for `## Phase` headers)
3. Count total phases and tasks
4. Report: "Found X phases with Y total tasks"

### Step 2: Execute Each Phase

For each phase:

1. **Announce**: "Starting Phase N: [Phase Name]"
2. **Execute**: Run all tasks in order
   - For bash commands in code blocks: execute them
   - For file creation tasks: create the files with specified content
   - For move/copy tasks: execute the file operations
3. **Validate**: Run any validation commands specified
4. **Report**: "Phase N complete. [summary of what was done]"
5. **Pause**: Ask "Continue to Phase N+1?" before proceeding

### Step 3: Handle Errors

If a task fails:
1. Report the specific error
2. Suggest a fix if possible
3. Ask: "Should I retry, skip this task, or stop?"

### Step 4: Final Report

After all phases complete:
1. Summarize what was accomplished
2. List any skipped or failed tasks
3. Run final validation commands
4. Report: "Implementation complete"

## Execution Rules

**IMPORTANT**: 
- Execute tasks in order within each phase
- Do not skip phases unless instructed
- Create parent directories before creating files
- Validate after each phase before continuing
- Report progress clearly

**ALWAYS**:
- Show what you're about to do before doing it
- Confirm destructive operations (delete, overwrite)
- Create backups of files being replaced if they exist

**NEVER**:
- Execute all phases without pausing
- Skip validation steps
- Ignore errors silently

## Progress Tracking

As you complete each phase, mentally track:
- [ ] Phase 1
- [ ] Phase 2
- [ ] Phase 3
- [ ] ...

Report this checklist status after each phase.

## Begin Execution

Now read the plan at `$ARGUMENTS` and begin with Step 1.
