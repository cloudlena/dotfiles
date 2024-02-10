-- Strip trailing whitespaces on save
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", command = "%s/\\s\\+$//e" })

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.txt", "*.md", "*.tex" },
    callback = function()
        vim.opt_local.spell = true
    end,
})
