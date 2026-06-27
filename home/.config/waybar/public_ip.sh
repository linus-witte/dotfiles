#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/waybar"
ip_cache_file="$cache_dir/public_ip"
cache_ttl=60

if ! mkdir -p "$cache_dir" 2>/dev/null; then
    cache_dir="${TMPDIR:-/tmp}/waybar-${UID:-user}"
    mkdir -p "$cache_dir"
    ip_cache_file="$cache_dir/public_ip"
fi

json_escape() {
    sed 's/\\/\\\\/g; s/"/\\"/g'
}

now=$(date +%s)
cached_at=""
cached_ip=""

if [[ -r "$ip_cache_file" ]]; then
    read -r cached_at cached_ip < "$ip_cache_file" || true
fi

if [[ -n "${cached_at:-}" && -n "${cached_ip:-}" && $((now - cached_at)) -lt $cache_ttl ]]; then
    ip="$cached_ip"
else
    ip=$(curl -fsS --max-time 2 https://api.ipify.org 2>/dev/null || true)
    if [[ -n "$ip" ]]; then
        printf '%s %s\n' "$now" "$ip" > "$ip_cache_file"
    elif [[ -n "${cached_ip:-}" ]]; then
        ip="$cached_ip"
    else
        ip="unavailable"
    fi
fi

escaped_ip=$(printf '%s' "$ip" | json_escape)
printf '{"text":"Public IP: %s","tooltip":"Public IP: %s"}\n' "$escaped_ip" "$escaped_ip"
