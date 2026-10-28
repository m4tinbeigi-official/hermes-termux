#!/bin/bash
# ==============================================================================
# 🌐 Mr Hermes Cloudflare Quick Tunnel (Remote Access for Laptop & Tablet)
# ==============================================================================

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          ☁️ Mr Hermes Instant Remote Cloud Tunnel             ║"
echo "║     Secure HTTPS Access for Laptop, iPad & Other Devices     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

# Verify local stack is alive
if ! lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}[!] Mr Hermes WebUI is not running on port 8787.${RESET}"
    echo -e "${BLUE}[*] Starting stack now...${RESET}"
    if command -v hermes-start >/dev/null 2>&1; then
        hermes-start
        sleep 2
    fi
fi

# Ensure cloudflared is installed
if ! command -v cloudflared >/dev/null 2>&1; then
    echo -e "${BLUE}[*] Setting up cloudflared binary...${RESET}"
    ARCH=$(uname -m)
    case "$ARCH" in
        aarch64|arm64) CF_ARCH="arm64" ;;
        armv7l|armhf)  CF_ARCH="arm" ;;
        x86_64|amd64)  CF_ARCH="amd64" ;;
        *)             CF_ARCH="arm64" ;;
    esac
    curl -fsSL "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${CF_ARCH}" -o "$PREFIX/bin/cloudflared" 2>/dev/null || \
    curl -fsSL "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" -o "$PREFIX/bin/cloudflared"
    chmod +x "$PREFIX/bin/cloudflared"
fi

TUNNEL_LOG="/tmp/hermes_tunnel.log"
rm -f "$TUNNEL_LOG"

echo -e "${CYAN}[*] Establishing encrypted Cloudflare tunnel to http://localhost:8787...${RESET}"
pkill -f "cloudflared tunnel" 2>/dev/null || true
cloudflared tunnel --url http://127.0.0.1:8787 > "$TUNNEL_LOG" 2>&1 &

# Wait for tunnel URL to generate
URL=""
for i in {1..25}; do
    sleep 1
    if [ -f "$TUNNEL_LOG" ]; then
        URL=$(grep -o 'https://[-a-zA-Z0-9.]*trycloudflare\.com' "$TUNNEL_LOG" | head -n 1 || true)
        if [ -n "$URL" ]; then
            break
        fi
    fi
    echo -n "."
done
echo ""

if [ -n "$URL" ]; then
    echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}"
    echo -e "${GREEN}${BOLD}✨ Remote Access URL Generated!                                   ${RESET}"
    echo -e "   👉 ${BOLD}${CYAN}${URL}${RESET}"
    echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}"
    
    # Generate terminal QR code if python or qrencode is available
    if command -v qrencode >/dev/null 2>&1; then
        echo -e "\n${BOLD}Scan this QR Code with your Laptop / Tablet / Phone:${RESET}\n"
        qrencode -t ANSIUTF8 "$URL"
    fi
    
    echo -e "\n${YELLOW}Press Ctrl+C to close the remote tunnel when finished.${RESET}\n"
    tail -f "$TUNNEL_LOG" | grep -v "failed" || true
else
    echo -e "${RED}[!] Could not establish tunnel. Check internet connection.${RESET}"
fi
