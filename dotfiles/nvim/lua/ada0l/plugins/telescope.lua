return {
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
      { 'gd', ':Telescope lsp_definitions<CR>', desc = '[LSP] Denifition' },
      { 'gD', ':Telescope lsp_type_definitions<CR>', desc = '[LSP] Type denifitions' },
      { 'gD', ':Telescope lsp_type_definitions<CR>', desc = '[LSP] Type denifitions' },
      { 'gr', ':Telescope lsp_references<CR>', desc = '[LSP] References' },
      { 'gi', ':Telescope lsp_implementations<CR>', desc = '[LSP] Implementations' },
    },
    tag = '0.1.5',
    config = function(_, opts)
      require('telescope').setup(opts)
    end,
    opts = function()
      local actions = require('telescope.actions')
      return {
        defaults = {
          layout_strategy = 'flex',
          layout_config = {
            horizontal = {
              width = 0.9,
              height = 0.9,
            },
            vertical = {
              width = 0.9,
              height = 0.9,
            },
          },
          mappings = {
            i = {
              ['<c-k>'] = actions.move_selection_previous,
              ['<c-h>'] = actions.results_scrolling_up,
              ['<c-j>'] = actions.move_selection_next,
              ['<c-l>'] = actions.results_scrolling_down,
            },
          },
          file_ignore_patterns = {
            'node_modules',
            'build',
            'dist',
          },
        },
        pickers = {
          git_status = {
            mappings = {
              i = {
                ['<c-a>'] = actions.git_staging_toggle,
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
