#!/bin/bash

action="${1:-start}"

if [ "$action" = "start" ]; then
    if tmux has-session 2>/dev/null && tmux list-windows -a -F '#W' | grep -q '^hugo$'; then
        tmux display "hugo already running"
        exit 0
    fi
    tmux new-window -d -n hugo -c "$HOME/workspace/writing/blog" "hugo server -D"
    tmux display "hugo started"
elif [ "$action" = "stop" ]; then
    if tmux has-session 2>/dev/null && tmux list-windows -a -F '#W' | grep -q '^hugo$'; then
        tmux kill-window -t :hugo
        tmux display "hugo stopped"
    else
        tmux display "hugo not running"
    fi
fi
