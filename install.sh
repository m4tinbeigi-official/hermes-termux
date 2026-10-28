#!/bin/bash
# ==============================================================================
# 🚀 Mr Hermes & 9Router Ultimate Android Termux Installer
# Repository: https://github.com/m4tinbeigi-official/hermes-termux
# Fully Autonomous · Self-Healing · 1-Tap Widget & Boot Support · Zero Friction
# ==============================================================================

set -euo pipefail

# Visual Palette
BOLD="\033[1m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RED="\033[1;31m"
RESET="\033[0m"

clear 2>/dev/null || true
echo -e "${CYAN}${BOLD}"
cat << "BANNER"
  __  __         _    _                               
 |  \/  |       | |  | |                              
 | \  / |_ __   | |__| | ___ _ __ _ __ ___   ___  ___ 
 | |\/| | '__|  |  __  |/ _ \ '__| '_ ` _ \ / _ \/ __|
 | |  | | |_    | |  | |  __/ |  | | | | | |  __/\__ \
 |_|  |_|_(_)   |_|  |_|\___|_|  |_| |_| |_|\___||___/
                                                      
   📱 Ultimate Android Termux AI Brain & Stack Engine
   9Router (20128) + Hermes Agent CLI + Mr Hermes WebUI (8787)
BANNER
echo -e "${RESET}"

echo -e "${BLUE}[1/5] 🛡️  Optimizing Android Runtime & Wake Lock...${RESET}"
# Acquire wake lock so Android Doze doesn't sleep the installer or servers
if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock || true
    echo -e "${GREEN}[✓] Termux Wake-Lock acquired (prevents sleep during background operation).${RESET}"
fi

# Fix storage access if needed
if [ ! -d "$HOME/storage" ] && command -v termux-setup-storage >/dev/null 2>&1; then
    termux-setup-storage || true
fi

# Detect Termux architecture
ARCH=$(uname -m)
echo -e "${GREEN}[✓] Device Architecture: ${ARCH}${RESET}"

echo -e "\n${BLUE}[2/5] 📦 Updating Termux Base Packages & proot-distro...${RESET}"
export DEBIAN_FRONTEND=noninteractive
if command -v pkg >/dev/null 2>&1; then
    pkg update -y -o Dpkg::Options::="--force-confold" || true
    pkg install -y proot-distro git curl wget nano jq lsof tar bc procps -o Dpkg::Options::="--force-confold"
fi

echo -e "\n${BLUE}[3/5] 🐧 Provisioning High-Performance Ubuntu Linux Environment...${RESET}"
if ! proot-distro list 2>/dev/null | grep -q "ubuntu.*installed"; then
    echo -e "${CYAN}[*] Downloading Ubuntu RootFS image (one-time fast setup)...${RESET}"
    proot-distro install ubuntu
else
    echo -e "${GREEN}[✓] Ubuntu RootFS environment already available.${RESET}"
fi

UBUNTU_ROOTFS="$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"
INNER_SETUP="/root/hermes_inner_setup.sh"

cat << 'INNER_EOF' > "$UBUNTU_ROOTFS$INNER_SETUP"
#!/bin/bash
set -euo pipefail

BOLD="\033[1m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}==> Configuring Ubuntu Core System for AI Runtime...${RESET}"
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y --no-install-recommends \
    curl wget git build-essential python3 python3-pip python3-venv \
    sqlite3 tmux nano procps ca-certificates gnupg lsof psmisc bc net-tools

# Install Node.js 20 LTS (Official NodeSource Node.js)
if ! command -v node >/dev/null 2>&1 || [ "$(node -v | cut -d'.' -f1 | tr -d 'v')" -lt 18 ]; then
    echo -e "${BLUE}[*] Provisioning Node.js 20 LTS...${RESET}"
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg --yes
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
    apt-get update -y
    apt-get install -y nodejs
fi
echo -e "${GREEN}[✓] Node.js $(node -v) & npm $(npm -v) installed.${RESET}"

# Install 9Router globally
echo -e "${BLUE}[*] Installing 9Router AI Gateway globally...${RESET}"
npm install -g 9router --silent || npm install -g 9router

# Pre-seed 9Router Database
echo -e "${BLUE}[*] Initializing 9Router SQLite Database with Admin Key...${RESET}"
mkdir -p /root/.9router/db
sqlite3 /root/.9router/db/data.sqlite << 'SQL_EOF'
CREATE TABLE IF NOT EXISTS apiKeys (
    id TEXT PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    name TEXT,
    machineId TEXT,
    isActive INTEGER DEFAULT 1,
    createdAt TEXT NOT NULL,
    accessRestricted INTEGER DEFAULT 0,
    accessAllow TEXT
);
INSERT OR IGNORE INTO apiKeys (id, key, name, machineId, isActive, createdAt, accessRestricted, accessAllow) 
VALUES ('key-admin', 'sk-9router-admin', 'Mr Hermes Admin', 'termux-android', 1, datetime('now'), 0, '[]');
SQL_EOF

# Install Hermes Agent CLI
echo -e "${BLUE}[*] Installing Hermes Agent autonomous engine...${RESET}"
if ! command -v hermes >/dev/null 2>&1; then
    curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash || true
fi

# Setup Hermes Environment & Routing
mkdir -p /root/.hermes/bin
cat << 'CONFIG_EOF' > /root/.hermes/config.yaml
# Mr Hermes Termux Stack Master Configuration
model_provider: custom:9router
model: custom:9router/auto
api_key: sk-9router-admin
base_url: http://127.0.0.1:20128/v1
providers:
  custom:9router:
    name: 9router
    base_url: http://127.0.0.1:20128/v1
    api_key: sk-9router-admin
approvals:
  mode: smart
display:
  interface: rich
CONFIG_EOF

cat << 'BASHRC_IN_UBUNTU' >> /root/.bashrc
export PATH="$HOME/.hermes/bin:/usr/local/bin:$PATH"
export HERMES_HOME="$HOME/.hermes"
BASHRC_IN_UBUNTU

# Clone & Setup Mr Hermes WebUI (Persian RTL & Custom Skin)
echo -e "${BLUE}[*] Installing Mr Hermes WebUI (Persian RTL Interface)...${RESET}"
cd /root
if [ -d "/root/hermes-webui" ]; then
    cd /root/hermes-webui && git pull || true
else
    git clone https://github.com/m4tinbeigi-official/MrHermesUI.git /root/hermes-webui
    cd /root/hermes-webui
fi

# Python venv for WebUI
if [ ! -d "/root/hermes-webui/.venv" ]; then
    python3 -m venv /root/hermes-webui/.venv
fi

/root/hermes-webui/.venv/bin/pip install --upgrade pip --quiet
if [ -f "/root/hermes-webui/requirements.txt" ]; then
    /root/hermes-webui/.venv/bin/pip install -r /root/hermes-webui/requirements.txt --quiet || true
fi
/root/hermes-webui/.venv/bin/pip install pyyaml httpx requests cryptography psutil --quiet || true

# Provision Container Daemon Controls
mkdir -p /usr/local/bin

# 1. Stack Start
cat << 'START_CMD' > /usr/local/bin/hermes-stack-start
#!/bin/bash
set -euo pipefail
BOLD="\033[1m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "${BLUE}[*] Verifying 9Router Gateway...${RESET}"
if lsof -Pi :20128 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}[!] 9Router already listening on port 20128.${RESET}"
else
    nohup 9router > /root/9router.log 2>&1 &
    sleep 2
    echo -e "${GREEN}[✓] 9Router started on http://127.0.0.1:20128${RESET}"
