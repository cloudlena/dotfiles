# Dotfiles

My personal dotfiles

I mainly work with [Go](https://golang.org/), [TypeScript](https://www.typescriptlang.org/), [Markdown](https://en.wikipedia.org/wiki/Markdown) and [shell scripts](https://en.wikipedia.org/wiki/Shell_script) so my setup is geared towards working with these technologies.

## Usage

I use [Stow](https://www.gnu.org/software/stow/) to symlink the files from this repo into my home directory.

1. Download and install stow
1. Clone this repo to your home folder
1. Run `cd "${HOME}/dotfiles"`
1. Run `stow vim`
1. Repeat for all needed folders

## Prerequisites

### General

* Run the above commands to get these dotfiles in the right place
* Install [fzf](https://github.com/junegunn/fzf)
* Install [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)

### Vim

* Install [NeoVim](https://github.com/neovim/neovim/wiki/Installing-Neovim) and run `ln -s "${HOME}/dotfiles/vim/.vimrc" "${HOME}/.config/nvim/init.vim"`
* Install [vim-plug](https://github.com/junegunn/vim-plug#installation)
* Install [Python 3](https://www.python.org/downloads/) and run `pip3 install --upgrade neovim`

### macOS recommendations

* Use [iTerm2](https://www.iterm2.com/)
* Install [mas](https://github.com/mas-cli/mas)
* Install [Homebrew](https://brew.sh/)
* Run `brew install reattach-to-user-namespace` to work with tmux

### Linux recommendations

* Use [Arch Linux](https://www.archlinux.org/) or [Antergos](https://antergos.com/)
* Install [Yaourt](https://archlinux.fr/yaourt-en)
