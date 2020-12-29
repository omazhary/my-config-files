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
declare -a yum=("CentOS")
declare -a dnf=("Fedora")
declare -a apt=("Debian GNU/Linux" "Ubuntu" "Lubuntu" "Kubuntu" "Xubuntu")
echo 'Identifying native package manager...'
DISTRO=$(cat /etc/os-release | grep '^NAME=' | sed -En 's/NAME=//p')
DISTRO="${DISTRO%\"}"
DISTRO="${DISTRO#\"}"
PACMAN=''
if array_contains yum "${DISTRO}" ; then
    PACMAN="yum"
elif array_contains dnf "${DISTRO}" ; then
    PACMAN="dnf"
elif array_contains apt "${DISTRO}" ; then
    PACMAN="apt"
else
    echo "Unidentified distro, aborting..."
    exit 1
fi
echo "You're running ${DISTRO}."
echo "The corresponding package manager is ${PACMAN}."

# Copy config files
echo 'Copying over basic config files...'
cp .bashrc ~/.
cp .dircolors ~/.
cp .git-prompt.sh ~/.
cp .tmux.conf ~/.
cp .tmuxinator.bash ~/.
cp .vimrc ~/.
cp .inputrc ~/.
cp .zshrc ~/.

# Install system packages
echo 'Installing additional system packages...'
packages=$(cat setuplist.csv)
for package in $packages
do
    echo "### Installing $package..."
    eval "sudo $PACMAN install -yq $package"
    echo "### $package installation done."
done
echo 'Package installation complete.'

# Install oh-my-zsh!
if [ ! -d ~/.oh-my-zsh ]; then
    echo 'Installing oh-my-zsh...'
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cp omazhary.zsh-theme ~/.oh-my-zsh/themes/.
    echo 'oh-my-zsh installation complete.'
else
    echo 'oh-my-zsh already installed. Skipping...'
fi

# Install nvm
echo 'Installing nvm...'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
echo 'nvm installation complete.'

# Install python packages
echo 'Installing python packages via pip...'
pypackages=$(cat pythonlist.csv)
for pypackage in $pypackages
do
    echo "### Installing $pypackage..."
    eval "pip3 install --default-timeout=100 --user $pypackage > /dev/null"
    echo "### $pypackage installation done."
done

# Install ruby gems
echo 'Installing ruby gems...'
gems=$(cat gemlist.csv)
for gem in $gems
do
    echo "### Installing $gem..."
    eval "sudo gem install $gem > /dev/null"
    echo "### $gem installation done."
done

# Create directory and copy over custom scripts
mkdir -p ~/bin
cp bin/* ~/bin/.

# Create fonts directory
echo 'Copying over custom fonts...'
cp -r .fonts ~/.

# LaTeX document templates
echo 'Copying over custom latex templates...'
cp -r texmf ~/.

# Vundle
echo 'Installing Vundle...'
if ! test -d ~/.vim/bundle/Vundle.vim; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    echo "Directory exists. Vundle already installed."
fi

source ~/.bashrc

echo 'Setup successful!'
