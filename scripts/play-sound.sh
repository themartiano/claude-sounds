#!/bin/sh
SOUNDS="${CLAUDE_PLUGIN_ROOT}/sounds"
TIMESTAMP_FILE="${TMPDIR:-/tmp}/claude-alert-sounds-timestamp"
THRESHOLD="${ALERT_SOUNDS_THRESHOLD:-60}"

play_sound() {
  case "$(uname -s)" in
    Darwin)
      afplay "$1" &
      ;;
    Linux)
      if command -v mpv >/dev/null 2>&1; then
        mpv --no-terminal "$1" &
      elif command -v paplay >/dev/null 2>&1; then
        paplay "$1" &
      elif command -v aplay >/dev/null 2>&1; then
        aplay "$1" &
      elif command -v ffplay >/dev/null 2>&1; then
        ffplay -nodisp -autoexit "$1" &
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*)
      powershell.exe -c "Add-Type -AssemblyName PresentationCore; \$p = New-Object System.Windows.Media.MediaPlayer; \$p.Open('$1'); \$p.Play(); Start-Sleep -Seconds 3" &
      ;;
  esac
}

case "$1" in
  start)
    date +%s > "$TIMESTAMP_FILE"
    ;;
  permission)
    play_sound "$SOUNDS/needs_input.mp3"
    ;;
  mcp)
    play_sound "$SOUNDS/attention.mp3"
    ;;
  complete)
    if [ -f "$TIMESTAMP_FILE" ]; then
      START_TIME=$(cat "$TIMESTAMP_FILE")
      NOW=$(date +%s)
      ELAPSED=$((NOW - START_TIME))
      if [ "$ELAPSED" -ge "$THRESHOLD" ]; then
        play_sound "$SOUNDS/completion.mp3"
      fi
      rm -f "$TIMESTAMP_FILE"
    fi
    ;;
esac
