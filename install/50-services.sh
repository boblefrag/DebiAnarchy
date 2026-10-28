#!/bin/bash
# System services, firewall and groups

set -e

# Docker without sudo
sudo usermod -aG docker "$USER"

# Brightness/OSD (swayosd) and input devices
sudo usermod -aG video,input "$USER"

for svc in NetworkManager bluetooth cups avahi-daemon power-profiles-daemon docker.socket systemd-resolved; do
  sudo systemctl enable "$svc" 2>/dev/null || echo "warning: could not enable $svc"
done
# Don't make boot wait for the network
sudo systemctl mask NetworkManager-wait-online.service

# NetworkManager owns wifi; Debian's ifupdown would fight it over interfaces
if [[ -f /etc/network/interfaces ]] && grep -qE '^(auto|allow-hotplug) (wl|en)' /etc/network/interfaces; then
  sudo sed -i -E 's/^(auto|allow-hotplug|iface) ((wl|en)[^ ]*)/# \1 \2/' /etc/network/interfaces
fi

# mDNS for printers / .local hosts
sudo sed -i 's/^hosts:.*/hosts:          mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns/' /etc/nsswitch.conf

# Firewall: deny incoming except LocalSend, like Omarchy
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 53317/udp comment LocalSend
sudo ufw allow 53317/tcp comment LocalSend
sudo ufw --force enable

# zram swap (half the RAM, zstd)
sudo tee /etc/systemd/zram-generator.conf >/dev/null <<ZRAM
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
ZRAM
