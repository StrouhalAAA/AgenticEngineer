# Background Agents: Team Guide

> **Last Updated:** January 2025
> **Applies to:** Claude Code v2.0.60+
> **Audience:** All team members (PM, Developers, QA)
> **Target Codebase:** ACBS (Aures Core Business Systems) - Automotive CRM Monorepo

---

## What Are Background Agents?

Background agents let you run tasks **in parallel** while continuing other work. Instead of waiting for Claude to finish a long analysis or keeping a dev server in your foreground, you push it to the background and keep moving.

**Two types:**

| Type | What It Is | Example |
|------|-----------|---------|
| **Background Commands** | Long-running shell processes | `npm run dev`, `docker-compose up` |
| **Background Agents** | Full Claude instances doing autonomous work | Codebase exploration, PR review, analysis |

---

## Quick Start (60 Seconds)

### Running a Command in Background
```
1. Claude suggests: npm run dev
2. Press: Ctrl+B (not Enter)
3. Result: "Command running in background with ID: bash_1"
4. Continue: You keep working, server runs independently
```

### Checking Background Tasks
```
/bashes

→ Shows all running/completed background processes
→ Use arrow keys to select
→ Press K to kill
→ Press Enter to view output
```

### Starting a Background Agent
```
You: "In the background, analyze our authentication module
      and document all security patterns used."

Claude: [Spawns background agent]
        "Analysis running in background. I'll notify you when complete.
         What would you like to work on in the meantime?"
```

---

## Use Cases by Role

### Product Manager

| Task | How to Use Background Agents |
|------|------------------------------|
| **Sprint planning research** | "In background: scan InterestService and DealService for all TODOs and FIXMEs" |
| **Technical feasibility** | "In background: investigate how FniService handles financing applications" |
| **Documentation audit** | "In background: find all API endpoints in the sales domain lacking Swagger documentation" |
| **Dependency review** | "In background: check which services depend on EnumerationService" |
| **Impact analysis** | "In background: find all code affected by changing the Customer model in the client schema" |

**Example PM Workflow (ACBS Context):**
```
You: "I need to write a technical spec for the new vehicle buying rules feature.

      In the background:
      1. Map how AuresVehicleBuyingRulesService processes vehicle eligibility
      2. Find all endpoints in StockGuideAdmin that call the rules service
      3. Identify Navision ERP integration points for vehicle data

      While that runs, I'll draft the business requirements section."

[You write requirements]
[Background agents explore Backend/AuresVehicleBuyingRulesService/ and Frontend/StockGuideAdmin/]
[Results ready when you need technical details]
```

---

### Senior Developer / Tech Lead

| Task | How to Use Background Agents |
|------|------------------------------|
| **Code review + coding** | Background: review PR for InterestService changes. Foreground: continue DealService feature |
| **Refactoring prep** | "In background: find all usages of EnumerationService across Backend/ services" |
| **Test monitoring** | "Run NUnit tests for CommissionService in background, alert only on failures" |
| **Multi-service debugging** | Parallel log monitoring: CiscoService, SignalRService, CommunicationCenterService |
| **Architecture mapping** | "In background: map all dependencies between sales domain services (InterestService, DealService, CalendarService)" |

**Example Tech Lead Workflow (ACBS Context):**
```
You: "I'm refactoring the IdentityService auth flow. Set up:
      - Background: run dotnet test Backend/IdentityService/IdentityService.sln continuously
      - Background: monitor Azure AD integration for errors
      - Background: watch Frontend/CRM TypeScript compilation for auth-related issues

      Alert me immediately if LDAPService or GlobalSec tests break."

[You refactor with confidence]
[Instant feedback on auth domain problems]
```

---

### Developer

| Task | How to Use Background Agents |
|------|------------------------------|
| **Dev environment startup** | "Start Frontend/CRM dev server, Backend/InterestService, and Docker SQL Server in background" |
| **Bug investigation** | "In background: find similar appointment state errors in Backend/InterestService/" |
| **Learning codebase** | "In background: explain how the cart-to-deal flow works through InterestService and DealService" |
| **Pre-PR review** | "In background: review my changes to FniService and suggest improvements" |
| **Dependency updates** | "In background: check what breaks in Frontend/CRM if we upgrade from Vue 2 to Vue 3 patterns" |

