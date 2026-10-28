#!/bin/bash
# Mr Hermes Doctor & Diagnostics Check
if command -v proot-distro >/dev/null 2>&1; then
    proot-distro login ubuntu -- hermes-stack-status
else
    echo "[!] proot-distro not found."
fi
