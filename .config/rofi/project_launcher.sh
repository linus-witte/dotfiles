#!/bin/bash

# Get the list of directories
PROJECTS_DIR=~/Repositories
PROJECT=$(ls -d $PROJECTS_DIR/*/ | sed 's|/$||' | xargs -n 1 basename | rofi -dmenu -i -p "Open Project:")

# Check if a project was selected
if [ -n "$PROJECT" ]; then
    # Name the tmux session after the project
    SESSION_NAME=$(echo "$PROJECT" | tr ' ' '_')

    # Open Kitty and either attach to existing tmux session or create a new one
    kitty -e zsh -c "tmux attach-session -t $SESSION_NAME || tmux new-session -s $SESSION_NAME -c $PROJECTS_DIR/$PROJECT 'nvim .; exec zsh'"
fi
