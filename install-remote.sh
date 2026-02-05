#!/bin/bash
#
# Remote installer for cursor-worktree-skill
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/haydenfowler/cursor-worktree-skill/master/install-remote.sh)
#

set -e

REPO="haydenfowler/cursor-worktree-skill"
BRANCH="master"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"

SKILLS_DIR="$HOME/.cursor/skills"
SKILL_NAME="git-worktree"
SKILL_PATH="$SKILLS_DIR/$SKILL_NAME"
DEFAULT_WORKTREES_DIR="$HOME/git-worktrees"

echo "Installing cursor-worktree-skill..."
echo ""

# Prompt for worktrees directory (read from /dev/tty for curl | bash compatibility)
exec < /dev/tty
printf "Where should worktrees be created? [$DEFAULT_WORKTREES_DIR]: "
read WORKTREES_DIR
WORKTREES_DIR="${WORKTREES_DIR:-$DEFAULT_WORKTREES_DIR}"

# Expand ~ to $HOME if used
WORKTREES_DIR="${WORKTREES_DIR/#\~/$HOME}"

# Create worktrees directory if it doesn't exist
if [ ! -d "$WORKTREES_DIR" ]; then
  echo "Creating directory: $WORKTREES_DIR"
  mkdir -p "$WORKTREES_DIR"
fi

# Create skill directories
mkdir -p "$SKILL_PATH/scripts"

# Download skill files
echo "Downloading skill files..."
curl -fsSL "$BASE_URL/git-worktree/SKILL.md" -o "$SKILL_PATH/SKILL.md"
curl -fsSL "$BASE_URL/git-worktree/scripts/wt.sh" -o "$SKILL_PATH/scripts/wt.sh"

# Update the worktrees directory in the script
sed -i '' "s|^WORKTREES_DIR=.*|WORKTREES_DIR=\"$WORKTREES_DIR\"|" "$SKILL_PATH/scripts/wt.sh"

# Make script executable
chmod +x "$SKILL_PATH/scripts/wt.sh"

echo ""
echo "Installed successfully!"
echo ""
echo "Location: $SKILL_PATH"
echo ""
echo "Usage: From any Git repo in Cursor, type in the chat:"
echo "  /git-worktree <branch-name>"
echo ""
echo "Worktrees will be created in: $WORKTREES_DIR"
