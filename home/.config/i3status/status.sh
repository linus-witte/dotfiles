#!/usr/bin/env bash
set -euo pipefail

config="$HOME/.config/i3status/config"
sleep_delay_script="$HOME/.config/i3status/sleep_delay.sh"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/i3status"
ip_cache_file="$cache_dir/public_ip"
city_cache_file="$cache_dir/public_city"
cache_ttl=60

mkdir -p "$cache_dir"

public_ip() {
    local now cached_at cached_ip ip

    now=$(date +%s)
    if [[ -r "$ip_cache_file" ]]; then
        read -r cached_at cached_ip < "$ip_cache_file" || true
        if [[ -n "${cached_at:-}" && -n "${cached_ip:-}" && $((now - cached_at)) -lt $cache_ttl ]]; then
            printf '%s\n' "$cached_ip"
            return
        fi
    fi

    ip=$(curl -fsS --max-time 2 https://api.ipify.org 2>/dev/null || true)
    if [[ -n "$ip" ]]; then
        printf '%s %s\n' "$now" "$ip" > "$ip_cache_file"
        printf '%s\n' "$ip"
    elif [[ -n "${cached_ip:-}" ]]; then
        printf '%s\n' "$cached_ip"
    else
        printf 'unavailable\n'
    fi
}

public_city() {
    local now cached_at cached_city city

    now=$(date +%s)
    if [[ -r "$city_cache_file" ]]; then
        read -r cached_at cached_city < "$city_cache_file" || true
        if [[ -n "${cached_at:-}" && -n "${cached_city:-}" && $((now - cached_at)) -lt $cache_ttl ]]; then
            printf '%s\n' "$cached_city"
            return
        fi
    fi

    city=$(curl -fsS --max-time 2 https://ipinfo.io/city 2>/dev/null | tr -d '\r' || true)
    if [[ -n "$city" ]]; then
        printf '%s %s\n' "$now" "$city" > "$city_cache_file"
        printf '%s\n' "$city"
    elif [[ -n "${cached_city:-}" ]]; then
        printf '%s\n' "$cached_city"
    else
        printf 'unavailable\n'
    fi
}

json_escape() {
    sed 's/\\/\\\\/g; s/"/\\"/g'
}

sleep_delay_block() {
    if [[ -r "$sleep_delay_script" ]]; then
        bash "$sleep_delay_script" status 2>/dev/null || true
    fi
}

extra_blocks() {
    local ip sleep_block

    ip=$(public_ip | json_escape)
    sleep_block=$(sleep_delay_block)

    if [[ -n "$sleep_block" ]]; then
        printf '%s,{"name":"public_ip","full_text":"Public IP: %s"}' "$sleep_block" "$ip"
    else
        printf '{"name":"public_ip","full_text":"Public IP: %s"}' "$ip"
    fi
}

print_status_line() {
    local prefix="$1"
    local rest="$2"
    local blocks

    blocks=$(extra_blocks)
    if [[ "$rest" =~ ^[[:space:]]*\] ]]; then
        printf '%s[%s%s\n' "$prefix" "$blocks" "$rest"
    else
        printf '%s[%s,%s\n' "$prefix" "$blocks" "$rest"
    fi
}

i3status -c "$config" 2>/dev/null | while IFS= read -r line; do
    case "$line" in
        '[' | '{"version":'*)
            printf '%s\n' "$line"
            ;;
        '['*)
            # city=$(public_city | json_escape)
            # City lookup is kept available, but not shown in the bar.
            # printf '[{"name":"public_ip","full_text":"Public IP: %s"},{"name":"public_city","full_text":"City: %s"},%s\n' "$ip" "$city" "${line:1}"
            print_status_line "" "${line:1}"
            ;;
        ',['*)
            # city=$(public_city | json_escape)
            # City lookup is kept available, but not shown in the bar.
            # printf ',[{"name":"public_ip","full_text":"Public IP: %s"},{"name":"public_city","full_text":"City: %s"},%s\n' "$ip" "$city" "${line:2}"
            print_status_line "," "${line:2}"
            ;;
        *)
            printf '%s\n' "$line"
            ;;
    esac
done
