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
declare -a apt=("Debian" "Ubuntu" "Lubuntu" "Kubuntu" "Xubuntu")
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

# Install system packages
echo 'Installing additional system packages...'
packages=$(cat setuplist.csv)
for package in $packages
do
    echo "### Installing $package..."
    eval "sudo $PACMAN install -yq $package"
    echo "### $package installation done."
done

# Install python packages
echo 'Installing python packages via pip3...'
pypackages=$(cat pythonlist.csv)
for pypackage in $pypackages
do
    echo "### Installing $pypackage..."
    eval "pip3 install --user $pypackage > /dev/null"
    echo "### $pypackage installation done."
done

# Install ruby and rvm packages
echo "Installing Ruby and RVM..."
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &> /dev/null
if [ "${DISTRO}" = "Ubuntu" ]; then
    echo "### Installing RVM for Ubuntu..."
else
    echo "### Installing RVM for ${DISTRO}"
    curl -sSL https://get.rvm.io | bash -s stable --ruby &> /dev/null
fi

# Install atom
echo 'Installing atom...'
if array_contains dnf "${DISTRO}" || array_contains yum "${DISTRO}" ; then
    if eval "sudo $PACMAN list installed atom > /dev/null" ; then
        echo 'Atom is already installed, skipping...'
    else
        sudo rpm --import https://packagecloud.io/AtomEditor/atom/gpgkey
        sudo sh -c 'echo -e "[Atom]\nname=Atom Editor\nbaseurl=https://packagecloud.io/AtomEditor/atom/el/7/\$basearch\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey" > /etc/yum.repos.d/atom.repo'
        eval "sudo $PACMAN install -yq atom"
    fi
elif array_contains apt "${DISTRO}" ; then
    PACMAN="apt"
else
    echo "Unidentified distro, aborting..."
    exit 1
fi
# Install atom packages
echo '#### Installing additional atom packages...'
atom_packages=$(cat atomlist.csv)
for atom_package in $atom_packages
do
    echo "#### Installing $atom_package..."
    eval "apm install -cs $atom_package > /dev/null"
    echo "#### $atom_package installation done."
done
echo "Atom installation done."

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
if [[ -d "~/.vim/bundle/Vundle.vim" ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    echo "Directory exists. Vundle already installed."
fi

echo 'Setup successful!'
