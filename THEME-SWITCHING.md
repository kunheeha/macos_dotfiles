# Automatic Theme Switching

Switches all terminal tools between **zenbones-light** and **rose-pine-dark**, either manually or automatically following macOS dark mode.

## How it works

```
macOS Dark Mode (System Settings > Appearance > Auto)
        |
        v
scripts/theme-watcher.sh  (polls every 30s via launchd)
        |
        v
scripts/theme-switch.sh <light|dark>
    |-- kitty    -> set-colors (live) + symlink current-theme.conf (new windows)
    |-- tmux     -> symlink current-theme.conf + source-file (live)
    |-- starship -> symlink current.toml (new shells only)
    |-- nvim     -> remote-send to all running instances (live)
    '-- ~/.config/theme/current  (sentinel file for other tools)
```

### Theme mapping

| Tool     | Light              | Dark            |
|----------|--------------------|-----------------|
| kitty    | zenbones_light.conf| rose-pine.conf  |
| tmux     | zenbones-light-theme.conf | rose-pine-theme.conf |
| starship | starship-zenbones-light.toml | starship.toml |
| nvim     | zenbones           | rose-pine       |

### What reloads live

- **kitty** — yes, via `kitty @ set-colors` over unix socket
- **tmux** — yes, via `tmux source-file`
- **nvim** — yes, via `--remote-send` to all running instances
- **starship** — no, existing shells keep old prompt; new shells pick up the change

## Files in this repo

```
scripts/
    theme-switch.sh              # Main script: switches all tools
    theme-watcher.sh             # Polls macOS dark mode, calls theme-switch.sh
    com.kunheeh.theme-watcher.plist  # launchd agent for theme-watcher.sh

kitty/
    kitty.conf                   # include current-theme.conf (symlink)
    current-theme.conf -> ...    # Symlink to active kitty theme
    zenbones_light.conf          # Light theme colors
    rose-pine.conf               # Dark theme colors

tmux/
    current-theme.conf -> ...    # Symlink to active tmux theme
    zenbones-light-theme.conf    # Light theme
    rose-pine-theme.conf         # Dark theme

starship/
    current.toml -> ...          # Symlink to active starship config
    starship-zenbones-light.toml # Light prompt
    starship.toml                # Dark prompt
```

### Outside this repo

- `~/.config/nvim/lua/config/init.lua` — reads `~/.config/theme/current` on startup to pick the right colorscheme
- `~/.config/theme/current` — sentinel file containing `light` or `dark`

## Setup on a new Mac

### Prerequisites

- kitty, tmux, nvim, and starship are installed (e.g. via Homebrew)
- This repo is cloned to `~/dots`
- Dotfiles are symlinked (`.zshrc`, `.tmux.conf`, `kitty/`, `starship/` etc.)

### 1. Kitty remote control

`kitty.conf` must have these two settings (already set in this repo):

```
allow_remote_control yes
listen_on unix:/tmp/kitty-socket
```

**Restart kitty** after cloning — these settings only take effect on launch, not on config reload.

### 2. Neovim sentinel file

Edit `~/.config/nvim/lua/config/init.lua` so the colorscheme reads from the sentinel file:

```lua
local f = io.open(os.getenv("HOME") .. "/.config/theme/current")
local mode = f and f:read("*l") or "light"
if f then f:close() end
require("config.colors").set(mode == "dark" and "rose-pine" or "zenbones")
```

### 3. Initialize symlinks

Run the script once to create all symlinks and the sentinel file:

```bash
chmod +x ~/dots/scripts/theme-switch.sh ~/dots/scripts/theme-watcher.sh
~/dots/scripts/theme-switch.sh light
```

### 4. Install the launchd agent

```bash
cp ~/dots/scripts/com.kunheeh.theme-watcher.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.kunheeh.theme-watcher.plist
```

### 5. Enable macOS auto appearance

System Settings > Appearance > set to **Auto** (switches at sunset/sunrise).

## Manual usage

Switch from any shell:

```bash
theme light
theme dark
```

This calls `~/dots/scripts/theme-switch.sh` (the `theme` function is defined in `.zshrc`).

## Troubleshooting

**Kitty doesn't live-reload:** Check that the socket exists (`ls /tmp/kitty-socket-*`). If not, restart kitty — `allow_remote_control` and `listen_on` only apply on launch.

**Watcher not running:** Check with `launchctl list | grep theme-watcher`. Logs are at `/tmp/theme-watcher.log`.

**Tmux theme looks wrong:** Make sure the theme files in `tmux/` have the powerline unicode characters. If they look garbled, re-extract from git history.

**Nvim doesn't switch:** The script finds sockets under `/var/folders/`. Check that nvim instances have server sockets: `find /var/folders -path "*/nvim.*/nvim.*" -type s 2>/dev/null`.
