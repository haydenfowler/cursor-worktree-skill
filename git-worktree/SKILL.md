---
name: git-worktree
description: Create temporary Git worktrees for reviewing branches and PRs without disrupting current work. Opens the branch in a new Cursor window and automatically cleans up when closed. Use when the user wants to review a PR, check out someone's branch, or open a branch in a separate window.
---

# Git Worktree for Branch Review

Create temporary worktrees to review branches without disrupting your current work. Opens the branch in a new Cursor window and automatically cleans up when that window closes.

## Prerequisites

- Must be run from within a Git repository
- The branch must exist (local or remote)

## Usage

When the user wants to review a branch, run the worktree script:

```bash
bash ~/.cursor/skills/git-worktree/scripts/wt.sh <branch-name>
```

**Examples:**
- `bash ~/.cursor/skills/git-worktree/scripts/wt.sh feature/new-login`
- `bash ~/.cursor/skills/git-worktree/scripts/wt.sh origin/fix/bug-123`

## What Happens

1. Creates a worktree in the configured directory (default: `~/git-worktrees`)
2. Opens the worktree in a new Cursor window
3. Starts a background monitor that watches for the window to close
4. When you close that Cursor window, the worktree is automatically removed

## Configuration

To change the worktrees directory, edit the `WORKTREES_DIR` variable at the top of:

```
~/.cursor/skills/git-worktree/scripts/wt.sh
```

## Managing Worktrees

**List active worktrees:**
```bash
git worktree list
```

**Manually remove a worktree:**
```bash
git worktree remove <path> --force
```

**Clean up all worktrees from the skill:**
```bash
rm -rf ~/git-worktrees && git worktree prune
```

## Troubleshooting

If a worktree wasn't cleaned up (e.g., Cursor crashed):
1. Run `git worktree list` to see orphaned worktrees
2. Run `git worktree remove <path> --force` to remove them
3. Or run `git worktree prune` to clean up stale entries
