#!/bin/bash
# Watches macOS dark mode and triggers theme-switch.sh automatically.
# Intended to run via launchd (KeepAlive).

LAST=""
while true; do
  CURRENT=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
  if [ "$CURRENT" != "$LAST" ]; then
    if [ "$CURRENT" = "Dark" ]; then
      ~/dots/scripts/theme-switch.sh dark
    else
      ~/dots/scripts/theme-switch.sh light
    fi
    LAST="$CURRENT"
  fi
  sleep 30
done
