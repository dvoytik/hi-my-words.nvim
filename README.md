# hi-my-words.nvim
HiMyWords is a [Neovim](https://neovim.io/) plugin that helps to focus on (key)words.

See [demo](https://github.com/dvoytik/hi-my-words.nvim/wiki#demo).

## ⚙️ Functionality
The plugin automatically installs the following commands:
 * `HiMyWordsToggle` - this command finds the word under cursor and highlights all its instances.
                       The search register will be updated, so `n` and `N` search commands will
                       work as expected. To remove the highlight under the cursor, execute this
                       command again. You can cycle throguh available highlight colors by repeating 
                       this command (execute twice for pick next color).
 * `HiMyWordsClear` - clear all highlights.

## 📦 Installation

- [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use "dvoytik/hi-my-words.nvim"
```

**Tip**: set up a convinient mappin in your config, for example:
```lua
vim.api.nvim_set_keymap("n", "<Space>m", ":HiMyWordsToggle<CR>", { noremap = true })
```

## Limitation
