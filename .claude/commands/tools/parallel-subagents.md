---
description: Launch parallel subagents to accomplish a task
argument-hint: <prompt-request> [count]
allowed-tools: Task, TaskOutput, Read
---

# Parallel Subagents

Launch `COUNT` agents in parallel to accomplish a task specified in `PROMPT_REQUEST`.

## Usage

```
/tools:parallel-subagents "Troubleshoot performance issues in InterestService" 3
```

## Variables

- `$1` (PROMPT_REQUEST): The task description for all agents
- `$2` (COUNT): Number of parallel agents (default: 3)

## Workflow

### 1. Parse Input Parameters

- Extract PROMPT_REQUEST from $1
- Determine COUNT from $2 (or infer from task complexity if not provided)
- Validate that the task benefits from parallelization

### 2. Design Agent Prompts

Create detailed, self-contained prompts for each agent.

**Key requirements:**
- Agents are **stateless** and need complete context
- Include specific instructions on what to accomplish
- Define clear output expectations
- **Avoid overlapping work** between agents

**Example prompt structure:**

```
You are agent [N] of [COUNT] analyzing [DOMAIN].

Your specific focus: [UNIQUE_ASPECT]

## Task
[PROMPT_REQUEST]

## Constraints
- Work independently from other agents
- Return findings in structured format
- Stay within your assigned scope

## Output Format
### Findings
- Finding 1: [description]
- Finding 2: [description]

### Summary
[2-3 sentence conclusion]
```

### 3. Launch Parallel Agents

Use the Task tool to spawn all agents simultaneously in a **single parallel batch**:

```python
# All tasks launched in single message with multiple tool calls
for i in range(COUNT):
    Task(
        description=f"Agent {i+1}: {short_label}",
        prompt=designed_prompts[i],
        subagent_type="Explore",  # or "general-purpose" for complex tasks
        run_in_background=True
    )
```

**Critical**: Launch all agents in the same message to ensure true parallelism.

### 4. Collect & Summarize Results

- Wait for all background tasks to complete
- Use TaskOutput to retrieve each result
- Synthesize findings into cohesive response
- Highlight agreements/disagreements between agents

## When to Use

| Scenario | Agents | Example |
|----------|--------|---------|
| Service troubleshooting | 3-4 | Analyze InterestService across API, business logic, data layers |
| Multi-layer debugging | 3 | Controller → Service → Repository issue tracing |
| Performance investigation | 2-3 | EF Core queries, async patterns, caching gaps |
| Cross-service analysis | 3-5 | Find dependencies between InterestService and AccountService |

## Anti-Patterns

| Avoid | Why | Instead |
|-------|-----|---------|
| Overlapping scopes | Duplicate work wastes resources | Assign distinct domains to each agent |
| No result synthesis | Lose coherence, raw dumps confuse | Always combine findings at the end |
| Too many agents (>5) | Diminishing returns, coordination overhead | Start with 3, increase only if needed |
| Vague prompts | Poor, unfocused results | Be specific about each agent's unique focus |
| Sequential launches | Loses parallelism benefit | Launch all in single tool call batch |

## Model Selection

| Agent Task | Recommended Model | Rationale |
|------------|------------------|-----------|
| Find files/patterns | `haiku` | Fast, cheap, read-only |
| Service layer analysis | `sonnet` | Balance of speed and depth |
| Complex debugging | `opus` | Deep reasoning for tricky async/EF issues |

## Example: Troubleshooting InterestService

```
/tools:parallel-subagents "Investigate slow response times in InterestService" 3
```

**Agent 1 Focus**: API Layer
- Controller endpoints, request validation, response mapping
- Middleware and filters affecting the service
- HTTP client configurations for external calls

**Agent 2 Focus**: Business Logic Layer
- `InterestCalculationService` and related services
- Async/await patterns and potential deadlocks
- Exception handling and retry policies

**Agent 3 Focus**: Data Access Layer
- EF Core queries in `InterestRepository`
- N+1 query detection, missing `Include()` statements
- Connection pooling and transaction scopes

## Related

- [07-subagents](../../../lessons/context-management/07-subagents.md) — Subagent fundamentals
- [patterns](../../../reference/subagents/patterns.md) — Task tool structure
