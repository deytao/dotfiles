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

[[ ! -L "${HOME}/.antigenrc" ]] && ln -s ~/dotfiles/antigenrc ~/.antigenrc
[[ ! -L "${HOME}/bin" ]] && ln -s ~/dotfiles/bin ~/bin
[[ ! -L "${HOME}/.config/alacritty" ]] && ln -s ~/dotfiles/alacritty ~/.config/alacritty
[[ ! -L "${HOME}/.gitconfig" ]] && ln -s ~/dotfiles/gitconfig ~/.gitconfig
[[ ! -L "${HOME}/.localrc" ]] && ln -s ~/dotfiles/localrc ~/.localrc
[[ ! -L "${HOME}/.oh-my-zsh" ]] && ln -s ~/dotfiles/oh-my-zsh ~/.oh-my-zsh
[[ ! -L "${HOME}/.omz_custom" ]] && ln -s ~/dotfiles/omz_custom ~/.omz_custom
[[ ! -L "${HOME}/.psqlrc" ]] && ln -s ~/dotfiles/psqlrc ~/.psqlrc
[[ ! -L "${HOME}/.pythonrc.py" ]] && ln -s ~/dotfiles/pythonrc.py ~/.pythonrc.py
[[ ! -L "${HOME}/.sbclrc" ]] && ln -s ~/dotfiles/sbclrc ~/.sbclrc
[[ ! -L "${HOME}/.tmux.conf" ]] && ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
[[ ! -L "${HOME}/.tmuxp" ]] && ln -s ~/dotfiles/tmuxp ~/.tmuxp
[[ ! -L "${HOME}/.vagrant-provisioning.sh" ]] && ln -s ~/dotfiles/vagrant-provisioning.sh ~/.vagrant-provisioning.sh
[[ ! -L "${HOME}/.vim" ]] && ln -s ~/dotfiles/vim ~/.vim
[[ ! -L "${HOME}/.vimrc" ]] && ln -s ~/dotfiles/vimrc ~/.vimrc
[[ ! -L "${HOME}/.zshrc" ]] && ln -s ~/dotfiles/zshrc ~/.zshrc

sudo chsh -s $(which zsh) deytao

~/dotfiles/fzf/install

pip install --user powerline-status
pip install --user tmuxp

my_install $1 \
    alacritty \
    bat \
    discover \
    httpie \
    kmix \
    networkmanager-openvpn \
    noto-fonts-emoji \
    otf-fira-code \
    pass \
    plasma-desktop \
    ripgrep \
    rofi \
    tmux \
    xf86-input-synaptics \
    yay \
&& true

yay -S --noconfirm \
    google-cloud-sdk \
    google-chrome-beta \
    plex-media-server \
    slack-desktop \
    vim-nox \
    vuze \
&& true

sudo systemctl enable sddm.service --force
sudo systemctl enable plexmediaserver

sudo sed -i 's/EnableHiDPI=false$/EnableHiDPI=true/g' /etc/sddm.conf
sudo sed -i 's/ServerArguments=-nolisten tcp$/ServerArguments=-nolisten tcp -dpi '$(xrdb -query | rg dpi | cut -f2)'/' /etc/sddm.conf

echo 'setxkbmap -option caps:escape' >> ~/.xinitrc

# Keychron K2
sudo sh -c 'echo options hid_apple fnmode=2 swap_opt_cmd=1 > /etc/modprobe.d/hid_apple.conf'
sudo modprobe -r hid_apple
sudo modprobe hid_apple
