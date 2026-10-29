#!/bin/bash
# ==============================================================================
# 🚀 Mr Hermes & 9Router Ultimate Android Termux Installer (v3 Pro)
# Repository: https://github.com/m4tinbeigi-official/hermes-termux
# Fully Autonomous · Self-Healing · Cloud Tunnel · TUI Menu · Zero Friction
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
                                                      
   📱 Ultimate Android Termux AI Brain & Stack Engine (v3 Pro)
   9Router (20128) + Hermes Agent CLI + Mr Hermes WebUI (8787)
BANNER
echo -e "${RESET}"

echo -e "${BLUE}[1/6] 🛡️  Optimizing Android Runtime & Wake Lock...${RESET}"
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

# Architecture validation
case "$ARCH" in
    aarch64|arm64)
        echo -e "${GREEN}[✓] 64-bit ARM architecture confirmed (Tier 1 Optimal).${RESET}"
        ;;
    x86_64|amd64)
        echo -e "${GREEN}[✓] 64-bit x86 architecture confirmed.${RESET}"
        ;;
    armv7l|armhf|arm)
        echo -e "${YELLOW}[!] Warning: 32-bit ARM detected ($ARCH). Modern 64-bit is strongly recommended for Node 20 and AI runtimes.${RESET}"
        ;;
    *)
        echo -e "${YELLOW}[!] Notice: Architecture $ARCH detected.${RESET}"
        ;;
esac

# Check Available Disk Space (At least 1.5 GB recommended)
FREE_KB=$(df -k "$PREFIX" 2>/dev/null | awk 'NR==2 {print $4}' || echo "9999999")
if [ "$FREE_KB" -lt 1500000 ] 2>/dev/null; then
    echo -e "${YELLOW}[!] Warning: Less than 1.5 GB free storage detected. Ubuntu RootFS and AI packages require ~1.5 - 2 GB.${RESET}"
else
    echo -e "${GREEN}[✓] Storage space verified (Sufficient free capacity).${RESET}"
fi

# Detect legacy Google Play Store Termux build
if [ -f "/data/data/com.termux/files/usr/etc/apt/sources.list" ]; then
    if grep -q "bintray" "/data/data/com.termux/files/usr/etc/apt/sources.list" 2>/dev/null; then
        echo -e "${RED}[!] Critical: You are using the deprecated Google Play Store Termux build!${RESET}"
        echo -e "${YELLOW}[*] Auto-repairing Termux repository sources to grimler.se / official mirrors...${RESET}"
        sed -i 's|.*bintray.*|deb https://packages.termux.dev/apt/termux-main stable main|g' /data/data/com.termux/files/usr/etc/apt/sources.list 2>/dev/null || true
    fi
fi

echo -e "\n${BLUE}[2/6] 📦 Updating Termux Base Packages & Tools...${RESET}"
export DEBIAN_FRONTEND=noninteractive
if command -v pkg >/dev/null 2>&1; then
    pkg update -y -o Dpkg::Options::="--force-confold" || true
    pkg install -y proot-distro git curl wget nano jq lsof tar bc procps qrencode -o Dpkg::Options::="--force-confold"
fi

echo -e "\n${BLUE}[3/6] 🐧 Provisioning High-Performance Ubuntu Linux Environment...${RESET}"
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
    sqlite3 tmux nano procps ca-certificates gnupg lsof psmisc bc net-tools qrencode

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

# Pre-seed 9Router Database (apiKeys & combos)
echo -e "${BLUE}[*] Initializing 9Router SQLite Database with Admin Key & Combos...${RESET}"
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

CREATE TABLE IF NOT EXISTS combos (
    id TEXT PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    kind TEXT,
    models TEXT NOT NULL,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL
);
INSERT OR IGNORE INTO combos (id, name, kind, models, createdAt, updatedAt)
VALUES ('combo-mrhermes', 'MrHermes', 'fallback', '["custom:9router/auto","gemini-2.5-flash","claude-3-5-sonnet"]', datetime('now'), datetime('now'));
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

if lsof -Pi :20128 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "  • 9Router Gateway (Port 20128)  : ${GREEN}${BOLD}ONLINE ✓${RESET}"
else
    echo -e "  • 9Router Gateway (Port 20128)  : ${RED}${BOLD}OFFLINE ✗${RESET}"
fi

if lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "  • Mr Hermes WebUI (Port 8787)   : ${GREEN}${BOLD}ONLINE ✓${RESET}"
else
    echo -e "  • Mr Hermes WebUI (Port 8787)   : ${RED}${BOLD}OFFLINE ✗${RESET}"
fi

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
echo "[*] Hermes Self-Healing Watchdog activated in background."
while true; do
    if ! lsof -Pi :20128 -sTCP:LISTEN -t >/dev/null 2>&1; then
        nohup 9router > /root/9router.log 2>&1 &
    fi
    if ! lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
        cd /root/hermes-webui && nohup /root/hermes-webui/.venv/bin/python3 server.py > /root/webui.log 2>&1 &
    fi
    sleep 30
