-- hi-my-words.nvim
--

local M = {}

local api = vim.api

-- see default.lua for default settings

local function set_hl_groups(hl_grps)
  for i = 1, #hl_grps do
    api.nvim_set_hl(0, hl_grps[i][1], hl_grps[i][2]) -- ns_id = 0, i.e. globally
  end
end

local function notify(msg, log_level)
  if not M.opts.silent then
    vim.notify(string.format("HiMyWords: %s", msg, log_level))
  end
end

local Current_hl_grp = 1

-- Choose next highlight group.
-- Return:
--   string name of hl group
local function next_hl_grp()
  local last_hl_grp = Current_hl_grp
  Current_hl_grp = Current_hl_grp + 1
  -- overflow - cycle
  if Current_hl_grp > #M.opts.hl_grps then
    Current_hl_grp = 1
  end
  return M.opts.hl_grps[last_hl_grp][1] -- return string name of the group
end

-- Mapping word to hl_grp. key = "word", Value = hl_grp
local Words_hlgrps = {}
-- Register all marked words in the hash table. Key = "word", Value = match ID
local Words_register = {}

local function wreg_is_registered(w)
  return Words_register[w]
end

-- Register new word to the word register
-- w        - word to register
-- new_m_id - new match ID (used to clear match)
local function wreg_register(w, new_m_id, hl_grp)
  local m_id = Words_register[w]
  if m_id ~= nil then
    vim.notify("HiMyWords: BUG: word already registered", vim.log.levels.ERROR)
  end
  Words_register[w] = new_m_id
  Words_hlgrps[w] = hl_grp
end

local function wreg_unregister(w)
  Words_register[w] = nil
  Words_hlgrps[w] = nil
end

local function wreg_clear()
  Words_register = {}
  Words_hlgrps = {}
  Current_hl_grp = 1
end

-- return true if character is NOT alphanumeric and NOT _
local function not_part_of_word(ch)
  if string.find(ch, "[_%w]") == nil then
    return true
  end
  return false
end

local function ch(str, i)
  return string.sub(str, i, i)
end

-- Find word around character line[start_i] in the line
-- Returns:
--   0 if no word was found (empty line, blank char)
--   "word" - found word at character line[start_i]
local function get_word(line, start_i)
  local line_len = #line
  if line_len == 0 or not_part_of_word(ch(line, start_i)) then
    return 0
  end
  local word_start = 0
  local word_end = line_len
  -- backward search of the word's start
  for i = start_i, 1, -1 do
    if not_part_of_word(ch(line, i)) then
      word_start = i + 1
      break
    elseif i == 1 then
      word_start = i
      break
    end
  end
  -- forward search of the word's end
  for i = start_i, line_len do
    if not_part_of_word(ch(line, i)) then
      word_end = i - 1
      break
    end
  end
  return word_start, string.sub(line, word_start, word_end)
end

local function matchadd_all_windows(w, hl_grp)
  -- TODO: run in schedule?
  local new_m_id = vim.fn.matchadd(hl_grp, "\\<" .. w .. "\\>", 10, -1)
  local cur_win_id = vim.api.nvim_tabpage_get_win(0)
  for _, w_id in ipairs(api.nvim_list_wins()) do
    if w_id ~= cur_win_id then
      api.nvim_win_call(w_id, function()
        vim.fn.matchadd(hl_grp, "\\<" .. w .. "\\>", 10, new_m_id)
      end)
    end
  end
  return new_m_id
end

local function matchdel_all_windows(m_id)
  -- TODO: run in schedule?
  for _, w_id in ipairs(api.nvim_list_wins()) do
    api.nvim_win_call(w_id, function()
    pcall(vim.fn.matchdelete, m_id)
    end)
  end
end

local function highlight_word_under_cursor()
  local r, c = unpack(api.nvim_win_get_cursor(0))
  local line = api.nvim_buf_get_lines(0, r - 1, r, true)[1]
  local ws, w = get_word(line, c + 1)
  if ws == 0 then
    notify("no word found under cursor", vim.log.levels.INFO)
    return
  end
  local m_id = wreg_is_registered(w)
  if m_id == nil then
    local hl_grp = next_hl_grp()
    m_id = matchadd_all_windows(w, hl_grp)
    wreg_register(w, m_id, hl_grp)
    -- TODO: introduce settings:
    vim.fn.setreg("/", "\\<" .. w .. "\\>")
  else
    matchdel_all_windows(m_id)
    wreg_unregister(w)
    -- TODO: introduce settings:
    local sw = vim.fn.getreg("/")
    if w == string.sub(sw, 3, -3) then
      vim.fn.setreg("/", "")
    end
  end
end

local function clear_all_highlights()
  wreg_clear()
  for _, w_id in ipairs(api.nvim_list_wins()) do
    api.nvim_win_call(w_id, function()
      vim.fn.clearmatches()
    end)
  end
end

-- TODO
-- vim.fn.getmatches() to store and vim.fn.setmatches() to restore

function M.setup(opts)
  -- opts will be extended by the default table
  M.opts = setmetatable(opts or {}, { __index = require("hi-my-words.defaults") })

  set_hl_groups(M.opts.hl_grps)

  vim.api.nvim_create_user_command("HiMyWordsToggle", function()
    highlight_word_under_cursor()
  end, { desc = "Highlight/unhighlight the word under cursor" })

  vim.api.nvim_create_user_command("HiMyWordsClear", function()
    clear_all_highlights()
  end, { desc = "Clear all highlights" })

  -- Some color-schemes clear highlights.
  -- Update the plugin's highlights if a color-scheme was loaded.
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Re-apply HiMyWords highlights after changing color-schemes",
    group = vim.api.nvim_create_augroup("HiMyWordsHiReload", { clear = true }),
    callback = function()
      set_hl_groups(M.opts.hl_grps)
    end,
  })

  -- Highlight words in the new windows
  vim.api.nvim_create_autocmd("WinNew", {
    desc = "HiMyWords highlights all registered words",
    group = vim.api.nvim_create_augroup("HiMyWordsHiRegitstered", { clear = true }),
    callback = function()
      for w, hl_grp in pairs(Words_hlgrps) do
        local m_id = Words_register[w]
        vim.fn.matchadd(hl_grp, "\\<" .. w .. "\\>", 10, m_id)
      end
    end,
  })
end

M.setup()

return M
