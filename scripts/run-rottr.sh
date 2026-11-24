#!/usr/bin/env bash
# ============================================================
# run-rottr.sh — Launch Rise of the Tomb Raider on Android
# ============================================================
# Launches ROTTR via Box64 + Wine + DXVK translation layers.
#
# Usage: bash scripts/run-rottr.sh [--benchmark] [--debug]
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()   { echo -e "${GREEN}[ROTTR]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# --- Parse arguments ---
BENCHMARK=false
DEBUG=false
for arg in "$@"; do
    case $arg in
        --benchmark) BENCHMARK=true ;;
        --debug)     DEBUG=true ;;
        --help|-h)
            echo "Usage: bash scripts/run-rottr.sh [--benchmark] [--debug]"
            echo ""
            echo "  --benchmark  Run the built-in benchmark instead of the game"
            echo "  --debug      Enable DXVK HUD and Wine debug output"
            exit 0
            ;;
    esac
done

# --- Configuration ---
WINEPREFIX="$HOME/.rottr-prefix"
GAME_DIR="$WINEPREFIX/drive_c/Games/ROTTR"
GAME_EXE="ROTTR.exe"

# --- Validate setup ---
[ -d "$WINEPREFIX" ] || error "Wine prefix not found. Run: bash scripts/setup-prefix.sh"
[ -f "$GAME_DIR/$GAME_EXE" ] || error "Game not found at $GAME_DIR/$GAME_EXE
Copy your Rise of the Tomb Raider files to: $GAME_DIR"

# --- Load Box64 environment ---
log "Loading translation layer configuration..."
source "$PROJECT_DIR/config/box64.env"

# --- Export Wine environment ---
export WINEPREFIX
export WINEARCH=win64

# --- DXVK config location ---
export DXVK_CONFIG_FILE="$WINEPREFIX/drive_c/dxvk.conf"

# --- Debug mode ---
if $DEBUG; then
    export DXVK_HUD="fps,devinfo,gpuload,compiler"
    export WINEDEBUG="warn+all"
    export BOX64_LOG=1
    export BOX64_DYNAREC_LOG=1
    log "Debug mode enabled (DXVK HUD + Wine/Box64 logging)"
else
    export DXVK_HUD="fps"
    export WINEDEBUG="-all"
fi

# --- Performance tuning ---
# Set CPU governor to performance if available
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
    CURRENT_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")
    log "Current CPU governor: $CURRENT_GOV"
    if [ "$CURRENT_GOV" != "performance" ]; then
        warn "Consider setting CPU governor to 'performance' for best results."
    fi
fi

# --- Start PulseAudio for game audio ---
log "Starting audio server..."
pulseaudio --start --daemonize 2>/dev/null || warn "PulseAudio not available. No audio."
export PULSE_SERVER=127.0.0.1

# --- Launch ---
cd "$GAME_DIR"

if $BENCHMARK; then
    log "Launching ROTTR Built-in Benchmark..."
    log "Resolution: 1280x720 | Preset: Low | FPS Cap: 30"
    echo ""
    wine "$GAME_EXE" -benchmark 2>&1
else
    log "Launching Rise of the Tomb Raider..."
    log "Resolution: 1280x720 | Preset: Low | FPS Cap: 30"
    log "Translation stack: Box64 → Wine → DXVK → Turnip Vulkan"
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────${NC}"
    echo -e "${CYAN}  Controls:${NC}"
    echo -e "${CYAN}  • Connect a Bluetooth/USB gamepad${NC}"
    echo -e "${CYAN}  • Press Ctrl+C to force quit${NC}"
    echo -e "${CYAN}────────────────────────────────────────────${NC}"
    echo ""
    wine "$GAME_EXE" 2>&1
fi

log "Game exited."
