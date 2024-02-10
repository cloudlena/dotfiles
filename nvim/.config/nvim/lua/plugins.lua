-- Install Packer if it's not installed yet
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim', install_path
    })
    vim.cmd 'packadd packer.nvim'
end

return require('packer').startup(function()
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Color scheme
    use {
        'folke/tokyonight.nvim',
        config = function()
            vim.g.tokyonight_style = 'night'
            vim.cmd [[colorscheme tokyonight]]
        end
    }

    -- Detect indentation settings
    use 'tpope/vim-sleuth'

    -- Edit surrounds
    use 'tpope/vim-surround'

    -- Toggle commenting
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    }

    -- Allow to repeat plugin commands
    use 'tpope/vim-repeat'

    -- Autoclose pairs
    use {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup {} end
    }

    -- Fuzzy finding
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
        },
        config = function()
            local telescope = require('telescope')
            telescope.setup {
                defaults = {
                    mappings = {
                        i = {
                            ['<Esc>'] = require('telescope.actions').close,
                            ['<C-c>'] = function()
                                vim.cmd [[stopinsert]]
                            end
                        }
                    }
                }
            }
            telescope.load_extension('fzf')
        end
    }

    -- File tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            vim.g.nvim_tree_show_icons = {
                git = 0,
                folders = 1,
                files = 1,
                folder_arrows = 1
            }
            require'nvim-tree'.setup {
                filters = {
                    custom = {'.DS_Store', '.git'}
                }
            }
        end
    }

    -- Git integration
    use 'tpope/vim-fugitive'
    use {
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
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
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner'
                        }
                    }
                }
            }
        end
    }

    use {
      'nvim-lualine/lualine.nvim',
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
      config = function() require('lualine').setup{
        sections = {
          lualine_a = {},
          lualine_b = {'branch', 'diff', {'diagnostics', sources={'nvim_diagnostic'}}},
          lualine_x = {'filetype'},
          lualine_z = {},
        },
        extensions = {'nvim-tree'}
      } end
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

            -- Set correct icons in sign column
            local signs = {
                Error = " ",
                Warn = " ",
                Hint = " ",
                Info = " "
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, {text = icon, texthl = hl})
            end
        end
    }
    use {
        'folke/trouble.nvim',
        opt = true,
        cmd = {'Trouble', 'TroubleToggle'},
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() require('trouble').setup {} end
    }

    -- Autocompletions
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'onsails/lspkind-nvim'
        },
        config = function()
            require('cmp').setup {
                sources = {
                    {name = 'nvim_lsp'},
                    {name = 'path'},
                    {
                        name = 'buffer',
                        option = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end
                        }
                    }
                },
                formatting = {format = require('lspkind').cmp_format()}
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
            vim.g.ale_sign_error = ''
            vim.g.ale_sign_warning = ''
            vim.g.ale_fix_on_save = 1
            vim.g.ale_disable_lsp = 1
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
        'folke/zen-mode.nvim',
        opt = true,
        cmd = {'ZenMode'},
        requires = {
            {
                'folke/twilight.nvim',
                config = function() require('twilight').setup {} end
            }
        },
        config = function()
            require('zen-mode').setup {
                window = {
                    backdrop = 1,
                    options = {
                        signcolumn = 'no',
                        number = false,
                        relativenumber = false
                    }
                }
            }
        end
    }
end)
