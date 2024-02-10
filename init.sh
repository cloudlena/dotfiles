#!/bin/bash

# This script installs these dotfiles.

case "$(uname)" in

# On Linux, use the respective package manager
'Darwin')

    # Install Xcode Command Line Tools if not installed
    if ! xcode-select -p &> /dev/null; then
        read -p 'Xcode Command Line Tools not installed. You will have to run the script again after successfully installing them. Install now? (Y/n)' -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]
        then
            xcode-select --install
            echo 'Please run the script again after the installation has finished'
        else
            echo 'Please install the Xcode Command Line Tools and run then script again.'
        fi
        exit
    fi

    # Install Homebrew if not installed
    if [ ! -x "$(command -v brew)" ]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Install Homebrew Bundle
    brew tap Homebrew/bundle

    # Install git if not installed
    if [ ! -x "$(command -v git)" ]; then
        brew install git
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        git clone git@github.com:mastertinner/dotfiles.git ~
    fi

    # Install stow if not installed
    if [ ! -x "$(command -v stow)" ]; then
        brew install stow
    fi
    # Stow subdirectories of dotfiles
    for dir in ~/dotfiles/*/
    do
        stow --dir ~/dotfiles "$(basename "${dir}")"
    done

    # Use vimrc as Neovim config
    ln -s ~/.vimrc ~/.config/nvim/init.vim

    # Install Python3 and pip3 if not installed
    if [ ! -x "$(command -v pip3)" ]; then
        brew install python3
    fi
    # Install the Python neovim package
    pip3 install --upgrade --user neovim

    # Install vim-plug
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Run full system upgrade
    source ~/dotfiles/bash/.functions
    pacu

    # Install diff-so-fancy
    npm install --global diff-so-fancy

    echo 'Dotfiles successfully initialized'
    ;;

# Default
*)
    echo "OS not supported. Please install manually."
    ;;
esac
