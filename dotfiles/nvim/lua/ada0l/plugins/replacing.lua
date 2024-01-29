return {
  {
    'nvim-pack/nvim-spectre',
    keys = {
      { '<leader>\\', '<cmd>lua require("spectre").toggle()<cr>', desc = '[Git] Open Lazy' },
    },
    opts = {
      color_devicons = true,
      open_cmd = 'vnew',
      live_update = true,
      line_sep_start = '┌-----------------------------------------',
      result_padding = '¦  ',
      line_sep = '└-----------------------------------------',
      highlight = {
        ui = 'String',
        search = 'DiffChange',
        replace = 'DiffDelete',
      },
      mapping = {
        ['toggle_line'] = {
          map = 'dd',
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = 'toggle item',
        },
        ['enter_file'] = {
          map = '<cr>',
          cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
          desc = 'open file',
        },
        ['show_option_menu'] = {
          map = '<leader>o',
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = 'show options',
        },
        ['run_current_replace'] = {
          map = '<leader>rc',
          cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
          desc = 'replace current line',
        },
        ['run_replace'] = {
          map = '<leader>R',
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = 'replace all',
        },
        ['toggle_ignore_case'] = {
          map = 'ti',
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = 'toggle ignore case',
        },
        ['toggle_ignore_hidden'] = {
          map = 'th',
          cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          desc = 'toggle search hidden',
        },
        ['resume_last_search'] = {
          map = '<leader>l',
          cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
          desc = 'repeat last search',
        },
      },
      find_engine = {
        ['rg'] = {
          cmd = 'rg',
          args = {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
          },
          options = {
            ['ignore-case'] = {
              value = '--ignore-case',
              icon = '[I]',
              desc = 'ignore case',
            },
            ['hidden'] = {
              value = '--hidden',
              desc = 'hidden file',
              icon = '[H]',
            },
          },
        },
        ['ag'] = {
          cmd = 'ag',
          args = {
            '--vimgrep',
            '-s',
          },
          options = {
            ['ignore-case'] = {
              value = '-i',
              icon = '[I]',
              desc = 'ignore case',
            },
            ['hidden'] = {
              value = '--hidden',
              desc = 'hidden file',
              icon = '[H]',
            },
          },
        },
      },
      replace_engine = {
        ['sed'] = {
          cmd = 'sed',
          args = nil,
          options = {
            ['ignore-case'] = {
              value = '--ignore-case',
              icon = '[I]',
              desc = 'ignore case',
            },
          },
        },
        ['oxi'] = {
          cmd = 'oxi',
          args = {},
          options = {
            ['ignore-case'] = {
              value = 'i',
              icon = '[I]',
              desc = 'ignore case',
            },
          },
        },
      },
      default = {
        find = {
          cmd = 'rg',
          options = { 'ignore-case' },
        },
        replace = {
          cmd = 'sed',
        },
      },
      replace_vim_cmd = 'cdo',
      is_open_target_win = true,
      is_insert_mode = false,
      is_block_ui_break = false,
    },
  },
}
