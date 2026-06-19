#!/usr/bin/env bash
#
# install.sh — install the gated multi-agent development workflow into a repo (or user scope).
#
# Usage:
#   ./install.sh [TARGET_DIR]      # install into TARGET_DIR/.claude (defaults to current dir)
#   ./install.sh --user            # install into ~/.claude (available in every project)
#
# Examples:
#   ./install.sh /Users/zaman.chaudhary/ulmo-edly-saas
#   ./install.sh                   # installs into the repo you're standing in
#   ./install.sh --user            # personal, global to all your projects
#
set -euo pipefail

# Directory this script lives in (so it works no matter where it's run from).
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${1:-}" == "--user" ]]; then
  CLAUDE_DIR="$HOME/.claude"
  SCOPE="user (global)"
  PUT_CLAUDE_MD=false   # don't clobber a global CLAUDE.md; print a snippet instead
else
  TARGET_DIR="${1:-$(pwd)}"
  if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: target directory does not exist: $TARGET_DIR" >&2
    exit 1
  fi
  CLAUDE_DIR="$TARGET_DIR/.claude"
  SCOPE="project: $TARGET_DIR"
  PUT_CLAUDE_MD=true
fi

echo "Installing workflow into: $CLAUDE_DIR"
echo "Scope: $SCOPE"
echo

mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/commands"
cp -v "$SRC_DIR/agents/"*.md     "$CLAUDE_DIR/agents/"
cp -v "$SRC_DIR/commands/"*.md   "$CLAUDE_DIR/commands/"

# Handle CLAUDE.md (project scope only): never overwrite an existing one.
if [[ "$PUT_CLAUDE_MD" == true ]]; then
  ROOT="$(dirname "$CLAUDE_DIR")"
  if [[ -f "$ROOT/CLAUDE.md" ]]; then
    cp -v "$SRC_DIR/CLAUDE.md" "$ROOT/CLAUDE.workflow.md"
    echo
    echo "NOTE: $ROOT/CLAUDE.md already exists — I did NOT overwrite it."
    echo "      The workflow rules were saved to $ROOT/CLAUDE.workflow.md."
    echo "      Merge them into your existing CLAUDE.md when ready."
  else
    cp -v "$SRC_DIR/CLAUDE.md" "$ROOT/CLAUDE.md"
  fi
else
  echo
  echo "NOTE: user scope — the always-on rules in CLAUDE.md were NOT installed globally."
  echo "      If you want them, copy this file's contents into ~/.claude/CLAUDE.md yourself:"
  echo "      $SRC_DIR/CLAUDE.md"
fi

echo
echo "Done. Installed:"
echo "  7 subagents  -> $CLAUDE_DIR/agents/"
echo "  5 commands   -> $CLAUDE_DIR/commands/"
echo
echo "Next steps:"
echo "  1) Restart Claude Code (or run /agents) so the new subagents are picked up."
echo "  2) Run /agents to confirm the 7 agents are listed."
echo "  3) Start a task:  /workflow <paste your Jira ticket or requirement>"
