# Agentic Engineer - Claude Code Documentation

A comprehensive guide to using Claude Code for agentic software engineering.

## About This Project

This repository contains documentation, tutorials, and best practices for leveraging Claude Code in software development workflows. It includes ready-to-use slash command templates that streamline common development tasks.

## Command Templates

Reusable slash command templates for Claude Code located in `CommandsTemplates/`:

| Command | Description |
|---------|-------------|
| `/prime` | Initialize and understand a codebase - runs `git ls-files` and reads README |
| `/feature` | Create detailed feature implementation plans with user stories, phases, and validation |
| `/bug` | Plan bug fixes with root cause analysis, reproduction steps, and testing strategy |
| `/chore` | Plan maintenance tasks and technical debt resolution |
| `/implement` | Execute a plan from `specs/*.md` and report completed work |
| `/tools` | List all built-in Claude Code development tools |

### How to Use

1. Copy the templates to your project's `.claude/commands/` directory
2. Invoke them with `/command-name` in Claude Code
3. Pass arguments where needed (e.g., `/feature Add dark mode support`)

## Repository Structure

```
.
├── README.md
└── CommandsTemplates/
    ├── prime.md      # Codebase initialization
    ├── feature.md    # Feature planning template
    ├── bug.md        # Bug fix planning template
    ├── chore.md      # Chore/maintenance planning
    ├── implement.md  # Plan execution template
    └── tools.md      # List available tools
```

## Getting Started

1. Clone this repository
2. Copy desired templates to your project's `.claude/commands/` folder
3. Customize the `Relevant Files` sections to match your project structure
4. Start using the commands in Claude Code

## Author

Jakub Strouhal

## License

MIT
