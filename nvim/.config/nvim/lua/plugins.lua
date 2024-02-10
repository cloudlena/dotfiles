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
            require("tokyonight").setup({
                style = "night",
            })
            vim.cmd([[colorscheme tokyonight]])
        end,
    })

    -- Syntax highlighting
    use({
        "nvim-treesitter/nvim-treesitter",
        requires = { "nvim-treesitter/nvim-treesitter-textobjects" },
        run = ":TSUpdateSync",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = "all",
                highlight = { enable = true },
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
                local telescope_builtin = require("telescope.builtin")

                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "gr", telescope_builtin.lsp_references, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, opts)

                -- Format on save
                if client.server_capabilities.document_formatting then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        callback = vim.lsp.buf.formatting_sync,
                    })
                end
            end

            local on_attach_without_formatting = function(client, bufnr)
                client.server_capabilities.document_formatting = false
                client.server_capabilities.document_range_formatting = false
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
                -- Formatting done by StyLua via null-ls
                on_attach = on_attach_without_formatting,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "use" },
                        },
                    },
                },
            })
            nvim_lsp.svelte.setup({
                on_attach = on_attach,
                capabilities = capabilities,
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
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
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
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
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
                    if client.server_capabilities.document_formatting then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            callback = function()
                                vim.lsp.buf.formatting_sync(nil, 10000)
                            end,
                        })
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
            "nvim-telescope/telescope-ui-select.nvim",
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
            telescope.load_extension("ui-select")

            local telescope_builtin = require("telescope.builtin")

            -- Toggle fuzzy file search
            vim.keymap.set("n", "<C-p>", function()
                telescope_builtin.find_files({
                    find_command = {
                        "fd",
                        "--type=f",
                        "--type=l",
                        "--hidden",
                        "--no-ignore",
                        "--exclude=.DS_Store",
                        "--exclude=.git",
                        "--exclude=.terraform",
                        "--exclude=.gradle",
                        "--exclude=.svelte-kit",
                        "--exclude=bin",
                        "--exclude=build",
                        "--exclude=coverage",
                        "--exclude=dist",
                        "--exclude=node_modules",
                        "--exclude=target",
                        "--exclude=vendor",
                    },
                })
            end)

            -- Toggle fuzzy search across project
            vim.keymap.set("n", "\\", telescope_builtin.live_grep)

            -- Toggle diagnostics
            vim.keymap.set("n", "<C-s>", telescope_builtin.diagnostics)
        end,
    })

    -- File tree
    use({
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            local nvim_tree = require("nvim-tree")

            nvim_tree.setup({
                filters = {
                    custom = { "^.DS_Store$", "^.git$" },
                },
                renderer = {
                    icons = {
                        show = {
                            git = false,
                        },
                    },
                },
            })

            vim.keymap.set("n", "<C-n>", nvim_tree.toggle)
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
    vim.keymap.set("n", "<C-k>", "<Cmd>SymbolsOutline<CR>", { silent = true })

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
                options = {
                    theme = "tokyonight",
                },
            })
        end,
    })

    -- Testing
    use({
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-vim-test",
            "vim-test/vim-test",
        },
        config = function()
            require("neotest").setup({
                icons = {
                    failed = "",
                    passed = "",
                    running = "奈",
                    unknown = "",
                },
                adapters = {
                    require("neotest-go"),
                    require("neotest-vim-test")({ ignore_filetypes = { "go" } }),
                },
            })

            vim.keymap.set("n", "<leader>tf", function()
                local neotest = require("neotest")
                neotest.run.run(vim.fn.expand("%"))
                neotest.summary.open()
            end, { silent = true })
            vim.keymap.set("n", "<leader>tn", function()
                require("neotest").run.run()
            end, { silent = true })
            vim.keymap.set("n", "<leader>ta", function()
                local neotest = require("neotest")
                neotest.run.run(vim.fn.getcwd())
                neotest.summary.open()
            end, { silent = true })
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
