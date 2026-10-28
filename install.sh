#!/bin/bash
# ==============================================================================
# 🚀 Mr Hermes & 9Router Termux All-in-One Installer for Android
# Repository: https://github.com/m4tinbeigi-official/hermes-termux
# ==============================================================================

set -e

# ANSI Color codes
BOLD="\033[1m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          🚀 Mr Hermes & 9Router Stack for Termux            ║"
echo "║          Android Autonomous AI Development Suite             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

# Step 0: Ensure we are inside Termux or proot
if [ ! -d "/data/data/com.termux/files/usr" ] && [ ! -f "/etc/proot-distro" ] && [ ! -d "/usr/local" ]; then
    echo -e "${YELLOW}[!] Warning: This script is optimized for Android Termux.${RESET}"
fi

# Step 1: Prevent Android battery saver from killing Termux background processes
echo -e "${BLUE}[*] Phase 1/4: Termux Environment Preparation...${RESET}"
if command -v termux-wake-lock >/dev/null 2>&1; then
    echo -e "${GREEN}[✓] Acquiring Termux Wake Lock...${RESET}"
    termux-wake-lock || true
fi

# Update packages in Termux
export DEBIAN_FRONTEND=noninteractive
if command -v pkg >/dev/null 2>&1; then
    echo -e "${BLUE}[*] Updating Termux packages...${RESET}"
    pkg update -y -o Dpkg::Options::="--force-confold" || true
    echo -e "${BLUE}[*] Installing proot-distro, git, curl, wget...${RESET}"
    pkg install -y proot-distro git curl wget nano -o Dpkg::Options::="--force-confold"
fi

# Step 2: Install and initialize Ubuntu proot-distro
echo -e "\n${BLUE}[*] Phase 2/4: Initializing Ubuntu Linux Container...${RESET}"
if ! proot-distro list 2>/dev/null | grep -q "ubuntu.*installed"; then
    echo -e "${CYAN}[*] Downloading and installing Ubuntu container (one-time setup)...${RESET}"
    proot-distro install ubuntu
else
    echo -e "${GREEN}[✓] Ubuntu container already installed.${RESET}"
fi

# Step 3: Write inner installation script to be run inside Ubuntu
UBUNTU_ROOTFS="$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"
INNER_SCRIPT="/root/hermes_inner_setup.sh"

cat << 'INNER_EOF' > "$UBUNTU_ROOTFS$INNER_SCRIPT"
#!/bin/bash
set -e

BOLD="\033[1m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}==> Setting up Linux environment inside container...${RESET}"
export DEBIAN_FRONTEND=noninteractive

# Update apt
apt-get update -y
apt-get install -y --no-install-recommends \
    curl wget git build-essential python3 python3-pip python3-venv \
    sqlite3 tmux nano procps ca-certificates gnupg lsof

# Install Node.js 20 LTS if not present
if ! command -v node >/dev/null 2>&1; then
    echo -e "${BLUE}[*] Installing Node.js 20 LTS...${RESET}"
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
    apt-get update -y
    apt-get install -y nodejs
fi
echo -e "${GREEN}[✓] Node.js version: $(node -v)${RESET}"

# Install 9Router
echo -e "${BLUE}[*] Installing 9Router globally via npm...${RESET}"
npm install -g 9router --silent || npm install -g 9router

# Seed 9Router SQLite DB
echo -e "${BLUE}[*] Seeding 9Router SQLite database with default admin credentials...${RESET}"
mkdir -p /root/.9router/db
sqlite3 /root/.9router/db/data.sqlite << 'SQL_EOF'
CREATE TABLE IF NOT EXISTS apiKeys (
    id TEXT PRIMARY KEY,
    key TEXT NOT NULL UNIQUE,
    name TEXT,
    role TEXT,
    isActive INTEGER DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT OR IGNORE INTO apiKeys (id, key, name, role, isActive) VALUES ('key-hermes', 'sk-9router-admin', 'Hermes Agent', 'hermes-admin', 1);
SQL_EOF

# Install Hermes Agent
echo -e "${BLUE}[*] Installing Hermes Agent...${RESET}"
if ! command -v hermes >/dev/null 2>&1; then
    curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash || true
fi

# Ensure paths in bashrc
mkdir -p /root/.hermes/bin
cat << 'BASHRC_EOF' >> /root/.bashrc
export PATH="$HOME/.hermes/bin:/usr/local/bin:$PATH"
BASHRC_EOF

# Configure Hermes Agent
mkdir -p /root/.hermes
cat << 'HERMES_CONFIG' > /root/.hermes/config.yaml
# Hermes Agent Configuration for Termux & 9Router
model_provider: custom:9router
api_key: sk-9router-admin
base_url: http://127.0.0.1:20128/v1
providers:
  custom:9router:
    name: 9router
    base_url: http://127.0.0.1:20128/v1
    api_key: sk-9router-admin
HERMES_CONFIG

# Clone & Setup Mr Hermes WebUI
echo -e "${BLUE}[*] Setting up Mr Hermes WebUI (RTL & Persian UI)...${RESET}"
cd /root
if [ -d "/root/hermes-webui" ]; then
    echo -e "${YELLOW}[!] Updating existing hermes-webui repository...${RESET}"
    cd /root/hermes-webui && git pull || true
else
    git clone https://github.com/m4tinbeigi-official/MrHermesUI.git /root/hermes-webui
    cd /root/hermes-webui
fi

# Setup Python Virtual Environment for WebUI
if [ ! -d "/root/hermes-webui/.venv" ]; then
    echo -e "${BLUE}[*] Creating Python virtual environment for WebUI...${RESET}"
    python3 -m venv /root/hermes-webui/.venv
fi

echo -e "${BLUE}[*] Installing Python dependencies for WebUI...${RESET}"
/root/hermes-webui/.venv/bin/pip install --upgrade pip --quiet
if [ -f "/root/hermes-webui/requirements.txt" ]; then
    /root/hermes-webui/.venv/bin/pip install -r /root/hermes-webui/requirements.txt --quiet || true
fi
/root/hermes-webui/.venv/bin/pip install pyyaml httpx requests cryptography --quiet || true

# Create Stack Management Scripts inside container
mkdir -p /usr/local/bin

# Start Script
cat << 'START_EOF' > /usr/local/bin/hermes-stack-start
#!/bin/bash
BOLD="\033[1m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${BLUE}[*] Starting 9Router on port 20128...${RESET}"
if lsof -Pi :20128 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}[!] 9Router is already running on port 20128.${RESET}"
else
    nohup 9router > /root/9router.log 2>&1 &
    sleep 2
    echo -e "${GREEN}[✓] 9Router started.${RESET}"
