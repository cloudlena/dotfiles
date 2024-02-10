-- Install Packer if it's not installed yet
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Automatically Run PackerCompile when this file changes
local packer_group = vim.api.nvim_create_augroup("PackerCompile", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = packer_group,
    pattern = "plugins.lua",
    command = "source <afile> | PackerCompile",
})

return require("packer").startup(function()
    local function km_opts(desc)
        return { noremap = true, silent = true, desc = desc }
    end

    -- Packer manages itself
    use("wbthomason/packer.nvim")

    -- Color scheme
    use({
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "night",
            })
            vim.api.nvim_command("colorscheme tokyonight")
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

            local function opts(desc)
                return { noremap = true, silent = true, desc = desc }
            end

            vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts("Show diagnostics of current line"))
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Move to previous diagnostic"))
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Move to next diagnostic"))

            -- Add additional capabilities supported by nvim-cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
                local telescope_builtin = require("telescope.builtin")

                local function buf_opts(desc)
                    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
                end
                vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts("Show signature of current symbol"))
                vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, buf_opts("Go to definiton"))
                vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, buf_opts("Go to implementation"))
                vim.keymap.set("n", "gr", telescope_builtin.lsp_references, buf_opts("Go to reference"))
                vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, buf_opts("Rename current symbol"))
                vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, buf_opts("Run code action"))
                vim.keymap.set("n", "<Leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, buf_opts("Format current file"))

                -- Format on save
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = formatting_group, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = formatting_group,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format()
                        end,
                    })
                end
            end

            local on_attach_without_formatting = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentOnTypeFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
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

            local formatting_augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

            -- Format on save
            null_ls.setup({
                sources = sources,
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = formatting_augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ timeout_ms = 5000 })
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
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
            {
                "nvim-telescope/telescope-ui-select.nvim",
                config = function()
                    require("telescope").load_extension("ui-select")
                end,
            },
        },
        config = function()
            local telescope = require("telescope")
            local telescope_builtin = require("telescope.builtin")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<Esc>"] = require("telescope.actions").close,
                        },
                    },
                },
            })

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
                        "--exclude=venv",
                        "--exclude=__pycache__",
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
        "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
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

            vim.keymap.set("n", "<C-n>", function()
                nvim_tree.toggle(true)
            end)
        end,
    })

    -- Autoclose pairs
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
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

    -- Status line
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons", opt = true },
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

    -- Code outline
    use({
        "simrat39/symbols-outline.nvim",
        opt = true,
        cmd = { "SymbolsOutline" },
        config = function()
            require("symbols-outline").setup()
        end,
    })
    vim.keymap.set("n", "<C-k>", "<Cmd>SymbolsOutline<CR>", km_opts("Toggle tree view for symbols"))

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
            local neotest = require("neotest")

            local function opts(desc)
                return { noremap = true, silent = true, desc = desc }
            end

            neotest.setup({
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

            vim.keymap.set("n", "<Leader>tn", function()
                neotest.run.run()
            end, opts("Run nearest test"))
            vim.keymap.set("n", "<Leader>tf", function()
                neotest.run.run(vim.fn.expand("%"))
                neotest.summary.open()
            end, opts("Run all tests in file"))
            vim.keymap.set("n", "<Leader>ta", function()
                neotest.run.run(vim.fn.getcwd())
                neotest.summary.open()
            end, opts("Run all tests in suite"))
            vim.keymap.set("n", "<Leader>tu", function()
                neotest.summary.toggle()
            end, opts("Toggle testing UI"))
        end,
    })

    -- Debugging
    use({
        "mfussenegger/nvim-dap",
        requires = {
            {
                "theHamsta/nvim-dap-virtual-text",
                config = function()
                    require("nvim-dap-virtual-text").setup()
                end,
            },
            {
                "rcarriga/nvim-dap-ui",
                config = function()
                    local dapui = require("dapui")

                    dapui.setup()

                    vim.keymap.set("n", "<Leader>du", dapui.toggle, km_opts("Toggle debugging UI"))
                    vim.keymap.set("n", "<Leader>dK", function()
                        dapui.eval(nil, { enter = true })
                    end, km_opts("Debug symbol under cursor"))
                end,
            },
            {
                "leoluz/nvim-dap-go",
                config = function()
                    require("dap-go").setup()
                end,
            },
        },
        opt = true,
        cmd = { "DapToggleBreakpoint" },
        config = function()
            local dap = require("dap")

            vim.keymap.set("n", "<Leader>dd", dap.continue, km_opts("Start/continue debugging"))
            vim.keymap.set("n", "<Leader>dn", dap.step_over, km_opts("Step over"))
            vim.keymap.set("n", "<Leader>di", dap.step_into, km_opts("Step into"))
            vim.keymap.set("n", "<Leader>do", dap.step_out, km_opts("Step out"))
        end,
    })
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
    vim.keymap.set("n", "<Leader>db", "<Cmd>DapToggleBreakpoint<CR>", km_opts("Toggle breakpoint"))

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
                    require("twilight").setup()
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

    if packer_bootstrap then
        require("packer").sync()
    end
end)
