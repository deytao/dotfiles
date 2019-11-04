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
git clone https://github.com/pyenv/pyenv-virtualenv.git $(PYENV_ROOT)/plugins/pyenv-virtualenv

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ln -s ~/dotfiles/bin ~/bin
ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/omz_custom ~/.omz_custom
ln -s ~/dotfiles/oh-my-zsh ~/.oh-my-zsh
ln -s ~/dotfiles/pythonrc.py ~/.pythonrc.py
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/tmuxp ~/.tmuxp
ln -s ~/dotfiles/vim ~/.vim
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/psqlrc ~/.psqlrc
ln -s ~/dotfiles/sbclrc ~/.sbclrc
ln -s ~/dotfiles/localrc ~/.localrc
ln -s ~/dotfiles/vagrant-provisioning.sh ~/.vagrant-provisioning.sh
ln -s ~/dotfiles/alacritty ~/.config/alacritty
ln -s ~/dotfiles/antigenrc ~/.antigenrc

sudo chsh -s `which zsh` deytao

~/dotfiles/fzf/install

pip install --user powerline-status
pip install --user tmuxp

my_install $1 \
    alacritty \
    bat \
    httpie \
    otf-fira-code \
    pass \
    plasma-desktop \
    ripgrep \
    rofi \
    tmux \
    xf86-input-synaptics \
    yay

yay -S --noconfirm \
    google-cloud-sdk \
    google-chrome-beta \
    plex-media-server \
    slack-desktop \
    vim-nox \
    vuze

sudo systemctl enable sddm.service --force

sudo sed -i 's/EnableHiDPI=false$/EnableHiDPI=true/g' /etc/sddm.conf
sudo sed -i 's/ServerArguments=-nolisten tcp$/ServerArguments=-nolisten tcp -dpi '$(xrdb -query | rg dpi | cut -f2)'/' /etc/sddm.conf

echo 'setxkbmap -option caps:escape' >> ~/.xinitrc

sudo sh -c 'echo options hid_apple fnmode=2 swap_opt_cmd=1 > /etc/modprobe.d/hid_apple.conf'
sudo modprobe -r hid_apple
sudo modprobe hid_apple
