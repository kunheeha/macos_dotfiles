#!/bin/sh
# Claude Code status line
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Directory: show ~ for home prefix
if [ -n "$cwd" ]; then
  dir=$(echo "$cwd" | sed "s|^$HOME|~|")
else
  dir=$(pwd | sed "s|^$HOME|~|")
fi

# Git branch
git_branch=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Format total tokens (input + output)
tokens_str=""
if [ -n "$input_tokens" ] && [ -n "$output_tokens" ]; then
  total=$(( input_tokens + output_tokens ))
  if [ "$total" -ge 1000000 ]; then
    tokens_str=$(printf "%.1fM" "$(echo "$total / 1000000" | bc -l)")
  elif [ "$total" -ge 1000 ]; then
    tokens_str=$(printf "%.1fk" "$(echo "$total / 1000" | bc -l)")
  else
    tokens_str="${total}"
  fi
fi

# Format cost
cost_str=""
if [ -n "$cost" ]; then
  cost_str=$(printf "\$%.2f" "$cost")
fi

# ANSI colors
dim='\033[90m'
white='\033[97m'
reset='\033[0m'

line="${dim}[${reset}${white}${dir}${reset}${dim}]${reset}"

if [ -n "$git_branch" ]; then
  line="${line}${dim}[${reset}${white}${git_branch}${reset}${dim}]${reset}"
fi

if [ -n "$used_pct" ]; then
  line="${line}${dim}[${reset}${white}$(printf "ctx:%.0f%%" "$used_pct")${reset}${dim}]${reset}"
fi

if [ -n "$tokens_str" ]; then
  line="${line}${dim}[${reset}${white}${tokens_str}${reset}${dim}]${reset}"
fi

if [ -n "$cost_str" ]; then
  line="${line}${dim}[${reset}${white}${cost_str}${reset}${dim}]${reset}"
fi

printf "%b\n" "$line"
