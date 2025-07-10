#!/bin/bash

arg=${1}

PROJECT_DIR=$(echo $arg | ack -o ".+(?<=\/)")
WORKTREE=$(echo $arg | ack -o "(.(?!\/))+$" | sed 's/\///g')

cd $PROJECT_DIR
git worktree remove $WORKTREE
git branch -d $WORKTREE
