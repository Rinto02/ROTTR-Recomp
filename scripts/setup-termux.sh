#!/usr/bin/env bash
# ============================================================
# setup-termux.sh — Install all ROTTR-Recomp dependencies
# ============================================================
# Run this once in Termux to set up the full translation layer
# stack: Box64, Wine, DXVK, and Turnip Vulkan driver.
#
# Usage: bash scripts/setup-termux.sh
# ============================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()   { echo -e "${GREEN}[ROTTR]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# --- Check environment ---
if [ ! -d "/data/data/com.termux" ]; then
    error "This script must be run inside Termux on Android."
fi

ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ]; then
    error "ARM64 (aarch64) device required. Detected: $ARCH"
fi

log "Setting up ROTTR-Recomp translation layer stack..."
log "Architecture: $ARCH"

# --- Update packages ---
log "Updating Termux packages..."
pkg update -y && pkg upgrade -y

# --- Install base dependencies ---
log "Installing base packages..."
pkg install -y \
    x11-repo \
    tur-repo \
    pulseaudio \
    wget \
    git \
    cmake \
    make \
    clang \
    python3 \
    proot \
    xwayland \
    virglrenderer \
    vulkan-tools \
    vulkan-headers \
    mesa-vulkan-icd-freedreno

# --- Install Box64 ---
log "Checking Box64..."
if command -v box64 &>/dev/null; then
    log "Box64 already installed: $(box64 --version 2>&1 | head -1)"
else
    log "Installing Box64..."
    # Try package manager first
    if pkg install -y box64 2>/dev/null; then
        log "Box64 installed via pkg."
    else
        warn "Box64 not in repos. Building from source..."
        BUILD_DIR=$(mktemp -d)
        cd "$BUILD_DIR"
        git clone --depth 1 https://github.com/ptitSeb/box64.git
        cd box64
        mkdir build && cd build
        cmake .. \
            -DARM_DYNAREC=ON \
            -DCMAKE_BUILD_TYPE=RelWithDebInfo \
            -DCMAKE_INSTALL_PREFIX=/data/data/com.termux/files/usr
        make -j$(nproc)
        make install
        cd /
        rm -rf "$BUILD_DIR"
        log "Box64 built and installed."
    fi
fi

# --- Install Wine ---
log "Checking Wine..."
if command -v wine &>/dev/null; then
    log "Wine already installed: $(wine --version 2>&1)"
else
    log "Installing Wine..."
    if pkg install -y wine 2>/dev/null; then
        log "Wine installed via pkg."
    else
        warn "Wine not in repos. Attempting tur-repo..."
        pkg install -y wine-stable 2>/dev/null || \
        pkg install -y wine-devel 2>/dev/null || \
        error "Could not install Wine. Please install manually.
See: https://github.com/AkiMaximworking/wine-termux"
    fi
fi

# --- Download DXVK ---
DXVK_VERSION="2.4.1"
DXVK_DIR="$HOME/.local/share/dxvk"
log "Setting up DXVK ${DXVK_VERSION}..."

if [ -d "$DXVK_DIR" ]; then
    log "DXVK directory already exists at $DXVK_DIR"
else
    mkdir -p "$DXVK_DIR"
    DXVK_URL="https://github.com/doitsujin/dxvk/releases/download/v${DXVK_VERSION}/dxvk-${DXVK_VERSION}.tar.gz"
    log "Downloading DXVK from: $DXVK_URL"
    wget -qO /tmp/dxvk.tar.gz "$DXVK_URL" || error "Failed to download DXVK"
    tar -xzf /tmp/dxvk.tar.gz -C "$DXVK_DIR" --strip-components=1
    rm -f /tmp/dxvk.tar.gz
    log "DXVK extracted to $DXVK_DIR"
fi

# --- Verify Turnip Vulkan driver ---
log "Checking Vulkan driver..."
if vulkaninfo --summary 2>/dev/null | grep -qi "freedreno\|turnip\|adreno"; then
    log "Turnip/Freedreno Vulkan driver detected."
elif vulkaninfo --summary 2>/dev/null | grep -qi "vulkan"; then
    warn "Vulkan driver found but may not be Turnip. Performance may vary."
else
    warn "No Vulkan driver detected. Install mesa-vulkan-icd-freedreno or
provide a custom Turnip driver for your device."
fi

# --- Summary ---
echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  ROTTR-Recomp — Setup Complete${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo -e "  Box64:  $(command -v box64 2>/dev/null && echo '✅ Installed' || echo '❌ Missing')"
echo -e "  Wine:   $(command -v wine 2>/dev/null && echo '✅ Installed' || echo '❌ Missing')"
echo -e "  DXVK:   $([ -d "$DXVK_DIR" ] && echo '✅ Installed' || echo '❌ Missing')"
echo -e "  Vulkan: $(command -v vulkaninfo 2>/dev/null && echo '✅ Available' || echo '❌ Missing')"
echo ""
echo -e "  Next step: ${GREEN}bash scripts/setup-prefix.sh${NC}"
echo ""
