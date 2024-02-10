# Dotfiles

My personal dotfiles

I mainly work with [Go](https://golang.org/), [JavaScript](https://en.wikipedia.org/wiki/JavaScript), [TypeScript](https://www.typescriptlang.org/), [Markdown](https://en.wikipedia.org/wiki/Markdown) and [shell scripts](https://en.wikipedia.org/wiki/Shell_script) so my setup is geared towards working with these technologies.

## Installation

1.  Run the following command:

    **WARNING: This may install and/or remove software and change your configs!**

    ```shell
    $ bash <(curl -s https://raw.githubusercontent.com/mastertinner/dotfiles/master/init.sh)
    ```

1.  Run command again if Xcode Command Line Tools needed to be installed

## Usage

* `pacu`: Updates and upgrades the whole system (using `Brewfile` on macOS)
* `depu`: Updates and upgrades the dependencies for the current project
* `vim`: Starts Neovim with all plugins
* and many more...

## Customize

1.  Fork this repo
1.  Change the `git clone` command in `init.sh` to use your own repo
1.  Change the name and email address in `git/.gitconfig`
1.  Change `Brewfile` to your liking or add `Brewfile.extra` for independent packages per machine
1.  If you have apps installed which you didn't install through `brew cask` but that you now added to `Brewfile` as `cask`, you need to reinstall them with `brew cask install <name> --force` so `cask` knows it's supposed to manage these apps.

    Note: This won't delete any of your data. The app will just be reinstalled with `brew cask` and everything will be back to normal once the installation script has run.

1.  Run the above installation command substituting the repo URL with your own
