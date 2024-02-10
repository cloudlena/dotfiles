vim.g.mapleader = " " -- Set leader key
vim.g.maplocalleader = " " -- Set local leader key
vim.o.completeopt = "menuone,noselect" -- Have a better completion experience
vim.opt.breakindent = true -- Keep indentation for line breaks
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.ignorecase = true -- Ignore case
vim.opt.inccommand = "split" -- Preview for find-replace command
vim.opt.laststatus = 3 -- Global status line
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.shortmess = "I" -- Disable welcome screen
vim.opt.smartcase = true -- Do not ignore case with capitals
vim.opt.spelllang = "en_us" -- Set default spell language
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.termguicolors = true -- True color support

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true }) -- Reserve space for keymaps
