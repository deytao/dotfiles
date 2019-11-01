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
    tmux \
    httpie \
    ripgrep \
    alacritty \
    bat \
    otf-fira-code \
    rofi \
    xf86-input-synaptics \
    snapd
yay -S google-cloud-sdk

sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

sudo snap install slack --classic
sudo snap install plexmediaserver
