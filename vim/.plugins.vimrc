" Install vim-plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.local/share/nvim/plugged')

" Color scheme
Plug 'trevordmiller/nova-vim'

" Goyo mode for focused writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
if has("autocmd")
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
endif
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

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
nnoremap <C-P> :Files<cr>

" Time tracking
Plug 'wakatime/vim-wakatime'

" Diff directories
Plug 'will133/vim-dirdiff'
let g:DirDiffExcludes = ".git,node_modules,vendor,dist,.DS_Store,.*.swp"

" Git integration
Plug 'tpope/vim-fugitive'

" Show Git indicators with line numbers
Plug 'airblade/vim-gitgutter'

" Detect indent settings
Plug 'tpope/vim-sleuth'

" Edit surrounds
Plug 'tpope/vim-surround'

" Source tree
Plug 'scrooloose/nerdtree'
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['.DS_Store','.git$']
map <C-n> :NERDTreeToggle<CR>

" Toggle Comments
Plug 'tpope/vim-commentary'

" Auto close braces
Plug 'jiangmiao/auto-pairs'

" Syntax Highlighting
Plug 'w0rp/ale'
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['css'] = ['prettier']
let g:ale_fixers['scss'] = ['prettier']
let g:ale_fixers['less'] = ['prettier']
let g:ale_fixers['graphql'] = ['prettier']
let g:ale_fixers['markdown'] = ['prettier']
let g:ale_fixers['typescript'] = ['prettier','tslint']
let g:ale_fix_on_save = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
if has('nvim') && has('python3')
    let g:deoplete#enable_at_startup = 1
endif

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' ,'for': 'go' }
let g:go_fmt_command = 'goimports'
let g:go_auto_type_info = 1
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction
if has("autocmd")
    autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
    autocmd FileType go nmap <leader>t <Plug>(go-test)
endif
Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go' }
Plug 'sebdah/vim-delve', { 'for': 'go' }

" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern', 'for': 'javascript' }
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
Plug 'mxw/vim-jsx', { 'for': 'javascript.jsx' }
let g:jsx_ext_required = 0
Plug 'wokalski/autocomplete-flow', { 'for': 'javascript.jsx' }

" Typescript
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'mhartington/nvim-typescript', { 'do': 'npm install -g typescript', 'for': 'typescript' }
Plug 'mhartington/deoplete-typescript', { 'do': ':UpdateRemotePlugins', 'for': 'typescript' }

" GraphQL
Plug 'jparise/vim-graphql', { 'for': 'graphql' }

" Terraform
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
let g:terraform_fmt_on_save = 1
Plug 'juliosueiras/vim-terraform-completion', { 'for': 'terraform' }
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'

" Initialize plugin system
call plug#end()
