# theFuck
eval $(thefuck --alias)

# OPTS
export EDITOR='nvim'
# turn off case sensitive completion
CASE_SENSITIVE='false'
# show hidden files with fzf
export FZF_DEFAULT_COMMAND="find \! \( -path '*\.git' -prune \) -printf '%P\n'"

# Lazy load pyenv (with auto-load in ~/Projects)
export PYENV_ROOT="$HOME/.PYENV"
export PATH="$PYENV_ROOT/bin:$PATH"

_load_pyenv() {
  if [[ -z "$_PYENV_LOADED" ]]; then
    eval "$(command pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export _PYENV_LOADED=1
  fi
}

pyenv() {
  _load_pyenv
  unset -f pyenv python pip
  pyenv "$@"
}
python() {
  _load_pyenv
  unset -f python pip
  python "$@"
}
pip() {
  _load_pyenv
  unset -f pip
  pip "$@"
}

# Fast completion init (skip security checks)
autoload -Uz compinit && compinit -C

# PLUGINS
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-vi-mode/zsh-vi-mode.zsh

# Aliases
source ~/.config/aliases/aliases.zsh
source ~/.config/aliases/ssh_aliases.sh

# Env Vars
source ~/.config/vars/vars.zsh
source ~/.secrets/gh_secrets.sh

# starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Lazy load SDKMAN (with auto-load in ~/Projects)
export SDKMAN_DIR="$HOME/.sdkman"

_load_sdkman() {
  if [[ -z "$_SDKMAN_LOADED" && -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    export _SDKMAN_LOADED=1
  fi
}

sdk() {
  _load_sdkman
  unset -f sdk
  sdk "$@"
}

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

# Auto-load pyenv and SDKMAN when in ~/Projects directory
_check_projects_dir() {
  if [[ "$PWD" == "$HOME/Projects"* ]]; then
    _load_pyenv
    _load_sdkman
  fi
}

# Hook into directory changes
autoload -U add-zsh-hook
add-zsh-hook chpwd _check_projects_dir

# Check on shell startup
_check_projects_dir

# Claude-Code
export CLAUDE_CODE_USE_VERTEX=1
export ANTHROPIC_SMALL_FAST_MODEL='claude-3-5-haiku@20241022'
export CLOUD_ML_REGION='europe-west1'
export VERTEX_REGION_CLAUDE_4_1_OPUS='europe-west4'
export ANTHROPIC_VERTEX_PROJECT_ID='spotify-claude-code-trial'
