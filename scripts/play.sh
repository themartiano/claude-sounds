#!/bin/sh

# ─── Configuration ───────────────────────────────────────────

# Config file location (follows XDG spec)
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/claude-sounds"
CONFIG_FILE="$CONFIG_DIR/config"

# Load config file if it exists
if [ -f "$CONFIG_FILE" ]; then
  # shellcheck source=/dev/null
  . "$CONFIG_FILE"
fi

# Environment variables override config file, which overrides defaults
SOUNDS="${CLAUDE_SOUNDS_DIR:-${SOUNDS_DIR:-${CLAUDE_PLUGIN_ROOT}/sounds}}"
TIMESTAMP_FILE="${TMPDIR:-/tmp}/claude-sounds-timestamp"
THRESHOLD="${CLAUDE_SOUNDS_THRESHOLD:-${THRESHOLD:-60}}"

# ─── Functions ───────────────────────────────────────────────

log_start() {
  date +%s > "$TIMESTAMP_FILE"
}

get_elapsed() {
  if [ -f "$TIMESTAMP_FILE" ]; then
    START_TIME=$(cat "$TIMESTAMP_FILE")
    NOW=$(date +%s)
    echo $((NOW - START_TIME))
  else
    echo 0
  fi
}

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
      WIN_PATH=$(cygpath -w "$1" 2>/dev/null || echo "$1" | sed 's|/|\\|g')
      powershell.exe -c "Add-Type -AssemblyName PresentationCore; \$p = New-Object System.Windows.Media.MediaPlayer; \$p.Open('$WIN_PATH'); \$p.Play(); Start-Sleep -Seconds 3" &
      ;;
  esac
}

# ─── Main ────────────────────────────────────────────────────

case "$1" in
  start)
    log_start
    ;;
  permission)
    play_sound "$SOUNDS/needs_input.mp3"
    ;;
  mcp)
    play_sound "$SOUNDS/attention.mp3"
    ;;
  complete)
    ELAPSED=$(get_elapsed)
    if [ "$ELAPSED" -ge "$THRESHOLD" ]; then
      play_sound "$SOUNDS/completion.mp3"
    fi
    rm -f "$TIMESTAMP_FILE"
    ;;
esac
