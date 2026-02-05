#!/bin/bash
#
# Installer for cursor-worktree-skill
#

set -e

SKILLS_DIR="$HOME/.cursor/skills"
SKILL_NAME="git-worktree"
DEFAULT_WORKTREES_DIR="$HOME/git-worktrees"

echo "Installing cursor-worktree-skill..."
echo ""

# Prompt for worktrees directory
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

# Create skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Check if skill already exists
if [ -d "$SKILLS_DIR/$SKILL_NAME" ]; then
  echo ""
  echo "Skill already exists at $SKILLS_DIR/$SKILL_NAME"
  read -p "Overwrite? (y/N) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
  fi
  rm -rf "$SKILLS_DIR/$SKILL_NAME"
fi

# Copy the skill
cp -r "$SKILL_NAME" "$SKILLS_DIR/"

# Update the worktrees directory in the script
sed -i '' "s|^WORKTREES_DIR=.*|WORKTREES_DIR=\"$WORKTREES_DIR\"|" "$SKILLS_DIR/$SKILL_NAME/scripts/wt.sh"

# Make the script executable
chmod +x "$SKILLS_DIR/$SKILL_NAME/scripts/wt.sh"

echo ""
echo "Installed successfully!"
echo ""
echo "Location: $SKILLS_DIR/$SKILL_NAME"
echo ""
echo "Usage: From any Git repo in Cursor, type in the chat:"
echo "  /git-worktree <branch-name>"
echo ""
echo "Worktrees will be created in: $WORKTREES_DIR"
