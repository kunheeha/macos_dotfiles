#!/bin/bash

branch_name=${1}

if [[ -z "$branch_name" ]]; then
  echo "Branch name required"
  exit 1
fi

if [[ $(git rev-parse --is-bare-repository 2>/dev/null) != "true" ]]; then
  echo "Not a bare git repo"
  exit 1
fi

git --git-dir=$(pwd) branch --track $branch_name origin/$branch_name

git worktree add $branch_name

cd $branch_name
