-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- File handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true

-- Completion
vim.opt.completeopt = "menuone,noselect"
vim.opt.pumheight = 10

-- Miscellaneous
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.conceallevel = 0
vim.opt.showmode = false
vim.opt.updatetime = 300
vim.opt.timeoutlen = 300

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
