# Changelog

Versions match `manifest.json`. This repository has no GitHub Release.

## 1.0.2

- Clicks send `hl.dsp.focus({ workspace = N })`. Omarchy evaluates Hyprland dispatch as Lua, and the previous `workspace N` string is a syntax error, so the click was dropped.
- A single monitor no longer draws a leading `1` in front of workspace 1.
- Three or more monitors are labeled `A`, `B`, `C`, up to `H`, left to right and then top to bottom. Digit labels collided with workspace numbers.
- The manifest description matches the 1.0.1 bracket rule.

## 1.0.1

- Brackets mark the workspace currently shown on every monitor, including the screen the bar is on. 1.0.0 bracketed only the other monitor.

## 1.0.0

- First published tree. Groups Hyprland workspace numbers by monitor on the Omarchy bar.
