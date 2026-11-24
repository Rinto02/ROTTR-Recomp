#!/usr/bin/env bash
# ============================================================
# benchmark.sh — Run ROTTR benchmark & collect results
# ============================================================
# Launches the built-in benchmark and logs FPS data.
#
# Usage: bash scripts/benchmark.sh
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/benchmarks"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/benchmark_${TIMESTAMP}.log"

mkdir -p "$LOG_DIR"

echo "============================================" | tee "$LOG_FILE"
echo "  ROTTR-Recomp Benchmark" | tee -a "$LOG_FILE"
echo "  $(date)" | tee -a "$LOG_FILE"
echo "============================================" | tee -a "$LOG_FILE"

# Collect device info
echo "" | tee -a "$LOG_FILE"
echo "Device Info:" | tee -a "$LOG_FILE"
echo "  SoC:    $(getprop ro.hardware.chipname 2>/dev/null || echo 'unknown')" | tee -a "$LOG_FILE"
echo "  Model:  $(getprop ro.product.model 2>/dev/null || echo 'unknown')" | tee -a "$LOG_FILE"
echo "  RAM:    $(free -h | awk '/^Mem:/{print $2}')" | tee -a "$LOG_FILE"
echo "  Kernel: $(uname -r)" | tee -a "$LOG_FILE"

# Vulkan info
echo "" | tee -a "$LOG_FILE"
echo "Vulkan Driver:" | tee -a "$LOG_FILE"
vulkaninfo --summary 2>/dev/null | grep -E "driverName|driverVersion|deviceName|apiVersion" | tee -a "$LOG_FILE" || echo "  (vulkaninfo not available)" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "Starting benchmark..." | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Run with DXVK HUD capturing FPS
export DXVK_HUD="fps,gpuload,compiler"
bash "$SCRIPT_DIR/run-rottr.sh" --benchmark 2>&1 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "Benchmark complete. Log saved to: $LOG_FILE" | tee -a "$LOG_FILE"
