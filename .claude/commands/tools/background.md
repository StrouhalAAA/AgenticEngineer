---
description: Launch a Claude Code instance in the background for autonomous work
argument-hint: <prompt> [model] [report-file]
allowed-tools: Bash, BashOutput, Read
---

# Background Claude Code

Spawn an independent Claude Code CLI instance to perform autonomous tasks while you continue working in the foreground.

## Usage

```
/tools:background "Analyze all API endpoints in Backend/InterestService for security issues"
/tools:background "Generate comprehensive test cases for FniService" opus
/tools:background "Document the cart-to-deal flow" sonnet ./reports/cart-flow.md
```

## Variables

- `$1` (PROMPT): The task for the background agent
- `$2` (MODEL): `sonnet` (default), `opus`, or `haiku`
- `$3` (REPORT_FILE): Output path (default: `./agents/background/report-{TIMESTAMP}.md`)

## When to Use

| Scenario | Time Estimate | Example |
|----------|---------------|---------|
| Deep code analysis | 10-30 min | Security audit, architecture review |
| Documentation generation | 5-15 min | API docs, code comments |
| Test case creation | 10-20 min | Edge cases, integration tests |
| Research tasks | 15-45 min | Technology evaluation, pattern analysis |
| Refactoring prep | 10-30 min | Usage mapping, dependency analysis |

## Workflow

### 1. Setup Report Directory

```bash
mkdir -p agents/background
```

### 2. Initialize Variables

Capture timestamp once for consistency across file references:

```bash
TIMESTAMP=$(date +%a_%H_%M_%S)
MODEL="${MODEL:-sonnet}"
REPORT_FILE="${REPORT_FILE:-./agents/background/report-${TIMESTAMP}.md}"
echo "# Background Agent Report - ${TIMESTAMP}" > "${REPORT_FILE}"
```

### 3. Launch Background Agent

Execute using Bash with `run_in_background=true`:

```bash
claude \
  --model "${MODEL}" \
  --output-format text \
  --dangerously-skip-permissions \
  --append-system-prompt "IMPORTANT: You are a background agent. Your PRIMARY responsibility is documenting progress continuously in ${REPORT_FILE}.

## Report Structure

Update this file iteratively as you work:

# Background Agent Report - {TIMESTAMP}

## Task Understanding
State exactly what was requested. Break complex requests into numbered items.

## Progress
Document each major step as you work:
- [Timestamp] Starting task
- [Timestamp] Action taken with tool/command used
- [Timestamp] Finding or observation
- [Timestamp] Next action
(Continue adding entries)

## Results
Concrete outcomes and deliverables:
- Files created/modified with paths
- Metrics and data found
- Specific accomplishments

## Task Completed (or Task Failed)
Final summary with success confirmation or failure explanation.

## Optional Sections
Add as needed:
- Blockers: Issues preventing progress
- Decisions: Important choices and rationale
- Recommendations: Follow-up suggestions
- Warnings: Critical issues to note

## Completion Protocol

When finished:
- Success: Rename to ${REPORT_FILE%.md}.complete.md
- Failed/Blocked: Rename to ${REPORT_FILE%.md}.failed.md

Update the report frequently - it is your primary output." \
  --print "${PROMPT}"
```

### 4. Verify Launch

Use BashOutput to confirm the agent started successfully:
- If successful: Report the agent ID and report file path to user
- If failed: Investigate and report the error

## Response Format

After launching:

```
Background agent launched successfully.

**Agent ID**: bash_{N}
**Model**: {MODEL}
**Report**: {REPORT_FILE}

The agent is writing progress to the report file as it works.
On completion: `{REPORT_FILE%.md}.complete.md`
On failure: `{REPORT_FILE%.md}.failed.md`

Use `/bashes` to monitor status or check the report file directly.
```

## Comparison: Background Tools

| Tool | Use Case | Context |
|------|----------|---------|
| `/tools:background` | Independent CLI instance | Full autonomy, separate process |
| `/tools:parallel-subagents` | Multiple Task-tool agents | Coordinated parallel work |
| `Ctrl+B` on command | Single shell command | Quick processes (npm, docker) |

## Best Practices

| Guideline | Rationale |
|-----------|-----------|
| Use `sonnet` for most tasks | Good balance of speed and capability |
| Use `opus` for complex analysis | Deeper reasoning for architecture/security |
| Use `haiku` for simple searches | Fast and cost-effective |
| Check `/bashes` before ending | Don't leave orphan processes |
| Review `.complete.md` files | Verify work was done correctly |
| Clean up old reports | `agents/background/` can accumulate |

## Security Note

This command uses `--dangerously-skip-permissions` for unattended operation. The background agent can:
- Read/write files
- Execute commands
- Make web requests

Only use for trusted prompts on trusted codebases.

## Related

- [parallel-subagents](parallel-subagents.md) - Coordinated parallel agents
- [background-agents-guide](../../../reference/subagents/background-agents-guide.md) - Team guide
- [background-orchestrator](../../../.claude/agents/background-orchestrator.md) - ACBS orchestrator subagent
