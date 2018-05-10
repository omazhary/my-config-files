#!/bin/bash

# Copy config files
echo 'Copying over basic config files...'
cp .bashrc ~/.
cp .dircolors ~/.
cp .git-prompt.sh ~/.
cp .tmux.conf ~/.
cp .tmuxinator.bash ~/.
cp .vimrc ~/.
cp .inputrc ~/.

# Create fonts directory
echo 'Copying over custom fonts...'
mkdir ~/.fonts

# LaTeX document templates
echo 'Copying over custom latex templates...'
cp -r texmf ~/.

# Vundle
echo 'Installing Vundle...'
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo 'Setup successful!'
