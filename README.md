# Workspaces by monitor

An [Omarchy](https://omarchy.org) bar widget. The built-in switcher (`omarchy.workspaces`) draws the same workspace list on every screen and marks only the focused workspace. This one groups the numbers by screen, so a two-monitor bar can be read from either screen.

```
L [2] 4 | R 1 [8]
```

![Bar text L [2] 4 | R 1 [8]](preview.png)

`preview.png` shows that two-monitor reading on a dark bar. It is not a full desktop capture.

## How to read it

- `L` / `R` are side-by-side screens, ordered left to right. `T` / `B` are used when the vertical gap is larger than the horizontal gap.
- When only one group is shown, there is no letter. A digit in front of the numbers would look like another workspace.
- With three or more groups the labels are `A`, `B`, `C`, through `H`. Order is left to right, then top to bottom. A monitor with nothing in 1 through 10 is left out, so the letters do not skip.
- The label for the screen this bar is on stays bright. Labels for the other screens are dim.
- `[2]` is the workspace that screen is showing. Each screen gets its own brackets.
- A bright number without brackets has windows on that screen and is not the one showing.
- A dim number is on that screen, has no windows, and is not showing.
- A number is listed only when Hyprland already has that workspace on a monitor. This widget does not force the built-in switcher's always-present `1` through `5`.
- Workspace 10 is drawn as `0`, matching Omarchy's Super+0 binding. Ids outside 1 through 10 are ignored.

Click a number to focus that workspace. The click sends Hyprland's Lua dispatcher `hl.dsp.focus`, which is the form Omarchy's config uses. Omarchy's default Super+1 through Super+0 bindings are unchanged.

Hover a label or a number for the screen name and, when the shell knows it, the connector.

## Install

From a machine that already has Omarchy:

```bash
omarchy plugin add https://github.com/jordanpartridge/omarchy-workspaces.git
omarchy plugin enable jordan.workspaces
```

`omarchy plugin add` clones this repo into `~/.config/omarchy/plugins/jordan.workspaces` and checks the manifest. It asks before turning the widget on. Pass `--enable` to add and enable in one step. Review the tree before enabling. The add command clones files. It does not run a setup script from this repo.

Enabling puts the widget on the left, from `defaultSection` in `manifest.json`. If the built-in switcher is still on the bar, turn that one off:

```bash
omarchy plugin disable omarchy.workspaces
```

Update an existing checkout with:

```bash
omarchy plugin update jordan.workspaces
```

## Usage

Click a workspace number. Brackets follow the workspace each screen is showing. The widget does not scroll between workspaces, does not change the layout, and does not open a panel.

## Config

There is no settings schema and no keys to set on the layout entry. Placement is the bar layout:

```bash
omarchy bar move jordan.workspaces --section left
```

`--section` is `left`, `center`, or `right`. Dragging the widget on the bar writes the same layout to `~/.config/omarchy/shell.json`. This repo does not ship a copy of that file.

A vertical bar stacks the same items in one column.

## Requirements

- Omarchy, with its Hyprland bar (Quickshell) and the `omarchy plugin` commands.
- No extra packages for the widget itself.
- Hyprland on Omarchy's Lua config. This widget does not send the legacy `workspace N` dispatch string, which Omarchy rejects as invalid Lua.

## Limits

- At most 8 monitors. A monitor with no workspace id in 1 through 10 is skipped.
- At most 10 workspace ids per monitor.
- One copy on the bar (`allowMultiple` is false).

## Removing

```bash
omarchy plugin remove jordan.workspaces
```

This plugin writes no state, cache, credentials, units, or hooks. Nothing survives removal except a git checkout you made yourself outside Omarchy.

## Development

`./test_structure.sh` checks the manifest, the license, and that the widget file still matches this contract. It needs `bash`, `grep`, and `python3`. It does not start Omarchy or Hyprland.

On an Omarchy machine, the shell's own check is:

```bash
omarchy plugin validate ~/.config/omarchy/plugins/jordan.workspaces
```

## Version

`manifest.json` is at 1.0.2. Notes for 1.0.0, 1.0.1, and 1.0.2 are in [CHANGELOG.md](CHANGELOG.md). This repository has no GitHub Release.

## License

[MIT](LICENSE). Copyright (c) 2026 Jordan Partridge.
