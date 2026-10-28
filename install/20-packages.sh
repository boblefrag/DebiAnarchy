#!/bin/bash
# Install every package listed in packages/*.list

set -e

mapfile -t packages < <(cat "$DEBIANARCHY_PATH"/packages/*.list | sed 's/#.*//' | awk 'NF')
sudo DEBIAN_FRONTEND=noninteractive apt install -y "${packages[@]}"

# Debian renames a couple of binaries to avoid clashes; restore the usual names
mkdir -p "$HOME/.local/bin"
[[ -x /usr/bin/fdfind && ! -e $HOME/.local/bin/fd ]] && ln -s /usr/bin/fdfind "$HOME/.local/bin/fd"
[[ -x /usr/bin/batcat && ! -e $HOME/.local/bin/bat ]] && ln -s /usr/bin/batcat "$HOME/.local/bin/bat"
true
