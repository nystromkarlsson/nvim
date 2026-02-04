---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-lint',
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      go = { 'golangcilint' },
      markdown = { 'markdownlint' },
    }

    lint.linters.golangcilint.args = {
      'run',
      '--output.json.path=stdout',
      '--show-stats=false',
      '--issues-exit-code=0',
    }
    lint.linters.golangcilint.ignore_exitcode = true

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('Lint', { clear = true }),
      callback = function() lint.try_lint() end,
    })
  end,
  event = {
    'BufReadPre',
    'BufNewFile',
  },
}
