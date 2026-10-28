#!/bin/bash
# Start 9Router and Mr Hermes WebUI
if command -v proot-distro >/dev/null 2>&1; then
    termux-wake-lock 2>/dev/null || true
    proot-distro login ubuntu -- hermes-stack-start
else
    echo "[!] proot-distro not found. Please run install.sh first."
fi
