#!/bin/bash
#
# Git Worktree Branch Reviewer
# Creates a temporary worktree, opens it in Cursor, and cleans up when done.
#
# ============================================================================
# CONFIGURATION - Edit this to change where worktrees are created
# ============================================================================
WORKTREES_DIR="$HOME/git-worktrees"
# ============================================================================

set -e

branch="$1"

if [[ -z "$branch" ]]; then
  echo "Usage: wt.sh <branch>"
  echo "Example: wt.sh feature/my-branch"
  exit 1
fi

# Ensure we're in a git repository
root="$(git rev-parse --show-toplevel)" || {
  echo "Error: Not in a git repository"
  exit 1
}

repo="$(basename "$root")"

# Make a filesystem-safe branch identifier
safe_branch="${branch//\//__}"
token="$(date +%s | tail -c 6)"  # unique suffix

wt_path="$WORKTREES_DIR/$repo-$safe_branch-$token"

# Create worktrees directory if needed
mkdir -p "$WORKTREES_DIR"

# Create the worktree
echo "Creating worktree for branch: $branch"
git worktree add "$wt_path" "$branch"

# Open in Cursor
echo "Opening in Cursor: $wt_path"
cursor "$wt_path"

echo ""
echo "Worktree created: $wt_path"
echo "Monitoring for window close in background..."

# Start background cleanup monitor
# This watches for the Cursor window to close, then removes the worktree
nohup bash -c "
  sleep 5  # Give Cursor time to open

  # Wait until window closes
  while true; do
    still_open=false
    
    # Check if any Cursor window contains our branch identifier
    if pgrep -q 'Cursor'; then
      window_check=\$(osascript -e '
        tell application \"System Events\"
          if exists process \"Cursor\" then
            tell process \"Cursor\"
              set windowNames to {}
              repeat with w in windows
                try
                  set end of windowNames to name of w
                end try
              end repeat
              return windowNames as text
            end tell
          end if
        end tell
      ' 2>/dev/null || echo '')
      
      if echo \"\$window_check\" | grep -q '$safe_branch'; then
        still_open=true
      fi
    fi
    
    if [ \"\$still_open\" = false ]; then
      break
    fi
    
    sleep 2
  done

  # Clean up the worktree
  cd '$root'
  git worktree remove '$wt_path' --force 2>/dev/null || true
  echo 'Worktree cleaned up: $wt_path'
" > /dev/null 2>&1 &

echo "Background cleanup monitor started (PID: $!)"
echo ""
echo "When you close the Cursor window, the worktree will be automatically removed."
