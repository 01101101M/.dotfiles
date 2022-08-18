lua <<EOF

require("dpr.set")
require("dpr.packer")
require("dpr.telescope")

EOF


nnoremap <silent><F1> <esc>:w<CR>
inoremap <silent><F1> <esc>:w<CR>
vnoremap <silent><F1> <esc>:w<CR>

nmap <leader>t :tabnew<CR>:Telescope find_files<CR>

"git
nmap <leader>gs :Git<CR>
nmap <leader>] <Plug>(GitGutterNextHunk)
nmap <leader>[ <Plug>(GitGutterPrevHunk)

"move selection
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap Y yg$
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
noremap <silent> <Leader>+ :vertical resize +5<CR>
noremap <silent> <Leader>- :vertical resize -5<CR>

let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_fullscreen=v:true

