# fzflua-gtags

> using [gtags](https://www.gnu.org/software/global/) under [fzf-lua](https://github.com/ibhagwan/fzf-lua/) !

## Setup

~~~lua
require("fzflua-gtags").setup()
~~~

Keymaps maybe like:

~~~lua
vim.keymap.set("n", "<leader>Gu", "<CMD>GtagsUpdate<CR>", { desc = "gtags update" })
vim.keymap.set("n", "<leader>Gd", "<CMD>GtagsFindDefs<CR>", { desc = "gtags find definition" })
vim.keymap.set("n", "<leader>Gr", "<CMD>GtagsFindRefs<CR>", { desc = "gtags find references" })
~~~

## Usage

- update: `:GtagsUpdate` update tag files incrementally. (os cmd: `global -u`)
- find definition: `:GtagsFindDefs` search word under cursor, or `:GtagsFindDefs <word>` with specified word. (os cmd: `global -x <word>` )
- find references: `:GtagsFindRefs` search word under cursor, or `:GtagsFindDefs <word>` with specified word. (os cmd: `global -xd <word>` )

