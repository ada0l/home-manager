return {
  {
    'echasnovski/mini.clue',
    version = false,
    opts = function()
      local miniclue = require('mini.clue')
      return {
        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows({ submode_resize = true }),
          miniclue.gen_clues.z(),
        },

        triggers = {
          { mode = 'n', keys = 'm' },
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- 'mini.bracketed'
          { mode = 'n', keys = '[' },
          { mode = 'n', keys = ']' },
          { mode = 'x', keys = '[' },
          { mode = 'x', keys = ']' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        window = {
          delay = 200,
          config = {
            width = 60,
            border = 'single',
          },
        },
      }
    end,
  },
  {
    'echasnovski/mini.comment',
    version = '*',
    keys = {
      { '<c-c>', mode = { 'n', 'v', 'x' }, desc = '[Comment] toggle' },
    },
    opts = {
      mappings = {
        comment = '<c-c>',
        comment_line = '<c-c>',
        comment_visual = '<c-c>',
        textobject = '<c-c>',
      },
    },
  },
  {
    'echasnovski/mini.cursorword',
    enabled = true,
    version = '*',
    opts = {},
  },
  {
    'echasnovski/mini.doc',
    version = '*',
    opts = {},
  },
  {
    'echasnovski/mini.files',
    keys = {
      {
        '<leader>n',
        function()
          require('mini.files').open()
        end,
        desc = '[Files] Toggle',
      },
      {
        '<leader>N',
        function()
          require('mini.files').open(vim.api.nvim_buf_get_name(0))
        end,
        desc = '[Files] Toggle current file',
      },
    },
    opts = {
      windows = {
        preview = true,
        width_focus = 40,
        width_preview = 90,
      },
    },
  },
  {
    'echasnovski/mini.jump2d',
    version = '*',
    keys = {
      '<CR>',
    },
    opts = {
      mappings = {
        start_jumping = '<CR>',
      },
      labels = 'asdfghjkl;',
      silent = false,
      view = {
        dim = false,
      },
      allowed_windows = {
        current = true,
        not_current = false,
      },
    },
    config = function(_, opts)
      require('mini.jump2d').setup(opts)
    end,
  },
  {
    'echasnovski/mini.pairs',
    version = '*',
    lazy = true,
    event = { 'InsertEnter' },
    opts = {},
    init = function()
      vim.cmd([[autocmd Filetype TelescopePrompt lua vim.b.minipairs_disable = true]])
    end,
  },
  {
    'echasnovski/mini.splitjoin',
    version = '*',
    lazy = true,
    keys = { { 'gS', desc = '[Splitjoin] toggle' } },
    opts = {
      mappings = {
        toggle = 'gS',
        split = '',
        join = '',
      },
    },
  },
  {
    'echasnovski/mini.statusline',
    dependencies = {
      {
        'linrongbin16/lsp-progress.nvim',
        version = '1.0.4',
        opts = {
          client_format = function(client_name, spinner, series_messages)
            return #series_messages > 0 and ('[' .. client_name .. '] ' .. spinner) or nil
          end,
          format = function(client_messages)
            return #client_messages > 0 and (' ' .. table.concat(client_messages, ' ')) or ''
          end,
        },
      },
    },
    version = '*',
    opts = function()
      local function section_lsp_loading()
        return require('lsp-progress').progress()
      end
      ---@param args __statusline_args
      ---@return __statusline_section
      local function section_fileinfo(args)
        local filetype = vim.bo.filetype

        if filetype == '' or vim.bo.buftype ~= '' then
          return ''
        end

        if MiniStatusline.is_truncated(args.trunc_width) then
          return filetype
        end

        local encoding = vim.bo.fileencoding or vim.bo.encoding
        local format = vim.bo.fileformat

        return string.format('%s %s %s', filetype, encoding, format)
      end

      ---@param args __statusline_args
      ---@return __statusline_section
      ---@diagnostic disable-next-line: unused-local
      local function section_location(args)
        return '%l, %c'
      end

      return {
        content = {
          active = function()
            -- stylua: ignore start
            local mode, _     = MiniStatusline.section_mode({ trunc_width = 120 })
            local lsp_loading = section_lsp_loading()

            local git         = MiniStatusline.section_git({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })

            local filename    = MiniStatusline.section_filename({ trunc_width = 140 })

            local fileinfo    = section_fileinfo({ trunc_width = 120 })

            local location    = section_location({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
              { strings = { mode } },
              { strings = { filename } },
              { strings = { lsp_loading } },
              '%=', -- End left alignment
              '%<', -- Mark general truncate point
              '%=', -- End left alignment
              { strings = { git, diagnostics } },
              { strings = { fileinfo } },
              { strings = { location } },
            })
            -- stylua: ignore end
          end,
        },
        inactive = function()
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          return MiniStatusline.combine_groups({
            { strings = { filename } },
          })
        end,
        set_vim_settings = false,
      }
    end,
    config = function(_, opts)
      require('mini.statusline').setup(opts)
      local set_active = function()
        vim.wo.statusline = '%!v:lua.MiniStatusline.active()'
      end
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LspProgressStatusUpdated',
        callback = set_active,
      })
    end,
  },
  {
    'echasnovski/mini.surround',
    version = '*',
    keys = {
      { 'ms', mode = { 'x', 'v', 'n' }, desc = '[Match] Surround add' },
      { 'md', mode = { 'n', 'x', 'v' }, desc = '[Match] Surround delete' },
      { 'mr', mode = { 'n' }, desc = '[Match] Surround replace' },
      { 'mf', mode = { 'n' }, desc = '[Match] Surround find' },
    },
    opts = {
      mappings = {
        add = 'ms',
        delete = 'md',
        replace = 'mr',
        find = 'mf',
      },
      search_method = 'cover_or_next',
    },
  },
  { 'echasnovski/mini.tabline', version = '*', opts = {} },
}
