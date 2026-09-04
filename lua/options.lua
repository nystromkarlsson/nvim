local opt = vim.opt

opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.virtualedit = "block"

opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 2
opt.smartindent = true
opt.softtabstop = 2
opt.tabstop = 2

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.completeopt = "menu,menuone,noselect"
opt.fillchars = {
    diff = "/",
    eob = " ",
    fold = " ",
    foldclose = "▸",
    foldopen = "▾",
    foldsep = " ",
}
opt.laststatus = 3
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.matchtime = 2
opt.pumblend = 10
opt.pumheight = 10
opt.ruler = false
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmatch = true
opt.showmode = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.winminwidth = 5
opt.wrap = false

opt.autowrite = true
opt.backup = false
opt.confirm = true
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
opt.writebackup = false

opt.timeoutlen = 300
opt.ttimeoutlen = 0
opt.updatetime = 300

opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.diffopt:append("linematch:60")
opt.formatoptions = "jcroqlnt"
opt.iskeyword:append("-")
opt.jumpoptions = "view"
opt.mouse = "a"
opt.path:append("**")
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })
opt.wildmode = "longest:full,full"

opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"

opt.maxmempattern = 20000
opt.redrawtime = 10000
opt.synmaxcol = 300
