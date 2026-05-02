#!/bin/bash

for session in personal labs logs sre tintim; do
    bash "$HOME/.config/tmux/tmux-session-manage.sh" start "$session"
done
