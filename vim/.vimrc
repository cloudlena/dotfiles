" Import plugins
source ~/.plugins.vimrc

" Set color scheme
colorscheme nova

" Make Vim more useful
set nocompatible
" Disable vim welcome message
set shortmess=I
" Set true terminal colors
set termguicolors
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow backspace in insert mode
set backspace=indent,eol,start
" Add the g flag to search/replace by default
set gdefault
" Change mapleader
let mapleader=","
" Enable relative line numbers
set relativenumber
set number
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Do not reset cursor to start of line when moving around
set nostartofline
" Show the (partial) command as it is being typed
set showcmd
" Start scrolling three lines before the horizontal window border
set scrolloff=3
" More natural splitting of windows
set splitbelow
set splitright
" Soft wrapping of lines
set wrap linebreak
" Set spell check language to en_us
set spelllang=en_us

" Automatic commands
if has("autocmd")
    " Enable file type detection
    filetype on
    " Strip trailing whitespaces on save
    autocmd BufWritePre * %s/\s\+$//e
    " Unify indentation on save
    autocmd BufWritePre * retab
    " Enable spell checking for certain files
    autocmd BufRead,BufNewFile *.md,*.tex setlocal spell
endif
