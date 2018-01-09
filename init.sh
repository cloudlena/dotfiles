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
    # Remove existing config files
    if [ -f ~/.bashrc ]; then
        rm ~/.bashrc
    fi
    if [ -f ~/.bash_profile ]; then
        rm ~/.bash_profile
    fi
    # Stow subdirectories of dotfiles
    for dir in ~/dotfiles/*/
    do
        stow --dir ~/dotfiles "$(basename "${dir}")"
    done

    # Use vimrc as Neovim config
    if [ -f ~/.config/nvim/init.vim ]; then
        rm ~/.config/nvim/init.vim
    fi
    mkdir -p ~/.config/nvim
    ln -s ~/.vimrc ~/.config/nvim/init.vim

    # Install Python3 and pip3 if not installed
    if [ ! -x "$(command -v pip3)" ]; then
        brew install python3
    fi
    # Install the Python neovim package
    pip3 install neovim --upgrade --user neovim

    # Run full system upgrade
    source ~/dotfiles/bash/.path
    source ~/dotfiles/bash/.functions
    pacu

    # Symlink Neovim to vim if vim not installed
    if [ ! -f /usr/local/bin/vim ]; then
        sudo ln -s /usr/local/bin/nvim /usr/local/bin/vim
    fi

    # Use zsh
    if [ -x "$(command -v zsh)" ]; then
        chsh -s "$(which zsh)"
    fi

    echo 'Dotfiles successfully initialized. Please reboot to finalize.'
    ;;

'Linux')
    if [ ! -x "$(command -v pacman)" ]; then
        echo 'Only Arch Linux is currently supported'
        exit 1
    fi

    # Install git if not installed
    sudo pacman -Syu git --noconfirm --needed

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        git clone https://github.com/mastertinner/dotfiles.git
    fi

    # Install stow if not installed
    sudo pacman -Syu stow --noconfirm --needed
    # Remove existing config files
    if [ -f ~/.bashrc ]; then
        rm ~/.bashrc
    fi
    if [ -f ~/.bash_profile ]; then
        rm ~/.bash_profile
    fi
    # Stow subdirectories of dotfiles
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles "$(basename "${dir}")"
    done

    # Install tools
    sudo pacman -Syu --noconfirm --needed \
        tmux \
        neovim \
        python-neovim \
        zsh \
        go \
        go-tools \
        nodejs \
        npm \
        fzf \
        the_silver_searcher \
        diff-so-fancy
    yaourt -Sy --noconfirm --needed \
        prezto-git \
        spotify \
        cloudfoundry-cli \

    # Change npm folder
    if [ -x "$(command -v npm)" ]; then
        npm config set prefix ~
    fi

    # Use vimrc as Neovim config
    if [ -f ~/.config/nvim/init.vim ]; then
        rm ~/.config/nvim/init.vim
    fi
    mkdir -p ~/.config/nvim
    ln -s ~/.vimrc ~/.config/nvim/init.vim

    # Run full system upgrade
    source ~/dotfiles/bash/.path
    source ~/dotfiles/bash/.functions
    pacu

    # Symlink Neovim to vim if vim not installed
    if [ ! -f /usr/bin/vim ]; then
        sudo ln -s /usr/bin/nvim /usr/bin/vim
    fi

    # Use zsh
    if [ -x "$(command -v zsh)" ]; then
        chsh -s "$(which zsh)"
    fi

    echo 'Dotfiles successfully initialized. Please reboot to finalize.'
    ;;

# Default
*)
    echo "OS not supported. Please install manually."
    exit 1
    ;;
esac
