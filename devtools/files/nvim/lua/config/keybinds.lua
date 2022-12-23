local keymap = vim.api.nvim_set_keymap

--
-- LEADER KEY
--
vim.g.mapleader = " "

--
-- Moving
--

keymap('i', '<PageUp>', '<C-O>50k', {})
keymap('n', '<PageUp>', '50k', {})
keymap('i', '<PageDown>', '<C-O>50j', {})
keymap('n', '<PageDown>', '50j', {})


--
-- Closing
--
keymap('i', "<C-w>", "<C-O>:bd<CR>", {})
keymap('n', "<C-w>", ":bd<CR>", {})

--
-- Tab indenting
--
keymap('n', '<Tab>', '>>_', {})
keymap('n', '<S-Tab>', '<<_', {})

keymap('i', '<S-Tab>', '<C-D>', {})

keymap('v', '<Tab>', '>gv', {})
keymap('v', '<S-Tab>', '<gv', {})
