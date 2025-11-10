#!/usr/bin/env bash

cd $HOME

if [[ ! -d dotfiles ]] ; then
    echo "Clonning repository..."
    git clone git@github.com:frnsimoes/dotfiles.git
fi

echo "Updating repository..."
cd dotfiles
git pull origin master

echo "Installing dotfiles as symbolic links..."
DIR="$HOME/dotfiles/"
ln -f -s "$DIR/nvim" "$HOME/.config/nvim"
ln -f -s "$DIR/.gitconfig" "$HOME/.gitconfig"
ln -f -s "$DIR/.zshrc" "$HOME/.zshrc"
ln -f -s "$DIR/tmux" "$HOME/.config/tmux"
ln -f -s "$DIR/aerospace" "$HOME/.config/aerospace"
ln -f -s "$DIR/ghostty" "$HOME/.config/ghostty"
