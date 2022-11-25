lua <<EOF

require("dpr.set")
require("dpr.packer")
require("dpr.telescope")

EOF


nnoremap <silent>` <esc>:ToggleTerm<CR>

nnoremap <silent><F1> <esc>:w<CR>
inoremap <silent><F1> <esc>:w<CR>
vnoremap <silent><F1> <esc>:w<CR>

nmap <leader>t :tabnew<CR>:Telescope find_files<CR>
nnoremap <leader>ws :Telescope lsp_document_symbols<CR>

"git
nmap <leader>gs :Git<CR>

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

" nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>pv :NvimTreeToggle<CR>
noremap <silent> <Leader>+ :vertical resize +5<CR>
noremap <silent> <Leader>- :vertical resize -5<CR>


tnoremap <Esc> <C-\><C-n>

" eslint_d
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exec = 'eslint_d'
" nnoremap <leader>f mF:%!eslint_d --stdin --fix-to-stdout --stdin-filename %<CR>`F

" neovide zoom
"
let g:gui_font_size = 12
silent! execute('set guifont=Menlo:h'.g:gui_font_size)
function! ResizeFont(delta)
let g:gui_font_size = g:gui_font_size + a:delta
execute('set guifont=Menlo:h'.g:gui_font_size)
endfunction
noremap <expr><D-=> ResizeFont(1)
noremap <expr><D--> ResizeFont(-1)
