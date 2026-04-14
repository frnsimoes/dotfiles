#!/bin/bash

for session in personal labs logs; do
    bash "$HOME/.config/tmux/tmux-session-manage.sh" start "$session"
done
