# Device Compatibility — ROTTR-Recomp

## Tested Devices

> **Help us grow this list!** If you test on your device, please open an
> issue or PR with your results.

| Device | SoC | RAM | Status | FPS (720p Low) | Notes |
|--------|-----|-----|--------|----------------|-------|
| *TBD* | SD 8 Gen 3 | 12GB | 🔲 Untested | — | — |
| *TBD* | SD 8 Gen 2 | 12GB | 🔲 Untested | — | — |
| *TBD* | SD 8 Gen 1 | 8GB | 🔲 Untested | — | — |
| *TBD* | SD 870 | 8GB | 🔲 Untested | — | — |
| *TBD* | Dimensity 9300 | 12GB | 🔲 Untested | — | — |

## Status Legend

- ✅ **Playable** — Stable 25+ FPS, no major crashes
- ⚠️ **Runs** — Boots and plays but with issues (crashes, low FPS)
- ❌ **Broken** — Crashes or fails to boot
- 🔲 **Untested** — No reports yet

## GPU Requirements

### Adreno (Qualcomm) — Best Support
- Requires Vulkan 1.1+ (1.3 recommended)
- Use **Turnip driver** for best compatibility
- Adreno 640+ required, 740+ recommended

### Mali (MediaTek / Samsung) — Experimental
- Requires custom Winlator Mali builds
- Performance significantly lower than Adreno
- May need wrapper libraries (Gladio/DXML)

### PowerVR (older devices) — Not Supported
- Insufficient Vulkan support
