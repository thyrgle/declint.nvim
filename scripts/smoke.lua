-- Headless smoke: attach the declint client to a fixture project and
-- wait for diagnostics.
--
-- Usage: nvim --headless -l scripts/smoke.lua <declint.nvim-repo> <fixture-dir>

local repo = arg[1] or error('usage: nvim --headless -l smoke.lua <declint.nvim-repo> <fixture-dir>')
local fixture = arg[2] or error('usage: nvim --headless -l smoke.lua <declint.nvim-repo> <fixture-dir>')

vim.opt.rtp:prepend(repo)
vim.opt.loadplugins = true

local ok, err = pcall(function()
  vim.cmd('set runtimepath^=' .. vim.fn.fnameescape(fixture))
  vim.cmd('cd ' .. vim.fn.fnameescape(fixture))
  require('declint').setup()
  vim.cmd('edit sample.ini')
  -- Neovim may detect .ini as `conf`; the real-world note is that the
  -- buffer filetype is what the FileType autocmd keys on.
  vim.bo.filetype = 'ini'
end)
if not ok then
  error(err)
end

local deadline = vim.loop.now() + 15000
local attached, diags = false, nil
while vim.loop.now() < deadline do
  local clients = vim.lsp.get_clients({ name = 'declint', bufnr = 0 })
  attached = #clients > 0
  diags = #vim.diagnostic.get(0)
  if attached and diags and diags > 0 then
    break
  end
  vim.wait(100)
end

if not attached then
  error('declint client never attached')
end
if not diags or diags == 0 then
  error('expected at least one diagnostic')
end

print('SMOKE PASS: client attached, ' .. diags .. ' diagnostic(s)')
vim.cmd('0cq') -- exit 0
