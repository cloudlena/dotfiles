#!/bin/sh

# This script installs these dotfiles.

set -e -u

printf '\e[1mInstalling dotfiles\e[0m\n'

case "$(uname)" in

# On Linux, use the respective package manager
'Darwin')

    # Install Xcode Command Line Tools if not installed
    if ! xcode-select -p > /dev/null; then
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

    # Install Stow if not installed
    if [ ! -x "$(command -v stow)" ]; then
        printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
        brew install stow
    fi
    # Remove existing config files
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
    fi
    # Stow subdirectories of dotfiles
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles "$(basename "${dir}")"
    done

    # Install pip if not installed
    if [ ! -x "$(command -v pip)" ]; then
        sudo easy_install pip
    fi

    # Install the Python Neovim package
    pip install --upgrade --user pynvim

    # Set dark mode
    sudo defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Dark
    ;;

'Linux')
    if [ ! -x "$(command -v pacman)" ]; then
        printf '\e[1mArch Linux is the only distro currently supported for automated setup\e[0m\n'
        exit 1
    fi

    # Install Git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        sudo pacman -Syu git --noconfirm --needed
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone git@github.com:mastertinner/dotfiles.git ~/dotfiles
    fi

    # Install Stow if not installed
    printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
    sudo pacman -Syu stow --noconfirm --needed
    # Remove existing config files
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
    fi
    # Stow subdirectories of dotfiles
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles "$(basename "${dir}")"
    done
    sudo pacman -Rns stow --noconfirm

    # Install Yay if not installed
    if [ ! -x "$(command -v yay)" ]; then
        printf '\e[1mInstalling Yay\e[0m\n'
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si)
    fi

    # Install tools
    printf '\e[1mInstalling desired tools and apps\e[0m\n'
    yay -Syu --noconfirm --needed \
        alacritty \
        ansible \
        ansible-lint \
        aws-cli \
        awslogs \
        base \
        base-devel \
        bluez \
        bluez-utils \
        clipman \
        curl \
        diff-so-fancy \
        dnsutils \
        efibootmgr \
        ethtool \
        eslint \
        fd \
        firefox \
        fwupd \
        fzf \
        gimp \
        git \
        github-cli-bin \
        gnupg \
        go \
        golangci-lint-bin \
        gopass \
        grim \
        grub \
        hadolint-bin \
        htop \
        imv \
        informant \
        inkscape \
        iputils \
        jq \
        kanshi \
        kubectl \
        kubectx \
        libimobiledevice \
        libnotify \
        light \
        linux \
        linux-firmware \
        lolcat \
        make \
        mako \
        man-db \
        mpv \
        ncdu \
        neovim \
        networkmanager \
        nftables \
        nodejs \
        noto-fonts-cjk \
        noto-fonts-emoji \
        npm \
        openssh \
        origin-client-bin \
        otf-fira-mono \
        otf-font-awesome \
        pacman-contrib \
        pkgconf \
        playerctl \
        podman-compose \
        podman-docker \
        prettier \
        protobuf \
        pulseaudio \
        pulseaudio-alsa \
        pulseaudio-bluetooth \
        pulsemixer \
        python \
        python-pip \
        python-pynvim \
        qemu \
        rclone \
        ripgrep \
        ruby \
        sed \
        shellcheck \
        slurp \
        smartmontools \
        spotifyd-bin-full \
        spotify-tui-bin \
        sudo \
        svgo \
        sway \
        swayidle \
        swaylock \
        terraform \
        tflint-bin \
        tlp \
        tlp-rdw \
        tmate \
        tmux \
        tree \
        typescript \
        udisks2 \
        unzip \
        vi \
        vifm \
        waybar \
        wf-recorder \
        wget \
        whois \
        wl-clipboard \
        wofi \
        zathura \
        zathura-pdf-poppler \
        zsh

    # Set colors for pacman
    sudo sed -i 's/#Color/Color/' /etc/pacman.conf

    # Change npm folder
    if [ -x "$(command -v npm)" ]; then
        mkdir -p ~/.node_modules/lib
        npm config set prefix ~/.node_modules
    fi
    ;;

# Default
*)
    printf '\e[1mOS not supported for automated setup. Please install manually.\e[0m\n'
    exit 1
    ;;
esac

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install rustup
if [ ! -x "$(command -v rustup)" ]; then
    printf '\e[1mInstalling Rust\e[0m\n'
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    rustup component add rls rust-analysis rust-src rustfmt clippy
fi

# Install prezto
if [ ! -d ~/.zprezto ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

# Use zsh
if [ -x "$(command -v zsh)" ]; then
    printf '\e[1mChanging your shell to zsh\e[0m\n'
    grep -q -F "$(command -v zsh)" /etc/shells || sudo sh -c 'echo "$(command -v zsh)" >> /etc/shells'
    chsh -s "$(command -v zsh)"
fi

# Remove existing bash config files
rm -rf ~/.bash*

# Run full system upgrade
. ~/dotfiles/zsh/.zsh.d/path.zsh
. ~/dotfiles/zsh/.zsh.d/functions.zsh
pacu

printf '\e[1mDotfiles successfully installed. Please reboot to finalize.\e[0m\n'