done
WATCHDOG_CMD
chmod +x /usr/local/bin/hermes-watchdog

echo -e "${GREEN}[✓] Container inner setup complete.${RESET}"
INNER_EOF

chmod +x "$UBUNTU_ROOTFS$INNER_SETUP"

echo -e "\n${BLUE}[4/6] ⚙️  Executing Stack Scaffolding inside Ubuntu...${RESET}"
proot-distro login ubuntu -- bash "$INNER_SETUP"

echo -e "\n${BLUE}[5/6] ☁️  Setting up Cloudflare Tunnel (Remote Sharing Engine)...${RESET}"
CF_BIN="$PREFIX/bin/cloudflared"
if [ ! -f "$CF_BIN" ]; then
    echo -e "${CYAN}[*] Downloading static cloudflared binary for remote access...${RESET}"
    curl -fsSL "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" -o "$CF_BIN" 2>/dev/null || true
    chmod +x "$CF_BIN" 2>/dev/null || true
fi

echo -e "\n${BLUE}[6/6] 📲 Injecting Android Shortcuts, Auto-Boot & Termux Widgets...${RESET}"
mkdir -p "$PREFIX/bin"

# 1. hermes-start
cat << 'EOF' > "$PREFIX/bin/hermes-start"
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock 2>/dev/null || true
proot-distro login ubuntu -- hermes-stack-start
nohup proot-distro login ubuntu -- hermes-watchdog > /dev/null 2>&1 &
echo -e "\033[1;32m[✓] Stack & Self-Healing Watchdog are ACTIVE.\033[0m"
EOF
chmod +x "$PREFIX/bin/hermes-start"

# 2. hermes-stop
cat << 'EOF' > "$PREFIX/bin/hermes-stop"
#!/data/data/com.termux/files/usr/bin/bash
proot-distro login ubuntu -- hermes-stack-stop
pkill -f "cloudflared tunnel" 2>/dev/null || true
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

# 8. hermes-share / hermes-tunnel (Cloudflare tunnel for PC/Tablet access)
cat << 'EOF' > "$PREFIX/bin/hermes-share"
#!/data/data/com.termux/files/usr/bin/bash
TUNNEL_LOG="/tmp/hermes_cf_tunnel.log"
rm -f "$TUNNEL_LOG"
echo -e "\033[1;36m[*] Establishing secure HTTPS Cloudflare tunnel for port 8787...\033[0m"
pkill -f "cloudflared tunnel" 2>/dev/null || true
cloudflared tunnel --url http://127.0.0.1:8787 > "$TUNNEL_LOG" 2>&1 &

URL=""
for i in {1..20}; do
    sleep 1
    if [ -f "$TUNNEL_LOG" ]; then
        URL=$(grep -o 'https://[-a-zA-Z0-9.]*trycloudflare\.com' "$TUNNEL_LOG" | head -n 1 || true)
        if [ -n "$URL" ]; then break; fi
    fi
    echo -n "."
done
echo ""

if [ -n "$URL" ]; then
    echo -e "\n\033[1;32m════════════════════════════════════════════════════════════════\033[0m"
    echo -e "\033[1;32m✨ Cloud Tunnel LIVE! Access from any Laptop or Tablet:\033[0m"
    echo -e "   👉 \033[1;36m$URL\033[0m"
    echo -e "\033[1;32m════════════════════════════════════════════════════════════════\033[0m"
    if command -v qrencode >/dev/null 2>&1; then
        echo -e "\n\033[1mScan to open on Laptop / Tablet / iPad:\033[0m\n"
        qrencode -t ANSIUTF8 "$URL"
    fi
    echo -e "\n\033[1;33mPress Ctrl+C to close the remote tunnel when finished.\033[0m\n"
    tail -f "$TUNNEL_LOG" | grep -v "failed" || true
else
    echo -e "\033[1;31m[!] Tunnel initialization timeout. Check internet connection.\033[0m"
fi
EOF
chmod +x "$PREFIX/bin/hermes-share"

# 9. hermes-menu (Interactive Cyberpunk Dashboard)
cat << 'EOF' > "$PREFIX/bin/hermes-menu"
#!/data/data/com.termux/files/usr/bin/bash
while true; do
    clear 2>/dev/null || true
    echo -e "\033[1;36m"
    cat << "BANNER"
  __  __         _    _                               
 |  \/  |       | |  | |                              
 | \  / |_ __   | |__| | ___ _ __ _ __ ___   ___  ___ 
 | |\/| | '__|  |  __  |/ _ \ '__| '_ ` _ \ / _ \/ __|
 | |  | | |_    | |  | |  __/ |  | | | | | |  __/\__ \
 |_|  |_|_(_)   |_|  |_|\___|_|  |_| |_| |_|\___||___/
