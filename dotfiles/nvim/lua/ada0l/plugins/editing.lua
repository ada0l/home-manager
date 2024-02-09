return {
  {
    'echasnovski/mini.comment',
    version = '*',
    keys = { { '<c-c>', mode = { 'n', 'v', 'x' }, desc = 'Comment' } },
    opts = { mappings = { comment = '<c-c>', comment_line = '<c-c>', comment_visual = '<c-c>', textobject = '<c-c>' } },
  },
  { 'echasnovski/mini.splitjoin', version = '*', lazy = true, keys = { { 'gS', desc = 'Splitjoin' } }, opts = { mappings = { toggle = 'gS', split = '', join = '' } } },
  { 'echasnovski/mini.pairs', version = '*', lazy = false, opts = {}, init = function() vim.cmd([[autocmd Filetype TelescopePrompt lua vim.b.minipairs_disable = true]]) end },
}
