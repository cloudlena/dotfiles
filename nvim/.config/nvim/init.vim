" Import plugins
source ~/.config/nvim/plugins.vim

" Many basic options are already set by the tpope/vim-sensible plugin

" Set color scheme
set background=dark
set termguicolors
colorscheme quantum

" Make Vim more useful
set nocompatible
" Disable Vim welcome message
set shortmess=I
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Change mapleader
let mapleader=","
" Enable relative line numbers
set relativenumber
set number
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Do not reset cursor to start of line when moving around
set nostartofline
" More natural splitting of windows
set splitbelow
set splitright
" Soft wrapping of lines
set wrap linebreak
" Set spell check language to en_us
set spelllang=en_us
" Search whole project
nnoremap \ :Rg<space>

if has("autocmd")
    " Strip trailing whitespaces on save
    autocmd BufWritePre * %s/\s\+$//e
    " Unify indentation on save
    autocmd BufWritePre * retab
    " Enable spell checking for certain file types
    autocmd BufRead,BufNewFile *.md,*.tex setlocal spell
endif

if has("nvim")
    " Preview for find-replace command
    set inccommand=split
endif
