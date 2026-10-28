#!/bin/bash
# apt sources: testing with contrib, non-free and non-free-firmware (firmware, codecs).

set -e

if [[ -f /etc/apt/sources.list.d/debian.sources ]]; then
  sudo sed -i -E 's/^Components:.*/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources
elif [[ -f /etc/apt/sources.list ]]; then
  sudo sed -i -E 's/^(deb(-src)? +(\[[^]]*\] +)?[^ ]+ +[^ ]+) .*/\1 main contrib non-free non-free-firmware/' /etc/apt/sources.list
fi

# Recommends drag in half of GNOME/KDE; stay lean like Omarchy
echo 'APT::Install-Recommends "false";' | sudo tee /etc/apt/apt.conf.d/99debianarchy-no-recommends >/dev/null

sudo apt update
