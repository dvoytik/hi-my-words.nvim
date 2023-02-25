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

- Highly recommended: with [packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use "dvoytik/hi-my-words.nvim"
```

- Manually in your init.lua:
```lua
require("hi-my-words")
```

**Tip**: set up a convinient mappin in your config, for example:
```lua
vim.api.nvim_set_keymap("n", "<Space>m", ":HiMyWordsToggle<CR>", { noremap = true })
```

## Setup

Example how to change default colors from ten by default to only two:
```lua
require("hi-my-words").setup({
	hl_grps = {
		{
			"HiMyWordsHLG0",
			{ ctermfg = 0, ctermbg = 11, fg = "#2c5f2d", bg = "#97bc62", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG1",
			{ ctermfg = 0, ctermbg = 11, fg = "#408ec6", bg = "#1e2761", bold = true, italic = true },
		},
	},
})
```

<details><summary>Full config spec</summary>
<p>

### Default settings

The plugin automatically sets up the following defaults:

```lua
require("hi-my-words").setup({
	silent = false,
	hl_grps = {
		{
			"HiMyWordsHLG0",
			{ ctermfg = 130, ctermbg = 21, fg = "#eea47f", bg = "#00539c", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG1",
			{ ctermfg = 0, ctermbg = 11, fg = "#101820", bg = "#fee715", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG2",
			{ ctermfg = 0, ctermbg = 11, fg = "#ccf381", bg = "#4831d4", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG3",
			{ ctermfg = 0, ctermbg = 11, fg = "#e2d1f9", bg = "#317773", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG4",
			{ ctermfg = 15, ctermbg = 1, fg = "#ffffff", bg = "#8aaae5", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG5",
			{ ctermfg = 15, ctermbg = 1, fg = "#fcf6f5", bg = "#990011", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG6",
			{ ctermfg = 0, ctermbg = 11, fg = "#2f3c7e", bg = "#fbeaeb", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG7",
			{ ctermfg = 0, ctermbg = 11, fg = "#2c5f2d", bg = "#97bc62", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG8",
			{ ctermfg = 0, ctermbg = 11, fg = "#408ec6", bg = "#1e2761", bold = true, italic = true },
		},
		{
			"HiMyWordsHLG9",
			{ ctermfg = 15, ctermbg = 1, fg = "#990011", bg = "#fcf6f5", bold = true, italic = true },
		},
	},
})
```

</p>
</details>
