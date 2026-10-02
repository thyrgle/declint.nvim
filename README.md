# declint.nvim

[declint](https://github.com/thyrgle/declint) for Neovim: one small
plugin that attaches the built-in LSP client to the `declint` language
server. Diagnostics and quickfixes from your `.declint.yaml` rules, as
you type.

<img width="951" height="484" alt="nvimdeclint" src="https://github.com/user-attachments/assets/7e442325-5cd1-4bc5-b58a-b5f03c934430" />

## Install

**lazy.nvim**

```lua
{
  'thyrgle/declint.nvim',
  config = function()
    require('declint').setup()
  end,
}
```

**Neovim's native package manager (no plugin manager needed)**

```lua
vim.pack.add({ 'https://github.com/thyrgle/declint.nvim' })
require('declint').setup()
```

**Classic `:packadd`**

```sh
git clone https://github.com/thyrgle/declint.nvim \
  ~/.local/share/nvim/site/pack/vendor/start/declint.nvim
```

```lua
-- init.lua
require('declint').setup()
```

## Setup

Prerequisite: the `declint` binary (once: `cargo install declint`), and
a config site in your project (`.declint.yaml`, `.declint/`, or
`declint.yaml` — `declint init --lang python` scaffolds one).

`require('declint').setup({ ... })` takes overrides merged over these
defaults:

```lua
{
  filetypes = { 'python', 'javascript', 'html', 'vue', 'svelte', 'erb',
                'handlebars', 'ini', 'markdown', 'json', 'toml', 'yaml',
                'sh', 'dockerfile' },
  cmd = { 'declint', 'serve' },
  markers = { '.declint.yaml', '.declint', 'declint.yaml' },
}
```

* `filetypes` — which buffers attach the linter. Match your declint
  configs' `languages` keys.
* `cmd` — the server command; point it at an absolute `declint` binary
  if it isn't on PATH.
* `markers` — files/directories that identify a project root.

## How attaching works

On each `FileType` event, the plugin walks up from the file looking for
a config-site marker. Found: one `declint serve` client starts per
project root and attaches every matching buffer in it. Not found: the
buffer just doesn't get a declint client — no noise.

## Troubleshooting

* **Client not attaching?** Check the buffer's detected filetype with
  `:set ft?` — the plugin attaches on the filetypes in `setup()`. Neovim
  detects `.ini` as `conf`, for example, so either add `conf` to
  `filetypes` or `:set filetype=ini` in a modeline/autocmd.
* **Client not attaching?** `:LspInfo` (or `:checkhealth vim.lsp`) — if
  no client is listed, no config site was found above the file. Run
  `declint check .` in the project to confirm the config itself works.
* **No diagnostics but the client is attached?** Your config's
  `languages` keys and the buffer's filetype must intersect — the
  server only publishes configs whose languages match.
