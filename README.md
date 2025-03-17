<div align="center">

<img alt="logo" src="cheato.png" width="300" height="auto">

### A Neovim plugin to view Markdown cheat sheets

</div>

https://github.com/user-attachments/assets/3d8bd755-e3f5-4f4f-8f71-55c049257dda


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
  directory = "~/cheatsheets",
}
```

</details>

### Keymaps

You can use the user command `Cheato` to open the cheat sheet picker.

#### Vim

```vim
vim.keymap.set("n", "<leader>oc", ":Cheato<cr>")
```

#### Lazy

```lua
keys = {
  {
    "<leader>oc",
    ":Cheato<cr>",
    desc = "Open cheat sheet",
  },
},
```

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
