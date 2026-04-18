#!/usr/bin/env bash
# init_and_push.sh — one-shot: initialise a git repo and push to github.com/TOTOGT/GTCT
#
# Usage:
#   cd GTCT
#   bash scripts/init_and_push.sh
#
# Assumes you have SSH set up for GitHub. If you prefer HTTPS, change the
# REMOTE line below.

set -euo pipefail

REMOTE="git@github.com:TOTOGT/GTCT.git"
# REMOTE="https://github.com/TOTOGT/GTCT.git"

if [ -d .git ]; then
  echo "✗ A .git directory already exists — aborting. Use 'git remote add origin …' and 'git push' manually."
  exit 1
fi

git init -b main
git add .
git commit -m "Initial commit: GTCT Lean formalization + dm³ numerics + SBM submission"
git remote add origin "$REMOTE"
git push -u origin main
echo "✓ Pushed to $REMOTE"
