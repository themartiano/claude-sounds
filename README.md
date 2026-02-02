# claude-sounds

A Claude Code plugin that plays sounds when Claude is waiting for you.

## Sounds

- **Permission request** - plays when Claude needs approval to run a command
- **Task complete** - plays when a long-running task finishes (60s+ by default)
- **MCP dialog** - plays when an MCP tool requests input

## Install

```sh
claude plugins add themartiano/claude-sounds
```

## Configuration

Copy `config.example` to `~/.config/claude-sounds/config` to customize:

```sh
mkdir -p ~/.config/claude-sounds
cp "$(claude plugins list | grep claude-sounds | awk '{print $2}')/config.example" ~/.config/claude-sounds/config
```

Options:
- `THRESHOLD` - seconds before completion sound plays (default: 60)
- `SOUNDS_DIR` - path to custom sound files

You can also use environment variables: `CLAUDE_SOUNDS_THRESHOLD`, `CLAUDE_SOUNDS_DIR`.

## Custom sounds

Place your own MP3 files in a custom sounds directory:
- `completion.mp3`
- `needs_input.mp3`
- `attention.mp3`

## Platform support

- **macOS** - works out of the box (uses `afplay`)
- **Linux** - requires `mpv`, `paplay`, `aplay`, or `ffplay`
- **Windows** - works via PowerShell (Git Bash/WSL)

## License

MIT