fi

echo -e "${BLUE}[*] Starting Mr Hermes WebUI on port 8787...${RESET}"
if lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}[!] Hermes WebUI is already running on port 8787.${RESET}"
else
    cd /root/hermes-webui
    nohup /root/hermes-webui/.venv/bin/python3 server.py > /root/webui.log 2>&1 &
    sleep 2
    echo -e "${GREEN}[✓] Mr Hermes WebUI started.${RESET}"
fi

echo -e "\n${GREEN}${BOLD}====================================================${RESET}"
echo -e "${GREEN}${BOLD}  ✨ All Services are LIVE!                        ${RESET}"
echo -e "${CYAN}  👉 WebUI URL : http://localhost:8787              ${RESET}"
echo -e "${CYAN}  👉 9Router   : http://localhost:20128             ${RESET}"
echo -e "${GREEN}${BOLD}====================================================${RESET}"
START_EOF
chmod +x /usr/local/bin/hermes-stack-start

# Stop Script
cat << 'STOP_EOF' > /usr/local/bin/hermes-stack-stop
#!/bin/bash
RED="\033[1;31m"
GREEN="\033[1;32m"
RESET="\033[0m"

echo -e "${RED}[*] Stopping Mr Hermes WebUI and 9Router...${RESET}"
pkill -f "python3 server.py" 2>/dev/null || true
pkill -f "9router" 2>/dev/null || true
sleep 1
echo -e "${GREEN}[✓] Services stopped.${RESET}"
STOP_EOF
chmod +x /usr/local/bin/hermes-stack-stop

# Status Script
cat << 'STATUS_EOF' > /usr/local/bin/hermes-stack-status
#!/bin/bash
BOLD="\033[1m"
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}--- Mr Hermes Stack Status Check ---${RESET}"
if lsof -Pi :20128 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${GREEN}[✓] 9Router (Port 20128): ACTIVE${RESET}"
else
    echo -e "${RED}[✗] 9Router (Port 20128): INACTIVE${RESET}"
fi

if lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${GREEN}[✓] Mr Hermes WebUI (Port 8787): ACTIVE${RESET}"
else
    echo -e "${RED}[✗] Mr Hermes WebUI (Port 8787): INACTIVE${RESET}"
fi
STATUS_EOF
chmod +x /usr/local/bin/hermes-stack-status

echo -e "${GREEN}[✓] Linux Container setup completed successfully!${RESET}"
INNER_EOF

chmod +x "$UBUNTU_ROOTFS$INNER_SCRIPT"

# Execute inner script inside Ubuntu
echo -e "${BLUE}[*] Phase 3/4: Executing installer inside Ubuntu container...${RESET}"
proot-distro login ubuntu -- bash "$INNER_SCRIPT"

# Step 4: Create convenient Termux shortcut commands
echo -e "\n${BLUE}[*] Phase 4/4: Creating Termux shortcut commands...${RESET}"
mkdir -p "$PREFIX/bin"

# 1. hermes-start
cat << 'EOF' > "$PREFIX/bin/hermes-start"
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock 2>/dev/null || true
proot-distro login ubuntu -- hermes-stack-start
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

# 5. hermes-web
cat << 'EOF' > "$PREFIX/bin/hermes-web"
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock 2>/dev/null || true
proot-distro login ubuntu -- hermes-stack-start
if command -v termux-open-url >/dev/null 2>&1; then
    termux-open-url http://localhost:8787
fi
EOF
chmod +x "$PREFIX/bin/hermes-web"

# Auto-start stack immediately
echo -e "\n${CYAN}[*] Starting all services now...${RESET}"
"$PREFIX/bin/hermes-start"

echo -e "\n${GREEN}${BOLD}════════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}🎉 Installation Complete! All services are up and running!    ${RESET}"
echo -e "${CYAN}🌐 Open this URL in Chrome / Firefox on your Android phone:    ${RESET}"
echo -e "${BOLD}${YELLOW}   http://localhost:8787                                      ${RESET}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}Quick Termux Commands Available Anytime:${RESET}"
echo -e "  • ${CYAN}hermes-start${RESET}   : Start 9Router & WebUI"
echo -e "  • ${CYAN}hermes-stop${RESET}    : Stop all services"
echo -e "  • ${CYAN}hermes-status${RESET}  : Check port 8787 & 20128 status"
echo -e "  • ${CYAN}hermes-cli${RESET}     : Run Hermes Agent CLI directly"
echo -e "  • ${CYAN}hermes-web${RESET}     : Start stack and open WebUI in browser"
echo -e "${GREEN}Enjoy autonomous AI on Android! 🤍${RESET}\n"
