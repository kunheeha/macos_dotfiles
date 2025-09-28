# ##################
# VIM
# ##################

# use Neovim
alias vim='nvim'

# ##################
# COMMON COMMANDS
# ##################

# Reload zshrc
alias reload='source ~/.zshrc'

# Quick Navigation
alias p='cd ~/Projects && cd $(find . -maxdepth 1 -type d | sed "s|./||" | grep -v "^\.$" | fzf)'
alias ref='cd ~/References'
alias notes='cd ~/Notes'
alias dots='cd ~/dots/'
alias secrets='cd ~/.secrets'
alias tmp='cd ~/tmp && vim tmp'
alias personal='cd ~/Personal'
# use lsd instead of vanilla ls
alias ls='lsd'
alias la='lsd -a'
alias ll='lsd -la'
alias lt='lsd --tree'
# Changing directory using fzf
alias fd='cd $(find * -type d | fzf)'

# ##################
# GIT
# ##################

alias gA='git add .'
alias ga='git add'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gcp='git cherry-pick'
alias gs='git status'
alias gp='git push origin $(git branch --show-current)'
alias gpf='git push -f origin $(git branch --show-current)'
alias gbd='git branch -d'
alias gbdf='git branch -D'
alias gr='git rebase origin/master'
alias grc='git rebase --continue'
alias gm='git merge'
alias gmc='git merge --continue'
alias gf='git fetch'
alias gd='git diff'
alias gdc='git diff --cached'

# Git Worktree Specific
alias gls='git worktree list'
alias gwa='git worktree add'
alias gwd='pwd | xargs ~/.config/scripts/git_worktree_remove_current.sh; cd ..'
alias gwcheck='pwd | xargs ~/.config/scripts/git_worktree_check_setup.sh'
alias gwfetch='git --git-dir=$(pwd) fetch origin'
alias gwaremote='~/.config/scripts/git_worktree_add_remote_branch.sh'

# ##################
# TMUX
# ##################

alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tls='tmux ls'
