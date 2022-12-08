-- disable netrw at the very start of your init.lua (strongly advised)
--[[ vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    hijack_cursor = true,
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    renderer = {
        highlight_git = true,
    },
    git = {
        enable = true,
        ignore = true,
    }
}) ]]
