local map = require('ada0l.utils').map

map('n', '<leader><cr>', '<cmd>noh<cr>', { desc = 'Clean search', silent = true })

map('v', '<', '<gv', { desc = 'Shift left', silent = true })
map('v', '>', '>gv', { desc = 'Shift left', silent = true })

map('n', '<leader>cd', '<cmd>cd %:p:h<cr>:pwd<cr>', { desc = 'cd' })
map('n', '<leader>cx', '<cmd>!chmod +x %<cr>', { desc = 'chmod +x', silent = true })

map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer', silent = true })
map('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous buffer', silent = true })

map('n', '<c-e>', '4<c-e>', { silent = true })
map('n', '<c-y>', '4<c-y>', { silent = true })

map('v', '<leader>y', [["+y]], { desc = 'Yank to system clipboard', noremap = false })
map('n', '<leader>p', [["+p]], { desc = 'Paste from system clipboard', noremap = false })
map('v', '<leader>p', [["+p]], { desc = 'Paste from system clipboard', noremap = false })

map('i', [[<Tab>]], [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
map('i', [[<S-Tab>]], [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

map('n', '<leader>q', '<cmd>bd<cr>', { desc = 'Delete buffer' })

map('c', '<C-p>', '<Up>', { silent = false })
map('c', '<C-n>', '<Down>', { silent = false })

map('n', 'mi', 'vi', { noremap = false, silent = true })
map('n', 'ma', 'va', { noremap = false, silent = true })

map({ 'n', 'v', 'x' }, 'ge', 'G', { desc = 'Go to end of file' })
map({ 'n', 'v', 'x' }, 'gh', '^', { desc = 'Go to start of line' })
map({ 'n', 'v', 'x' }, 'gl', '$', { desc = 'Go to end of line' })
map({ 'n', 'v', 'x' }, 'gc', function()
  require('ada0l.utils').goto_window('center')
end, { desc = 'Go to center of window' })
map({ 'n', 'v', 'x' }, 'gt', function()
  require('ada0l.utils').goto_window('top')
end, { desc = 'Go to top of window' })
map({ 'n', 'v', 'x' }, 'gb', function()
  require('ada0l.utils').goto_window('bottom')
end, { desc = 'Go to bottom of window' })
map({ 'n', 'v', 'x' }, 'gw', '*', { desc = 'Go to bottom of window' })
