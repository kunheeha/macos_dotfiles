# theFuck
eval $(thefuck --alias)

# OPTS
export EDITOR='nvim'
# turn off case sensitive completion
CASE_SENSITIVE='false'
# show hidden files with fzf
export FZF_DEFAULT_COMMAND="find \! \( -path '*\.git' -prune \) -printf '%P\n'"

# Google Cloud SDK (for cbt, bq, etc.)
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# Lazy load pyenv (with auto-load in ~/Projects)
export PYENV_ROOT="$HOME/.PYENV"
export PATH="$PYENV_ROOT/bin:$PATH"

# Reset pyenv loaded flag to ensure proper initialization in new shells/panes
unset _PYENV_LOADED

pyenv() {
  if [[ -z "$_PYENV_LOADED" ]]; then
    unset -f pyenv python pip
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    export _PYENV_LOADED=1
  fi
  pyenv "$@"
}

python() {
  if [[ -z "$_PYENV_LOADED" ]]; then
    unset -f pyenv python pip
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    export _PYENV_LOADED=1
  fi
  command python "$@"
}

pip() {
  if [[ -z "$_PYENV_LOADED" ]]; then
    unset -f pyenv python pip
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    export _PYENV_LOADED=1
  fi
  command pip "$@"
}

# Fast completion init (skip security checks)
autoload -Uz compinit && compinit -C

# PLUGINS
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-vi-mode/zsh-vi-mode.zsh

# Aliases
source ~/.config/aliases/aliases.zsh
source ~/.config/aliases/gcloud_aliases.zsh

# Env Vars
source ~/.config/vars/vars.zsh
source ~/.secrets/gh_secrets.sh

# starship
export STARSHIP_CONFIG=~/.config/starship/current.toml
eval "$(starship init zsh)"

# theme switcher
theme() { ~/dots/scripts/theme-switch.sh "$1"; }

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Created by `pipx` on 2025-06-23 07:39:15
export PATH="$PATH:/Users/kunheeh/.local/bin"
export PATH=/opt/spotify-devex/bin:$PATH

export NVM_DIR="$HOME/.nvm"
# Lazy load nvm
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
# Lazy load node/npm
node() {
  unset -f node
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}
npm() {
  unset -f npm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm "$@"
}
# Load npm when running claude
claude() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  unset -f claude
  claude "$@"
}

# Auto-load pyenv when in ~/Projects directory
_check_projects_dir() {
  if [[ "$PWD" == "$HOME/Projects"* && -z "$_PYENV_LOADED" ]]; then
    unset -f pyenv python pip 2>/dev/null
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    export _PYENV_LOADED=1
  fi
}

# Hook into directory changes
autoload -U add-zsh-hook
add-zsh-hook chpwd _check_projects_dir

# Check on shell startup
_check_projects_dir
