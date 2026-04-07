#!/bin/bash

count=0
for target in $(tmux list-windows -a -F '#S:#W' | grep '\-shell$'); do
    tmux kill-window -t "$target"
    count=$((count + 1))
done

tmux display "$count shell(s) closed"
