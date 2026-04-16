#!/bin/sh
# Session start — load current work context into the conversation.
# Runs as SessionStart hook. Reads _WorkContext.md, emits as feedback JSON.
# Flags staleness when file not updated in >3 days (matches vault CLAUDE.md contract).

ctx="$HOME/Notes/Claude/_WorkContext.md"
[ -f "$ctx" ] || exit 0

last_updated=$(head -10 "$ctx" | grep '^updated:' | sed 's/updated: *//' | head -1 | tr -d ' ')
today_sec=$(date +%s)
# Strip T-suffix (e.g., 2026-04-16T17:00 -> 2026-04-16) for date parsing
last_date="${last_updated%%T*}"
last_sec=$(date -j -f "%Y-%m-%d" "$last_date" +%s 2>/dev/null || echo "$today_sec")
days_old=$(( (today_sec - last_sec) / 86400 ))

staleness=""
if [ "$days_old" -gt 3 ]; then
    staleness=" — STALE (>3 days old; per vault contract, refresh via calendar/slack/git log before trusting)"
fi

preamble="Session start. Loaded ~/Notes/Claude/_WorkContext.md (last updated: $last_updated, $days_old days ago)$staleness. Use as starting context; read related project/system notes as needed."

head -45 "$ctx" | jq -Rs --arg p "$preamble" '{feedback: ($p + "\n\n" + .)}'
