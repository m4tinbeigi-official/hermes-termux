#!/bin/bash
# ==============================================================================
# 🎮 Mr Hermes Cyberpunk Interactive Command Center for Termux
# ==============================================================================

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RED="\033[1;31m"
RESET="\033[0m"

while true; do
    clear 2>/dev/null || true
    echo -e "${CYAN}${BOLD}"
    cat << "BANNER"
  __  __         _    _                               
 |  \/  |       | |  | |                              
 | \  / |_ __   | |__| | ___ _ __ _ __ ___   ___  ___ 
 | |\/| | '__|  |  __  |/ _ \ '__| '_ ` _ \ / _ \/ __|
 | |  | | |_    | |  | |  __/ |  | | | | | |  __/\__ \
 |_|  |_|_(_)   |_|  |_|\___|_|  |_| |_| |_|\___||___/
BANNER
    echo -e "${RESET}"

    # Check Ports
    WEB_STATUS="${RED}OFFLINE ✗${RESET}"
    ROUTER_STATUS="${RED}OFFLINE ✗${RESET}"
    if lsof -Pi :8787 -sTCP:LISTEN -t >/dev/null 2>&1; then
        WEB_STATUS="${GREEN}ONLINE :8787 ✓${RESET}"
    fi
    if lsof -Pi :20128 -sTCP:LISTEN -t >/dev/null 2>&1; then
        ROUTER_STATUS="${GREEN}ONLINE :20128 ✓${RESET}"
    fi

    echo -e "  ┌────────────────────────────────────────────────────────────┐"
    echo -e "  │  ${BOLD}WebUI:${RESET} $WEB_STATUS     ${BOLD}9Router:${RESET} $ROUTER_STATUS  │"
    echo -e "  └────────────────────────────────────────────────────────────┘"
    echo -e ""
    echo -e "  ${BOLD}${CYAN}[1]${RESET} 🌐 ${BOLD}Open WebUI in Browser${RESET} (Chrome / Firefox)"
    echo -e "  ${BOLD}${CYAN}[2]${RESET} 🚀 ${BOLD}Start / Revive Stack & Watchdog${RESET}"
    echo -e "  ${BOLD}${CYAN}[3]${RESET} 🛑 ${BOLD}Stop All Daemons${RESET}"
    echo -e "  ${BOLD}${CYAN}[4]${RESET} ☁️  ${BOLD}Cloudflare Quick Tunnel${RESET} (Access from Laptop/PC)"
    echo -e "  ${BOLD}${CYAN}[5]${RESET} ⚡ ${BOLD}Hermes Interactive CLI Chat${RESET}"
    echo -e "  ${BOLD}${CYAN}[6]${RESET} 🩺 ${BOLD}Run System Doctor & Diagnostics${RESET}"
    echo -e "  ${BOLD}${CYAN}[7]${RESET} 🔄 ${BOLD}Update All Stack Components${RESET}"
    echo -e "  ${BOLD}${CYAN}[0]${RESET} 🚪 ${BOLD}Exit to Termux Shell${RESET}"
    echo -e ""
    echo -n -e "  ${BOLD}${YELLOW}Select an option [0-7]: ${RESET}"
    read -r opt || break

    case "$opt" in
        1)
            echo -e "\n${BLUE}[*] Launching browser...${RESET}"
            if command -v hermes-web >/dev/null 2>&1; then
                hermes-web
            elif command -v termux-open-url >/dev/null 2>&1; then
                termux-open-url http://localhost:8787
            else
                am start -a android.intent.action.VIEW -d "http://localhost:8787" >/dev/null 2>&1 || true
            fi
            sleep 1
            ;;
        2)
            echo -e "\n${GREEN}[*] Starting services...${RESET}"
            if command -v hermes-start >/dev/null 2>&1; then
                hermes-start
            fi
            read -r -p "Press [Enter] to continue..."
            ;;
        3)
            echo -e "\n${RED}[*] Stopping services...${RESET}"
            if command -v hermes-stop >/dev/null 2>&1; then
                hermes-stop
            fi
            read -r -p "Press [Enter] to continue..."
            ;;
        4)
            echo -e "\n${CYAN}[*] Starting Cloudflare Tunnel...${RESET}"
            if [ -f "$(dirname "$0")/tunnel.sh" ]; then
                bash "$(dirname "$0")/tunnel.sh"
            elif command -v hermes-share >/dev/null 2>&1; then
                hermes-share
            fi
            read -r -p "Press [Enter] to continue..."
            ;;
        5)
            echo -e "\n${GREEN}[*] Entering Hermes CLI...${RESET}"
            if command -v hermes-cli >/dev/null 2>&1; then
                hermes-cli
            fi
            ;;
        6)
            echo -e "\n${CYAN}[*] Running Diagnostics...${RESET}"
            if command -v hermes-doctor >/dev/null 2>&1; then
                hermes-doctor
            fi
            read -r -p "Press [Enter] to continue..."
            ;;
        7)
            echo -e "\n${YELLOW}[*] Updating Stack...${RESET}"
            if command -v hermes-update >/dev/null 2>&1; then
                hermes-update
            fi
            read -r -p "Press [Enter] to continue..."
            ;;
        0)
            echo -e "\n${GREEN}Exiting. Have a productive session! 🤍${RESET}\n"
            break
            ;;
        *)
            echo -e "\n${RED}Invalid option.${RESET}"
            sleep 1
            ;;
    esac
done
