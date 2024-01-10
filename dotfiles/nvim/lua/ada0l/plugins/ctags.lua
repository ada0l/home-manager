return {
  {
    'stevearc/aerial.nvim',
    cmd = { 'AerialToggle' },
    opts = function()
      local opts = {
        attach_mode = 'global',
        backends = { 'lsp', 'treesitter', 'markdown', 'man' },
        show_guides = true,
        open_automatic = false,
        layout = {
          min_width = { 40, 0.2 },
          resize_to_content = true,
          win_opts = {
            winhl = 'Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB',
            signcolumn = 'yes',
            statuscolumn = ' ',
          },
        },
        -- stylua: ignore
        guides = {
          mid_item   = "├╴",
          last_item  = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
      }
      return opts
    end,
  },
}
