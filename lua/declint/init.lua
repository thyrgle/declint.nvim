-- declint.nvim — attach Neovim's LSP client to the declint language
-- server.
--
-- require('declint').setup()     -- that's it
--
-- On FileType events for the configured languages, the plugin finds
-- the declint config site walking up from the file (`.declint.yaml`,
-- `.declint/`, `declint.yaml`) and starts one `declint serve` client
-- per project root. The server discovers configs exactly like the CLI
-- does; `languages` filtering happens in your config.

local M = {}

local DEFAULTS = {
  filetypes = {
    'python',
    'javascript',
    'html',
    'vue',
    'svelte',
    'erb',
    'handlebars',
    'ini',
    'markdown',
    'json',
    'toml',
    'yaml',
    'sh',
    'dockerfile',
  },
  cmd = { 'declint', 'serve' },
  markers = { '.declint.yaml', '.declint', 'declint.yaml' },
}

local config = nil

function M.setup(opts)
  config = vim.tbl_deep_extend('force', vim.deepcopy(DEFAULTS), opts or {})

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('declint.nvim', { clear = true }),
    pattern = config.filetypes,
    callback = M._on_filetype,
    desc = 'declint: start the language server',
  })
end

function M._on_filetype(args)
  if not config then
    return
  end

  local root = vim.fs.root(args.file, config.markers) or vim.fs.dirname(args.file)

  vim.lsp.start({
    name = 'declint',
    cmd = config.cmd,
    root_dir = root,
  })
end

return M
