#!/bin/bash

cd ~/dotfiles/ && git submodule update --init

# pyenv

curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
git clone https://github.com/pyenv/pyenv-virtualenv.git $(PYENV_ROOT)/plugins/pyenv-virtualenv

~/dotfiles/fzf/install

ln -s ~/dotfiles/bin ~/bin
ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/omz_custom ~/.omz_custom
ln -s ~/dotfiles/oh-my-zsh ~/.oh-my-zsh
ln -s ~/dotfiles/pythonrc.py ~/.pythonrc.py
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vim ~/.vim
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/psqlrc ~/.psqlrc
ln -s ~/dotfiles/sbclrc ~/.sbclrc
ln -s ~/dotfiles/localrc ~/.localrc
ln -s ~/dotfiles/vagrant-provisioning.sh ~/.vagrant-provisioning.sh
ln -s ~/dotfiles/pgclirc ~/.config/pgcli/config

pip install --user powerline-status

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get install httpie
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install httpie
fi
