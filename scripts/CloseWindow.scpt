tell application "System Events"
  set frontApp to name of first application process whose frontmost is true
end tell

tell application frontApp
  try
    close front window
  end try
end tell
