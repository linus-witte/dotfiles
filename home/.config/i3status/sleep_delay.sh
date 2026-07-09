#!/usr/bin/env bash
set -euo pipefail

state_base="${XDG_RUNTIME_DIR:-}"
if [[ -z "$state_base" || ! -d "$state_base" || ! -w "$state_base" ]]; then
    state_base="${XDG_CACHE_HOME:-$HOME/.cache}/i3status"
fi
state_dir="$state_base/sleep-delay"
pid_file="$state_dir/pid"
until_file="$state_dir/until"
legacy_prompt_lock_dir="$state_dir/prompt.lock"
why="i3-sleep-delay"

usage() {
    cat <<EOF
Usage: ${0##*/} [status|prompt [minutes]|clear|help]

Commands:
  status            Print i3bar JSON only while sleep inhibition is active.
  prompt [minutes]  Enable sleep inhibition for minutes, or prompt on a TTY.
  clear             Clear the active sleep inhibition.
  help              Show this help.
EOF
}

is_delay_pid() {
    local pid="$1"

    [[ "$pid" =~ ^[0-9]+$ ]] || return 1
    [[ -r "/proc/$pid/cmdline" ]] || return 1
    tr '\0' ' ' < "/proc/$pid/cmdline" | grep -F -- "$why" >/dev/null 2>&1
}

clear_delay() {
    local pid

    if [[ -r "$pid_file" ]]; then
        read -r pid < "$pid_file" || true
        if is_delay_pid "${pid:-}"; then
            kill "$pid" >/dev/null 2>&1 || true
        fi
    fi

    rm -f "$pid_file" "$until_file"
    rmdir "$legacy_prompt_lock_dir" 2>/dev/null || true
}

remaining_seconds() {
    local now until pid

    [[ -r "$until_file" && -r "$pid_file" ]] || return 1
    read -r until < "$until_file" || return 1
    read -r pid < "$pid_file" || return 1
    [[ "$until" =~ ^[0-9]+$ ]] || return 1

    now=$(date +%s)
    if (( now >= until )) || ! is_delay_pid "$pid"; then
        clear_delay
        return 1
    fi

    printf '%s\n' "$((until - now))"
}

status() {
    local remaining minutes

    if remaining=$(remaining_seconds); then
        minutes=$(((remaining + 59) / 60))
        printf '{"name":"sleep_delay","full_text":"Sleep inhibition for %sm","color":"#a3be8c"}\n' "$minutes"
    fi
}

prompt() {
    local remaining default choice minutes seconds until pid

    mkdir -p "$state_dir"

    default="30"
    if remaining=$(remaining_seconds); then
        default="$(((remaining + 59) / 60))"
    fi

    choice="${1:-}"
    if [[ -z "$choice" ]]; then
        if [[ -t 0 ]]; then
            printf 'Keep awake for how many minutes? [default: %s, 0 clears] ' "$default" >&2
            read -r choice
        else
            usage >&2
            exit 2
        fi
    fi

    minutes=$(printf '%s' "$choice" | tr -d '[:space:]')
    if [[ -z "$minutes" ]]; then
        minutes="$default"
    fi

    if [[ ! "$minutes" =~ ^[0-9]+$ ]]; then
        printf 'Enter a whole number of minutes.\n' >&2
        exit 1
    fi

    if (( minutes == 0 )); then
        clear_delay
        printf 'Sleep inhibition cleared.\n'
        exit 0
    fi

    if (( minutes > 1440 )); then
        printf 'Use 1440 minutes or less.\n' >&2
        exit 1
    fi

    seconds=$((minutes * 60))
    until=$(($(date +%s) + seconds))

    clear_delay
    nohup systemd-inhibit \
        --what=idle:sleep \
        --mode=block \
        --why="$why" \
        sleep "$seconds" >/dev/null 2>&1 &
    pid=$!

    printf '%s\n' "$pid" > "$pid_file"
    printf '%s\n' "$until" > "$until_file"
    printf 'Sleep inhibition enabled for %s minutes.\n' "$minutes"
}

case "${1:-status}" in
    status|block)
        status
        ;;
    prompt)
        prompt "${2:-}"
        ;;
    clear)
        clear_delay
        printf 'Sleep inhibition cleared.\n'
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac
