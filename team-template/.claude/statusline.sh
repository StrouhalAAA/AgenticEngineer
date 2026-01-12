#!/bin/bash
# Team Status Line Script
# Shows: Model, Directory, Git Branch, Session Cost, Lines Changed
#
# Installation:
#   1. Copy to ~/.claude/statusline.sh (personal) or .claude/statusline.sh (project)
#   2. Make executable: chmod +x statusline.sh
#   3. Add to settings.json:
#      {
#        "statusLine": {
#          "type": "command",
#          "command": "~/.claude/statusline.sh",
#          "padding": 0
#        }
#      }
#
# Requires: jq (brew install jq / apt install jq)

# Read JSON input from Claude Code
input=$(cat)

# Extract values using jq
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // "."')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Get directory basename
DIR_NAME=$(basename "$CURRENT_DIR")

# Check for git branch
GIT_BRANCH=""
if git -C "$CURRENT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git -C "$CURRENT_DIR" branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" $BRANCH"
    fi
fi

# ANSI color codes
ORANGE='\033[38;5;208m'
GREEN='\033[32m'
BLUE='\033[34m'
CYAN='\033[36m'
RED='\033[31m'
RESET='\033[0m'

# Format cost with 4 decimal places
COST_FMT=$(printf "%.4f" "$COST")

# Build output
# Format: [Model] 📁 directory  branch | $0.0000 | +100 -20
printf "${ORANGE}[%s]${RESET} ${BLUE}📁 %s${RESET}${GREEN}%s${RESET} | ${CYAN}\$%s${RESET} | ${GREEN}+%s${RESET} ${RED}-%s${RESET}" \
    "$MODEL" \
    "$DIR_NAME" \
    "$GIT_BRANCH" \
    "$COST_FMT" \
    "$LINES_ADDED" \
    "$LINES_REMOVED"
