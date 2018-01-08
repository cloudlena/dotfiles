# Dotfiles

My personal dotfiles

I mainly work with [Go](https://golang.org/), [TypeScript](https://www.typescriptlang.org/), [Markdown](https://en.wikipedia.org/wiki/Markdown) and [shell scripts](https://en.wikipedia.org/wiki/Shell_script) so my setup is geared towards working with these technologies.

## Installation

1. Run the following command:

   **WARNING: This may install and/or remove software and change your configs!**

   ```shell
   $ bash <(curl -s https://raw.githubusercontent.com/mastertinner/dotfiles/master/init.sh)
   ```

1. Run command again if Xcode Command Line Tools needed to be installed

## Usage

* `pacu`: Installs and updates everything in `Brewfile` and removes everything else
* `nvim`: Starts neovim with all plugins
* and many more...

## Customize

1. Fork this repo
1. Change the `git clone` command in `init.sh` to use your own repo
1. Change the name and email address in `git/.gitconfig`
1. Change `Brewfile` to your liking
1. If you have apps installed which you didn't install through `brew cask` but that you now added to `Brewfile` as `cask`, you need to remove the respective `.app` file from your applications folder.

   Note: This won't delete any of your data. The app will just be reinstalled with `brew cask` and everything will be back to normal once the installation script has run.

1. Run the above installation command substituting the repo URL with your own
