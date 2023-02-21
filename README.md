# hi-my-words.nvim
HiMyWords is a Neovim plugin that helps to focus on (key)words.

## Commands
The plugin automatically install the following commands:
 * HiMyWordsToggle - find the word under cursor and highlights all instances. Update the search
                     register, so n and N will work as expected. Repeat the command
                     the comammand to remove the highlight. You can cycle throguh available
                     highlights colors by repeating this command.
 * HiMyWordsClear - clear all highlights.

## Limitations
 * Doesn't update other windows on removing highlights with `HiMyWordsToggle`.
