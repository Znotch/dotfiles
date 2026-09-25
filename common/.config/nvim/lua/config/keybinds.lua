vim.g.mapleader = " "

--Easy Netrw
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

--Save and Quit
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', {desc = "Save"})
vim.keymap.set("n", "<leader>wq", "<cmd>wq<CR>", {desc = 'Save and quit'})

--Yank to Clip
vim.keymap.set('v', '<leader>y', '<cmd>%y+<CR>', {desc = "Yank to clp"})

--Source File
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