BANNER
    echo -e "\033[0m"

    WEB_STATUS="\033[1;31mOFFLINE ✗\033[0m"
    ROUTER_STATUS="\033[1;31mOFFLINE ✗\033[0m"
    if lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
        WEB_STATUS="\033[1;32mONLINE :8787 ✓\033[0m"
    fi
    if lsof -Pi :20128 -sTCP:LISTEN -t >/dev/null 2>&1; then
        ROUTER_STATUS="\033[1;32mONLINE :20128 ✓\033[0m"
    fi

    echo -e "  ┌────────────────────────────────────────────────────────────┐"
    echo -e "  │  WebUI: $WEB_STATUS     9Router: $ROUTER_STATUS  │"
    echo -e "  └────────────────────────────────────────────────────────────┘"
    echo -e ""
    echo -e "  \033[1;36m[1]\033[0m 🌐 Open WebUI in Browser (Chrome / Firefox)"
    echo -e "  \033[1;36m[2]\033[0m 🚀 Start / Revive Stack & Watchdog"
    echo -e "  \033[1;36m[3]\033[0m 🛑 Stop All Daemons"
    echo -e "  \033[1;36m[4]\033[0m ☁️  Cloudflare Tunnel & QR (Access from Laptop/PC)"
    echo -e "  \033[1;36m[5]\033[0m ⚡ Hermes Interactive CLI Chat"
    echo -e "  \033[1;36m[6]\033[0m 🩺 Run System Doctor & Diagnostics"
    echo -e "  \033[1;36m[7]\033[0m 🔄 Update All Stack Components"
    echo -e "  \033[1;36m[0]\033[0m 🚪 Exit to Termux Shell"
    echo -e ""
    echo -n -e "  \033[1;33mSelect option [0-7]: \033[0m"
    read -r opt || break

    case "$opt" in
        1) hermes-web; sleep 1 ;;
        2) hermes-start; read -r -p "Press [Enter] to continue..." ;;
        3) hermes-stop; read -r -p "Press [Enter] to continue..." ;;
        4) hermes-share; read -r -p "Press [Enter] to continue..." ;;
        5) hermes-cli ;;
        6) hermes-doctor; read -r -p "Press [Enter] to continue..." ;;
        7) hermes-update; read -r -p "Press [Enter] to continue..." ;;
        0) break ;;
        *) sleep 1 ;;
    esac
done
EOF
chmod +x "$PREFIX/bin/hermes-menu"

# Link 'hermes' command in Termux to the Interactive Menu
ln -sf "$PREFIX/bin/hermes-menu" "$PREFIX/bin/hermes" 2>/dev/null || true

# 10. Setup Termux:Boot (Auto-start on Android Phone Boot)
mkdir -p "$HOME/.termux/boot"
cat << 'EOF' > "$HOME/.termux/boot/start-hermes.sh"
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock 2>/dev/null || true
sleep 5
$PREFIX/bin/hermes-start
EOF
chmod +x "$HOME/.termux/boot/start-hermes.sh"

# 11. Setup Termux:Widget (Home-Screen 1-Tap Control Buttons)
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

cat << 'EOF' > "$HOME/.shortcuts/☁️ Hermes Tunnel"
#!/data/data/com.termux/files/usr/bin/bash
$PREFIX/bin/hermes-share
EOF
chmod +x "$HOME/.shortcuts/☁️ Hermes Tunnel"

cat << 'EOF' > "$HOME/.shortcuts/🩺 Hermes Doctor"
#!/data/data/com.termux/files/usr/bin/bash
$PREFIX/bin/hermes-doctor
read -p "Press enter to exit"
EOF
chmod +x "$HOME/.shortcuts/🩺 Hermes Doctor"

# Add pleasant MOTD hint to Termux ~/.bashrc
if ! grep -q "hermes-menu" "$HOME/.bashrc" 2>/dev/null; then
    cat << 'BASHRC_EOF' >> "$HOME/.bashrc"

# Mr Hermes Android AI Brain
echo -e "\033[1;36m🤖 Mr Hermes Stack Ready!\033[0m Type \033[1;32mhermes\033[0m for Control Menu or \033[1;32mhermes-web\033[0m to open WebUI."
BASHRC_EOF
fi

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
echo -e "  🎮 ${CYAN}Interactive Menu${RESET}       : Type '${BOLD}hermes${RESET}' anytime for the Cyber Control Panel."
echo -e "  ☁️  ${CYAN}Remote Cloud Tunnel${RESET}    : Run '${BOLD}hermes-share${RESET}' to get a secure link & QR code for laptop."
echo -e "  ⚡ ${CYAN}Self-Healing Watchdog${RESET}  : Automatically revives dead processes."
echo -e "  📲 ${CYAN}Termux:Boot Support${RESET}    : Auto-starts when your phone turns on."
echo -e "  🔘 ${CYAN}Home-Screen Widgets${RESET}    : 1-Tap widgets ready in ~/.shortcuts/."
echo -e "  🩺 ${CYAN}hermes-doctor${RESET}          : Run diagnostics whenever needed."
echo -e "  🔄 ${CYAN}hermes-update${RESET}          : 1-click update for the entire stack."
echo -e "\n${GREEN}Enjoy your autonomous AI agent on Android! 🤍${RESET}\n"
