# Module 09: MCP Integration

> **Connect Claude Code to external tools and services via Model Context Protocol.**

> 🆕 **Updated for Claude Code 2.1.0** — Includes `list_changed` notifications for dynamic tool updates.

---

## What Is MCP?

**Model Context Protocol (MCP)** is a standard for connecting AI assistants to external tools. Think of it as USB for AI — a universal way to plug in capabilities.

```
┌─────────────────────────────────────────────────────────────┐
│                 MCP ARCHITECTURE                             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│                    ┌─────────────────┐                      │
│                    │   Claude Code   │                      │
│                    └────────┬────────┘                      │
│                             │                                │
│                      MCP Protocol                            │
│                             │                                │
│         ┌───────────────────┼───────────────────┐           │
│         ▼                   ▼                   ▼            │
│   ┌──────────┐       ┌──────────┐       ┌──────────┐        │
│   │  GitHub  │       │ Database │       │  Notion  │        │
│   │  Server  │       │  Server  │       │  Server  │        │
│   └──────────┘       └──────────┘       └──────────┘        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Why Use MCP?

### Without MCP

```
You: "Create a GitHub issue for this bug"
Claude: "I can't directly interact with GitHub.
        Here's the curl command..."
You: *manually runs command*
```

### With MCP

```
You: "Create a GitHub issue for this bug"
Claude: *calls GitHub MCP server*
        "Done! Created issue #123"
```

---

## Configuration

MCP servers are configured in `.mcp.json` at project root:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "./src"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

---

## Common MCP Servers

| Server | Purpose | Package |
|--------|---------|---------|
| GitHub | Git hosting | `@modelcontextprotocol/server-github` |
| Filesystem | File access | `@modelcontextprotocol/server-filesystem` |
| PostgreSQL | Database | `@modelcontextprotocol/server-postgres` |
| SQLite | Database | `@modelcontextprotocol/server-sqlite` |
| Slack | Messaging | `@modelcontextprotocol/server-slack` |
| Notion | Documentation | `@notionhq/mcp-server` |
| Puppeteer | Browser | `@modelcontextprotocol/server-puppeteer` |

---

## Environment Variables

Three ways to provide variables:

**1. Shell environment:**
```bash
export GITHUB_TOKEN="ghp_xxxx"
claude
```

**2. In .mcp.json:**
```json
{
  "env": {
    "TOKEN": "${MY_TOKEN}",
    "URL": "${API_URL:-localhost}"  // With default
  }
}
```

**3. .env file** (with direnv)

---

## Transport Types

### STDIO (Default)

Server runs as subprocess:
```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "@package/server"]
    }
  }
}
```

### HTTP

Server runs as HTTP service:
```json
{
  "mcpServers": {
    "remote": {
      "type": "http",
      "url": "https://mcp.service.com/api"
    }
  }
}
```

---

## New in 2.1.0: Dynamic Tool Updates

MCP servers can now notify Claude Code when their available tools, prompts, or resources change. This enables dynamic capability updates without session restart.

### Server-Side Implementation

```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";

const server = new Server(
  { name: 'dynamic-tools', version: '1.0.0' },
  {
    capabilities: {
      tools: { listChanged: true },
      prompts: { listChanged: true },
      resources: { listChanged: true }
    }
  }
);

// When tools change (e.g., new database table discovered):
await server.notification({
  method: 'notifications/tools/list_changed',
  params: {}
});

// Claude Code automatically refreshes available capabilities
```

### Use Cases

**Dynamic Database Tools:**
```typescript
// Schema watcher detects new table
schemaWatcher.on('tableAdded', async (tableName) => {
  // Generate new query tool for the table
  addQueryTool(tableName);
  
  // Notify Claude Code
  await server.notification({
    method: 'notifications/tools/list_changed',
    params: {}
  });
});
```

**Feature-Flag Controlled Tools:**
```typescript
featureFlags.on('change', async (flags) => {
  if (flags.experimentalFeatures) {
    enableExperimentalTools();
  } else {
    disableExperimentalTools();
  }
  
  await server.notification({
    method: 'notifications/tools/list_changed',
    params: {}
  });
});
```

**Permission-Based Tool Visibility:**
```typescript
// User role changes, update available tools
userSession.on('roleChange', async (newRole) => {
  updateToolsForRole(newRole);
  
  await server.notification({
    method: 'notifications/tools/list_changed',
    params: {}
  });
});
```

---

## Security Best Practices

1. **Use fine-grained tokens** with minimal scopes
2. **Use read-only connections** when possible
3. **Limit filesystem access** to specific directories
4. **Never commit secrets** to git

```gitignore
# .gitignore
.env
.env.*
```

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Server not found | Package not installed | `npx -y @package/server` |
| Auth failed | Invalid token | Regenerate token |
| Connection timeout | Network/firewall | Check connectivity |
| Permission denied | Insufficient scopes | Update token |

---

## Hands-On Exercises

### Exercise 8.1: GitHub MCP Setup

1. Create GitHub token with repo access

2. Set environment:
   ```bash
   export GITHUB_TOKEN="ghp_xxxx"
   ```

3. Create `.mcp.json`:
   ```json
   {
     "mcpServers": {
       "github": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-github"],
         "env": {
           "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
         }
       }
     }
   }
   ```

4. Test:
   ```
   > List my GitHub repositories
   ```

### Exercise 8.2: Filesystem MCP

1. Configure filesystem server for `./docs`:
   ```json
   {
     "mcpServers": {
       "files": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-filesystem", "./docs"]
       }
     }
   }
   ```

2. Test:
   ```
   > Use the filesystem server to list files in docs
   ```

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **MCP** | Standard protocol for AI-tool connections |
| **Servers** | Bridge between Claude and external services |
| **Configuration** | `.mcp.json` at project root |
| **Environment** | Use `${VAR}` for secrets |
| **Transport** | STDIO (local) or HTTP (remote) |
| **Security** | Minimal permissions, never commit secrets |
| **list_changed** | Dynamic tool updates without reconnection (2.1.0+) |

---

---

## Next Module

Continue to [10-plugins.md](./10-plugins.md) to learn how to bundle and share your Claude Code setup with your team.
