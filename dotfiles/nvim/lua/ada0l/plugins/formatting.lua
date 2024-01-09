local slow_format_filetypes = { 'typescript' }
return {
  {
    'stevearc/conform.nvim',
    dependencies = { 'mason.nvim' },
    event = { 'BufWritePre' },
    opts = function()
      return {
        format_on_save = function(bufnr)
          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          local function on_format(err)
            if err and err:match('timeout$') then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return { timeout_ms = 1000, lsp_fallback = true }, on_format
        end,

        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_fallback = true }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'isort', 'black' },
          typescript = { 'prettier_ts' },
          javascript = { 'prettier_js' },
        },
        formatters = {
          prettier_ts = {
            inherit = false,
            command = 'prettier',
            args = { '--parser', 'typescript' },
          },
          prettier_js = {
            inherit = false,
            command = 'prettier',
            args = { '--parser', 'javascript' },
          },
        },
      }
    end,
  },
}
