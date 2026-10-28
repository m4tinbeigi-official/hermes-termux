#!/bin/bash
# Stop 9Router and Mr Hermes WebUI
if command -v proot-distro >/dev/null 2>&1; then
    proot-distro login ubuntu -- hermes-stack-stop
else
    echo "[!] proot-distro not found."
fi
