# DebiAnarchy

**Omarchy, on Debian testing.**

> Let's be clear: the real project is [Omarchy](https://omarchy.org) by DHH
> ([basecamp/omarchy](https://github.com/basecamp/omarchy)). The vision, the look, the
> keybindings, the choice of tools: that's all him. DebiAnarchy only fixes its one and only
> flaw: **not running on the best operating system in the world.** 🍥

DebiAnarchy takes Omarchy's Hyprland setup (based on **v3.8.4**, the last release with the
classic `hyprland.conf` config and waybar/mako/swayosd) and ports it to Debian testing:
apt packages, configs, `debianarchy-*` scripts in place of `omarchy-*`, and themes.

## Install

Start from a minimal Debian testing (forky) install (netinst with no desktop environment, only
"standard system utilities") and a user with `sudo`, then:

```bash
sudo apt install -y git
git clone https://github.com/boblefrag/DebiAnarchy ~/.local/share/debianarchy
~/.local/share/debianarchy/install.sh
```

Reboot, then pick the **DebiAnarchy** session in SDDM.

Useful variables:

| Variable | Effect |
|---|---|
| `DEBIANARCHY_YES=1` | answer yes to every extras prompt |
| `DEBIANARCHY_AUTOLOGIN=1` | SDDM autologin (only if your disk is encrypted) |
| `DEBIANARCHY_FORCE=1` | try anyway on Debian stable (unsupported) |

Every step in `install/` is idempotent and can be re-run on its own.

## What's inside

```
packages/          apt lists (base, desktop, fonts, apps, dev), Debian testing names
install/           install steps (apt sources, packages, extras, configs, services, login)
config/            → copied to ~/.config (yours to edit)
default/           → read in place from ~/.local/share/debianarchy (don't edit, override)
bin/               debianarchy-*: menu, themes, captures, launchers, toggles, update
themes/            12 Omarchy themes (colors.toml) rendered through default/themed/*.tpl
```

Same layout as Omarchy: `~/.config/hypr/hyprland.conf` sources the defaults from
`~/.local/share/debianarchy/default/hypr/`, then your own files (`bindings.conf`,
`monitors.conf`, `input.conf`, `looknfeel.conf`, `autostart.conf`), which override them.

## Omarchy (Arch) → DebiAnarchy (Debian)

Everything available in Debian testing comes from apt (161 packages, all checked against
testing). For the rest:

| Omarchy | DebiAnarchy | Why |
|---|---|---|
| walker / elephant | **fuzzel** (`debianarchy-launcher`, `debianarchy-menu`) | walker isn't packaged |
| satty | **swappy** | satty isn't packaged |
| gpu-screen-recorder | **wf-recorder** | no binary in testing |
| ghostty | **alacritty** (+ foot, kitty) | ghostty isn't packaged; alacritty is Omarchy's default anyway |
| polkit-gnome | **hyprpolkitagent** | |
| evince | **papers** | GNOME's replacement |
| tldr | **tealdeer** | |
| dust | **du-dust** | Debian name |
| fd, bat | fd-find, bat (+ `fd`/`bat` symlinks in `~/.local/bin`) | binaries renamed `fdfind`/`batcat` |
| impala / bluetui / wiremix | `cargo install` (optional), otherwise **nmtui / bluetoothctl / pulsemixer** | not packaged |
| mise, gh | official upstream apt repos | not in Debian |
| lazydocker | GitHub release binary | not packaged |
| omarchy-nvim | LazyVim starter | |
| obsidian, localsend, signal, spotify, pinta | **Flatpak** (Flathub) | not in Debian |
| typora, 1password, dropbox… | not installed | proprietary, add them yourself |
| limine + snapper | GRUB from the Debian installer | the bootloader is left alone |
| omarchy-screensaver, voxtype, weather, reminders | not ported | Omarchy-specific |
| wallpapers | not included | drop images in `~/.config/debianarchy/backgrounds/<theme>/` (otherwise a flat theme-colored background) |

Hyprland ≥ 0.53 is required (new `windowrule = …, match:…` syntax); testing ships 0.56.
That's why Debian stable isn't supported.

## Main keybindings

Same as Omarchy. `Super + K` lists them all.

| Keys | Action |
|---|---|
| `Super + Space` | app launcher |
| `Super + Alt + Space` | DebiAnarchy menu |
| `Super + Escape` | lock / suspend / restart / shut down |
| `Super + Return` | terminal (in the active terminal's directory) |
| `Super + Shift + B` | browser |
| `Super + Shift + F` | file manager |
| `Super + W` | close window |
| `Super + 1…0` | workspaces |
| `Super + T` / `F` | floating / fullscreen |
| `Super + Shift + Ctrl + Space` | switch theme |
| `Print` / `Alt + Print` | screenshot / screen recording |
| `Super + Ctrl + V` | clipboard history |
| `Super + Ctrl + E` | emoji picker |
| `CapsLock` | compose key |

Non-US keyboard: set `kb_layout` in `~/.config/hypr/input.conf` (e.g. `kb_layout = fr,us`).

## Themes

```bash
debianarchy-theme-list
debianarchy-theme-set catppuccin
```

A theme is a single `colors.toml`. To make your own, drop it in
`~/.config/debianarchy/themes/<name>/colors.toml` (add an empty `light.mode` file for a light
theme). The templates in `default/themed/` generate alacritty, kitty, foot, hyprland,
hyprlock, waybar, mako, swayosd, fuzzel and btop configs.

## Updating

```bash
debianarchy-update   # git pull of this repo + apt full-upgrade + flatpak + mise
```

Waybar shows the number of pending apt upgrades.

## Credits

All the credit goes to [Omarchy](https://github.com/basecamp/omarchy) and DHH: the Hyprland,
waybar and mako configs, the themes and the scripts are directly derived from it (MIT license,
see `LICENSE.omarchy`). DebiAnarchy is not affiliated with Omarchy or Basecamp.
