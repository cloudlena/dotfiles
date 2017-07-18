" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.local/share/nvim/plugged')

" seoul256 Color scheme
Plug 'junegunn/seoul256.vim'
let g:seoul256_background = 233
if has("autocmd")
  autocmd! VimEnter * colorscheme seoul256
endif

" Emmet for HTML editing
Plug 'mattn/emmet-vim', { 'for': ['html','xml'] }
let g:user_emmet_leader_key='<C-i>'

" Goyo mode for focused writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
function! s:goyo_enter()
  set noshowcmd
  set scrolloff=999
  ALEDisable
  Limelight
endfunction
function! s:goyo_leave()
  set showcmd
  set scrolloff=3
  ALEEnable
  Limelight!
endfunction

" Git integration
Plug 'tpope/vim-fugitive'

" Diff directories
Plug 'will133/vim-dirdiff'
let g:DirDiffExcludes = ".git,node_modules,vendor,dist,.DS_Store,.*.swp"

" Edit surrounds
Plug 'tpope/vim-surround'

" Source tree
Plug 'scrooloose/nerdtree'
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['.DS_Store','.git$']
map <C-n> :NERDTreeToggle<CR>

" Toggle Comments
Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims = 1

" Auto close braces
Plug 'jiangmiao/auto-pairs'

" Syntax Highlighting
Plug 'w0rp/ale'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Show Git indicators with line numbers
Plug 'airblade/vim-gitgutter'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <C-P> :Files<cr>

" Autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern', 'for': 'javascript' }
Plug 'mhartington/deoplete-typescript', { 'do': 'npm install -g typescript', 'for': 'typescript' }
Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go' }
if has('nvim')
  let g:deoplete#enable_at_startup = 1
endif

" Crystal language support
Plug 'rhysd/vim-crystal', { 'for': 'crystal' }

" Go language support
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' ,'for': 'go' }
let g:go_fmt_command = 'goimports'

" Typescript language support
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'Shougo/vimproc.vim', { 'do': 'make', 'for': 'typescript' }
Plug 'Quramy/tsuquyomi', { 'for': 'typescript' }

" JSX language support
Plug 'mxw/vim-jsx', { 'for': 'javascript.jsx' }

" Initialize plugin system
call plug#end()