fi

echo -e "${BLUE}[*] Verifying Mr Hermes WebUI...${RESET}"
if lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}[!] Hermes WebUI already listening on port 8787.${RESET}"
else
    cd /root/hermes-webui
    nohup /root/hermes-webui/.venv/bin/python3 server.py > /root/webui.log 2>&1 &
    sleep 2
    echo -e "${GREEN}[✓] Mr Hermes WebUI started on http://127.0.0.1:8787${RESET}"
fi
START_CMD
chmod +x /usr/local/bin/hermes-stack-start

# 2. Stack Stop
cat << 'STOP_CMD' > /usr/local/bin/hermes-stack-stop
#!/bin/bash
RED="\033[1;31m"
GREEN="\033[1;32m"
RESET="\033[0m"

echo -e "${RED}[*] Stopping stack daemons...${RESET}"
fuser -k 8787/tcp 2>/dev/null || pkill -f "python3 server.py" 2>/dev/null || true
fuser -k 20128/tcp 2>/dev/null || pkill -f "9router" 2>/dev/null || true
pkill -f "hermes_watchdog" 2>/dev/null || true
sleep 1
echo -e "${GREEN}[✓] All services successfully stopped.${RESET}"
STOP_CMD
chmod +x /usr/local/bin/hermes-stack-stop

# 3. Stack Status
cat << 'STATUS_CMD' > /usr/local/bin/hermes-stack-status
#!/bin/bash
BOLD="\033[1m"
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}║           📊 Mr Hermes Android Stack Diagnostics             ║${RESET}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════════╝${RESET}"

