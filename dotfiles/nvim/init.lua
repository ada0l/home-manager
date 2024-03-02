--{{{ OVERRIDE NOTIFY
local orig_notify = vim.notify
local filter_notify = function(text, level, opts)
  -- more specific to this case
  if
      type(text) == 'string'
      and (string.find(text, 'get_query', 1, true) or string.find(text, 'get_node_text', 1, true))
  then
    -- for all deprecated and stack trace warnings
    -- if type(text) == "string" and (string.find(text, ":help deprecated", 1, true) or string.find(text, "stack trace", 1, true)) then
    return
  end
  orig_notify(text, level, opts)
end
vim.notify = filter_notify
--}}}

--{{{ Functions
local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

local xmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, opts)
end
---}}}

--{{{ Options
vim.g.mapleader = ' '
vim.opt.compatible = false

vim.opt.fileformat = 'unix'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.confirm = true

vim.opt.timeoutlen = 300
vim.opt.updatetime = 200

vim.opt.ttyfast = true
vim.opt.lazyredraw = true

vim.opt.scrolloff = 8
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3

vim.opt.inccommand = 'split'
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.magic = true

vim.opt.foldmethod = 'marker'

vim.opt.autoread = true

vim.opt.completeopt = { 'menu', 'menuone', 'preview', 'noselect' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.opt.pumheight = 10
vim.opt.pumblend = 10

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.errorbells = false
vim.opt.visualbell = true

vim.opt.background = 'dark'
--}}}

--{{{ Install mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  })
end

require('mini.deps').setup({ path = { package = path_package } })
---@diagnostic disable-next-line: undefined-global
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
--}}}

--{{{ Extra
now(function() require('mini.extra').setup() end)
--}}}

--{{{ Misc
later(function() require("mini.misc").setup({ make_global = { "zoom" } }) end)
--}}}

--{{{Session
later(function() require("mini.sessions").setup({ file = '' }) end)
--}}}

--{{{ Mapping
now(function()
  vim.keymap.set('v', '<', '<gv', { desc = 'Shift left', silent = true })
  vim.keymap.set('v', '>', '>gv', { desc = 'Shift left', silent = true })

  vim.keymap.set('n', '<c-e>', '4<c-e>', { silent = true })
  vim.keymap.set('n', '<c-y>', '4<c-y>', { silent = true })

  vim.keymap.set('c', '<C-p>', '<Up>', { silent = false })
  vim.keymap.set('c', '<C-n>', '<Down>', { silent = false })

  vim.keymap.set('n', 'mi', 'vi', { noremap = false, silent = true })
  vim.keymap.set('n', 'ma', 'va', { noremap = false, silent = true })

  vim.keymap.set('n', '=', function() vim.lsp.buf.format({ async = true }) end)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
  vim.keymap.set('n', 'gr', '<cmd>Pick lsp scope="references"<cr>', { desc = "References" })
  vim.keymap.set('n', 'gi', '<cmd>Pick lsp scope="implementation"<cr>', { desc = "Implementation" })

  vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>', { desc = "Select hunk" })
end)
--}}}

--{{{ Bracket mapping
now(function()
  vim.keymap.set('n', ']h', '<cmd>next_hunk()', { desc = 'Next Hunk' })
  vim.keymap.set('n', '[h', '<cmd>prev_hunk()', { desc = 'Prev Hunk' })
end)
--}}}

