#!/bin/sh
# Global last-window: jump to previous window across sessions.
# Subcommands: track (called by hooks), jump (called by key binding).

_get_env() {
    val=$(tmux show-environment -g "$1" 2>/dev/null)
    case "$val" in
        "$1="*) printf '%s' "${val#"$1="}" ;;
        *) printf '' ;;
    esac
}

track() {
    current=$(tmux display-message -p '#S:#I')
    prev=$(_get_env TMUX_CURRENT_WINDOW)

    [ "$current" = "$prev" ] && return

    tmux set-environment -g TMUX_LAST_WINDOW "$prev"
    tmux set-environment -g TMUX_CURRENT_WINDOW "$current"
}

jump() {
    target=$(_get_env TMUX_LAST_WINDOW)

    if [ -z "$target" ]; then
        tmux display-message "no previous window"
        return
    fi

    target_session="${target%%:*}"
    target_window="${target##*:}"

    if ! tmux has-session -t "$target_session" 2>/dev/null; then
        tmux display-message "last window no longer exists"
        tmux set-environment -g TMUX_LAST_WINDOW ""
        return
    fi

    if ! tmux list-windows -t "$target_session" -F '#I' 2>/dev/null | grep -qx "$target_window"; then
        tmux display-message "last window no longer exists"
        tmux set-environment -g TMUX_LAST_WINDOW ""
        return
    fi

    current_session=$(tmux display-message -p '#S')

    if [ "$target_session" = "$current_session" ]; then
        tmux select-window -t "${target_session}:${target_window}"
    else
        tmux switch-client -t "${target_session}:${target_window}"
    fi
}

case "$1" in
    track) track ;;
    jump)  jump  ;;
    *)     printf 'usage: %s track|jump\n' "$0" ;;
esac
