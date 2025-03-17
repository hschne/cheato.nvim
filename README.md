<div align="center">

<img alt="logo" src="cheato.png" width="300" height="auto">

### A Neovim plugin to view Markdown cheat sheets

</div>

## Installation

### lazy.nvim

```lua
 {
  "hschne/cheato.nvim",
  dependencies = {
     "ibhagwan/fzf-lua",
     "MeanderingProgrammer/render-markdown.nvim" -- optional, for nice markdown rendering
   },
   opts = {}
 }
```

### packer.nvim

```lua
use({
  'hschne/cheato.nvim',
  after = { 'nvim-treesitter' },
  requires = {
    { 'ibhagwan/fzf-lua' },
    { 'MeanderingProgrammer/render-markdown.nvim', opt = true },
  },
  config = function()
    require('cheato').setup({})
  end,
})
```

## Setup

<details>
  <summary>Default Configuration</summary>

```lua
require("cheatsheet").setup({
  directory = "~/my-cheatsheets-directory",
}
```

</details>

## Cheatsheets

Cheat sheets are plain markdown files. Create them in your configured cheatsheet directory. You may use subfolders.

```
~/Documents/cheatsheets/
  ├── vim.md
  ├── git.md
  ├── languages/
  │   ├── python.md
  │   └── javascript.md
  └── tools/
      └── docker.md
```

## Credits

This plugin was inspired by [sudormrfbin/cheatsheet](https://github.com/sudormrfbin/cheatsheet.nvim).
