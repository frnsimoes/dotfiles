#!/bin/bash

CONFIG="$HOME/.config/tmux/session-windows.conf"

_list_sessions() {
    grep '^\[' "$CONFIG" | tr -d '[]'
}

_session_windows() {
    local session="$1"
    local in_section=false
    while IFS= read -r line; do
        case "$line" in
            "[$session]") in_section=true ;;
            \[*)          in_section=false ;;
            *)            $in_section && [ -n "$line" ] && printf '%s\n' "$line" ;;
        esac
    done < "$CONFIG"
}

_create_session() {
    local session="$1"
    local first=true

    while IFS= read -r win; do
        [ -z "$win" ] && continue
        local name="${win%%:*}"
        local rest="${win#*:}"
        local path_part="${rest%%|*}"
        local dir="${path_part/#\~/$HOME}"
        local cmd=""
        [ "$rest" != "$path_part" ] && cmd="${rest#*|}"

        if $first; then
            tmux new-session -d -s "$session" -n "$name" -c "$dir"
            first=false
        else
            tmux new-window -t "$session" -n "$name" -c "$dir"
        fi

        [ -n "$cmd" ] && tmux send-keys -t "$session:$name" "$cmd" Enter
    done <<< "$(_session_windows "$session")"

    tmux select-window -t "$session:0"
}

session_start() {
    local session="$1"
    if [ -z "$session" ]; then
        local menu_args=()
        while IFS= read -r name; do
            if tmux has-session -t "$name" 2>/dev/null; then
                menu_args+=("$name (running)" "" "")
            else
                menu_args+=("$name" "" "run-shell \"bash $HOME/.config/tmux/tmux-session-manage.sh start $name\"")
            fi
        done <<< "$(_list_sessions)"
        tmux display-menu -T "Start session" "${menu_args[@]}"
        return
    fi
    if ! grep -qx "\[$session\]" "$CONFIG"; then
        tmux display-message "unknown session: $session"
        return 1
    fi
    if tmux has-session -t "$session" 2>/dev/null; then
        tmux display-message "$session already running"
        return
    fi
    _create_session "$session"
    tmux display-message "$session started"
}

session_stop() {
    local session="$1"
    if [ -z "$session" ]; then
        local menu_args=()
        while IFS= read -r name; do
            if tmux has-session -t "$name" 2>/dev/null; then
                menu_args+=("$name" "" "run-shell \"bash $HOME/.config/tmux/tmux-session-manage.sh stop $name\"")
            else
                menu_args+=("$name (stopped)" "" "")
            fi
        done <<< "$(_list_sessions)"
        tmux display-menu -T "Stop session" "${menu_args[@]}"
        return
    fi
    if tmux has-session -t "$session" 2>/dev/null; then
        tmux kill-session -t "$session"
        tmux display-message "$session stopped"
    else
        tmux display-message "$session not running"
    fi
}

case "$1" in
    start) session_start "$2" ;;
    stop)  session_stop  "$2" ;;
esac
