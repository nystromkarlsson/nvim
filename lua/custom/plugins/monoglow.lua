return {
  {
    'wnkz/monoglow.nvim',
    lazy = false,
    opts = {},
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme 'monoglow-z'
    end,
  },
}
