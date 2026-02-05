# Cursor Worktree Skill

A Cursor AI skill that creates temporary Git worktrees for reviewing PRs and branches. Opens in a new Cursor window, cleans up automatically when closed.

## The Problem

You're in the middle of some work, but you want to check out someone else's branch for a PR review. Switching branches means:
- Stashing or committing your work-in-progress
- Losing your mental context
- Potential conflicts when switching back

## The Solution

This skill creates a **temporary Git worktree**, opens it in a **new Cursor window**, and lets you explore the branch completely isolated from your main work.

When you're done and close that Cursor window, the worktree is **automatically cleaned up**.

Multiple worktrees can be open at once — no conflicts with your main branch or other reviews.

## Usage

From any Git repository in Cursor, type in the chat:

```
/git-worktree feature/new-login
```

This will create a worktree, open it in a new Cursor window, and automatically clean up when you close that window.

## Installation

### Quick Install (Recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/haydenfowler/cursor-worktree-skill/master/install-remote.sh)
```

### Clone and Install

```bash
git clone https://github.com/haydenfowler/cursor-worktree-skill.git
cd cursor-worktree-skill
./install.sh
```

### Manual Install

Copy the `git-worktree` folder to your Cursor skills directory:

```bash
cp -r git-worktree ~/.cursor/skills/
chmod +x ~/.cursor/skills/git-worktree/scripts/wt.sh
```

## Features

- **Zero disruption** — Your current work stays exactly as-is
- **Automatic cleanup** — Worktree removed when you close the Cursor window
- **Multiple reviews** — Open as many branches as you need simultaneously
- **Simple invocation** — Just ask Cursor to "review branch X"

## Requirements

- macOS (uses AppleScript for window detection)
- Git
- Cursor IDE with the `cursor` CLI installed

## Troubleshooting

### Worktree wasn't cleaned up

If Cursor crashed or the cleanup didn't run:

```bash
# See orphaned worktrees
git worktree list

# Remove specific worktree
git worktree remove ~/git-worktrees/repo-branch-12345 --force

# Or prune all stale entries
git worktree prune
```

### Branch not found

Make sure the branch exists locally or fetch it first:

```bash
git fetch origin branch-name
```

Then use `origin/branch-name` when invoking the skill.

### "Not in a git repository" error

The skill must be invoked from within a Cursor window that has a Git repository open.

## How It Works

1. **Worktree Creation** — Uses `git worktree add` to create an isolated checkout of the branch
2. **Cursor Launch** — Opens the worktree directory in a new Cursor window
3. **Background Monitor** — A background process uses AppleScript to detect when the Cursor window closes
4. **Cleanup** — When the window closes, `git worktree remove` cleans up the directory

## License

MIT
