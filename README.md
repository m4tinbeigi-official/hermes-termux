<!-- DevSponsors Badges -->
<p align="center">
  <a href="https://devsponsors.github.io"><img src="https://img.shields.io/badge/DevSponsors-Verified_OSS-6366f1?style=for-the-badge&logo=github" alt="DevSponsors Verified"></a>
  <a href="https://devsponsors.github.io"><img src="https://img.shields.io/badge/Sponsor-DevSponsors_Hub-emerald?style=for-the-badge&logo=github-sponsors" alt="DevSponsors Sponsor"></a>
  <a href="https://devsponsors.github.io/mediakit.html"><img src="https://img.shields.io/badge/Infrastructure-DevSponsors_Cloud-ec4899?style=for-the-badge&logo=server" alt="DevSponsors Cloud"></a>
</p>

<div align="center">

# 📱 Mr Hermes & 9Router Stack for Android (Termux)

### Autonomous AI Brain & Self-Hosted Intelligence Suite on Your Phone

**Hermes Agent CLI** · **Mr Hermes WebUI (Port 8787)** · **9Router AI Gateway (Port 20128)** · **Cloudflare Remote Tunnel & QR**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Termux-3DDC84?logo=android&logoColor=white)](#-device--android-compatibility)
[![Architecture](https://img.shields.io/badge/Arch-ARM64%20%7C%20x86__64-blue)](#-device--android-compatibility)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/m4tinbeigi-official/hermes-termux/pulls)

One command. The entire Hermes agent ecosystem, multi-model AI routing gateway, modern responsive web UI, and self-healing background daemons automatically installed, configured, wired, and launched on Android Termux.

</div>

---

## ⚡️ Quick Install (One Command)

Open **Termux** on your Android phone and paste this single command:

```bash
pkg update -y && pkg install -y curl && curl -fsSL https://raw.githubusercontent.com/m4tinbeigi-official/hermes-termux/main/install.sh | bash
```

> 💡 **If `curl` is already installed on your Termux:**
> ```bash
> curl -fsSL https://raw.githubusercontent.com/m4tinbeigi-official/hermes-termux/main/install.sh | bash
> ```

---

## ✨ What is this?

**Hermes Termux Stack** transforms any Android smartphone into a dedicated, autonomous AI workstation. It bundles the complete Nous Research Hermes Agent ecosystem along with high-throughput multi-model gateway routing and browser controls:

| Component | Role | Network Port |
| :--- | :--- | :--- |
| 🖥️ **Mr Hermes WebUI** | Modern, responsive, RTL/LTR web dashboard with session management & file browser | `http://localhost:8787` |
| 🔀 **9Router AI Gateway** | Lightweight local model proxy with provider fallback, caching & token optimizer | `http://localhost:20128` |
| 🧠 **Hermes Agent** | Autonomous terminal agent core, self-improving skills & persistent memory | `hermes-cli` |
| ☁️ **Cloudflare Tunnel** | Encrypted global HTTPS bridge with ASCII QR Code for laptop/tablet pairing | `hermes-share` |
| 🛡️ **Self-Healing Watchdog** | Background process monitor that auto-revives services if Android LMK reclaims RAM | Background daemon |

---

## 🌟 Key Pro Features

- **🚀 Zero-Click Browser Launch:** The installer dispatches native Android VIEW intents (`termux-open-url` & `am start`) to automatically open `http://localhost:8787` in your default browser (Chrome/Firefox) the moment installation completes.
- **🎮 Cyberpunk Interactive TUI (`hermes`):** Type `hermes` in Termux at any time to enter an interactive dashboard displaying live port statuses, quick launch actions, log streams, and diagnostic controls.
- **☁️ Remote Access & ASCII QR Code (`hermes-share`):** Need to use the WebUI on your laptop, Mac, iPad, or desktop? Run `hermes-share` to spin up an instant Cloudflare tunnel and generate a high-contrast terminal QR code for instant camera pairing.
- **⚡ Self-Healing Daemon (Watchdog):** Android's Low Memory Killer (LMK) or aggressive battery managers can sleep background sockets. A lightweight background watchdog continuously polls ports 8787 and 20128 and automatically restarts any fallen services.
- **🔋 Doze & Battery Optimization Immunity:** Automatically invokes `termux-wake-lock` to ensure uninterrupted AI generation, multi-step subagent execution, and streaming when the screen is locked.
- **📲 Termux:Boot Auto-Start:** Provisions `~/.termux/boot/start-hermes.sh` so your AI stack automatically powers on in the background whenever your Android phone reboots.
- **🔘 Termux:Widget 1-Tap Home Screen Buttons:** Pre-seeds `~/.shortcuts/` with home screen launcher widgets (`🚀 Start Mr Hermes`, `🛑 Stop Mr Hermes`, `☁️ Hermes Tunnel`, `🩺 Hermes Doctor`).
- **📦 Pre-Seeded 9Router Combos & Database:** Automatically provisions the SQLite database with `sk-9router-admin` and sets up the `MrHermes` model fallback combo out of the box.

---

## 🛠 System Architecture

```
                 Android Device (Termux Userland)
                                │
                     ┌──────────▼──────────┐
                     │   proot-distro      │
                     │  (Ubuntu 22.04 LTS) │
                     └──────────┬──────────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        ▼                       ▼                       ▼
   ┌──────────┐           ┌───────────┐           ┌───────────┐
   │ 9Router  │           │  Hermes   │           │ Mr Hermes │
   │ Gateway  │◀──────────┤   Agent   │◀──────────┤   WebUI   │
   │  :20128  │           │    CLI    │           │   :8787   │
   └──────────┘           └───────────┘           └───────────┘
        │                       ▲                       ▲
        └───────────────────────┴───────────────────────┘
                                │
                       ┌────────▼────────┐
                       │ Cloudflare Host │ ──▶ Remote Access (Laptop, Tablet, PC)
                       │ (trycloudflare) │
                       └─────────────────┘
```

---

## 📱 Device & Android Compatibility

Tested and verified on over 95% of modern Android devices:

| Requirement | Minimum Spec | Recommended / Optimal Spec |
| :--- | :--- | :--- |
| **Android Version** | Android 7.0 (Nougat)+ | Android 10 to Android 15 |
| **CPU Architecture** | ARM 64-bit (`aarch64`) / x86_64 | `aarch64` (All smartphones produced after 2016) |
| **RAM (Memory)** | 2.0 GB RAM | 4.0 GB+ RAM (Stack consumes ~350MB–450MB under load) |
| **Storage (Disk)** | 1.5 GB free space | 3.0 GB+ free storage |
| **Termux Source** | **F-Droid** or **GitHub Releases** | ⚠️ **Never install from Google Play Store!** (See note below) |

### ⚠️ Critical Note on Google Play Termux:
The Google Play Store version of Termux was **deprecated in 2020** due to Android SDK target policy restrictions. If you install Termux from Google Play, repository mirrors fail with `404 / 403` errors.
- Download the official Termux build from **[F-Droid](https://f-droid.org/packages/com.termux/)** or **[GitHub Releases](https://github.com/termux/termux-app/releases)**.
- *Note:* The installer script includes automated source-healing logic to recover legacy Termux instances if old mirrors are detected.

---

## 📋 Termux CLI Commands & Shortcuts

After installation, the following commands are available globally in your Termux shell:

```bash
hermes          # Launch the Cyberpunk Interactive Command Center
hermes-web      # Start stack and open WebUI in your Android browser
hermes-share    # Create an encrypted Cloudflare HTTPS tunnel and display QR code
hermes-start    # Start 9Router, Hermes WebUI, and Watchdog in background
hermes-stop     # Cleanly terminate all background services and tunnels
hermes-status   # Display live port, PID, memory, and container status
hermes-doctor   # Run system diagnostics (hardware, wake-lock, disk, sockets)
hermes-update   # 1-click update for WebUI repo, 9Router, and Hermes Agent
hermes-cli      # Launch interactive Hermes Agent CLI terminal inside Ubuntu
```

---

## 💻 Remote Access from Laptop, Mac, or iPad

To control your Android AI instance from a computer on the same or external network:

1. In Termux, type:
   ```bash
   hermes-share
   ```
2. A secure Cloudflare HTTPS address (`https://*.trycloudflare.com`) and an ASCII QR code will appear in your terminal.
3. Scan the QR code or enter the link in your computer's browser. You now have full, zero-lag access to your agent, workspace, and model controls.
4. Press `Ctrl+C` in Termux to cleanly close the tunnel when finished.

---

## 🔬 Technical Details & Implementation

1. **Why `proot-distro Ubuntu`?**  
   Android uses `bionic libc`, which lacks standard GNU `glibc` symbols required by modern Python wheels (`cryptography`, `pydantic-core`, `uv`) and Node.js native add-ons. By operating inside an ultra-lightweight `proot-distro` Ubuntu 22.04 LTS container, all binaries run natively with zero emulation overhead.
2. **Shared Networking:**  
   `proot` containers inherit the Android Linux kernel network namespace. Therefore, binding to `127.0.0.1:8787` inside Ubuntu exposes the port directly to Android browsers and apps at `http://localhost:8787`.
3. **Process Supervision:**  
   Because Android does not run standard `systemd`, background services are managed via background detached processes paired with a self-healing health watchdog (`hermes-watchdog`).

---

## 📄 License

Developed for the open-source community with ❤️  
Licensed under the [MIT License](LICENSE).
