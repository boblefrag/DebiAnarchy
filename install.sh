#!/bin/bash
# DebiAnarchy installer — Omarchy's Hyprland setup on Debian testing.
#
#   git clone https://github.com/boblefrag/DebiAnarchy ~/.local/share/debianarchy
#   ~/.local/share/debianarchy/install.sh
#
# Run as your regular user (sudo is used when needed). Each step can be re-run alone:
#   ~/.local/share/debianarchy/install/20-packages.sh

set -eE

export DEBIANARCHY_PATH="$HOME/.local/share/debianarchy"
export DEBIANARCHY_INSTALL="$DEBIANARCHY_PATH/install"
export PATH="$DEBIANARCHY_PATH/bin:$PATH"

if [[ $(realpath "$(dirname "$0")") != $(realpath "$DEBIANARCHY_PATH") ]]; then
  echo "Clone DebiAnarchy into $DEBIANARCHY_PATH first:"
  echo "  git clone https://github.com/boblefrag/DebiAnarchy $DEBIANARCHY_PATH"
  exit 1
fi

trap 'echo -e "\n\e[31mDebiAnarchy install failed at: $BASH_COMMAND\e[0m\nFix the issue and re-run install.sh (every step is idempotent)."' ERR

for step in "$DEBIANARCHY_INSTALL"/[0-9]*.sh; do
  echo -e "\n\e[1;35m==> $(basename "$step")\e[0m"
  bash "$step"
done

echo -e "\n\e[1;32mDebiAnarchy is installed. Reboot and pick the \"DebiAnarchy\" session in SDDM.\e[0m"
