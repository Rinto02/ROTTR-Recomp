# ROTTR-Recomp

**Rise of the Tomb Raider — Android Port via Translation Layers**

A project to run Rise of the Tomb Raider on Android devices natively using
translation layers (Box64 + Wine + DXVK + Turnip), without emulation or
cloud streaming.

## Architecture

```
┌──────────────────────────────────────────────┐
│          Rise of the Tomb Raider             │
│           (Windows x86_64 binary)            │
├──────────────────────────────────────────────┤
│  Wine / Proton     (Win32 → Linux syscalls)  │
├──────────────────────────────────────────────┤
│  DXVK 2.4+         (DirectX 11 → Vulkan)    │
├──────────────────────────────────────────────┤
│  Box64              (x86_64 → ARM64 JIT)     │
├──────────────────────────────────────────────┤
│  Turnip Driver      (Vulkan → Adreno GPU)    │
├──────────────────────────────────────────────┤
│  Android / Termux   (Host OS)                │
└──────────────────────────────────────────────┘
```

## Requirements

### Hardware
- **SoC:** Snapdragon 8 Gen 2 or newer (Adreno 740+)
- **RAM:** 8 GB minimum, 12 GB+ recommended
- **Storage:** ~40 GB free (game files + runtime)
- **Vulkan:** 1.3 support required

### Software
- Android 12+ with Termux installed
- Box64 (ARM64 x86_64 translator)
- Wine 9.0+ or Proton
- DXVK 2.4+ (DirectX → Vulkan)
- Mesa Turnip Vulkan driver (for Adreno GPUs)

## Project Structure

```
rottr/
├── README.md                 # This file
├── LICENSE                   # MIT License
├── config/
│   ├── dxvk.conf             # DXVK tuning for ROTTR
│   ├── box64.env             # Box64 dynarec environment
│   └── wine.reg              # Wine registry overrides
├── scripts/
│   ├── setup-termux.sh       # Install all dependencies in Termux
│   ├── setup-prefix.sh       # Create & configure Wine prefix
│   ├── run-rottr.sh          # Launch the game
│   └── benchmark.sh          # Run built-in benchmark
├── patches/
│   ├── rottr-settings.reg    # Optimal in-game settings via registry
│   └── dxvk-shader-cache/    # Pre-compiled shader cache (optional)
├── docs/
│   ├── SETUP.md              # Detailed setup guide
│   ├── PERFORMANCE.md        # Tuning & benchmarks
│   ├── COMPATIBILITY.md      # Device compatibility list
│   └── TROUBLESHOOTING.md    # Common issues & fixes
└── launcher/
    └── src/                  # Future: Android launcher app
```

## Quick Start

```bash
# 1. Clone this repo in Termux
git clone https://github.com/Rinto02/ROTTR-Recomp.git
cd ROTTR-Recomp

# 2. Install dependencies
bash scripts/setup-termux.sh

# 3. Set up Wine prefix with ROTTR configs
bash scripts/setup-prefix.sh

# 4. Copy your ROTTR game files into the prefix
# (You need a legitimate copy of the game)

# 5. Launch
bash scripts/run-rottr.sh
```

## Performance Targets

| Setting            | Target Value       |
|--------------------|--------------------|
| Resolution         | 720p (1280×720)    |
| Graphics Preset    | Low / Lowest       |
| Target FPS         | 30 FPS (locked)    |
| Anti-Aliasing      | Off / FXAA         |
| Shadows            | Low                |
| Texture Quality    | Medium             |

## Legal Notice

This project does **not** include any game files, assets, or copyrighted material.
You must own a legitimate copy of Rise of the Tomb Raider (Steam/GOG) to use this.
This project only provides configuration, scripts, and translation layer setup.

## License

MIT License — see [LICENSE](LICENSE)

## Credits

- [Box64](https://github.com/ptitSeb/box64) — x86_64 → ARM64 translation
- [Wine](https://www.winehq.org/) — Windows compatibility layer
- [DXVK](https://github.com/doitsujin/dxvk) — DirectX → Vulkan translation
- [Mesa Turnip](https://docs.mesa3d.org/drivers/freedreno.html) — Open-source Adreno Vulkan driver
