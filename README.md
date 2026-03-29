# 🏷️fzflua-gtags

> using [gtags](https://www.gnu.org/software/global/) under [fzf-lua](https://github.com/ibhagwan/fzf-lua/) !

## Setup

If no pack manager:
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

- `:GtagsUpdate` Update tag files incrementally. (os cmd: `global -u`)

- `:GtagsFindDefs` Find definition with word under cursor. (os cmd: `global -x <cword>`)
- `:GtagsFindRefs` Find references with word under cursor. (os cmd: `global -xd <cword>`)

- `:GtagsFindDefs <word>` Find definition with specified word.
- `:GtagsFindDefs <word>` Find references with specified word.

