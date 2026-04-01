#!/bin/bash
# ~/.tmux-sessions.sh

create_session() {
  local session=$1
  shift
  local windows=("$@")

  tmux has-session -t "$session" 2>/dev/null && return

  local first="${windows[0]}"
  local name="${first%%:*}"
  local rest="${first#*:}"
  local dir="${rest%%|*}"

  tmux new-session -d -s "$session" -n "$name" -c "$dir"

  if [ "$rest" != "$dir" ]; then
    local cmd="${rest#*|}"
    tmux send-keys -t "$session:$name" "$cmd" Enter
  fi

  for win in "${windows[@]:1}"; do
    name="${win%%:*}"
    rest="${win#*:}"
    dir="${rest%%|*}"
    tmux new-window -t "$session" -n "$name" -c "$dir"

    if [ "$rest" != "$dir" ]; then
      cmd="${rest#*|}"
      tmux send-keys -t "$session:$name" "$cmd" Enter
    fi
  done

  tmux select-window -t "$session:0"
}

W="$HOME/workspace"

tintim_windows=(
  "docs:$W/work/docs"
  "lambdas:$W/work/tintim-lambdas"
  "locals:$W/work/tintim-locals"
  "alcazar:$W/work/tintim-alcazar"
  "waha:$W/work/waha-code"
)

sre_windows=(
  "shell:$W"
  "infrastructure:$W/work/tintim-infrastructure"
  "fleet:$W/work/tintim-k3s-fleet"
  "gateway:$W/work/tintim-k3s-gateway"
  "custom-exporter:$W/work/tintim-k3s-custom-exporter"
  "operating-k3s:$W/work/operating-k3s"
  "k9s:$W/work|k9s"
)


personal_windows=(
  "shell:$W"
  "daily:$W/writing/notes|nvim daily.md"
  "dotfiles:$W/dotfiles"
)


labs_windows=(
  "shell:$W"
  "lab:$W/labs"
  "server:$W"
  "blog:$W/writing/blog"
  "mental-models:$W/writing/mental-models"
  "linux:$W/projects/linux"
)

labs_windows=(
  "shell:$W"
  "lab:$W/labs"
  "server:$W"
  "blog:$W/writing/blog"
  "mental-models:$W/writing/mental-models"
  "linux:$W/projects/linux"
)


assistant_windows=(
  "a-shell:$W"
)

create_session "tintim" "${tintim_windows[@]}"
create_session "sre" "${sre_windows[@]}"
create_session "personal" "${personal_windows[@]}"
create_session "labs" "${labs_windows[@]}"
create_session "assistant" "${assistant_windows[@]}"
