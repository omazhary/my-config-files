#!/bin/bash

# Copy config files
cp .bashrc ~/.
cp .dircolors ~/.
cp .git-prompt.sh ~/.
cp .tmux.conf ~/.
cp .tmuxinator.bash ~/.
cp .vimrc ~/.
cp .inputrc ~/.

# Create fonts directory
mkdir ~/.fonts

# LaTeX document templates
cp -r texmf ~/.
