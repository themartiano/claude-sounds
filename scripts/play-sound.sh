#!/bin/sh
SOUNDS="${CLAUDE_PLUGIN_ROOT}/sounds"

# Select sound file based on event type
case "$1" in
  permission) SOUND="$SOUNDS/needs_input.mp3" ;;
  mcp)        SOUND="$SOUNDS/attention.mp3" ;;
  complete)   SOUND="$SOUNDS/completion.mp3" ;;
  *)          exit 0 ;;
esac

# Play sound using platform-appropriate player
case "$(uname -s)" in
  Darwin)
    afplay "$SOUND" &
    ;;
  Linux)
    if command -v mpv >/dev/null 2>&1; then
      mpv --no-terminal "$SOUND" &
    elif command -v paplay >/dev/null 2>&1; then
      paplay "$SOUND" &
    elif command -v aplay >/dev/null 2>&1; then
      aplay "$SOUND" &
    elif command -v ffplay >/dev/null 2>&1; then
      ffplay -nodisp -autoexit "$SOUND" &
    fi
    ;;
  MINGW*|MSYS*|CYGWIN*)
    powershell.exe -c "Add-Type -AssemblyName PresentationCore; \$p = New-Object System.Windows.Media.MediaPlayer; \$p.Open('$SOUND'); \$p.Play(); Start-Sleep -Seconds 3" &
    ;;
esac
