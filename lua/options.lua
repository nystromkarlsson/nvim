-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- Line display
vim.opt.scrolloff = 8
vim.opt.wrap = false

-- File handling
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- UI / appearance
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Misc
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.schedule(function() vim.o.clipboard = "unnamedplus" end)
