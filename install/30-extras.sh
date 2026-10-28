#!/bin/bash
# Everything Omarchy ships that Debian doesn't package: upstream apt repos,
# GitHub releases, flatpaks and cargo crates. Each block is skippable/idempotent.

set -e

ask() {
  [[ ${DEBIANARCHY_YES:-} == 1 ]] && return 0
  gum confirm "$1" 2>/dev/null || { read -rp "$1 [Y/n] " r; [[ -z $r || $r =~ ^[Yy] ]]; }
}

arch=$(dpkg --print-architecture)

# JetBrainsMono Nerd Font (all configs use it; only the plain font is in Debian)
if ! fc-list | grep -q "JetBrainsMono Nerd Font"; then
  tmp=$(mktemp -d)
  curl -fsSL -o "$tmp/font.tar.xz" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  mkdir -p "$HOME/.local/share/fonts/JetBrainsMonoNerd"
  tar -xJf "$tmp/font.tar.xz" -C "$HOME/.local/share/fonts/JetBrainsMonoNerd"
  rm -rf "$tmp"
  fc-cache -f
fi

# mise (Omarchy's runtime manager) — official apt repo
if ! command -v mise >/dev/null && ask "Install mise (ruby/node/python version manager)?"; then
  sudo install -dm 755 /etc/apt/keyrings
  curl -fsSL https://mise.jdx.dev/gpg-key.pub | sudo gpg --dearmor --yes -o /etc/apt/keyrings/mise-archive-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$arch] https://mise.jdx.dev/deb stable main" |
    sudo tee /etc/apt/sources.list.d/mise.list >/dev/null
  sudo apt update && sudo apt install -y mise
fi

# GitHub CLI — official apt repo
if ! command -v gh >/dev/null && ask "Install GitHub CLI (gh)?"; then
  sudo install -dm 755 /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  echo "deb [arch=$arch signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt update && sudo apt install -y gh
fi

# lazydocker — GitHub release binary
if ! command -v lazydocker >/dev/null && ask "Install lazydocker?"; then
  case $arch in amd64) la=x86_64 ;; arm64) la=arm64 ;; *) la= ;; esac
  if [[ -n $la ]]; then
    version=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | jq -r .tag_name)
    curl -fsSL "https://github.com/jesseduffield/lazydocker/releases/download/${version}/lazydocker_${version#v}_Linux_${la}.tar.gz" |
      tar -xz -C "$HOME/.local/bin" lazydocker
  fi
fi

# LazyVim (Omarchy's neovim setup)
if [[ ! -d $HOME/.config/nvim ]] && ask "Install LazyVim as your neovim config?"; then
  git clone --depth 1 https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
fi

# Rust TUIs Omarchy uses for wifi/bluetooth/audio (fallbacks: nmtui, bluetoothctl, pulsemixer)
if ask "Build impala, bluetui and wiremix with cargo (takes a few minutes)?"; then
  sudo apt install -y libdbus-1-dev libpipewire-0.3-dev libclang-dev pkg-config
  for crate in impala bluetui wiremix; do
    command -v $crate >/dev/null || cargo install --locked $crate
  done
fi

# Desktop apps not in Debian, from Flathub
if ask "Install flatpak apps (Obsidian, LocalSend, Signal, Spotify, Pinta)?"; then
  sudo apt install -y flatpak
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install -y flathub md.obsidian.Obsidian org.localsend.localsend_app org.signal.Signal com.spotify.Client com.github.PintaProject.Pinta
fi

# Claude Code
if ! command -v claude >/dev/null && ask "Install Claude Code?"; then
  curl -fsSL https://claude.ai/install.sh | bash
fi
