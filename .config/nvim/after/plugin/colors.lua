

vim.cmd("colorscheme codedark")

vim.cmd("highlight Conceal      guibg=#1d1f21 ctermbg=none cterm=none")
vim.cmd("highlight CursorLine   guibg=#1d1f21 ctermbg=none cterm=none")
vim.cmd("highlight NonText      guibg=#1d1f21 ctermbg=none cterm=none")
vim.cmd("highlight Normal       guibg=#1d1f21 ctermbg=none cterm=none")
vim.cmd("highlight SpecialKey   guibg=#1d1f21 ctermbg=none cterm=none")
vim.cmd("highlight LineNr       guibg=#1d1f21 ctermbg=none cterm=none")
vim.cmd("highlight Folded       guibg=#1d1f21 ctermbg=none cterm=none")
vim.cmd("highlight VertSplit    guibg=#1d1f21 ctermbg=none cterm=none")
vim.cmd("highlight SignColumn   guibg=#1d1f21 ctermbg=none cterm=none")
vim.cmd("highlight EndOfBuffer  guibg=#1d1f21 ctermbg=none cterm=none")









local hl = function(thing, opts)
    vim.api.nvim_set_hl(0, thing, opts)
end

--[[ hl("Conceal", { bg = "none"})
hl("CursorLine", { bg = "none"})
hl("NonText", { bg = "none"})
hl("Normal", { bg = "none"})
hl("SpecialKey", { bg = "none"})
hl("LineNr", { bg = "none"})
hl("Folded", { bg = "none"})
hl("VertSpli", { bg = "none"})
hl("SignColumn", { bg = "none"})
hl("EndOfBuffer", { bg = "none"}) ]]
vim.g.neovide_transparency = 0.95
