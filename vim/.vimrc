" Make Vim more useful
set nocompatible
" Set true terminal colors
set termguicolors
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Add the g flag to search/replace by default
set gdefault
" Change mapleader
let mapleader=","
" Enable relative line numbers
set relativenumber
set number
" Use 2 spaces instead of tabs
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Start scrolling three lines before the horizontal window border
set scrolloff=3
" More natural splitting of windows and easier split navigation
set splitbelow
set splitright
" Soft wrapping of lines
set wrap linebreak

" Automatic commands
if has("autocmd")
  " Enable file type detection
  filetype on
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  " Use 4 spaces for python files
  autocmd FileType python setlocal ts=4 sts=4 sw=4
  " Use tabs for make files
  autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
  " Strip trailing whitespaces on save
  autocmd BufWritePre * %s/\s\+$//e
endif

" Import Vundle configuration
source ~/.plugins
