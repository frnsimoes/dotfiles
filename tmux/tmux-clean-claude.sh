#!/bin/bash

tmux list-windows -aF '#S:#W' | grep '\-claude$' | while read win; do
  tmux kill-window -t "$win"
done