**Example Developer Workflow (ACBS Context):**
```
You: "Starting work on Azure DevOps task #67340 (callback scheduling failures).

      In background: find all places in Backend/InterestService/ that handle CallBack errors
      In background: show recent commits in DB/interest/PROCEDURE/ related to callbacks

      I'll read the task details with /read-task 67340."

[Context gathering happens automatically]
[You're prepared faster with domain-specific context]
```

---

### QA / Test Engineer

| Task | How to Use Background Agents |
|------|------------------------------|
| **Regression testing** | "Run dotnet test for all sales domain services (InterestService, DealService) in background" |
| **Coverage analysis** | "In background: find all untested code paths in Backend/CommissionService/" |
| **Test data generation** | "In background: generate 1000 realistic InterestBuy and Customer test records" |
| **E2E testing** | "Run Frontend/CRM Cypress tests in background while analyzing failures" |
| **API contract testing** | "In background: compare InterestService Swagger spec with actual controller implementations" |

---

## Commands & Shortcuts Reference

| Action | How |
|--------|-----|
| Run command in background | `Ctrl+B` when Claude suggests a command |
| List all background tasks | `/bashes` |
| View task details | Select in `/bashes` + `Enter` |
| Kill a task | `K` in `/bashes` menu |
| Check agent status | Ask: "What's the status of the background analysis?" |
| View specific output | Ask: "Show output from bash_1" |
| Resume previous agent | Ask: "Resume agent [id] and continue the analysis" |

---

## Team Rules

### ALWAYS Run in Background (Use Ctrl+B)

- `npm run dev` / `npm start` — Dev servers
- `docker-compose up` — Container services
- `npm run test:watch` — Test watchers
- `npm run build` — Production builds (when >30 sec)
- Any command with `--watch` flag
- Log tailing: `tail -f`, `docker logs -f`
- Long-running analysis or exploration tasks

### NEVER Run in Background

- Git commits and pushes (need immediate feedback)
- Database migrations (must see result immediately)
- Quick file operations (<10 seconds)
- Interactive commands requiring your input
- Security-sensitive operations

### Background Agent Guidelines

| Guideline | Reason |
|-----------|--------|
| Use for tasks >2 minutes | Short tasks are faster inline |
| Max 3-5 concurrent agents | More becomes hard to track |
| Check `/bashes` before ending session | Don't leave orphan processes |
| Respond to critical alerts promptly | Background ≠ ignored |
| Document long-running agents | Note agent IDs for resumption |

---

## Workflow Patterns

### Pattern 1: Parallel Research (Communication Domain)
```
You: "I need to understand our communication system. Run in parallel:
      1. How CommunicationCenterService sends SMS via NaviSmsConverterService
      2. How CiscoService and CiscoEventsService handle telephony
      3. How SignalRService stores real-time notifications in commCenter schema

      Summarize findings when all complete."
```

### Pattern 2: Monitor + Work (Multi-Service)
```
You: "Monitor the test environment logs for InterestService and DealService in background.
      Alert me only if you see 500 errors or EF Core exceptions.

      Now let's work on the new appointment scheduling feature..."
```

### Pattern 3: Review + Continue (Domain-Scoped)
```
You: "Review my last 3 commits in Backend/InterestService/ in background, flag any issues.
      I'm going to start on the next ticket in the sales domain."

[15 minutes later]

Claude: "Background review complete. Found 1 issue:
         Potential null reference in AppointmentService.cs line 245.
         Missing Include() for related CallBack entity.
         Want me to show details?"
```

### Pattern 4: Environment Setup (ACBS Stack)
```
You: "Set up my dev environment for working on CRM frontend"

Claude: "Starting services:
         - Frontend/CRM dev server (npm run dev) [bash_1 - background]
         - Backend/InterestService API [bash_2 - background]
         - Backend/EnumerationService [bash_3 - background]
         - SQL Server via Docker [bash_4 - background]

         All starting. What would you like to work on in the CRM?"
```

### Pattern 5: Deep Analysis (Cross-Domain)
```
# Session 1
You: "Analyze all services in the financial domain for security issues"
Claude: "Analyzing CommissionService, ClaimService, FniService..."
Claude: "Analysis complete. Agent ID: financial-audit-abc123"

# Session 2 (next day)
You: "Resume agent financial-audit-abc123 and now audit the commission calculation logic"
Claude: [Continues with full context from financial domain review]
```

---

## Anti-Patterns (Avoid These)

