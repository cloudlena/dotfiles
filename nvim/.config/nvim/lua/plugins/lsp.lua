local formatting_group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        event = "VeryLazy",
        config = function()
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

            -- Set up keymaps
            vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics of current line" })
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Move to previous diagnostic" })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Move to next diagnostic" })

            -- Add additional capabilities supported by nvim-cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                -- Setup initial sources (all others are configured in tools.lua)
                sources = {
                    null_ls.builtins.code_actions.gitsigns,
                },
                -- Format on save
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = formatting_group, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = formatting_group,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ timeout_ms = 5000 })
                            end,
                        })
                    end
                end,
            })
        end,
    },
}
