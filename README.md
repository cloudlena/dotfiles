# Dotfiles

My personal dotfiles

I mainly work with [Go](https://golang.org/), [Node.js](https://nodejs.org/en/), [TypeScript](https://www.typescriptlang.org/), [Markdown](https://en.wikipedia.org/wiki/Markdown) and [shell scripts](https://en.wikipedia.org/wiki/Shell_script) so my setup is geared towards working with these technologies.

## Usage

I use [Stow](https://www.gnu.org/software/stow/) to symlink the files from this repo into my home directory.

1. Download and install stow
1. Clone this repo to your home folder
1. Run `cd "${HOME}/dotfiles"`
1. Run `stow vim`
1. Repeat for all needed folders

## Prerequisites

### Vim

* Install [NeoVim](https://github.com/neovim/neovim/wiki/Installing-Neovim) or [Vim 8](http://www.vim.org/download.php)
* Install [vim-plug](https://github.com/junegunn/vim-plug#installation)
* Install [Python 3](https://www.python.org/downloads/)

### System Upgrade

* Install [fzf](https://github.com/junegunn/fzf)

#### macOS

* Install [mas](https://github.com/mas-cli/mas)
* Install [Homebrew](https://brew.sh/)

#### Linux

* Use [Arch Linux](https://www.archlinux.org/) or [Antergos](https://antergos.com/)
* Install [Yaourt](https://archlinux.fr/yaourt-en)