# 9Router Check
if lsof -Pi :20128 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "  • 9Router Gateway (Port 20128)  : ${GREEN}${BOLD}ONLINE ✓${RESET}"
else
    echo -e "  • 9Router Gateway (Port 20128)  : ${RED}${BOLD}OFFLINE ✗${RESET}"
fi

# WebUI Check
if lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "  • Mr Hermes WebUI (Port 8787)   : ${GREEN}${BOLD}ONLINE ✓${RESET}"
else
    echo -e "  • Mr Hermes WebUI (Port 8787)   : ${RED}${BOLD}OFFLINE ✗${RESET}"
fi

# Hermes CLI Check
if [ -f "/root/.hermes/bin/hermes" ] || command -v hermes >/dev/null 2>&1; then
    echo -e "  • Hermes Agent Core Engine      : ${GREEN}${BOLD}INSTALLED ✓${RESET}"
else
    echo -e "  • Hermes Agent Core Engine      : ${YELLOW}NOT FOUND${RESET}"
fi

echo -e "\n${BOLD}System Resources in Container:${RESET}"
free -m 2>/dev/null || true
STATUS_CMD
chmod +x /usr/local/bin/hermes-stack-status

# 4. Self-Healing Watchdog Daemon
cat << 'WATCHDOG_CMD' > /usr/local/bin/hermes-watchdog
#!/bin/bash
# Checks health every 30 seconds and revives any dead daemon
echo "[*] Hermes Self-Healing Watchdog activated in background."
while true; do
    if ! lsof -Pi :20128 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "[!] 9Router down, restarting..."
        nohup 9router > /root/9router.log 2>&1 &
    fi
    if ! lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "[!] WebUI down, restarting..."
        cd /root/hermes-webui && nohup /root/hermes-webui/.venv/bin/python3 server.py > /root/webui.log 2>&1 &
    fi
    sleep 30
done
WATCHDOG_CMD
chmod +x /usr/local/bin/hermes-watchdog

echo -e "${GREEN}[✓] Container inner setup complete.${RESET}"
INNER_EOF

chmod +x "$UBUNTU_ROOTFS$INNER_SETUP"

echo -e "\n${BLUE}[4/5] ⚙️  Executing Stack Scaffolding inside Ubuntu...${RESET}"
proot-distro login ubuntu -- bash "$INNER_SETUP"

echo -e "\n${BLUE}[5/5] 📲 Injecting Android Shortcuts, Auto-Boot & Termux Widgets...${RESET}"
mkdir -p "$PREFIX/bin"

# 1. hermes-start
cat << 'EOF' > "$PREFIX/bin/hermes-start"
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock 2>/dev/null || true
proot-distro login ubuntu -- hermes-stack-start
# Start watchdog in background
nohup proot-distro login ubuntu -- hermes-watchdog > /dev/null 2>&1 &
echo -e "\033[1;32m[✓] Stack & Self-Healing Watchdog are ACTIVE.\033[0m"
EOF
chmod +x "$PREFIX/bin/hermes-start"

# 2. hermes-stop
cat << 'EOF' > "$PREFIX/bin/hermes-stop"
#!/data/data/com.termux/files/usr/bin/bash
proot-distro login ubuntu -- hermes-stack-stop
EOF
chmod +x "$PREFIX/bin/hermes-stop"

# 3. hermes-status
cat << 'EOF' > "$PREFIX/bin/hermes-status"
#!/data/data/com.termux/files/usr/bin/bash
proot-distro login ubuntu -- hermes-stack-status
EOF
chmod +x "$PREFIX/bin/hermes-status"

# 4. hermes-cli
cat << 'EOF' > "$PREFIX/bin/hermes-cli"
#!/data/data/com.termux/files/usr/bin/bash
proot-distro login ubuntu -- bash -c "export PATH=\$HOME/.hermes/bin:\$PATH; hermes $@"
EOF
chmod +x "$PREFIX/bin/hermes-cli"

# 5. hermes-web (Opens directly in Android browser)
cat << 'EOF' > "$PREFIX/bin/hermes-web"
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock 2>/dev/null || true
if ! proot-distro login ubuntu -- lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
    hermes-start
    sleep 2
fi
echo -e "\033[1;36m[*] Launching Mr Hermes WebUI in your default browser...\033[0m"
if command -v termux-open-url >/dev/null 2>&1; then
    termux-open-url http://localhost:8787
elif command -v am >/dev/null 2>&1; then
    am start -a android.intent.action.VIEW -d "http://localhost:8787" >/dev/null 2>&1 || true
fi
EOF
chmod +x "$PREFIX/bin/hermes-web"

