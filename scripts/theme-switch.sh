#!/bin/bash
set -euo pipefail

# Ensure tools are on PATH (needed when run from launchd)
export PATH="/opt/homebrew/bin:/usr/local/bin:/Applications/kitty.app/Contents/MacOS:$PATH"

DOTS="$HOME/dots"
MODE="${1:-}"

if [[ "$MODE" != "light" && "$MODE" != "dark" && "$MODE" != "nord" ]]; then
  echo "Usage: theme-switch.sh <light|dark|nord>"
  exit 1
fi

# Persist mode for other scripts (nord is treated as dark for tmux/starship/nvim)
mkdir -p "$HOME/.config/theme"
if [[ "$MODE" == "nord" ]]; then
  echo "dark" > "$HOME/.config/theme/current"
else
  echo "$MODE" > "$HOME/.config/theme/current"
fi

# --- Kitty ---
case "$MODE" in
  dark) KITTY_THEME="rose-pine.conf" ;;
  nord) KITTY_THEME="nord.conf" ;;
  *)    KITTY_THEME="zenbones_light.conf" ;;
esac
# Update symlink for new windows
ln -sf "$KITTY_THEME" "$DOTS/kitty/current-theme.conf"
# Live reload all existing kitty windows
for sock in /tmp/kitty-socket-*; do
  if [[ -S "$sock" ]]; then
    kitty @ --to "unix:$sock" set-colors --all --configured "$DOTS/kitty/$KITTY_THEME" 2>/dev/null || true
  fi
done

# --- Tmux ---
if [[ "$MODE" == "dark" || "$MODE" == "nord" ]]; then
  TMUX_THEME="rose-pine-theme.conf"
else
  TMUX_THEME="zenbones-light-theme.conf"
fi
ln -sf "$TMUX_THEME" "$DOTS/tmux/current-theme.conf"
tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true

# --- Starship ---
if [[ "$MODE" == "dark" || "$MODE" == "nord" ]]; then
  STARSHIP_THEME="starship.toml"
else
  STARSHIP_THEME="starship-zenbones-light.toml"
fi
ln -sf "$STARSHIP_THEME" "$DOTS/starship/current.toml"

# --- Neovim ---
if [[ "$MODE" == "dark" || "$MODE" == "nord" ]]; then
  NVIM_THEME="rose-pine"
else
  NVIM_THEME="zenbones"
fi
# Send to all running nvim instances
while IFS= read -r sock; do
  nvim --server "$sock" --remote-send "<Cmd>lua require('config.colors').set('$NVIM_THEME')<CR>" 2>/dev/null || true
done < <(find /var/folders -path "*/nvim.*/nvim.*" -type s 2>/dev/null)

echo "Switched to $MODE mode"
