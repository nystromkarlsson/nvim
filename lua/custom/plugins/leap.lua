return {
  {
    'ggandor/leap.nvim',
    config = function()
      local leap = require 'leap'
      local leap_user = require 'leap.user'

      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
      vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

      -------------------------------------------------------------------------
      -- Preview filter (reduce visual noise / blinking)
      -------------------------------------------------------------------------
      -- Exclude whitespace and the middle of alphabetic words from preview:
      --   foobar[baaz] = quux
      --   ^----^^^--^^-^-^--^
      leap.opts.preview = function(ch0, ch1, ch2) return not (ch1:match '%s' or (ch0:match '%a' and ch1:match '%a' and ch2:match '%a')) end

      -------------------------------------------------------------------------
      -- Equivalence classes (brackets, quotes, whitespace)
      -------------------------------------------------------------------------
      leap.opts.equivalence_classes = {
        ' \t\r\n', -- whitespace
        '([{', -- opening brackets
        ')]}', -- closing brackets
        '\'"`', -- quotes
      }

      -------------------------------------------------------------------------
      -- Repeat keys: use <Enter> / <Backspace> to repeat leap motions
      -------------------------------------------------------------------------
      -- While Leap is active, these are the traversal keys.
      -- Outside of Leap, they behave normally.
      leap_user.set_repeat_keys('<enter>', '<backspace>')
    end,
  },
}
