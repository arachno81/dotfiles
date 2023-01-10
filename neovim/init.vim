set encoding=utf-8
" set ambiwidth=double
set clipboard+=unnamed
set number
set hlsearch
set smartindent
set wildmenu
set ruler
set modifiable
set write
set tabstop=2
set shiftwidth=2
set cursorline
set guifont=Ricty\ Diminished\ 13
set guifontwide=Ricty\ Diminished\ 13
" set cursorcolumn
set title
set helplang=ja
scriptencoding utf-8
syntax enable
let g:indent_guides_enable_on_vim_startup = 1
" Move current line to up/down
" Ref: https://vim.fandom.com/wiki/Moving_lines_up_or_down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv


nmap <silent> <C-o><C-o> <ESC>i<C-r>=strftime("-------------------- \n%Y-%m-%d %H:%M:%S(%a)")<CR><CR>

nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap ss :<C-u>sp<CR><C-w>j
nnoremap sv :<C-u>vs<CR><C-w>l

vnoremap x "_x
nnoremap x "_x

" PLUGIN SETTINGS
call plug#begin('~/.config/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'sainnhe/gruvbox-material'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'simeji/winresizer'
Plug 'friendsofphp/php-cs-fixer'
Plug 'mattn/vim-maketable'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-jp/vimdoc-ja'
Plug 'skanehira/translate.vim'
Plug 'easymotion/vim-easymotion'
Plug 'skanehira/preview-markdown.vim'
Plug 'nathanaelkane/vim-indent-guides'
call plug#end()

" NERDTree SETTINGS
nmap <C-f> :NERDTreeToggle<CR>
let g:airline#extensions#tabline#enabled = 1
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab


" Airline SETTINGS
let g:airline_powerline_fonts = 1

" Esc SETTINGS
inoremap jk <Esc>
inoremap jj <Esc>

" /// Enable Netrw (default file browser)
" filetype plugin on
" /// Netrw SETTINGS
" let g:netwr_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_winsize = 30
" let g:netrw_sizestyle = "H"
" let g:netrw_timefmt = "%Y/%m/%d(%a) %H:%M:%S"
" let g:netrw_preview = 1

"/// SPLIT BORDER SETTINGS
hi VertSplit cterm=none

"" treesitter
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "typescript",
    "tsx",
  },
  highlight = {
    enable = true,
  },
}
EOF

"" gruvbox
if has('termguicolors')
	set termguicolors
endif
let g:gruvbox_material_cursor='orange'
let g:gruvbox_material_foreground='soft'
let g:gruvbox_material_ui_contrast='high'
let g:gruvbox_material_menu_selection_background='green'
let g:gruvbox_material_transparent_background=1
colorscheme gruvbox-material
"" coc.nvim
let g:coc_global_extensions = ['coc-eslint8', 'coc-tsserver', 'coc-prettier', 'coc-git', 'coc-fzf-preview', 'coc-lists', 'coc-snippets', 'coc-html', 'coc-css', 'coc-phpls', 'coc-vetur']

inoremap <silent> <expr> <C-Space> coc#refresh()
nnoremap <silent> K       :<C-u>call <SID>show_documentation()<CR>
nmap     <silent> [dev]rn <Plug>(coc-rename)
nmap     <silent> [dev]a  <Plug>(coc-codeaction-selected)iw

function! s:coc_typescript_settings() abort
  nnoremap <silent> <buffer> [dev]f :<C-u>CocCommand eslint.executeAutofix<CR>:CocCommand prettier.formatFile<CR>
endfunction

augroup coc_ts
  autocmd!
  autocmd FileType typescript,typescriptreact call <SID>coc_typescript_settings()
augroup END

function! s:show_documentation() abort
  if index(['vim','help'], &filetype) >= 0
    execute 'h ' . expand('<cword>')
  elseif coc#rpc#ready()
    call CocActionAsync('doHover')
  endif
endfunction

" fzf settings
let $FZF_DEFAULT_OPTS="--layout=reverse"
let $FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/**'"
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }

let mapleader = "\<Space>"

" fzf
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>g :GFiles<CR>
nnoremap <silent> <leader>G :GFiles?<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>r :Rg<CR>

" preview-markdown
let g:preview_markdown_parser='glow'
