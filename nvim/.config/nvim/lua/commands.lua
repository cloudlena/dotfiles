local opts = {noremap = true, silent = true}

-- Clear highlights
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>nohlsearch<CR>', opts)

-- Toggle fuzzy search
vim.api.nvim_set_keymap('n', '<C-P>', ':Files<CR>', opts)
vim.api.nvim_set_keymap('n', '\\', ':Rg<space>', opts)

-- Toggle file tree
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', opts)

-- LSP actions
vim.api
    .nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
                        opts)
vim.api
    .nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
                        opts)

-- Unify indentation on save
vim.cmd 'autocmd BufWritePre * retab'
-- Enable spell checking for certain file types
vim.cmd 'autocmd BufRead,BufNewFile *.md,*.tex setlocal spell'
