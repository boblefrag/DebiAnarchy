#!/bin/bash
# SDDM with a uwsm-managed Hyprland session ("DebiAnarchy"), optional autologin.

set -e

sudo install -Dm644 "$DEBIANARCHY_PATH/default/wayland-sessions/debianarchy.desktop" /usr/share/wayland-sessions/debianarchy.desktop

sudo mkdir -p /etc/sddm.conf.d
if [[ ! -f /etc/sddm.conf.d/autologin.conf ]] && { [[ ${DEBIANARCHY_AUTOLOGIN:-} == 1 ]] ||
  gum confirm "Log in automatically (only if your disk is encrypted)?" 2>/dev/null; }; then
  sudo tee /etc/sddm.conf.d/autologin.conf >/dev/null <<SDDM
[Autologin]
User=$USER
Session=debianarchy
SDDM
fi

sudo systemctl enable sddm.service
# graphical boot
sudo systemctl set-default graphical.target

# Quiet splash boot with plymouth
if [[ -f /etc/default/grub ]] && ! grep -q 'splash' /etc/default/grub; then
  sudo sed -i -E 's/^GRUB_CMDLINE_LINUX_DEFAULT="([^"]*)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 splash"/' /etc/default/grub
  sudo update-grub
fi
sudo plymouth-set-default-theme -R bgrt 2>/dev/null || true
