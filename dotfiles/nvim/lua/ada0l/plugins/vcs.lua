return {
  {
    'tpope/vim-fugitive',
    cmd = 'Git',
    init = function() vim.cmd([[cab git Git]]) end,
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit' },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = '[Git] Open Lazy' },
    },
    config = function() vim.g.lazygit_floating_window_scaling_factor = 1 end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    opts = function()
      return {
        signcolumn = true,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        update_debounce = 100,
        max_file_length = 40000,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, '[Git] Next Hunk')

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, '[Git] Prev Hunk')
          map('n', '<leader>ht', function()
            vim.api.nvim_command('Gitsigns toggle_signs')
            vim.api.nvim_command('Gitsigns toggle_current_line_blame')
          end)
          map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>', '[Git] Stage Hunk')
          map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>', '[Git] Reset Hunk')
          map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, '[Git] stage hunk')
          map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, '[Git] reset hunk')
          map('n', '<leader>hp', gs.preview_hunk, '[Git] Preview Hunk')
          map('n', '<leader>hu', gs.undo_stage_hunk, '[Git] Undo Stage Hunk')
          map('n', '<leader>hS', gs.stage_buffer, '[Git] Stage Buffer')
          map('n', '<leader>hR', gs.reset_buffer, '[Git] Reset Buffer')
          map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame Line')
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>', '[Git] Gits Select Hunk')
        end,
      }
    end,
  },
}
