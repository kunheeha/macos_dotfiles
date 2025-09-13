# theFuck
eval $(thefuck --alias)

# OPTS
export EDITOR='nvim'
# turn off case sensitive completion
CASE_SENSITIVE='false'
# show hidden files with fzf
export FZF_DEFAULT_COMMAND="find \! \( -path '*\.git' -prune \) -printf '%P\n'"

# Lazy load pyenv
export PYENV_ROOT="$HOME/.PYENV"
export PATH="$PYENV_ROOT/bin:$PATH"
pyenv() {
  unset -f pyenv python pip
  eval "$(command pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  pyenv "$@"
}
python() {
  unset -f pyenv python pip
  eval "$(command pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  python "$@"
}
pip() {
  unset -f pyenv python pip
  eval "$(command pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
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

# Lazy load SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
sdk() {
  unset -f sdk
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
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

# Claude-Code
export CLAUDE_CODE_USE_VERTEX=1
export ANTHROPIC_SMALL_FAST_MODEL='claude-3-5-haiku@20241022'
export CLOUD_ML_REGION='europe-west1'
export VERTEX_REGION_CLAUDE_4_0_OPUS='europe-west4'
export ANTHROPIC_VERTEX_PROJECT_ID='spotify-claude-code-trial'
