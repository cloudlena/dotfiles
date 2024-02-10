-- Install Packer if it's not installed yet
local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    vim.api.nvim_command('packadd packer.nvim')
end

return require('packer').startup(function()
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Color scheme
    use {
        'folke/tokyonight.nvim',
        config = function()
            vim.g.tokyonight_style = "night"
            vim.cmd [[colorscheme tokyonight]]
        end
    }

    -- Detect indentation settings
    use 'tpope/vim-sleuth'

    -- Edit surrounds
    use 'tpope/vim-surround'

    -- Toggle commenting
    use 'tpope/vim-commentary'

    -- Allow to repeat plugin commands
    use 'tpope/vim-repeat'

    -- Autoclose pairs
    use {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup() end
    }

    -- Fuzzy finding
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    -- File tree
    use {
        'kyazdani42/nvim-tree.lua',
        opt = true,
        cmd = {'NvimTreeOpen', 'NvimTreeToggle'},
        config = function()
            vim.g.nvim_tree_ignore = {'.DS_Store', '.git'}
            vim.g.nvim_tree_show_icons = {
                git = 0,
                folders = 1,
                files = 0,
                folder_arrows = 0
            }
            vim.g.nvim_tree_icons = {
                folder = {
                    default = '▸',
                    open = '▾',
                    empty = '▸',
                    empty_open = '▾',
                    symlink = '▸',
                    symlink_open = '▾'
                }
            }
        end
    }

    -- Git integration
    use 'tpope/vim-fugitive'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('gitsigns').setup() end
    }

    -- Syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdateSync',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = 'maintained',
                highlight = {enable = true}
            }
        end
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
            require'nvim-treesitter.configs'.setup {
                textobjects = {
                    select = {
                        enable = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner"
                        }
                    }
                }
            }
        end
    }

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        config = function()
            local lsp = require('lspconfig')
            lsp.bashls.setup {}
            lsp.gopls.setup {}
            lsp.rust_analyzer.setup {}
            lsp.tsserver.setup {}
            lsp.terraformls.setup {}
        end
    }

    -- Autocompletions
    use {
        'hrsh7th/nvim-compe',
        config = function()
            vim.opt.completeopt = {'menuone', 'noselect'}
            require('compe').setup {
                enabled = true,
                source = {buffer = true, path = true, nvim_lsp = true}
            }
        end
    }

    -- Linting and auto fixing
    use {
        'dense-analysis/ale',
        config = function()
            vim.g.ale_fixers = {
                javascript = {'prettier', 'eslint'},
                typescript = {'prettier', 'eslint'},
                json = {'prettier'},
                html = {'prettier'},
                vue = {'prettier'},
                css = {'prettier'},
                less = {'prettier'},
                scss = {'prettier'},
                graphql = {'prettier'},
                markdown = {'prettier'},
                yaml = {'prettier'},
                go = {'goimports'},
                rust = {'rustfmt'},
                terraform = {'terraform'},
                lua = {'lua-format'}
            }
            vim.g.ale_sign_error = '●'
            vim.g.ale_sign_warning = '●'
            vim.g.ale_fix_on_save = 1
        end
    }

    -- Diff directories
    use {
        'will133/vim-dirdiff',
        opt = true,
        cmd = {'DirDiff'},
        config = function()
            vim.g.DirDiffExcludes =
                '.git,node_modules,vendor,dist,.DS_Store,.*.swp'
        end
    }

    -- Distraction free writing
    use {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup {
                window = {
                    backdrop = 1,
                    options = {
                        signcolumn = "no",
                        number = false,
                        relativenumber = false
                    }
                }
            }
        end
    }
    use {
        "folke/twilight.nvim",
        config = function() require("twilight").setup {} end
    }
end)