# 6. hermes-doctor (Diagnostics)
cat << 'EOF' > "$PREFIX/bin/hermes-doctor"
#!/data/data/com.termux/files/usr/bin/bash
BOLD="\033[1m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}=== Mr Hermes Android Doctor & System Audit ===${RESET}"
hermes-status
echo -e "\n${BOLD}Wake-Lock Status:${RESET}"
dumpsys power 2>/dev/null | grep -i "wake" | head -n 3 || echo "Managed by Termux wake-lock"
echo -e "\n${BOLD}Storage Free Space:${RESET}"
df -h "$PREFIX" | tail -n 1
echo -e "\n${GREEN}[✓] Stack Health Check completed!${RESET}"
EOF
chmod +x "$PREFIX/bin/hermes-doctor"

# 7. hermes-update (1-Click Auto Update)
cat << 'EOF' > "$PREFIX/bin/hermes-update"
#!/data/data/com.termux/files/usr/bin/bash
echo -e "\033[1;34m[*] Updating Mr Hermes WebUI, 9Router, and Hermes Agent...\033[0m"
proot-distro login ubuntu -- bash -c "
  cd /root/hermes-webui && git pull
  npm update -g 9router
  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
"
hermes-stop
hermes-start
echo -e "\033[1;32m[✓] Stack updated and restarted successfully!\033[0m"
EOF
chmod +x "$PREFIX/bin/hermes-update"

# 8. Setup Termux:Boot (Auto-start on Android Phone Boot)
mkdir -p "$HOME/.termux/boot"
cat << 'EOF' > "$HOME/.termux/boot/start-hermes.sh"
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock 2>/dev/null || true
sleep 5
$PREFIX/bin/hermes-start
EOF
chmod +x "$HOME/.termux/boot/start-hermes.sh"

# 9. Setup Termux:Widget (Home-Screen 1-Tap Control Buttons)
mkdir -p "$HOME/.shortcuts"
cat << 'EOF' > "$HOME/.shortcuts/🚀 Start Mr Hermes"
#!/data/data/com.termux/files/usr/bin/bash
$PREFIX/bin/hermes-web
EOF
chmod +x "$HOME/.shortcuts/🚀 Start Mr Hermes"

cat << 'EOF' > "$HOME/.shortcuts/🛑 Stop Mr Hermes"
#!/data/data/com.termux/files/usr/bin/bash
$PREFIX/bin/hermes-stop
EOF
chmod +x "$HOME/.shortcuts/🛑 Stop Mr Hermes"

cat << 'EOF' > "$HOME/.shortcuts/🩺 Hermes Doctor"
#!/data/data/com.termux/files/usr/bin/bash
$PREFIX/bin/hermes-doctor
read -p "Press enter to exit"
EOF
chmod +x "$HOME/.shortcuts/🩺 Hermes Doctor"

# Auto-start everything right now!
echo -e "\n${CYAN}[*] Starting all stack daemons and auto-opening browser...${RESET}"
hermes-start

# Attempt to launch the browser automatically on phone!
if command -v termux-open-url >/dev/null 2>&1; then
    termux-open-url http://localhost:8787 || true
elif command -v am >/dev/null 2>&1; then
    am start -a android.intent.action.VIEW -d "http://localhost:8787" >/dev/null 2>&1 || true
fi

# Send Android Notification if termux-api available
if command -v termux-notification >/dev/null 2>&1; then
    termux-notification --title "Mr Hermes is Ready!" --content "Stack is LIVE at http://localhost:8787" --id 8787 2>/dev/null || true
fi

echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}🎉 SUCCESS! Mr Hermes AI Brain is fully deployed on Android!  ${RESET}"
echo -e "${CYAN}🌐 WebUI Address : ${BOLD}${YELLOW}http://localhost:8787${RESET}"
echo -e "${CYAN}🔀 9Router Proxy  : ${BOLD}${YELLOW}http://localhost:20128${RESET}"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}Features Automatically Configured:${RESET}"
echo -e "  ⚡ ${CYAN}Self-Healing Watchdog${RESET}  : Automatically revives dead processes."
echo -e "  📲 ${CYAN}Termux:Boot Support${RESET}    : Auto-starts when your phone turns on."
echo -e "  🔘 ${CYAN}Home-Screen Widgets${RESET}    : 1-Tap widgets ready in ~/.shortcuts/."
echo -e "  🩺 ${CYAN}hermes-doctor${RESET}          : Run diagnostics whenever needed."
echo -e "  🔄 ${CYAN}hermes-update${RESET}          : 1-click update for the entire stack."
echo -e "\n${GREEN}Enjoy your autonomous AI agent on Android! 🤍${RESET}\n"
