-- Install Packer if it's not installed yet
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    vim.cmd("packadd packer.nvim")
end

return require("packer").startup(function()
    -- Packer manages itself
    use("wbthomason/packer.nvim")

    -- Color scheme
    use({
        "folke/tokyonight.nvim",
        config = function()
            vim.g.tokyonight_style = "night"
            vim.cmd([[colorscheme tokyonight]])
        end,
    })

    -- Syntax highlighting
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdateSync",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = "maintained",
                highlight = { enable = true },
            })
        end,
    })
    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        requires = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                },
            })
        end,
    })

    -- LSP
    use({
        "neovim/nvim-lspconfig",
        config = function()
            local nvim_lsp = require("lspconfig")

            -- Add additional capabilities supported by nvim-cmp
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
                local function buf_set_keymap(...)
                    vim.api.nvim_buf_set_keymap(bufnr, ...)
                end

                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { noremap = true, silent = true }
                buf_set_keymap("n", "gd", "<Cmd>Telescope lsp_definitions<CR>", opts)
                buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
                buf_set_keymap("n", "gi", "<Cmd>Telescope lsp_implementations<CR>", opts)
                buf_set_keymap("n", "<space>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
                buf_set_keymap("n", "<space>ca", "<Cmd>Telescope lsp_code_actions<CR>", opts)
                buf_set_keymap("n", "gr", "<Cmd>Telescope lsp_references<CR>", opts)
                buf_set_keymap("n", "<space>e", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts)
                buf_set_keymap("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
                buf_set_keymap("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
                buf_set_keymap("n", "<space>f", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts)

                -- Format on save
                if client.resolved_capabilities.document_formatting then
                    vim.cmd([[augroup Format]])
                    vim.cmd([[autocmd! * <buffer>]])
                    vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]])
                    vim.cmd([[augroup END]])
                end
            end

            local on_attach_without_formatting = function(client, bufnr)
                client.resolved_capabilities.document_formatting = false
                client.resolved_capabilities.document_range_formatting = false
                on_attach(client, bufnr)
            end

            nvim_lsp.bashls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
            nvim_lsp.gopls.setup({
                -- Formatting done by goimports via null-ls
                on_attach = on_attach_without_formatting,
                capabilities = capabilities,
            })
            nvim_lsp.rust_analyzer.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
            nvim_lsp.tsserver.setup({
                -- Formatting done by Prettier via null-ls
                on_attach = on_attach_without_formatting,
                capabilities = capabilities,
            })
            nvim_lsp.terraformls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
            nvim_lsp.sumneko_lua.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "use" },
                        },
                    },
                },
            })

            -- Set correct icons in sign column
            local signs = {
                Error = " ",
                Warn = " ",
                Hint = " ",
                Info = " ",
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl })
            end
        end,
    })

    -- Completion
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "onsails/lspkind-nvim",
        },
        config = function()
            local cmp = require("cmp")

            local sources = {
                { name = "nvim_lua" },
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "buffer" },
            }

            cmp.setup({
                sources = sources,
                formatting = { format = require("lspkind").cmp_format() },
            })
        end,
    })

    -- Linting and fixing
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")

            local sources = {
                null_ls.builtins.code_actions.gitsigns,
                null_ls.builtins.diagnostics.eslint_d,
                null_ls.builtins.diagnostics.golangci_lint,
                null_ls.builtins.diagnostics.hadolint,
                null_ls.builtins.diagnostics.shellcheck,
                null_ls.builtins.formatting.goimports,
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.shfmt.with({
                    extra_args = { "-i", 4 },
                }),
                null_ls.builtins.formatting.stylua.with({
                    extra_args = { "--indent-type", "Spaces" },
                }),
            }

            -- Format on save
            null_ls.setup({
                sources = sources,
                on_attach = function(client)
                    if client.resolved_capabilities.document_formatting then
                        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 10000)")
                    end
                end,
            })
        end,
    })

    -- Git integration
    use("tpope/vim-fugitive")
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup()
        end,
    })

    -- Fuzzy finding
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<Esc>"] = require("telescope.actions").close,
                        },
                    },
                },
            })
            telescope.load_extension("fzf")

            -- Toggle fuzzy file search
            vim.api.nvim_set_keymap(
                "n",
                "<C-p>",
                '<Cmd>lua require("telescope.builtin").find_files({ find_command = { "fd", "--type=f", "--type=l", "--hidden", "--no-ignore", "--exclude=.DS_Store", "--exclude=.git", "--exclude=.terraform", "--exclude=.gradle", "--exclude=bin", "--exclude=build", "--exclude=coverage", "--exclude=dist", "--exclude=node_modules", "--exclude=target", "--exclude=vendor" }})<CR>',
                { noremap = true, silent = true }
            )

            -- Toggle fuzzy search across project
            vim.api.nvim_set_keymap("n", "\\", "<Cmd>Telescope live_grep<CR>", { noremap = true, silent = true })

            -- Toggle diagnostics
            vim.api.nvim_set_keymap("n", "<C-s>", "<Cmd>Telescope diagnostics<CR>", { noremap = true, silent = true })
        end,
    })

    -- File tree
    use({
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            vim.g.nvim_tree_show_icons = {
                git = 0,
                folders = 1,
                files = 1,
                folder_arrows = 1,
            }
            require("nvim-tree").setup({
                filters = {
                    custom = { ".DS_Store", ".git" },
                },
            })

            vim.api.nvim_set_keymap("n", "<C-n>", "<Cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
        end,
    })

    -- Autoclose pairs
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    })

    -- Edit surrounds
    use("tpope/vim-surround")

    -- Toggle comments
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- Allow to repeat plugin commands
    use("tpope/vim-repeat")

    -- Code outline
    use({
        "simrat39/symbols-outline.nvim",
        opt = true,
        cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    })
    vim.api.nvim_set_keymap("n", "<C-k>", "<Cmd>SymbolsOutline<CR>", { noremap = true, silent = true })

    -- Status line
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup({
                sections = {
                    lualine_a = {},
                    lualine_x = { "filetype" },
                    lualine_z = {},
                },
                extensions = { "nvim-tree" },
            })
        end,
    })

    -- Testing
    use({
        "rcarriga/vim-ultest",
        requires = { "vim-test/vim-test" },
        config = function()
            vim.g["test#java#runner"] = "gradletest"

            vim.g.ultest_pass_sign = "﫠"
            vim.g.ultest_fail_sign = ""
            vim.g.ultest_running_sign = "奈"
            vim.g.ultest_not_run_sign = ""

            vim.api.nvim_set_keymap(
                "n",
                "<space>tf",
                "<Cmd>UltestSummaryOpen<CR><Cmd>Ultest<CR>",
                { noremap = true, silent = true }
            )
            vim.api.nvim_set_keymap("n", "<space>tn", "<Cmd>UltestNearest<CR>", { noremap = true, silent = true })
        end,
    })

    -- Diff directories
    use({
        "will133/vim-dirdiff",
        opt = true,
        cmd = { "DirDiff" },
        config = function()
            vim.g.DirDiffExcludes =
                ".DS_Store,.git,.terraform,.gradle,bin,build,coverage,dist,node_modules,target,vendor"
        end,
    })

    -- Distraction free writing
    use({
        "folke/zen-mode.nvim",
        opt = true,
        cmd = { "ZenMode" },
        requires = {
            {
                "folke/twilight.nvim",
                config = function()
                    require("twilight").setup({})
                end,
            },
        },
        config = function()
            require("zen-mode").setup({
                window = {
                    backdrop = 1,
                    options = {
                        signcolumn = "no",
                        number = false,
                        relativenumber = false,
                    },
                },
            })
        end,
    })
end)
