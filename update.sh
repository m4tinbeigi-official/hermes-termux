#!/bin/bash
# 1-Click Update for 9Router, Mr Hermes WebUI, and Hermes Agent
if command -v proot-distro >/dev/null 2>&1; then
    echo "[*] Updating stack components inside container..."
    proot-distro login ubuntu -- bash -c "
      cd /root/hermes-webui && git pull
      npm update -g 9router
      curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
    "
    proot-distro login ubuntu -- hermes-stack-stop
    proot-distro login ubuntu -- hermes-stack-start
    echo "[✓] Stack successfully updated and restarted!"
else
    echo "[!] proot-distro not found."
fi
