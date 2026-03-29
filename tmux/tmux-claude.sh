#!/bin/bash
# ~/.tmux-claude.sh

name=$(tmux display-message -p '#W')

if echo "$name" | grep -q '\-claude$'; then
  exit 0
elif tmux list-windows -F '#W' | grep -q "^${name}-claude$"; then
  tmux select-window -t "${name}-claude"
else
  tmux new-window -n "${name}-claude" -c "$(tmux display-message -p '#{pane_current_path}')"
fi
