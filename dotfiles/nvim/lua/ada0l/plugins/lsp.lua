local function diagnostic_format(diagnostic)
  if diagnostic.code then return ('[%s] %s'):format(diagnostic.code, diagnostic.message) end
  return diagnostic.message
end

local function on_attach(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- diagnostic
  vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, vim.tbl_extend('keep', opts, { desc = 'Next diagnostic' }))
  vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, vim.tbl_extend('keep', opts, { desc = 'Prev diagnostic' }))
  vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, vim.tbl_extend('keep', opts, { desc = 'Next error' }))
  vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, vim.tbl_extend('keep', opts, { desc = 'Prev error' }))
  vim.keymap.set('n', '<leader>e', function() vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR }) end, vim.tbl_extend('keep', opts, { desc = 'Errors' }))

  -- signature
  vim.keymap.set('n', '<leader>k', function() vim.lsp.buf.hover() end, vim.tbl_extend('keep', opts, { desc = '[LSP] Hover' }))
  vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, vim.tbl_extend('keep', opts, { desc = '[LSP] Signature' }))

  -- actions
  vim.keymap.set('n', '<leader>a', function() vim.lsp.buf.code_action() end, vim.tbl_extend('keep', opts, { desc = '[LSP] Code action' }))
  vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, vim.tbl_extend('keep', opts, { desc = '[LSP] Rename' }))
  vim.keymap.set('n', '=', function() vim.lsp.buf.format({ async = true }) end, opts)
end

return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function(_, _)
      local lsp = require('lsp-zero')
      local lsp_config = require('lspconfig')
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()

      lsp.preset('recommended')

      cmp.setup({ mapping = cmp.mapping.preset.insert({ ['<Tab>'] = cmp_action.luasnip_supertab(), ['<S-Tab>'] = cmp_action.luasnip_shift_supertab() }) })

      ---@diagnostic disable-next-line: redundant-parameter
      lsp.set_preferences({ suggest_lsp_servers = false, sign_icons = { error = 'E', warn = 'W', hint = 'H', info = 'I' } })

      lsp.on_attach(on_attach)

      vim.diagnostic.config({ virtual_text = { source = 'always', format = diagnostic_format }, float = { source = 'always', format = diagnostic_format } })

      lsp_config.tsserver.setup({})
      lsp_config.nil_ls.setup({})
      lsp_config.lua_ls.setup({ settings = { Lua = { runtime = { version = 'LuaJIT' } } } })
      lsp_config.pyright.setup({
        settings = { python = {} },
        before_init = function(_, config) config.settings.python.pythonPath = require('ada0l.utils').get_python_venv({ force = false }) end,
      })
      lsp_config.gopls.setup({
        on_attach = on_attach,
        cmd = { 'gopls', 'serve' },
        filetypes = { 'go', 'go.mod' },
        root_dir = lsp_config.util.root_pattern('go.work', 'go.mod', '.git'),
        settings = { gopls = { analyses = { unusedparams = true, shadow = true }, staticcheck = true } },
      })

      lsp.setup()
    end,
  },
}