--{{{ Leader mapping
now(function()
  nmap_leader('<leader>', '<cmd>noh<cr>', 'Clean search')
  nmap_leader('0', '<cmd>e ~/.config/home-manager/dotfiles/nvim_mini/init.lua<cr>', 'Open config')

  nmap_leader('cd', '<cmd>cd %:p:h<cr>:pwd<cr>', 'cd')
  nmap_leader('cx', '<cmd>!chmod +x %<cr>', 'chmod +x')

  nmap_leader('o', '<cmd>only<CR>', 'Only')

  nmap_leader('q', '<cmd>bd<cr>', 'Delete buffer')
  nmap_leader('Q', '<cmd>bufdo bd<cr>', 'Delete buffers')

  xmap_leader('y', [["+y]], 'Yank to system clipboard')
  xmap_leader('p', [["+p]], 'Paste from system clipboard')
  xmap_leader('p', [["+p]], 'Paste from system clipboard')

  local open_file = function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end
  nmap_leader('n', function() require('mini.files').open() end, 'Files')
  nmap_leader('N', open_file, 'Files from current file')

  nmap_leader('gG', ':Git ', 'Git')
  nmap_leader('gg', '<cmd>LazyGit<cr> ', 'LazyGit')

  nmap_leader("sw", "<cmd>lua MiniSessions.select('write')<cr>", "Write a session")
  nmap_leader("sW", ":lua MiniSessions.write('')<left><left>", "Write a session")
  nmap_leader("sr", "<cmd>lua MiniSessions.select('read')<cr>", "Read a session")
  nmap_leader("sD", "<cmd>lua MiniSessions.select('delete')<cr>", "Delete a session")

  nmap_leader('hs', '<cmd>Gitsigns stage_hunk<cr>', 'Stage Hunk')
  nmap_leader('hr', '<cmd>Gitsigns reset_hunk<cr>', 'Reset Hunk')
  nmap_leader('hp', '<cmd>Gitsigns preview_hunk<cr>', 'Preview Hunk')
  nmap_leader('hu', '<cmd>Gitsigns undo_stage_hunk<cr>', 'Undo Stage Hunk')
  nmap_leader('hS', '<cmd>Gitsigns stage_buffer<cr>', 'Stage Buffer')
  nmap_leader('hR', '<cmd>Gitsigns reset_buffer<cr>', 'Reset Buffer')
  nmap_leader('hb', '<cmd>Gitsigns blame_line<cr>', 'Blame Line')
  nmap_leader('gs', '<cmd>Pick git_hunks<cr>', 'Git branches')
  nmap_leader('gb', '<cmd>Pick git_branches<cr>', 'Git branches')
  nmap_leader('gf', '<cmd>!gh browse %<cr>', 'Browse file')

  nmap_leader('w', "<cmd>lua require('nvim-window').pick()<cr>", 'Jump to window')

  nmap_leader('li', '<cmd>LspInfo<cr>', 'Lsp info')
  nmap_leader('lr', '<cmd>LspRestart<cr>', 'Lsp restart')

  nmap_leader('k', vim.lsp.buf.hover, 'Hover')
  nmap_leader('a', vim.lsp.buf.code_action, 'Code action')
  nmap_leader('r', vim.lsp.buf.rename, 'Rename')
  nmap_leader('S', '<cmd>Pick lsp scope="workspace_symbol"<cr>', 'Workspace symbol')
  nmap_leader('s', '<cmd>Pick lsp scope="document_symbol"<cr>', 'Document symbol')
  nmap_leader('t', '<cmd>AerialToggle!<CR>', 'Toggle aerial')

  nmap_leader('db', "<cmd>lua require'dap'.toggle_breakpoint()<cr>", 'Breakpoint')
  nmap_leader('dc', "<cmd>lua require'dap'.continue()<cr>", 'Continue')
  nmap_leader('do', "<cmd>lua require'dap'.step_over()<cr>", 'Step over')
  nmap_leader('di', "<cmd>lua require'dap'.step_into()<cr>", 'Step into')
  nmap_leader('dr', "<cmd>lua require'dap'.repl.open()<cr>", 'Repl')

  nmap_leader('dX', "<cmd>lua require('dapui').toggle()<cr>", 'UI toggle')
  nmap_leader('dxs', '<cmd>lua require("dapui").float_element("scopes")<cr>', 'Scopes')
  nmap_leader('dxt', '<cmd>lua require("dapui").float_element("stacks")<cr>', 'Stacks')
  nmap_leader('dxw', '<cmd>lua require("dapui").float_element("watches")<cr>', 'Watches')
  nmap_leader('dxb', '<cmd>lua require("dapui").float_element("breakpoints")<cr>', 'Brackpoints')
  nmap_leader('dxr', '<cmd>lua require("dapui").float_element("repl")<cr>', 'Repl')

  nmap_leader('f', '<cmd>Pick files<cr>', 'Files')
  nmap_leader('/', '<cmd>Pick grep_live<cr>', 'LiveGrep')
  nmap_leader('b', '<cmd>Pick buffers<cr>', 'Buffers')
  nmap_leader('d', '<cmd>Pick diagnostic<cr>', 'Diagnostics')
  nmap_leader("'", '<cmd>Pick resume<cr>', 'Resume')
  nmap_leader('j', '<cmd>Pick list scope="jump"<cr>', 'Jumplists')

  nmap_leader("z", '<cmd>lua zoom()<cr>', "Zoom")
end)
--}}}

--{{{ Autogroups
-- Remove whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '',
  command = ':%s/\\s\\+$//e',
})

-- Set indentation to 2 spaces
vim.api.nvim_create_augroup('setIndent', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = {
    'cpp',
    'javascript',
    'javascriptreact',
    'json',
    'lua',
    'markdown',
    'nix',
    'typescript',
    'vue',
  },
  command = 'setlocal shiftwidth=2 tabstop=2 softtabstop=2',
})

-- Enter insert mode when switching to terminal
vim.api.nvim_create_autocmd('TermOpen', {
  command = 'setlocal listchars= nonumber norelativenumber nocursorline',
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '',
  command = 'startinsert',
})

-- Close terminal buffer on process exit
vim.api.nvim_create_autocmd('BufLeave', {
  pattern = 'term://*',
  command = 'stopinsert',
})
--}}}

--{{{ LSP
later(function()
  add({
    source = 'VonHeikemen/lsp-zero.nvim',
    checkout = 'v3.x',
    depends = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',

      'neovim/nvim-lspconfig',
      'folke/neodev.nvim',
      'onsails/lspkind.nvim',
    },
  })
  require('neodev').setup({
    library = { plugins = { 'nvim-dap-ui' }, types = true },
  })

  local lsp_config = require('lspconfig')
  local cmp = require('cmp')
  local cmp_action = require('lsp-zero').cmp_action()

  cmp.setup({
    formatting = {
      fields = { 'abbr', 'kind', 'menu' },
      format = require('lspkind').cmp_format({
        mode = 'symbol',
        maxwidth = 50,
        ellipsis_char = '...',
      }),
      expandable_indicator = true,
    },
    mapping = cmp.mapping.preset.insert({
      ['<TAB>'] = cmp_action.luasnip_supertab(),
      ['<S-TAB>'] = cmp_action.luasnip_shift_supertab(),
      ['<c-y>'] = cmp.mapping.confirm({ select = true }),
    }),
  })

  local function diagnostic_format(diagnostic)
    if diagnostic.code then return ('[%s] %s'):format(diagnostic.code, diagnostic.message) end
    return diagnostic.message
  end

  vim.diagnostic.config({
    virtual_text = { source = 'always', format = diagnostic_format },
    float = { source = 'always', format = diagnostic_format },
  })
  lsp_config.tsserver.setup({
    -- filetypes = { 'javascript', 'typescript', 'typescriptreact', 'typescript.tsx' },
  })
  lsp_config.nil_ls.setup({})
  lsp_config.lua_ls.setup({ settings = { Lua = { runtime = { version = 'LuaJIT' } } } })
  lsp_config.pyright.setup({
    settings = { python = {} },
    -- before_init = function(_, config)
    --   config.settings.python.pythonPath = get_python_venv({ force = true })
    -- end,
  })
  lsp_config.gopls.setup({
    cmd = { 'gopls', 'serve' },
    filetypes = { 'go', 'go.mod' },
    root_dir = lsp_config.util.root_pattern('go.work', 'go.mod', '.git'),
    settings = { gopls = { analyses = { unusedparams = true, shadow = true }, staticcheck = true } },
  })
end)

later(function()
  add('stevearc/aerial.nvim')
  require('aerial').setup({
    on_attach = function(bufnr)
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
    end,
  })
end)
--}}}

--{{{ DAP
later(function()
  add({
    source = 'rcarriga/nvim-dap-ui',
    depends = {
      'mfussenegger/nvim-dap',
      'olexsmir/gopher.nvim',
      'mxsdev/nvim-dap-vscode-js',
      -- 'microsoft/vscode-js-debug',
    },
    hooks = {
      post_checkout = function() end,
    },
  })

  local vscode_js_debug = path_package .. '/pack/deps/opt/vscode-js-debug'
  if not vim.loop.fs_stat(vscode_js_debug) then
    local filename = 'js-debug-dap-v1.86.1.tar.gz'
    local buildLink = 'https://github.com/'
        .. 'microsoft/vscode-js-debug/'
        .. 'releases/download/v1.86.1/'
        .. filename
    vim.cmd('!mkdir -p ' .. vscode_js_debug)
    vim.cmd('!cd ' .. vscode_js_debug .. ' && wget ' .. buildLink)
    vim.cmd('!cd ' .. vscode_js_debug .. ' && tar -xf ' .. filename)
    vim.cmd('!mv ' .. vscode_js_debug .. '/js-debug/ ' .. vscode_js_debug .. '/out')
    vim.cmd('!rm -rf ' .. vscode_js_debug .. '/' .. filename)
  end

  require('dapui').setup()
  require('gopher.dap').setup()
  local dap = require('dap')

  local DEBUGGER_PATH = path_package .. 'pack/deps/opt/vscode-js-debug/out/src/dapDebugServer.js'
  -- require('dap-vscode-js').setup({
  --   node_path = 'node',
  --   debugger_path = DEBUGGER_PATH,
  --   -- debugger_cmd = { "js-debug-adapter" },
  --   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- })
  require('dap').adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'node',
      args = { DEBUGGER_PATH, '${port}' },
    },
  }
  for _, language in ipairs({ 'typescript', 'javascript' }) do
    dap.configurations[language] = {
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach',
        processId = function() return require('dap.utils').pick_process({ filter = 'yarn' }) end,
        cwd = '${workspaceFolder}',
      },
    }
  end
end)
--}}}

--{{{ Formatting
later(function()
  add('stevearc/conform.nvim')
  local slow_format_filetypes = { 'typescript' }

  local function format_on_save(bufnr)
    if slow_format_filetypes[vim.bo[bufnr].filetype] then return end
    local function on_format(err)
      if err and err:match('timeout$') then slow_format_filetypes[vim.bo[bufnr].filetype] = true end
    end
    return { timeout_ms = 1000, lsp_fallback = true }, on_format
  end

  local function format_after_save(bufnr)
    if not slow_format_filetypes[vim.bo[bufnr].filetype] then return end
    return { lsp_fallback = true }
  end

  require('conform').setup({
    format_on_save = format_on_save,
    format_after_save = format_after_save,
    formatters_by_ft = {
      -- lua = { 'stylua' },
      python = { 'isort', 'black' },
      typescript = { 'prettierd' },
      javascript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
    },
    formatters = {
      prettier_ts = { inherit = false, command = 'prettierd', args = { '--parser', 'typescript' } },
      prettier_js = { inherit = false, command = 'prettierd', args = { '--parser', 'javascript' } },
    },
  })
end)
--}}}

--{{{ Navigation
later(function() add('yorickpeterse/nvim-window') end)

later(function()
  add({
    source = 'antosha417/nvim-lsp-file-operations',
    depends = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-tree.lua',
    },
  })
  require('nvim-tree').setup()
  require('lsp-file-operations').setup({
    -- debug = true,
  })
end)

later(
  function()
    require('mini.files').setup({
      windows = { preview = false, width_focus = 40, width_preview = 90 },
    })
  end
)

later(
  function()
    require('mini.pick').setup({
      mappings = {
        scroll_down = '<C-d>',
        scroll_left = '<C-h>',
        scroll_right = '<C-l>',
        scroll_up = '<C-u>',

        move_down = '<C-j>',
        move_up = '<C-k>',
      },
    })
  end
)

later(function()
  local miniclue = require('mini.clue')
  miniclue.setup({
    clues = {
      -- miniclue.gen_clues.builtin_completion(),
      -- miniclue.gen_clues.g(),
      -- miniclue.gen_clues.marks(),
      -- miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      -- miniclue.gen_clues.z(),
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

    window = { delay = 500, config = { width = 60, height = 100, border = 'single' } },
  })
end)

later(function() require("mini.bracketed").setup() end)
--}}}

--{{{ Editing
later(
  function()
    require('mini.comment').setup({
      mappings = {
        comment = '<c-c>',
        comment_line = '<c-c>',
        comment_visual = '<c-c>',
        textobject = '<c-c>',
      },
    })
  end
)

later(
  function()
    require('mini.splitjoin').setup({ mappings = { toggle = 'gS', split = '', join = '' } })
  end
)

later(
  function()
    require('mini.surround').setup({
      mappings = {
        add = 'ms',
        delete = 'md',
        find = 'mf',
        replace = 'mr',
        suffix_last = 'l',
        suffix_next = 'n',
      },
    })
  end
)

later(function() require('mini.pairs').setup() end)

later(function() require('mini.operators').setup() end)

later(function() require('mini.ai') end)

later(function() require("mini.move") end)
--}}}

--{{{ Replacing
later(function()
  -- It's to avoid annoying "You need to install gnu sed 'brew install gnu-sed"
  -- I have sed on darwin!!!
  local _executable = vim.fn.executable
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.fn.executable = function(arg)
    if arg == 'gsed' then return 1 end
    return _executable(arg)
  end

  add({ source = 'nvim-pack/nvim-spectre', depends = { 'nvim-lua/plenary.nvim' } })
  require('spectre').setup({
    mapping = {
      ['toggle_line'] = {
        map = 'dd',
        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
        desc = 'toggle item',
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
    },
  })
end)
--}}}

--{{{ UI
later(function()
  add('nvim-tree/nvim-web-devicons')
  require('nvim-web-devicons').setup({})
end)

later(function() require('mini.statusline').setup() end)

later(function() require('mini.tabline').setup() end)

later(function() require('mini.notify').setup() end)

later(function()
  add({ source = 'utilyre/barbecue.nvim', depends = { 'SmiteshP/nvim-navic' } })
  require('barbecue').setup()
end)

now(function()
  add('catppuccin/nvim')
  vim.cmd('colorscheme catppuccin-mocha')

  add('f-person/auto-dark-mode.nvim')
  require('auto-dark-mode').setup({
    update_interval = 1000,
    set_dark_mode = function()
      -- vim.cmd('!kitten themes --reload-in=all Catppuccin-Mocha')
      vim.cmd('colorscheme catppuccin-mocha')
    end,
    set_light_mode = function()
      -- vim.cmd('!kitten themes --reload-in=all Catppuccin-Latte')
      vim.cmd('colorscheme catppuccin-latte')
    end,
  })
end)

later(function() require("mini.indentscope").setup({ draw = { delay = 0 } }) end)
--}}}

--{{{ VCS
later(function()
  add('tpope/vim-fugitive')
  vim.cmd([[cab git Git]])
end)

later(function()
  add('kdheepak/lazygit.nvim')
  vim.g.lazygit_floating_window_scaling_factor = 1
end)

later(function()
  add({
    source = 'lewis6991/gitsigns.nvim',
    checkout = 'release',
    depends = { 'nvim-lua/plenary.nvim' },
  })
  require('gitsigns').setup({ signcolumn = true })
end)
--}}}

--{{{ Tresitter
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'v0.7.2',
  })
  add('windwp/nvim-ts-autotag')

  ---@diagnostic disable-next-line: missing-fields
  require('nvim-treesitter.configs').setup({
    ignore_install = {},
    sync_install = false,
    auto_install = true,
    ensure_installed = {
      'dockerfile',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'c',
      'cpp',
      'html',
      'javascript',
      'typescript',
      'tsx',
      'prisma',
      'vue',
      'jsdoc',
      'go',
      'gomod',
      'gosum',
      'gowork',
      'lua',
      'luadoc',
      'luap',
      'markdown',
      'markdown_inline',
      'php',
      'phpdoc',
      'python',
      'sql',
      'vim',
      'vimdoc',
    },
    indent = {
      enable = true,
      disable = {},
    },
    compilers = { 'clang' },
    highlight = {
      enable = true,
      disable = function(_, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then return true end
      end,
      additional_vim_regex_highlighting = false,
    },
  })
  require('nvim-ts-autotag').setup({})
end)
--}}}

--{{{ Go
later(function()
  add({
    source = 'olexsmir/gopher.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'mfussenegger/nvim-dap',
    },
  })
  require('gopher').setup({
    commands = {
      dlv = 'dlv',
      go = 'go',
      gomodifytags = 'gomodifytags',
      gotests = 'gotests',
      impl = 'impl',
      iferr = 'iferr',
    },
  })
end)
--}}}
