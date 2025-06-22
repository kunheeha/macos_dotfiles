# theFuck
eval $(thefuck --alias)

# OPTS
export EDITOR='nvim'
# turn off case sensitive completion
CASE_SENSITIVE='false'
# show hidden files with fzf
export FZF_DEFAULT_COMMAND="find \! \( -path '*\.git' -prune \) -printf '%P\n'"

# PLUGIINS
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-vi-mode/zsh-vi-mode.zsh

# Aliases
source ~/.config/aliases/aliases.zsh

# Env Vars
source ~/.config/vars/vars.zsh
source ~/.secrets/gh_secrets.sh

# starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
