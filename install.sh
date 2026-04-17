#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"
MACHINE=""

for arg in "$@"; do
    case $arg in
        --machine=*) MACHINE="${arg#*=}" ;;
    esac
done

if [[ -z "$MACHINE" ]]; then
    echo "Usage: $0 --machine=<name>"
    echo "Available machines: $(ls "$DOTFILES/machines/")"
    exit 1
fi

if [[ ! -d "$DOTFILES/machines/$MACHINE" ]]; then
    echo "Machine '$MACHINE' not found in $DOTFILES/machines/"
    exit 1
fi

# Detect OS
if [[ -f /etc/arch-release ]]; then
    OS="arch"
elif [[ -f /etc/debian_version ]]; then
    OS="debian"
elif [[ "$(uname)" == "Darwin" ]]; then
    OS="osx"
else
    echo "Unsupported OS"
    exit 1
fi

pkg_install() {
    for item in "$@"; do
        case "$OS" in
            debian) sudo apt -y install "$item" ;;
            osx)    brew install "$item" ;;
            arch)   sudo pacman -S --noconfirm "$item" ;;
        esac
    done
}

yay_install() {
    for item in "$@"; do
        yay -S --noconfirm "$item"
    done
}

link() {
    local src=$1 dst=$2
    [[ ! -L "$dst" ]] && ln -s "$src" "$dst"
}

echo "==> Setting up dotfiles for machine: $MACHINE (OS: $OS)"

# --- Git submodules ---
cd "$DOTFILES" && git submodule update --init

# --- Download antigen ---
curl -sL git.io/antigen > "$DOTFILES/antigen.zsh"

# --- pyenv ---
if [[ ! -d "$HOME/.pyenv" ]]; then
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
fi
if [[ ! -d "$HOME/.pyenv/plugins/pyenv-virtualenv" ]]; then
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$HOME/.pyenv/plugins/pyenv-virtualenv"
fi

# --- tmux plugin manager ---
[[ ! -d "$HOME/.tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# --- Common symlinks ---
link "$DOTFILES/common/zshrc"        "$HOME/.zshrc"
link "$DOTFILES/common/gitconfig"    "$HOME/.gitconfig"
link "$DOTFILES/common/antigenrc"    "$HOME/.antigenrc"
link "$DOTFILES/common/psqlrc"       "$HOME/.psqlrc"
link "$DOTFILES/common/pythonrc.py"  "$HOME/.pythonrc.py"
link "$DOTFILES/common/sbclrc"       "$HOME/.sbclrc"
link "$DOTFILES/common/tmux.conf"    "$HOME/.config/tmux.conf"
link "$DOTFILES/common/alacritty"    "$HOME/.config/alacritty"
link "$DOTFILES/common/nvim"         "$HOME/.config/nvim"
link "$DOTFILES/common/spaceship.zsh" "$HOME/.config/spaceship.zsh"

# --- Machine-specific symlinks ---
link "$DOTFILES/machines/$MACHINE/localrc"       "$HOME/.localrc"
link "$DOTFILES/machines/$MACHINE/gitconfig.local" "$HOME/.gitconfig.local"
[[ -d "$DOTFILES/machines/$MACHINE/tmuxp" ]] && \
    link "$DOTFILES/machines/$MACHINE/tmuxp" "$HOME/.tmuxp"

# --- fzf ---
"$DOTFILES/fzf/install" --all

# --- Common packages ---
pkg_install \
    alacritty \
    bat \
    bison \
    fakeroot \
    gcc \
    httpie \
    make \
    patch \
    ripgrep \
    tmux \
    tmuxp \
    wl-clipboard \
    neovim

yay_install \
    fd \
    git-absorb \
    git-delta \
    ttf-fira-code

# --- Machine-specific packages ---
if [[ "$MACHINE" == "arcanite" ]]; then
    pkg_install \
        networkmanager-openvpn \
        smartmontools \
        tlp \
        tlpui

    yay_install \
        glab \
        mattermost \
        pgadmin4-desktop
fi

# --- Shell ---
sudo chsh -s "$(which zsh)" "$USER"

echo "==> Done. Open a new shell to apply changes."
