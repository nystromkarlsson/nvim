return {
  {
    'stevearc/oil.nvim',
    dependencies = {
      {
        'nvim-mini/mini.icons',
        opts = {},
      },
    },
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = { view_options = { show_hidden = true } },
    keys = {
      {
        '<leader>o',
        '<cmd>Oil<cr>',
        desc = 'Open Oil',
      },
    },
  },
}
