# Dotfiles

:unicorn: My personal dotfiles

I mainly work with [Go](https://golang.org/), [JavaScript](https://en.wikipedia.org/wiki/JavaScript), [TypeScript](https://www.typescriptlang.org/), [Markdown](https://en.wikipedia.org/wiki/Markdown) and [shell scripts](https://en.wikipedia.org/wiki/Shell_script) so my setup is geared towards working with these technologies.

On macOS, it is recommended to use these dotfiles with [iTerm2](https://www.iterm2.com/) and the [quantum](https://github.com/tyrannicaltoucan/vim-quantum/blob/master/term/iterm/quantum.itermcolors) color scheme.

## Usage

- `pacu`: Updates and upgrades the whole system (using `Brewfile` on macOS)
- `depu`: Updates and upgrades the dependencies for the current project
- `vim`: Starts Neovim with all plugins
- and many more...

## Installation

1. Clone this repo to `~/dotfiles` by running `git clone git@github.com:mastertinner/dotfiles.git ~/dotfiles`
1. Change the name and email address in `git/.gitconfig`
1. macOS only: Change `Brewfile` to your liking or add `Brewfile.extra` for independent packages per machine
1. macOS only: If you have apps installed which you didn't install through `brew cask` but that you now added to `Brewfile` as `cask`, you need to reinstall them with `brew cask install <name> --force` so `cask` knows it's supposed to manage these apps.

   Note: This won't delete any of your data. The app will just be reinstalled with `brew cask` and everything will be back to normal once the installation script has run.

1. Run `~/dotfiles/init.sh`

   **WARNING: This may install and/or remove software and change your configs!**

## Quick Installation without customization (not recommended)

1.  Run the following command:

    **WARNING: This may install and/or remove software and change your configs!**

    ```shell
    $ bash <(curl -s https://raw.githubusercontent.com/mastertinner/dotfiles/master/init.sh)
    ```
