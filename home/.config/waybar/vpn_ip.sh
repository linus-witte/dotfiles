#!/usr/bin/env bash
set -euo pipefail

ip_addr=$(ip -4 -o addr show dev tun0 2>/dev/null | awk '{ split($4, a, "/"); print a[1]; exit }' || true)

if [[ -z "${ip_addr:-}" ]]; then
    printf '{"text":"","tooltip":"VPN: down","class":"disconnected"}\n'
    exit 0
fi

printf '{"text":"VPN: %s","tooltip":"tun0: %s","class":"connected"}\n' "$ip_addr" "$ip_addr"
