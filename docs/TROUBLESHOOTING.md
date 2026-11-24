# Troubleshooting — ROTTR-Recomp

## Common Issues

### Game won't start / crashes immediately

**Cause:** Game is trying to use DirectX 12.

**Fix:** Ensure `ROTTR.ini` has:
```ini
[Rendering]
RenderingAPI=DirectX11
```
The setup script should handle this, but verify manually if needed:
```bash
cat ~/.rottr-prefix/drive_c/Games/ROTTR/ROTTR.ini | grep RenderingAPI
```

---

### Black screen after launch

**Cause:** DXVK not installed or Vulkan driver missing.

**Fix:**
```bash
# Verify DXVK DLLs exist
ls ~/.rottr-prefix/drive_c/windows/system32/d3d11.dll

# Verify Vulkan works
vulkaninfo --summary
```

If DXVK DLLs are missing, re-run:
```bash
bash scripts/setup-prefix.sh
```

---

### Very low FPS (< 10)

**Causes & Fixes:**
1. **Resolution too high** — Set to 960×540 or 720p in ROTTR.ini
2. **Wrong GPU driver** — Use Turnip driver, not stock Adreno
3. **Thermal throttling** — Use a phone cooler, play in short sessions
4. **Box64 settings too conservative** — Try aggressive settings in `config/box64.env`

---

### No audio

**Cause:** PulseAudio not running.

**Fix:**
```bash
pulseaudio --start --daemonize
export PULSE_SERVER=127.0.0.1
```

---

### Gamepad not working

**Cause:** XInput not mapped correctly in Wine.

**Fix:** Copy Xidi DLLs into the game directory:
```bash
# Download Xidi and place dinput8.dll in the game folder
cp /path/to/xidi/dinput8.dll ~/.rottr-prefix/drive_c/Games/ROTTR/
```

Then set DLL override:
```bash
wine reg add "HKCU\Software\Wine\DllOverrides" /v dinput8 /t REG_SZ /d "native,builtin" /f
```

---

### "Out of memory" crash

**Cause:** Game tries to allocate more memory than available.

**Fix:**
1. Lower texture quality to Low
2. Set `VideoMemorySize` to `1024` in `config/wine.reg`
3. Close all other apps before launching
4. Ensure at least 4GB free RAM before starting

---

### Shader compilation stutter

**Cause:** DXVK compiling shaders on first run.

**Fix:** This is normal on first launch. Subsequent launches use the cache.
Enable async compilation in `config/dxvk.conf`:
```
dxvk.enableAsync = True
```

---

## Getting Help

If your issue isn't listed here:
1. Run with debug mode: `bash scripts/run-rottr.sh --debug`
2. Check the log output for errors
3. Open an issue at: https://github.com/Rinto02/ROTTR-Recomp/issues
