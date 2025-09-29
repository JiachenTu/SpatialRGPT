#!/usr/bin/env bash

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Launch weight download in tmux session
SESSION_NAME="srgpt_weights_download"

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

echo "Starting model weights download..."
tmux send-keys -t $SESSION_NAME "cd $SCRIPT_DIR" C-m
tmux send-keys -t $SESSION_NAME "bash download_weights.sh 2>&1 | tee download_weights.log" C-m

echo ""
echo "Model weights download started in tmux session: $SESSION_NAME"
echo ""
echo "To monitor progress:"
echo "  tmux attach -t $SESSION_NAME    # Attach to session (Ctrl+B, then D to detach)"
echo "  tail -f $SCRIPT_DIR/download_weights.log"
echo ""
echo "Expected total size: ~7GB"
echo "To check download progress:"
echo "  du -sh $SCRIPT_DIR/osdsynth/external/"