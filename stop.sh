#!/bin/bash
# Stop 9Router, Mr Hermes WebUI, Watchdog, and Cloudflare Tunnels
if command -v proot-distro >/dev/null 2>&1; then
    proot-distro login ubuntu -- hermes-stack-stop
    pkill -f "cloudflared tunnel" 2>/dev/null || true
    echo -e "\033[1;32m[✓] All services and tunnels stopped.\033[0m"
else
    echo "[!] proot-distro not found."
fi
