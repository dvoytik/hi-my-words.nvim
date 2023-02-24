# hi-my-words.nvim
HiMyWords is a [Neovim](https://neovim.io/) plugin that helps to focus on (key)words.

See [demo](https://github.com/dvoytik/hi-my-words.nvim/wiki#demo).

## ⚙️ Functionality
The plugin automatically installs the following commands:
 * `HiMyWordsToggle` - this command detects a word under cursor and highlights all its
                       instances in all windows. The search register is updated, so `n` and `N`
                       search commands work as expected. To remove the highlight under the cursor,
                       execute `HiMyWordsToggle` command again. By repeating the command twice
                       it is possible to cycles throguh available highlight colors.
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
