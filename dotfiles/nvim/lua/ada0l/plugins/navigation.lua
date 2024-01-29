return {
  {
    'echasnovski/mini.files',
    keys = {
      { '<leader>n', function() require('mini.files').open() end, desc = '[Files] Toggle' },
      { '<leader>N', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, desc = '[Files] Toggle current file' },
    },
    opts = { windows = { preview = false, width_focus = 40, width_preview = 90 } },
  },
  {
    'echasnovski/mini.jump2d',
    version = '*',
    keys = { '<CR>' },
    opts = { mappings = { start_jumping = '<CR>' }, labels = 'asdfghjkl;', silent = false, view = { dim = false }, allowed_windows = { current = true, not_current = false } },
    init = function() vim.cmd([[autocmd Filetype qf,minifiles lua vim.b.minijump2d_disable = true]]) end,
    config = function(_, opts) require('mini.jump2d').setup(opts) end,
  },
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

        window = { delay = 0, config = { width = 60, border = 'single' } },
      }
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
    opts = { mappings = { add = 'ms', delete = 'md', replace = 'mr', find = 'mf' }, search_method = 'cover_or_next' },
  },
  { 'echasnovski/mini.cursorword', enabled = true, version = '*', opts = {} },
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-symbols.nvim' },
    },
    keys = {
      { '<leader>f', ':Telescope find_files<CR>', desc = '[Telescope] Search files' },
      { '<leader>/', ':Telescope live_grep<CR>', desc = '[Telescope] Search by live grep' },
      { '<leader>b', ':Telescope buffers<CR>', desc = '[Telescope] Search buffer' },
      { '<leader>d', ':Telescope diagnostic<CR>', desc = '[Telescope] Search diagnostics' },
      { "<leader>'", ':Telescope resume<CR>', desc = '[Telescope] Resume Picker' },
      { '<leader>j', ':Telescope jumplist<CR>', desc = '[Telescope] Resume Picker' },
      { '<leader>S', ':Telescope lsp_dynamic_workspace_symbols<CR>', desc = '[Telescope] Search symbol' },
      { '<leader>s', ':Telescope lsp_document_symbols<CR>', desc = '[Telescope] Search symbol in workspace' },
      { '<leader>gs', ':Telescope git_status<CR>', desc = '[Git] status' },
      { '<leader>d', ':Telescope diagnostics<CR>', desc = '[LSP] Diagnostics' },
      { 'gd', ':Telescope lsp_definitions<CR>', desc = '[LSP] Denifition' },
      { 'gD', ':Telescope lsp_type_definitions<CR>', desc = '[LSP] Type denifitions' },
      { 'gD', ':Telescope lsp_type_definitions<CR>', desc = '[LSP] Type denifitions' },
      { 'gr', ':Telescope lsp_references<CR>', desc = '[LSP] References' },
      { 'gi', ':Telescope lsp_implementations<CR>', desc = '[LSP] Implementations' },
    },
    tag = '0.1.5',
    config = function(_, opts) require('telescope').setup(opts) end,
    opts = function()
      local actions = require('telescope.actions')
      return {
        defaults = {
          layout_strategy = 'flex',
          layout_config = {
            horizontal = { width = 0.9, height = 0.9 },
            vertical = { width = 0.9, height = 0.9 },
          },
          mappings = {
            i = {
              ['<c-k>'] = actions.move_selection_previous,
              ['<c-h>'] = actions.results_scrolling_up,
              ['<c-j>'] = actions.move_selection_next,
              ['<c-l>'] = actions.results_scrolling_down,
            },
          },
          file_ignore_patterns = { 'node_modules', 'build', 'dist' },
        },
        pickers = {
          git_status = {
            mappings = {
              i = {
                ['<Tab>'] = actions.git_staging_toggle,
              },
            },
          },
          live_grep = {
            file_ignore_patterns = {
              'yarn.lock',
              'package-lock.json',
              'package.json',
              'tsconfig.json',
            },
          },
          buffers = {
            mappings = {
              i = {
                ['<c-d>'] = actions.delete_buffer + actions.move_to_top,
              },
            },
          },
        },
      }
    end,
  },
}
