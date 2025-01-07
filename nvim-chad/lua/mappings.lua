require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
vim.keymap.set('n', 'gD', require('vim.lsp.buf').definition, {})
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--

--
-- terminal toggle
map({"n" , "t" , "i" , "v"}, "<C-t>", function()
  require("nvterm.terminal").toggle "float"
end, { desc = "Toggle floating terminal" })
