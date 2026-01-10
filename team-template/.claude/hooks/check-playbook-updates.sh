#!/bin/bash
# Check for Agentic Engineer Playbook updates
# Runs once per Claude Code session via SessionStart hook
#
# Setup:
# 1. Set PLAYBOOK_REPO to your playbook's GitHub repo
# 2. Add SessionStart hook to .claude/settings.json
# 3. Add .claude/.playbook-version to .gitignore

# ============================================================
# CONFIGURATION - Update this to your playbook repo
# ============================================================
PLAYBOOK_REPO="your-org/agentic-engineer-playbook"

# ============================================================
# Script logic (no changes needed below)
# ============================================================
CACHE_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/.playbook-version"
CHANGELOG_URL="https://raw.githubusercontent.com/${PLAYBOOK_REPO}/main/CHANGELOG.md"

# Get latest commit SHA (short form)
LATEST=$(curl -sf "https://api.github.com/repos/${PLAYBOOK_REPO}/commits/main" \
  | grep -o '"sha": "[^"]*"' | head -1 | cut -d'"' -f4 | cut -c1-7)

# Network error - fail silently to not block session start
if [ -z "$LATEST" ]; then
  exit 0
fi

# Compare with cached version
CACHED=$(cat "$CACHE_FILE" 2>/dev/null)

if [ "$LATEST" != "$CACHED" ]; then
  # Check if this is a priority update (star marker in changelog table)
  PRIORITY=$(curl -sf "$CHANGELOG_URL" | head -20 | grep -c "⭐")

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ "$PRIORITY" -gt 0 ]; then
    echo "📚 PLAYBOOK UPDATE (⭐ Priority)"
  else
    echo "📚 Playbook Updated"
  fi
  echo "   See: https://github.com/${PLAYBOOK_REPO}/blob/main/CHANGELOG.md"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Update cache
  mkdir -p "$(dirname "$CACHE_FILE")"
  echo "$LATEST" > "$CACHE_FILE"
fi

exit 0
