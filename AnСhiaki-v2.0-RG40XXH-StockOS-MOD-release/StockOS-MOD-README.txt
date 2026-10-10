# Retro Chiaki for Anbernic RG40XX H — StockOS MOD

This is an experimental StockOS MOD package based on the last RG40XX H build. Target: Anbernic RG40XX H (H700), StockOS MOD 4.0.0. The upstream StockOS MOD project lists RG40XX H as supported; its PortMaster compatibility patch is integrated from MOD 3.9.8.

## Requirements and installation

- Install and run PortMaster once on StockOS MOD before installing this port.
- Extract this archive to the root of the games microSD card (TF2), merging the `ROMS` and `ports` folders with existing folders. Do not put the files inside an extra `ports` directory.
- Confirm these paths exist: `ROMS/Ports/Chiaki.sh` and `ports/chiaki/chiaki`.
- Launch Chiaki from the Ports list.

## Controls

The RG40XX H button/axis mapping and the previously confirmed face-button layout are preserved. During streaming, **M + Start** maps to PS5 Touchpad + Options and closes Chiaki back to StockOS. Select is mapped to Guide rather than Touchpad for this exit combination.

## Audio and diagnostics

The launcher uses the system ALSA plugin directory only if the muOS-specific PipeWire module exists; otherwise it leaves the StockOS ALSA configuration untouched. Audio routing has not yet been verified on StockOS MOD.

The binary and launcher have not been tested on the target StockOS MOD device. If launch fails, inspect `ports/chiaki/log.txt` on the games card. This is a test package, not a confirmed working release.