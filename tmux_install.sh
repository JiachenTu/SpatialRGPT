#!/usr/bin/env bash

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Launch installation in tmux session
SESSION_NAME="srgpt_install"

# Check if session exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? == 0 ]; then
    echo "Tmux session '$SESSION_NAME' already exists."
    echo "To attach: tmux attach -t $SESSION_NAME"
    echo "To kill and restart: tmux kill-session -t $SESSION_NAME && $0"
    exit 1
fi

echo "Creating tmux session: $SESSION_NAME"
tmux new-session -d -s $SESSION_NAME

echo "Starting installation..."
tmux send-keys -t $SESSION_NAME "cd $SCRIPT_DIR" C-m
tmux send-keys -t $SESSION_NAME "bash install_srgpt.sh" C-m

echo ""
echo "Installation started in tmux session: $SESSION_NAME"
echo ""
echo "To monitor progress:"
echo "  tmux attach -t $SESSION_NAME    # Attach to session (Ctrl+B, then D to detach)"
echo "  tail -f $SCRIPT_DIR/install_srgpt.log"
echo ""
echo "To check if installation is complete:"
echo "  grep 'SUCCESS!' $SCRIPT_DIR/install_srgpt.log"