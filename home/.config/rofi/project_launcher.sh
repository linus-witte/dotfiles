#!/usr/bin/env bash
set -euo pipefail

PROJECTS_DIR="$HOME/Repositories"

if [[ ! -d "$PROJECTS_DIR" ]]; then
    notify-send "Project launcher" "Directory not found: $PROJECTS_DIR"
    exit 1
fi

PROJECT=$(
    find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' |
        sort |
        rofi -dmenu -i -p "Open Project:"
)

if [[ -z "$PROJECT" ]]; then
    exit 0
fi

PROJECT_PATH="$PROJECTS_DIR/$PROJECT"
SESSION_NAME=$(printf '%s' "$PROJECT" | tr -c '[:alnum:]_-' '_')

kitty -e zsh -lc '
    session_name=$1
    project_path=$2

    if tmux has-session -t "$session_name" 2>/dev/null; then
        exec tmux attach-session -t "$session_name"
    fi

    exec tmux new-session -s "$session_name" -c "$project_path" "nvim .; exec zsh"
' zsh "$SESSION_NAME" "$PROJECT_PATH"
