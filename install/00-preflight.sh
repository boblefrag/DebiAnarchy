#!/bin/bash
# Refuse to run anywhere but Debian testing/sid, as a regular user with sudo.

set -e

if [[ $EUID -eq 0 ]]; then
  echo "Run DebiAnarchy as your regular user, not root."
  exit 1
fi

. /etc/os-release
if [[ $ID != debian ]]; then
  echo "DebiAnarchy only supports Debian (found: $ID)."
  exit 1
fi

# Stable releases have a VERSION_ID; testing and sid don't
if [[ -n $VERSION_ID && ${DEBIANARCHY_FORCE:-} != 1 ]]; then
  echo "This is Debian $VERSION_ID (stable). DebiAnarchy targets Debian testing:"
  echo "Hyprland >= 0.53 is required. Set DEBIANARCHY_FORCE=1 to try anyway."
  exit 1
fi

sudo -v
