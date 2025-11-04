return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    ---@module 'lazydev'
    ---@type lazydev.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      library = {
        {
          path = '${3rd}/luv/library',
          words = { 'vim%.uv' },
        },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
      },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, {
              buffer = event.buf,
              desc = 'LSP: ' .. desc,
            })
          end

          map('<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, 'Toggle diagnostics')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open document symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open workspace symbols')
          map('gra', vim.lsp.buf.code_action, 'Goto code action', {
            'n',
            'x',
          })
          map('grd', require('telescope.builtin').lsp_definitions, 'Goto definition')
          map('grD', vim.lsp.buf.declaration, 'Goto declaration')
          map('gri', require('telescope.builtin').lsp_implementations, 'Goto implementation')
          map('grn', vim.lsp.buf.rename, 'Rename')
          map('grr', require('telescope.builtin').lsp_references, 'Goto references')
          map('grt', require('telescope.builtin').lsp_type_definitions, 'Goto type definition')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({
              'CursorHold',
              'CursorHoldI',
            }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({
              'CursorMoved',
              'CursorMovedI',
            }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds {
                  group = 'kickstart-lsp-highlight',
                  buffer = event2.buf,
                }
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle inlay hints')
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'if_many',
        },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
        },
        virtual_lines = true,
      }

      -- local capabilities = require('blink.cmp').get_lsp_capabilities()
      ---@class LspServersConfig
      ---@field mason table<string, vim.lsp.Config>
      ---@field others table<string, vim.lsp.Config>
      local servers = {
        mason = {
          -- clangd = {},
          gopls = {},
          pyright = {},
          -- rust_analyzer = {},
          lua_ls = {
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
                diagnostics = { disable = { 'missing-fields' } },
              },
            },
          },
        },
        others = {
          biome = {
            root_dir = require('lspconfig.util').root_pattern('biome.json', 'biome.jsonc'),
            single_file_support = false,
          },
        },
      }

      for server, config in pairs(vim.tbl_extend('keep', servers.mason, servers.others)) do
        if not vim.tbl_isempty(config) then
          vim.lsp.config(server, config)
        end
      end

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_enable = true,
      }

      if not vim.tbl_isempty(servers.others) then
        vim.lsp.enable(vim.tbl_keys(servers.others))
      end
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
