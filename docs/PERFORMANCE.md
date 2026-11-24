# Performance Guide — ROTTR-Recomp

## In-Game Settings

The setup script configures optimal settings automatically. If you need to
tweak further, edit `~/.rottr-prefix/drive_c/Games/ROTTR/ROTTR.ini`.

### Recommended Settings Matrix

| Setting | 8GB RAM | 12GB+ RAM |
|---------|---------|-----------|
| Resolution | 960×540 | 1280×720 |
| Textures | Low | Medium |
| Shadows | Off | Low |
| Anti-Aliasing | Off | FXAA |
| Ambient Occlusion | Off | Off |
| Tessellation | Off | Off |
| Motion Blur | Off | Off |
| Depth of Field | Off | Off |
| Level of Detail | Low | Low |
| PureHair | Off | Off |

## Box64 Dynarec Tuning

Edit `config/box64.env` to adjust CPU translation:

| Variable | Conservative | Balanced | Aggressive |
|----------|-------------|----------|------------|
| `BIGBLOCK` | 1 | 3 | 3 |
| `SAFEFLAGS` | 2 | 1 | 0 |
| `STRONGMEM` | 3 | 1 | 0 |
| `FASTNAN` | 0 | 1 | 1 |
| `FASTROUND` | 0 | 1 | 1 |

- **Conservative**: Maximum stability, lowest performance
- **Balanced**: Default — good for most devices
- **Aggressive**: Maximum performance, may cause crashes

## DXVK Tuning

Edit `config/dxvk.conf`:

| Setting | Low-end | High-end |
|---------|---------|----------|
| `maxFrameRate` | 20 | 30-60 |
| `numCompilerThreads` | 1 | 2-4 |
| `presentMode` | mailbox | mailbox |

## Thermal Management

Mobile devices throttle heavily under sustained load:

1. **Use a phone cooler** — essential for sessions over 10 minutes
2. **Lower brightness** — reduces heat from display
3. **Remove phone case** — allows passive cooling
4. **Play in cool environment** — ambient temperature matters

## Benchmarking

Run the built-in benchmark to test your settings:

```bash
bash scripts/benchmark.sh
```

Results are saved to `benchmarks/` with device info and FPS data.
