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

# Enable H264 video formats
echo 'Enabling H.264 video codec'
if array_contains yum "${DISTRO}" ; then
    echo "### Not configured."
    sudo yum install epel-release
elif array_contains dnf "${DISTRO}" ; then
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf config-manager --set-enabled fedora-cisco-openh264
    sudo dnf install ffmpeg ffmpeg-devel
elif array_contains apt "${DISTRO}" ; then
    echo "### Not configured."
else
    echo "Unidentified distro, aborting..."
    exit 1
fi

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

# Install ruby gems
echo 'Installing ruby gems...'
gems=$(cat gemlist.csv)
for gem in $gems
do
    echo "### Installing $gem..."
    eval "gem install $gem > /dev/null"
    echo "### $gem installation done."
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
if [[ -d  "~/bin" ]]; then
    echo '### User bin directory does not exist. Creating...'
    mkdir -p ~/deb
fi
cp bin/* ~/bin/.

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
