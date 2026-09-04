local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

for _, key in ipairs({ "<left>", "<right>", "<up>", "<down>" }) do
    map("n", key, "", { desc = "Disabled, use hjkl" })
end

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })

map("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
map("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
map("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
map("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })

map("n", "<leader>cp", '<cmd>let @+ = expand("%")<CR>', { desc = "Buffer path" })
map("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>Q", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })
