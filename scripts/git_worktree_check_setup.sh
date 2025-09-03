#!/bin/bash

repo_dir=${1}
cd $repo_dir

if [[ $(git rev-parse --is-bare-repository 2>/dev/null) != "true" ]]; then
  echo "Not a bare git repo"
  exit 1
fi

if ! git config list | grep -q "remote.origin.fetch=+refs/heads/\*:refs/remotes/origin/\*"; then
  echo "Setting remote.origin.fetch configuration..."
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
else
  echo "Correct remote fetch config exists"
fi
