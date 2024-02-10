#!/bin/bash

# This script installs these dotfiles.

printf '\e[1mInitializing dotfiles\e[0m\n'

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
        printf '\e[1mInstalling Homebrew\e[0m\n'
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Install git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        brew install git
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone git@github.com:mastertinner/dotfiles.git ~/dotfiles
    fi

    # Install stow if not installed
    if [ ! -x "$(command -v stow)" ]; then
        printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
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
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles "$(basename "${dir}")"
    done

    # Use vimrc as Neovim config
    if [ -f ~/.config/nvim/init.vim ]; then
        printf '\e[1mSetting up Neovim\e[0m\n'
        rm ~/.config/nvim/init.vim
    fi
    mkdir -p ~/.config/nvim
    ln -s ~/.vimrc ~/.config/nvim/init.vim

    # Install Python and pip if not installed
    if [ ! -x "$(command -v pip)" ]; then
        brew install python
    fi
    # Install the Python neovim package
    pip install --upgrade --user neovim

    # Run full system upgrade
    source ~/dotfiles/bash/.path
    source ~/dotfiles/bash/.functions
    pacu

    # Symlink nvim to vim if Vim not installed
    if [ ! -f /usr/local/bin/vim ]; then
        sudo ln -s /usr/local/bin/nvim /usr/local/bin/vim
    fi
    ;;

'Linux')
    if [ ! -x "$(command -v pacman)" ]; then
        printf '\e[1mArch Linux is the only distro currently supported for automated setup\e[0m\n'
        exit 1
    fi

    # Install git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        sudo pacman -Syu git --noconfirm
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone https://github.com/mastertinner/dotfiles.git
    fi

    # Install Stow if not installed
    printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
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
    sudo pacman -Rns stow --noconfirm

    # Install tools
    printf '\e[1mInstalling desired tools and apps\e[0m\n'
    sudo pacman -Syu --noconfirm --needed \
        go \
        nodejs \
        npm \
        python \
        python-pip \
        ruby \
        cmake \
        diff-so-fancy \
        docker \
        fzf \
        git \
        go-tools \
        htop \
        jq \
        mongodb \
        neovim \
        shellcheck \
        the_silver_searcher \
        tmux \
        wget \
        yaourt \
        yarn \
        zsh
    yaourt -Sy --noconfirm --needed \
        cloudfoundry-cli \
        dep \
        delve \
        dropbox \
        graphiql-app \
        kubectl-bin \
        minio-client \
        prezto-git \
        spotify \
        tmate

    # Enable docker service and allow user to run it without sudo
    sudo systemctl enable docker.service
    sudo groupadd docker
    sudo usermod -aG docker "${USER}"

    # Change npm folder
    if [ -x "$(command -v npm)" ]; then
        npm config set prefix ~
    fi

    # Use vimrc as Neovim config
    printf '\e[1mSetting up Neovim\e[0m\n'
    if [ -f ~/.config/nvim/init.vim ]; then
        rm ~/.config/nvim/init.vim
    fi
    mkdir -p ~/.config/nvim
    ln -s ~/.vimrc ~/.config/nvim/init.vim

    # Install the Python neovim package
    pip install neovim --upgrade --user

    # Run full system upgrade
    source ~/dotfiles/bash/.path
    source ~/dotfiles/bash/.functions
    pacu

    # Symlink nvim to vim if Vim not installed
    if [ ! -f /usr/bin/vim ]; then
        sudo ln -s /usr/bin/nvim /usr/bin/vim
    fi
    ;;

# Default
*)
    printf '\e[1mOS not supported for automated setup. Please install manually.\e[0m\n'
    exit 1
    ;;
esac

# Use zsh
if [ -x "$(command -v zsh)" ]; then
    printf '\e[1mChanging your shell to zsh\e[0m\n'
    chsh -s "$(which zsh)"
fi

printf '\e[1mDotfiles successfully initialized. Please reboot to finalize.\e[0m\n'
