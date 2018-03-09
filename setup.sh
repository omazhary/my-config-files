#!/bin/bash

sudo apt install -y fonts-powerline

pushd /tmp
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
popd

cp .bashrc ~/.
cp .dircolors ~/.
cp .git-prompt.sh ~/.
cp .tmux.conf ~/.
cp .tmuxinator.bash ~/.
cp .vimrc ~/.
cp az-conformant.zsh-theme ~/.oh-my-zsh/themes/.
cp .zshrc ~/.

git submodule init
git submodule update

./nerd-fonts/install.sh
