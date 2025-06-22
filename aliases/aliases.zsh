# ##################
# VIM
# ##################

# use Neovim
alias vim='nvim'

# ##################
# COMMON COMMANDS
# ##################

# Quick Navigation
alias p='cd ~/Projects'
alias ref='cd ~/References'
alias notes='cd ~/Notes'
alias dots='cd ~/dots/'
alias secrets='cd ~/.secrets'
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

alias gls='git worktree list'
alias gA='git add .'
alias ga='git add'
alias gc='git commit -m'
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
alias gwa='git worktree add'
alias gwd='pwd | xargs ~/.config/scripts/git_worktree_remove_current.sh; cd ..'
alias gd='git diff'
alias gdc='git diff --cached'

# ##################
# TMUX
# ##################

alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tls='tmux ls'
