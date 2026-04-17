#!/bin/bash

DOTFILES="$HOME/dotfiles"

rm -f \
    "$HOME/.zshrc" \
    "$HOME/.gitconfig" \
    "$HOME/.gitconfig.local" \
    "$HOME/.antigenrc" \
    "$HOME/.localrc" \
    "$HOME/.psqlrc" \
    "$HOME/.pythonrc.py" \
    "$HOME/.sbclrc" \
    "$HOME/.config/tmux.conf" \
    "$HOME/.config/alacritty" \
    "$HOME/.config/nvim" \
    "$HOME/.config/spaceship.zsh" \
    "$HOME/.tmuxp"
