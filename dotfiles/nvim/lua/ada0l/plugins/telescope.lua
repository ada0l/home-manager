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
      { '<leader>S', ':Telescope lsp_dynamic_workspace_symbols<CR>', desc = '[Telescope] Search symbol' },
      { '<leader>s', ':Telescope lsp_document_symbols<CR>', desc = '[Telescope] Search symbol in workspace' },
    },
    tag = '0.1.5',
    config = function(_, opts)
      require('telescope').setup(opts)
    end,
    opts = function()
      local actions = require('telescope.actions')
      return {
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--no-config',
            '--no-ignore',
            '--color=never',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '-g=!.git',
            '-g=!.ccls-cache',
            '-g=!node_modules',
            '-g=!lazy-lock.json',
            '-g=!venv',
            '-g=!__pycache__',
            '-g=!dist',
          },
          layout_config = {
            vertical = { width = 1 },
          },
          file_ignore_patterns = {
            'node_modules',
            'build',
            'dist',
            'yarn.lock',
            'package-lock.json',
          },
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ['<c-d>'] = actions.delete_buffer + actions.move_to_top,
              },
            },
            -- previewer = false,
          },
          find_files = {
            -- previewer = false,
          },
        },
      }
    end,
  },
}
