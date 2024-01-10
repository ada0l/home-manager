local function diagnostic_format(diagnostic)
  if diagnostic.code then
    return ('[%s] %s'):format(diagnostic.code, diagnostic.message)
  end
  return diagnostic.message
end

local function on_attach(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- diagnostic
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.goto_next()
  end, opts)
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.goto_prev()
  end, opts)
  vim.keymap.set('n', '[e', function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, opts)
  vim.keymap.set('n', ']e', function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, opts)
  vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.setloclist()
  end, opts)
  vim.keymap.set('n', '<leader>e', function()
    vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR })
  end, opts)

  -- signature
  vim.keymap.set('n', '<leader>k', function()
    vim.lsp.buf.hover()
  end, opts)
  vim.keymap.set('i', '<C-h>', function()
    vim.lsp.buf.signature_help()
  end, opts)

  -- actions
  vim.keymap.set('n', '<leader>a', function()
    vim.lsp.buf.code_action()
  end, opts)
  vim.keymap.set('n', '<leader>r', function()
    vim.lsp.buf.rename()
  end, opts)
  vim.keymap.set('n', '=', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },

      { 'folke/neodev.nvim', opts = {} },
    },
    config = function(_, _)
      local lsp = require('lsp-zero')
      local lsp_config = require('lspconfig')
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()
      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')

      lsp.preset('recommended')

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp_action.luasnip_supertab(),
          ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        }),
      })

      ---@diagnostic disable-next-line: redundant-parameter
      lsp.set_preferences({
        suggest_lsp_servers = false,
        sign_icons = {
          error = 'E',
          warn = 'W',
          hint = 'H',
          info = 'I',
        },
      })

      lsp.on_attach(on_attach)

      mason.setup({
        ensure_instaled = {
          'stylua',
          'shfmt',
          'isort',
          'black',
          'prettier',
        },
      })
      mason_lspconfig.setup({
        ensure_installed = {
          'tsserver',
          'rust_analyzer',
          'nil_ls',
          'gopls',
        },
        handlers = {
          lsp.default_setup,
        },
      })

      vim.diagnostic.config({
        virtual_text = {
          source = 'always',
          format = diagnostic_format,
        },
        float = {
          source = 'always',
          format = diagnostic_format,
        },
      })

      lsp_config.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
          },
        },
      })

      lsp_config.pyright.setup({
        settings = {
          python = {},
        },
        before_init = function(_, config)
          config.settings.python.pythonPath = require('ada0l.utils').get_python_venv({ force = false })
        end,
      })
      lsp_config.gopls.setup({
        on_attach = on_attach,
        cmd = { 'gopls', 'serve' },
        filetypes = { 'go', 'go.mod' },
        root_dir = lsp_config.util.root_pattern('go.work', 'go.mod', '.git'),
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
      })

      lsp.setup()
    end,
  },
}
