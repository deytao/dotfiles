#!/bin/bash

ln -s ~/dotfiles/bin ~/bin
ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/omz_custom ~/.omz_custom
ln -s ~/dotfiles/oh-my-zsh ~/.oh-my-zsh
ln -s ~/dotfiles/pythonrc.py ~/.pythonrc.py
ln -s ~/dotfiles/tmux ~/.tmux
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vim ~/.vim
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/psqlrc ~/.psqlrc
ln -s ~/dotfiles/sbclrc ~/.sbclrc
ln -s ~/dotfiles/vagrant-provisioning.sh ~/.vagrant-provisioning.sh

pip install --user powerline-status

~/dotfiles/fzf/install
