#!/bin/bash
# Start 9Router, Mr Hermes WebUI, and Self-Healing Watchdog
if command -v proot-distro >/dev/null 2>&1; then
    termux-wake-lock 2>/dev/null || true
    proot-distro login ubuntu -- hermes-stack-start
    nohup proot-distro login ubuntu -- hermes-watchdog > /dev/null 2>&1 &
    echo -e "\033[1;32m[✓] Stack & Self-Healing Watchdog are ACTIVE.\033[0m"
else
    echo "[!] proot-distro not found. Please run install.sh first."
fi
