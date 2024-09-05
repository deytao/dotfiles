#!/bin/bash

my_install () {
    local sys=$1; shift
    for item in $@; do
        if [[ "$sys" == "debian" ]]; then
            sudo apt -y install $item
        elif [[ "$sys" == "osx" ]]; then
            brew install $item
        elif [[ "$sys" == "arch" ]]; then
            sudo pacman -S --noconfirm $item
        fi
    done
}

my_install $1 zsh

cd ~/dotfiles/ && git submodule update --init

# pyenv
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
[[ ! -d "${PYENV_ROOT}/plugins/pyenv-virtualenv" ]] && git clone https://github.com/pyenv/pyenv-virtualenv.git $(PYENV_ROOT)/plugins/pyenv-virtualenv

[[ ! -d "${HOME}/.tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm

curl -L git.io/antigen > ~/dotfiles/antigen.zsh
[[ ! -L "${HOME}/.antigenrc" ]] && ln -s ~/dotfiles/antigenrc ~/.antigenrc
[[ ! -L "${HOME}/bin" ]] && ln -s ~/dotfiles/bin ~/bin
[[ ! -L "${HOME}/.config/alacritty" ]] && ln -s ~/dotfiles/alacritty ~/.config/alacritty
[[ ! -L "${HOME}/.config/nvim" ]] && ln -s ~/dotfiles/nvim ~/.config/nvim
[[ ! -L "${HOME}/.config/spaceship.zsh" ]] && ln -s ~/dotfiles/spaceship.zsh ~/.config/spaceship.zsh
[[ ! -L "${HOME}/.gitconfig" ]] && ln -s ~/dotfiles/gitconfig ~/.gitconfig
[[ ! -L "${HOME}/.localrc" ]] && ln -s ~/dotfiles/localrc ~/.localrc
[[ ! -L "${HOME}/.psqlrc" ]] && ln -s ~/dotfiles/psqlrc ~/.psqlrc
[[ ! -L "${HOME}/.pythonrc.py" ]] && ln -s ~/dotfiles/pythonrc.py ~/.pythonrc.py
[[ ! -L "${HOME}/.sbclrc" ]] && ln -s ~/dotfiles/sbclrc ~/.sbclrc
[[ ! -L "${HOME}/.config/tmux.conf" ]] && ln -s ~/dotfiles/tmux.conf ~/.config/tmux.conf
[[ ! -L "${HOME}/.tmuxp" ]] && ln -s ~/dotfiles/tmuxp ~/.tmuxp
[[ ! -L "${HOME}/.zshrc" ]] && ln -s ~/dotfiles/zshrc ~/.zshrc

sudo chsh -s $(which zsh) jcamile

~/dotfiles/fzf/install

my_install $1 \
    alacritty \
    bat \
    bison \
    ethtool \
    fakeroot \
    gcc \
    httpie \
    make \
    networkmanager-openvpn \
    noto-fonts-emoji \
    pass \
    patch \
    python-powerline-git \
    ripgrep \
    rofi \
    smartmontools \
    tmux \
    tmuxp \
    tlp \
    tlpui \
    xclip \
    xf86-input-synaptics \
    xfce4 \
    yay \
&& true

yay -S --noconfirm \
    balena-etcher \
    fd \
    git-delta \
    glab \
    mattermost \
    neovim \
    pgadmin4-desktop \
    signal-desktop \
    telegram-desktop \
    thunderbird \
    ttf-fira-code \
    vim \
&& true

xdg-mime default firefox.desktop x-scheme-handler/https
xdg-mime default firefox.desktop x-scheme-handler/http
