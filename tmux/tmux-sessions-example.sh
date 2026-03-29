#!/bin/bash
# ~/.tmux-sessions.sh

personal_windows=(
  "shell:~"
  "server:~"
  "mental-models:~/mental-models"
)

work_windows=(
  "shell:~"
  "k9s:~/work"
)

create_session() {
  local session=$1
  shift
  local windows=("$@")

  tmux has-session -t "$session" 2>/dev/null && return

  local first="${windows[0]}"
  local name="${first%%:*}"
  local dir="${first#*:}"

  tmux new-session -d -s "$session" -n "$name" -c "$dir"

  for win in "${windows[@]:1}"; do
    name="${win%%:*}"
    dir="${win#*:}"
    tmux new-window -t "$session" -n "$name" -c "$dir"
  done

  tmux select-window -t "$session:0"
}

create_session "personal" "${personal_windows[@]}"
create_session "work" "${work_windows[@]}"
