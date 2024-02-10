#!/bin/sh

# This script installs these dotfiles.

set -e -u

printf '\e[1mInstalling dotfiles\e[0m\n'

case "$(uname)" in

'Linux')
    if [ ! -x "$(command -v pacman)" ]; then
        printf '\e[1mArch Linux is the only distro currently supported for automated setup\e[0m\n'
        exit 1
    fi

    # Install Git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        sudo pacman -S --noconfirm --needed git
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone https://github.com/cloudlena/dotfiles.git ~/dotfiles
    fi

    # Install Stow if not installed
    sudo pacman -S --noconfirm --needed stow
    # Remove existing config files
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
    fi
    if [ -f ~/.zshenv ]; then
        rm ~/.zshenv
    fi
    # Stow subdirectories of dotfiles
    printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles --target ~ "$(basename "${dir}")"
    done
    sudo pacman -Rns --noconfirm stow

    # Install Paru if not installed
    if [ ! -x "$(command -v paru)" ]; then
        printf '\e[1mInstalling Paru\e[0m\n'
        git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
        (cd /tmp/paru && makepkg -si)
    fi

    # Set colors for pacman
    sudo sed -i 's/#Color/Color/' /etc/pacman.conf

    # Install Pacmanfile if not installed
    if [ ! -x "$(command -v pacmanfile)" ]; then
        printf '\e[1mInstalling Pacmanfile\e[0m\n'
        paru -S --noconfirm --needed pacmanfile
    fi

    # Install packages using Pacmanfile
    printf '\e[1mInstalling desired packages using Pacmanfile\e[0m\n'
    pacmanfile sync --noconfirm

    # Change npm folder
    if [ -x "$(command -v npm)" ]; then
        mkdir -p ~/.node_modules/lib
        npm config set prefix '~/.node_modules'
    fi
    ;;

'Darwin')

    # Install Xcode Command Line Tools if not installed
    if ! xcode-select -p >/dev/null; then
        printf 'Xcode Command Line Tools not installed. You will have to run the script again after successfully installing them. Install now? (Y/n)'
        read -r
        echo
        if ! "$REPLY" | grep -Eq '^[Nn]'; then
            xcode-select --install
            echo 'Please run the script again after the installation has finished'
        else
            echo 'Please install the Xcode Command Line Tools and run then script again.'
        fi
        exit
    fi

    # Install Homebrew if not installed
    if [ ! -x "$(command -v brew)" ]; then
        printf '\e[1mInstalling Homebrew\e[0m\n'
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        brew install git
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone https://github.com/cloudlena/dotfiles.git ~/dotfiles
    fi

    # Install Stow if not installed
    if [ ! -x "$(command -v stow)" ]; then
        brew install stow
    fi
    # Remove existing config files
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
    fi
    # Stow subdirectories of dotfiles
    printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles --target ~ "$(basename "${dir}")"
    done
    # Remove Stow
    brew uninstall stow

    # Install packages using Brewfile
    printf '\e[1mInstalling desired packages using Pacmanfile\e[0m\n'
    brew update
    brew upgrade
    cat ~/.config/homebrew/*Brewfile | brew bundle --file=-

    # Install the Python Neovim package
    pip3 install --upgrade --user pynvim

    # Install additional language servers currently not available via Homebrew
    npm install --global \
        typescript-language-server \
        svelte-language-server \
        eslint_d

    # Install additional Go tooling currently not available via Homebrew
    go install golang.org/x/tools/cmd/goimports@latest

    # Set dark mode
    sudo defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Dark
    ;;

# Default
*)
    printf '\e[1mOS not supported for automated setup. Please install manually.\e[0m\n'
    exit 1
    ;;
esac

# Install Neovim plugin manager
if [ ! -d ~/.local/share/nvim/site/pack/packer ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

# Install prezto
if [ ! -d ~/.zprezto ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

# Use zsh
if [ -x "$(command -v zsh)" ] && [ "$SHELL" != "$(command -v zsh)" ]; then
    printf '\e[1mChanging your shell to zsh\e[0m\n'
    grep -q -F "$(command -v zsh)" /etc/shells || sudo sh -c 'echo "$(command -v zsh)" >> /etc/shells'
    chsh -s "$(command -v zsh)"
fi

# Remove existing bash config files
rm -rf ~/.bash*

# Run full system upgrade
. ~/dotfiles/zsh/.zsh.d/functions.zsh
EDITOR=nvim pacu

printf '\e[1mDotfiles successfully installed. Please reboot to finalize.\e[0m\n'
