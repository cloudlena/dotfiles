" Import plugins
source ~/.config/nvim/plugins.vim

" Many basic options are already set by the tpope/vim-sensible plugin

" Set color scheme
set termguicolors
colorscheme quantum

" Disable Vim welcome message
set shortmess=I
" Use system clipboard
set clipboard=unnamedplus
" Set leader key
let mapleader=","
" Enable relative line numbers
set relativenumber
set number
" Highlight searches
set hlsearch
" Use smart case for searching
set ignorecase
set smartcase
" Do not reset cursor to start of line when moving around
set nostartofline
" More natural splitting of windows
set splitbelow
set splitright
" Soft wrapping of lines
set wrap linebreak
" Set spell check language to US English
set spelllang=en_us
" Preview for find-replace command
set inccommand=split

" Strip trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e
" Unify indentation on save
autocmd BufWritePre * retab
" Enable spell checking for certain file types
autocmd BufRead,BufNewFile *.md,*.tex setlocal spell

" Shortcut to search whole project
nnoremap \ :Rg<space>