| ❌ Don't | ✅ Do Instead |
|----------|---------------|
| Background everything | Be selective—small tasks run faster inline |
| Run 10+ parallel agents | Max 3-5 concurrent for clarity |
| Forget to check `/bashes` | Always review before ending session |
| Background interactive tasks | Only background autonomous work |
| Ignore critical alerts | Respond to security/error notifications |
| Lose track of agent IDs | Note IDs for tasks you'll resume |

---

## Troubleshooting

### "I can't see my background task"
Run `/bashes` to list all tasks. Tasks are assigned IDs like `bash_1`, `bash_2`, etc.

### "Background task seems stuck"
Ask Claude: "What's the status of bash_1?" or check output in `/bashes`.

### "I need to stop everything"
In `/bashes`, you can kill individual tasks with `K` or ask Claude to "kill all background tasks".

### "I closed Claude Code, are my tasks gone?"
No—background tasks persist across sessions. Run `claude --continue` to resume and check `/bashes`.

### "Background agent finished but I missed the results"
Ask Claude: "Show me the results from the background analysis" or check the agent ID in your session.

---

## CLAUDE.md Snippet

Add this to your project's `CLAUDE.md` for automatic enforcement:

```markdown
## Background Execution Rules

### Always Background (Ctrl+B)
- Frontend dev servers: npm run dev in Frontend/CRM, Frontend/FNI, etc.
- Backend services: dotnet run for any Backend/{ServiceName}/ project
- docker-compose up for SQL Server and RabbitMQ
- Test suites: dotnet test, npm run test:e2e (Cypress)
- Build commands: npm run build, dotnet build (when >30 sec)

### Never Background
- git commit, git push (need immediate feedback)
- Database migrations in DB/{schema}/ (must verify success)
- Azure DevOps task updates (need confirmation)
- Security-sensitive auth operations

### Agent Rules
- Max 3-5 concurrent background agents
- Alert immediately on: EF Core exceptions, auth failures, NUnit test failures
- Document agent IDs for domain-scoped reviews (e.g., "sales-audit-abc123")
- Use /tools:parallel-subagents for multi-layer analysis
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────┐
│  BACKGROUND AGENTS CHEAT SHEET                          │
├─────────────────────────────────────────────────────────┤
│  Start background command     Ctrl+B                    │
│  List background tasks        /bashes                   │
│  Kill a task                  K in /bashes menu         │
│  View task output             Enter in /bashes menu     │
│  Check agent status           "Status of [agent]?"      │
│  Resume previous agent        "Resume agent [id]"       │
├─────────────────────────────────────────────────────────┤
│  ✓ Background: dev servers, watchers, long analysis     │
│  ✗ Foreground: git ops, migrations, quick tasks         │
└─────────────────────────────────────────────────────────┘
```

---

## ACBS-Specific Commands

These commands integrate with the ACBS codebase structure:

| Command | Description |
|---------|-------------|
| `/audit <domain>` | Audit all services in a business domain (customer, vehicle, sales, etc.) |
| `/analyze <product> <layer>` | Analyze specific product layer (e.g., `/analyze CRM frontend`) |
| `/tools:parallel-subagents <task> 3` | Launch parallel agents for multi-layer analysis |
| `/read-task <id>` | Read Azure DevOps task details |

### Domain-to-Service Resolution

When specifying domains, background agents resolve to these paths:

| Domain | Backend Services | Frontend | DB Schemas |
|--------|-----------------|----------|------------|
| sales | InterestService, DealService, CalendarService | CRM, kiosek | interest, Deal |
| vehicle | VehicleService, StockListService, AuresVehicleBuyingRulesService | StockGuideAdmin, CRM | interest, ruleAVB |
| financial | CommissionService, ClaimService, FniService | FNI, new-fni-app | commission, claim, Deal |
| communication | CiscoService, CommunicationCenterService, SignalRService | phones | cisco, commCenter |

---

## Related Resources

- [/tools:background Command](../../.claude/commands/tools/background.md) - Launch standalone background CLI instances
- [/tools:parallel-subagents Command](../../.claude/commands/tools/parallel-subagents.md) - Coordinated parallel Task-tool agents
- [Background Orchestrator Agent](../../.claude/agents/background-orchestrator.md) - Invoke with natural language for automated setup
- [Subagent Patterns](patterns.md) - General subagent design patterns
- [Parallel Sessions](../expert-patterns/parallel-sessions.md) - Running multiple Claude Code sessions
- [ACBS Project Reference](../../agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml) - Full domain/service mapping

---

*Document maintained by: Aures Holdings Development Team*
*Target Codebase: ACBS (Aures Core Business Systems)*
