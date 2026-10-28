#!/bin/bash
# Copy config/ to ~/.config (backing up anything that would be overwritten)
# and wire the bashrc, XCompose and the default theme.

set -e

backup_dir="$HOME/.config/debianarchy-backup-$(date +%Y%m%d-%H%M%S)"

cd "$DEBIANARCHY_PATH/config"
find . -type f | while read -r f; do
  target="$HOME/.config/${f#./}"
  if [[ -f $target ]] && ! cmp -s "$f" "$target"; then
    mkdir -p "$backup_dir/$(dirname "${f#./}")"
    mv "$target" "$backup_dir/${f#./}"
  fi
  mkdir -p "$(dirname "$target")"
  cp "$f" "$target"
done
[[ -d $backup_dir ]] && echo "Previous configs backed up to $backup_dir"

# bash
if [[ -f $HOME/.bashrc ]] && ! grep -q debianarchy "$HOME/.bashrc"; then
  mv "$HOME/.bashrc" "$HOME/.bashrc.pre-debianarchy"
fi
cp "$DEBIANARCHY_PATH/default/bashrc" "$HOME/.bashrc"

# XCompose (CapsLock is the compose key)
cat >"$HOME/.XCompose" <<XC
include "$DEBIANARCHY_PATH/default/xcompose"

# Personal identity shortcuts (CapsLock, space, n / e)
<Multi_key> <space> <n> : "$(getent passwd "$USER" | cut -d: -f5 | cut -d, -f1)"
<Multi_key> <space> <e> : "$(git config --global user.email 2>/dev/null)"
XC

mkdir -p "$HOME/Pictures" "$HOME/Videos"

# Render the default theme (re-running keeps the current one)
current=$(cat "$HOME/.config/debianarchy/current/theme.name" 2>/dev/null || echo tokyo-night)
"$DEBIANARCHY_PATH/bin/debianarchy-theme-set" "$current"
