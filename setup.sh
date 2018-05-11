#!/bin/bash -e

shopt -s nocasematch

array_contains() {
    local seeking=$2
    name=$1[@]
    local array=("${!name}")
    local in=1
    for element in "${array[@]}"; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
}

# Identify package manager
declare -a yum=("CentOS" "Fedora")
declare -a apt=("Debian" "Ubuntu", "Lubuntu", "Kubuntu", "Xubuntu")
echo 'Identifying native package manager...'
DISTRO=$(cat /etc/os-release | grep '^NAME=' | sed -En 's/NAME=//p')
PACMAN=''
if array_contains yum $DISTRO ; then
    PACMAN="yum"
elif array_contains apt $DISTRO ; then
    PACMAN="apt"
else
    echo "Unidentified distro, aborting..."
    exit 1
fi
echo "You're running ${DISTRO}."
echo "The corresponding package manager is ${PACMAN}."

# Install packages
echo 'Installing additional packages...'
packages=$(cat setuplist.csv)
for package in $packages
do
    echo "### Installing $package..."
    eval "sudo $PACMAN install -yq $package"
    echo "$package installation done."
done

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
cp -r .fonts ~/.

# LaTeX document templates
echo 'Copying over custom latex templates...'
cp -r texmf ~/.

# Vundle
echo 'Installing Vundle...'
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo 'Setup successful!'
