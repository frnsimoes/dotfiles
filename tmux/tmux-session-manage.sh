#!/bin/bash

W="$HOME/workspace"

declare -A SESSION_DEFS

read -r -d '' SESSION_DEFS[tintim] <<WINDOWS
lambdas:$W/work/tintim-lambdas
locals:$W/work/tintim-locals
alcazar:$W/work/tintim-alcazar
waha:$W/work/waha-code
WINDOWS

read -r -d '' SESSION_DEFS[sre] <<WINDOWS
shell:$W
infrastructure:$W/work/tintim-infrastructure
fleet:$W/work/tintim-k3s-fleet
gateway:$W/work/tintim-k3s-gateway
custom-exporter:$W/work/tintim-k3s-custom-exporter
operating-k3s:$W/work/operating-k3s
k9s:$W/work|k9s
docs:$W/work/docs
work-log:$HOME/me/notes|nvim work-log.md
WINDOWS

read -r -d '' SESSION_DEFS[personal] <<WINDOWS
shell:$W
dotfiles:$W/dotfiles
notes:$HOME/me/notes/
personal-log:$HOME/me/notes|nvim personal-log.md
WINDOWS

read -r -d '' SESSION_DEFS[labs] <<WINDOWS
shell:$W
lab:$W/labs
server:$W
blog:$W/writing/blog
mental-models:$W/writing/mental-models
linux:$W/projects/linux
WINDOWS

read -r -d '' SESSION_DEFS[assistant] <<WINDOWS
a-shell:$W
infrastructure:$W/work/tintim-infrastructure
fleet:$W/work/tintim-k3s-fleet
gateway:$W/work/tintim-k3s-gateway
custom-exporter:$W/work/tintim-k3s-custom-exporter
operating-k3s:$W/work/operating-k3s
k9s:$W/work|k9s
WINDOWS

_create_session() {
  local session=$1
  local first=true

  while IFS= read -r win; do
    [ -z "$win" ] && continue
    local name="${win%%:*}"
    local rest="${win#*:}"
    local dir="${rest%%|*}"

    if $first; then
      tmux new-session -d -s "$session" -n "$name" -c "$dir"
      first=false
    else
      tmux new-window -t "$session" -n "$name" -c "$dir"
    fi

    if [ "$rest" != "$dir" ]; then
      local cmd="${rest#*|}"
      tmux send-keys -t "$session:$name" "$cmd" Enter
    fi
  done <<< "$2"

  tmux select-window -t "$session:0"
}

session_start() {
  local session="$1"
  if [ -z "$session" ]; then
    local menu_args=()
    for name in $(printf "%s\n" "${!SESSION_DEFS[@]}" | sort); do
      if tmux has-session -t "$name" 2>/dev/null; then
        menu_args+=("$name (running)" "" "")
      else
        menu_args+=("$name" "" "run-shell \"bash $HOME/.config/tmux/tmux-session-manage.sh start $name\"")
      fi
    done
    tmux display-menu -T "Sessions" "${menu_args[@]}"
    return
  fi
  if [ -z "${SESSION_DEFS[$session]+x}" ]; then
    tmux display "unknown session: $session"
    return 1
  fi
  if tmux has-session -t "$session" 2>/dev/null; then
    tmux display "$session already running"
    return
  fi
  _create_session "$session" "${SESSION_DEFS[$session]}"
  tmux display "$session started"
}

session_stop() {
  local session="$1"
  if [ -z "$session" ]; then
    local menu_args=()
    for name in $(printf "%s\n" "${!SESSION_DEFS[@]}" | sort); do
      if tmux has-session -t "$name" 2>/dev/null; then
        menu_args+=("$name" "" "run-shell \"bash $HOME/.config/tmux/tmux-session-manage.sh stop $name\"")
      else
        menu_args+=("$name (stopped)" "" "")
      fi
    done
    tmux display-menu -T "Stop session" "${menu_args[@]}"
    return
  fi
  if tmux has-session -t "$session" 2>/dev/null; then
    tmux kill-session -t "$session"
    tmux display "$session stopped"
  else
    tmux display "$session not running"
  fi
}

if [ -n "$1" ]; then
  case "$1" in
    start) session_start "$2" ;;
    stop)  session_stop "$2" ;;
  esac
fi
