#!/bin/bash

name=$(tmux display-message -p '#W')

if echo "$name" | grep -q '\-shell$'; then
  exit 0
elif tmux list-windows -F '#W' | grep -q "^${name}-shell$"; then
  tmux select-window -t "${name}-shell"
else
  tmux new-window -n "${name}-shell" -c "$(tmux display-message -p '#{pane_current_path}')"
fi
