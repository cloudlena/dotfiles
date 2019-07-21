" Install vim-plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.local/share/nvim/plugged')

" Sensible defaults everyone can agree on
Plug 'tpope/vim-sensible'

" Colorscheme
Plug 'tyrannicaltoucan/vim-quantum'
let g:quantum_black=1

" Enable hard mode
Plug 'takac/vim-hardtime'
let g:hardtime_default_on = 1

" Goyo mode for focused writing
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Goyo' }
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

" Diff directories
Plug 'will133/vim-dirdiff', { 'on': 'DirDiff' }
let g:DirDiffExcludes = ".git,node_modules,vendor,dist,.DS_Store,.*.swp"

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim', { 'on': 'GV' }

" Show Git indicators with line numbers
Plug 'airblade/vim-gitgutter'

" Detect indent settings
Plug 'tpope/vim-sleuth'

" Edit surrounds
Plug 'tpope/vim-surround'

" Allow to repeat plugin commands
Plug 'tpope/vim-repeat'

" Source tree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['.DS_Store','.git$']
map <C-n> :NERDTreeToggle<CR>

" Toggle Comments
Plug 'tpope/vim-commentary'

" Auto close braces
Plug 'jiangmiao/auto-pairs'

" Linting and auto fixing
Plug 'w0rp/ale'
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier','eslint']
let g:ale_fixers['typescript'] = ['prettier','eslint']
let g:ale_fixers['json'] = ['prettier']
let g:ale_fixers['html'] = ['prettier']
let g:ale_fixers['vue'] = ['prettier']
let g:ale_fixers['css'] = ['prettier']
let g:ale_fixers['less'] = ['prettier']
let g:ale_fixers['scss'] = ['prettier']
let g:ale_fixers['graphql'] = ['prettier']
let g:ale_fixers['markdown'] = ['prettier']
let g:ale_fixers['yaml'] = ['prettier']
let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
let g:ale_fix_on_save = 1

" Autocompletion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" Snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' ,'for': ['go','gomod'] }
let g:go_fmt_command = 'goimports'
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_metalinter_command='golangci-lint'
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
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

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
let g:rustfmt_autosave = 1

" JavaScript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern', 'for': 'javascript' }
Plug 'mxw/vim-jsx', { 'for': 'javascript.jsx' }
Plug 'posva/vim-vue', { 'for': 'vue' }

" Typescript
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
if has('nvim')
    Plug 'mhartington/nvim-typescript', { 'do': './install.sh', 'for': 'typescript' }
endif

" GraphQL
Plug 'jparise/vim-graphql', { 'for': 'graphql' }

" Terraform
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
let g:terraform_fmt_on_save = 1
Plug 'juliosueiras/vim-terraform-completion', { 'for': 'terraform' }
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'

" TOML
Plug 'cespare/vim-toml', { 'for': 'toml' }

" nginx
Plug 'chr4/nginx.vim', { 'for': 'nginx' }

" MDX
Plug 'jxnblk/vim-mdx-js', { 'for': 'markdown.mdx' }

" Initialize plugin system
call plug#end()
