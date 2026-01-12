# Module 04a: Terminal Configuration

> **Optimize your terminal for parallel Claude Code sessions and maximum productivity.**

---

## Why Terminal Configuration Matters

Power users run **multiple Claude Code sessions simultaneously** — sometimes 5+ terminal tabs plus additional sessions on claude.ai/code. Proper terminal configuration lets you:

- Know when any session needs attention (notifications)
- Enter multi-line prompts easily (line breaks)
- Work efficiently with keyboard shortcuts (vim mode)
- Handle large code blocks without issues

```
┌─────────────────────────────────────────────────────────────┐
│              PARALLEL SESSION WORKFLOW                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Terminal Tabs:    [1] [2] [3] [4] [5]                     │
│                      ▲                                       │
│                      │                                       │
│   Each tab = independent Claude Code session                │
│   System notifications tell you which needs attention       │
│                                                              │
│   Plus: claude.ai/code sessions in browser                  │
│   Use --teleport to move sessions between them              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Notification Setup

Never miss when Claude completes a task:

### iTerm2 System Notifications

For macOS users with iTerm2:

1. Open **iTerm2 Preferences** (⌘,)
2. Navigate to **Profiles → Terminal**
3. Enable **"Silence bell"**
4. Under **Filter Alerts**, enable **"Send escape sequence-generated alerts"**
5. Set notification delay based on typical task duration

When Claude finishes a task, you'll get a macOS notification — essential when running multiple sessions.

> **Note**: These notifications are specific to iTerm2 and not available in default macOS Terminal.app.

### Custom Notification Hooks

For advanced cross-terminal notifications, create a hook:

```json
// .claude/settings.json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Task complete\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

See [06-hooks.md](./06-hooks.md) for more hook patterns.

---

## Line Breaks

Multi-line prompts are essential for complex instructions. You have several options:

### Option 1: Quick Escape

Type `\` followed by Enter to create a newline:

```
> Write a function that:\
  - Takes a user ID\
  - Fetches their profile\
  - Returns formatted JSON
```

### Option 2: Shift+Enter (Recommended)

Run `/terminal-setup` within Claude Code to automatically configure Shift+Enter for your terminal.

**Manual setup for iTerm2 or VS Code:**
1. Open Settings → Profiles → Keys
2. Add key mapping for Shift+Enter → Send Escape Sequence `\n`

### Option 3: Option+Enter

**For Mac Terminal.app:**
1. Open Settings → Profiles → Keyboard
2. Check **"Use Option as Meta Key"**

**For iTerm2 and VS Code terminal:**
1. Open Settings → Profiles → Keys
2. Under General, set Left/Right Option key to **"Esc+"**

---

## Handling Large Inputs

When working with extensive code or long instructions:

| Issue | Solution |
|-------|----------|
| Long pasted content truncated | Write to file, ask Claude to read it |
| VS Code terminal limitations | Use iTerm2 or native terminal for large pastes |
| Complex multi-file context | Use `@file` references in prompts |

**File-based workflow example:**
```bash
# Instead of pasting 500 lines of code:
pbpaste > /tmp/code-to-review.ts

# Then in Claude Code:
> Review the code in /tmp/code-to-review.ts
```

---

## Vim Mode

Enable vim keybindings for efficient text editing:

```bash
# Enable during session
/vim

# Or configure permanently
/config
```

### Supported Vim Commands

| Category | Commands |
|----------|----------|
| **Mode switching** | `Esc` (NORMAL), `i`/`I`, `a`/`A`, `o`/`O` (INSERT) |
| **Navigation** | `h`/`j`/`k`/`l`, `w`/`e`/`b`, `0`/`$`/`^`, `gg`/`G` |
| **Editing** | `x`, `dw`/`de`/`db`/`dd`/`D`, `cw`/`ce`/`cb`/`cc`/`C`, `.` (repeat) |

---

## Themes and Appearance

Claude Code inherits your terminal's theme. To match Claude Code's interface to your terminal:

```bash
/config
```

Select theme options that complement your terminal colors.

For additional customization, configure a [custom status line](./04c-statusline.md) to display contextual information like current model, working directory, or git branch.

---

## Recommended Terminal Setup

### For Maximum Productivity

| Setting | Recommendation |
|---------|----------------|
| **Terminal** | iTerm2 (macOS) or Windows Terminal |
| **Notifications** | Enabled for task completion |
| **Line breaks** | Shift+Enter configured |
| **Tabs** | 5+ tabs for parallel sessions |
| **Status line** | Custom script showing model/cost |

### Quick Setup Checklist

- [ ] Run `/terminal-setup` for line break configuration
- [ ] Enable iTerm2 notifications (if using iTerm2)
- [ ] Configure custom status line (see [04c-statusline.md](./04c-statusline.md))
- [ ] Test with 2-3 parallel sessions
- [ ] Optional: Enable vim mode if preferred

---

## Hands-On Exercises

### Exercise 4a.1: Configure Notifications

1. If using iTerm2, enable system notifications per instructions above
2. Start a Claude Code session
3. Give Claude a task that takes 10+ seconds
4. Switch to another app
5. Verify you receive a notification when Claude finishes

### Exercise 4a.2: Multi-Line Prompts

1. Run `/terminal-setup`
2. Test Shift+Enter:
   ```
   > Create a function that:
     [Shift+Enter]
     - Validates email format
     [Shift+Enter]
     - Checks domain exists
     [Shift+Enter]
     - Returns boolean
   ```
3. Verify all lines are sent as one prompt

### Exercise 4a.3: Parallel Sessions

1. Open 3 terminal tabs
2. Start Claude Code in each: `claude`
3. Give each a different task
4. Practice switching between them
5. Note which needs attention via notifications

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **Notifications** | iTerm2 alerts when tasks complete |
| **Line breaks** | Shift+Enter after `/terminal-setup` |
| **Large inputs** | Use file-based workflows |
| **Vim mode** | `/vim` for keyboard efficiency |
| **Parallel sessions** | Run 5+ tabs with notifications |

---

## Next Module

Continue to [04b-model-config.md](./04b-model-config.md) to learn model selection strategies.
