# Setup Guide — ROTTR-Recomp

Detailed guide for setting up Rise of the Tomb Raider on Android.

## Prerequisites

### Hardware Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| SoC | Snapdragon 870 | Snapdragon 8 Gen 2+ |
| GPU | Adreno 650 | Adreno 740+ |
| RAM | 8 GB | 12 GB+ |
| Storage | 35 GB free | 50 GB free (with cache) |
| Android | 12 | 13+ |
| Vulkan | 1.1 | 1.3 |

### Software Requirements

- [Termux](https://f-droid.org/en/packages/com.termux/) (from F-Droid, **not** Play Store)
- A legitimate copy of Rise of the Tomb Raider (Steam or GOG)

---

## Step 1: Install Termux

1. Install Termux from **F-Droid** (the Play Store version is outdated)
2. Open Termux and grant storage permissions:
   ```bash
   termux-setup-storage
   ```

## Step 2: Clone ROTTR-Recomp

```bash
pkg install git -y
git clone https://github.com/Rinto02/ROTTR-Recomp.git
cd ROTTR-Recomp
```

## Step 3: Install Dependencies

```bash
bash scripts/setup-termux.sh
```

This installs:
- Box64 (x86_64 → ARM64 translator)
- Wine (Windows → Linux compatibility)
- DXVK (DirectX 11 → Vulkan translator)
- Mesa Turnip (Vulkan driver for Adreno GPUs)

## Step 4: Set Up Wine Prefix

```bash
bash scripts/setup-prefix.sh
```

This creates a Wine prefix at `~/.rottr-prefix` with:
- DXVK installed
- Optimal registry settings
- ROTTR graphics config (720p, Low preset)

## Step 5: Copy Game Files

Copy your ROTTR game files to the Wine prefix:

```bash
# If game files are on shared storage:
cp -r /storage/emulated/0/ROTTR/* ~/.rottr-prefix/drive_c/Games/ROTTR/

# Or specify the path during prefix setup:
bash scripts/setup-prefix.sh /path/to/your/rottr/files
```

The game directory should contain at least:
- `ROTTR.exe`
- Game data files (`.pak`, etc.)

## Step 6: Launch

```bash
bash scripts/run-rottr.sh
```

### Launch Options

```bash
# Normal launch
bash scripts/run-rottr.sh

# With debug overlay (FPS counter, GPU info)
bash scripts/run-rottr.sh --debug

# Run built-in benchmark
bash scripts/run-rottr.sh --benchmark
```

---

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues.

## Performance Tuning

See [PERFORMANCE.md](PERFORMANCE.md) for optimization tips.
