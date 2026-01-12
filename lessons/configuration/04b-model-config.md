# Module 04b: Model Configuration

> **Choose the right model for each task — balance quality, speed, and cost.**

---

## Why Model Selection Matters

Different tasks need different models:

```
┌─────────────────────────────────────────────────────────────┐
│                 MODEL SELECTION STRATEGY                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   OPUS (Most Capable)                                       │
│   • Complex architectural decisions                         │
│   • Security reviews                                        │
│   • Difficult debugging                                     │
│   • Slowest, highest cost                                   │
│                                                              │
│   SONNET (Balanced)                                         │
│   • Daily coding tasks                                      │
│   • Feature implementation                                  │
│   • Code refactoring                                        │
│   • Good balance of speed/quality                           │
│                                                              │
│   HAIKU (Fastest)                                           │
│   • Simple queries                                          │
│   • Documentation                                           │
│   • Code explanations                                       │
│   • Fastest, lowest cost                                    │
│                                                              │
│   OPUSPLAN (Hybrid) ← RECOMMENDED DEFAULT                   │
│   • Opus for planning, Sonnet for execution                 │
│   • Best of both worlds                                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Model Aliases

Claude Code provides convenient aliases so you don't need exact version numbers:

| Alias | Current Model | Best For |
|-------|---------------|----------|
| `default` | Varies by account | General use |
| `sonnet` | Claude Sonnet 4.5 | Daily coding |
| `opus` | Claude Opus 4.5 | Complex reasoning |
| `haiku` | Claude Haiku 4.5 | Simple/fast tasks |
| `sonnet[1m]` | Sonnet + 1M context | Long sessions |
| `opusplan` | Opus→Sonnet hybrid | **Recommended** |

### The `opusplan` Strategy

This is the power-user approach:

1. **Plan Mode** (Shift+Tab twice) → Uses **Opus** for reasoning
2. **Execution Mode** → Automatically switches to **Sonnet**

You get Opus-quality architectural thinking combined with Sonnet's execution efficiency.

```
┌────────────────┐     ┌────────────────┐
│   PLAN MODE    │     │ EXECUTION MODE │
│                │     │                │
│  "Let's think  │────▶│  "Now let's    │
│   through the  │     │   implement    │
│   architecture"│     │   this..."     │
│                │     │                │
│   Uses: OPUS   │     │  Uses: SONNET  │
└────────────────┘     └────────────────┘
```

---

## Setting Your Model

Multiple ways to configure, in order of priority:

### 1. During Session (Highest Priority)

```bash
/model opus
/model sonnet
/model opusplan
```

### 2. At Startup

```bash
claude --model opus
claude --model opusplan
```

### 3. Environment Variable

```bash
export ANTHROPIC_MODEL=opusplan
```

### 4. Settings File (Permanent)

```json
// .claude/settings.json
{
  "model": "opusplan"
}
```

---

## Extended Context: The `[1m]` Suffix

For Console/API users, add `[1m]` to enable **1 million token context**:

```bash
/model sonnet[1m]
```

Or with full model names:

```bash
/model anthropic.claude-sonnet-4-5-20250929-v1:0[1m]
```

**Use cases:**
- Very long coding sessions
- Large codebase analysis
- Multi-file refactoring

**Note**: Extended context has [different pricing](https://docs.claude.com/en/docs/about-claude/pricing#long-context-pricing).

---

## Subagent Model Configuration

Subagents don't need your primary model — they run focused, constrained tasks:

```bash
export CLAUDE_CODE_SUBAGENT_MODEL="claude-sonnet-4-5-20250929"
```

This saves cost when spawning multiple subagents.

### All Model Environment Variables

| Variable | Controls |
|----------|----------|
| `ANTHROPIC_MODEL` | Default model |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Model for `opus` alias |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Model for `sonnet` alias |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Model for `haiku` alias |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Model for subagents |

---

## Checking Your Current Model

### Method 1: Status Line

Configure a [custom status line](./04c-statusline.md) to always show current model.

### Method 2: /status Command

```bash
/status
```

Shows current model plus account information.

---

## Prompt Caching

Claude Code automatically uses prompt caching to reduce costs. You can disable it if needed:

| Variable | Effect |
|----------|--------|
| `DISABLE_PROMPT_CACHING` | Disable for all models |
| `DISABLE_PROMPT_CACHING_HAIKU` | Disable for Haiku only |
| `DISABLE_PROMPT_CACHING_SONNET` | Disable for Sonnet only |
| `DISABLE_PROMPT_CACHING_OPUS` | Disable for Opus only |

Most users should leave caching enabled.

---

## Model Selection Guidelines

Add these to your team's CLAUDE.md:

```markdown
## Model Selection Guidelines

| Task Type | Model | Reason |
|-----------|-------|--------|
| New features, refactoring | `opusplan` | Quality planning + efficient execution |
| Quick fixes, simple tasks | `sonnet` | Fast iteration |
| Complex debugging, security | `opus` | Maximum reasoning |
| Explanations, documentation | `haiku` | Speed, low cost |
| Long sessions | `sonnet[1m]` | Extended context |
```

---

## Cost-Aware Workflows

### Per-Session Model Commands

Create commands for quick model switching:

```markdown
<!-- .claude/commands/model-opus.md -->
Switch to opus for complex reasoning
/model opus
```

```markdown
<!-- .claude/commands/model-fast.md -->
Switch to sonnet for fast iteration
/model sonnet
```

### Track Costs in Status Line

See [04c-statusline.md](./04c-statusline.md) to display session costs.

---

## Hands-On Exercises

### Exercise 4b.1: Set Default Model

1. Add to your `.claude/settings.json`:
   ```json
   {
     "model": "opusplan"
   }
   ```

2. Start Claude Code and verify:
   ```bash
   /status
   ```

### Exercise 4b.2: Test Plan Mode with opusplan

1. Ensure model is `opusplan`
2. Enter Plan Mode: Press **Shift+Tab** twice
3. Ask Claude to plan a feature
4. Exit Plan Mode: Press **Shift+Tab** twice
5. Ask Claude to implement
6. Notice: Planning used Opus, implementation uses Sonnet

### Exercise 4b.3: Mid-Session Model Switching

1. Start with `sonnet`
2. Give Claude a complex debugging task
3. Switch: `/model opus`
4. Continue debugging with enhanced reasoning
5. Switch back: `/model sonnet` for implementation

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **opusplan** | Best default — Opus planning, Sonnet execution |
| **Aliases** | `sonnet`, `opus`, `haiku` — no version numbers needed |
| **[1m] suffix** | 1 million token context for long sessions |
| **Subagent model** | Use `CLAUDE_CODE_SUBAGENT_MODEL` to save costs |
| **Priority** | CLI > settings.local > settings > global > defaults |

---

## Next Module

Continue to [04c-statusline.md](./04c-statusline.md) to create a custom status line.
