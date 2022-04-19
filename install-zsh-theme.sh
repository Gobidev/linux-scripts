#!/bin/bash

# This scripts installs zsh with my custom theme and .zshrc
# based on https://github.com/RubixDev/HandyLinuxStuff/blob/main/zish/install.sh

_COLOR () { echo "\\033[38;5;$1m"; }
BOLD () { if [ "$1" != "" ]; then echo "$(BOLD)$(_COLOR "$1")"; else echo "\\033[1m"; fi; }
NORMAL () { if [ "$1" != "" ]; then echo "$(NORMAL)$(_COLOR "$1")"; else echo "\\033[22m"; fi; }
RESET () { echo "\\033[0m"; }

# Install zsh if not installed
if ! command -v zsh &> /dev/null; then
    echo "zsh is not installed, installing.."
    if command -v pacman &> /dev/null; then
        sudo pacman -S zsh --noconfirm
    elif command -v apt &> /dev/null; then
        sudo apt install zsh -y
    elif command -v dnf &> /dev/null; then
        sudo dnf install zsh -y
    fi
fi

# Install git if not installed
if ! command -v git &> /dev/null; then
    echo "git is not installed, installing.."
    if command -v pacman &> /dev/null; then
        sudo pacman -S git --noconfirm
    elif command -v apt &> /dev/null; then
        sudo apt install git -y
    elif command -v dnf &> /dev/null; then
        sudo dnf install git -y
    fi
fi

# Install pfetch, if not installed
if ! command -v pfetch &> /dev/null; then
    echo "pfetch is not installed, installing to /usr/local/bin/pfetch"
    sudo wget -O /usr/local/bin/pfetch https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch && sudo chmod +x /usr/local/bin/pfetch
fi

# Check if wget or curl and git is installed
wget --version > /dev/null || {
  curl --version > /dev/null || {
    echo -e "$(BOLD 1)You have neither wget nor curl installed.$(NORMAL) Please install at least one of them.$(RESET)"
    exit 127
  }
}

git --version > /dev/null || {
  echo -e "$(BOLD 1)git is not installed.$(NORMAL) Please make sure it is correctly installed on your system.$(RESET)"
  exit 127
}

# Install Oh My Zsh
echo -e "$(NORMAL 6)Installing oh-my-zsh$(RESET)"
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || exit 1
}
echo -e "$(NORMAL 2)..done$(RESET)"

# Install necessary plugins
echo -e "$(NORMAL 6)Installing zsh-autosuggestions$(RESET)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions || exit 1
echo -e "$(NORMAL 2)..done$(RESET)"

echo -e "$(NORMAL 6)Installing zsh-syntax-highlighting$(RESET)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || exit 1
echo -e "$(NORMAL 2)..done$(RESET)"

# Install theme
echo -e "$(NORMAL 6)Installing agnoster theme$(RESET)"
wget -O- https://raw.githubusercontent.com/Gobidev/zsh-theme/master/agnoster.zsh-theme > ~/.oh-my-zsh/custom/themes/agnoster.zsh-theme || {
  curl -fsSL https://raw.githubusercontent.com/Gobidev/zsh-theme/master/agnoster.zsh-theme > ~/.oh-my-zsh/custom/themes/agnoster.zsh-theme || exit 1
}
echo -e "$(NORMAL 2)..done$(RESET)"


# Create backup of .zshrc
echo -e "$(NORMAL 6)Backing up .zshrc to .zshrc-old$(RESET)"
cp ~/.zshrc .zshrc-old
echo -e "$(NORMAL 2)..done$(RESET)"

# Install .zshrc
echo -e "$(NORMAL 6)Installing .zshrc$(RESET)"
wget -O- https://raw.githubusercontent.com/Gobidev/dotfiles/main/.zshrc > ~/.zshrc || {
  curl -fsSL https://raw.githubusercontent.com/Gobidev/dotfiles/main/.zshrc > ~/.zshrc || exit 1
}
echo -e "$(NORMAL 2)..done$(RESET)"
