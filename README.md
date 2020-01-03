# Dotfiles

:unicorn: My personal dotfiles

I mainly work with [Go](https://golang.org), [Rust](https://www.rust-lang.org), [JavaScript](https://en.wikipedia.org/wiki/JavaScript), [TypeScript](https://www.typescriptlang.org), [Markdown](https://en.wikipedia.org/wiki/Markdown) and [shell scripts](https://en.wikipedia.org/wiki/Shell_script) so my setup is geared towards working with these technologies.

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

1. Either import an existing PGP key pair by using `gpg --import my-key.asc` and `gpg --import my-key-pub.asc` or create a new one by following the [GitHub](https://help.github.com/en/articles/generating-a-new-gpg-key) guide. You need to use the same name and email address as an ID that you have configured in `git/.gitconfig` in order to correctly sign your commits.
1. Either import an existing SSH key pair by copying it to `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` or create a new one by following the [GitHub](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) guide.

## Quick Installation without customization (not recommended unless you're the owner of this repo :wink:)

1.  Run the following command:

    **WARNING: This may install and/or remove software and change your configs!**

    ```shell
    $ curl -s https://raw.githubusercontent.com/mastertinner/dotfiles/master/init.sh | sh
    ```
