set encoding=utf-8 "文字コードをUTF-8に設定
set clipboard+=unnamed "クリップボードの連携
set number "行番号の表示
set hlsearch "検索結果をハイライトする
set smartindent "自動でインデントする
set wildmenu "TABキーでコマンド候補一覧表示
set ruler "右下にカーソルの位置を表示
set modifiable "ファイルの編集を許可する
set write "ファイルを保存する前にバックアップファイルを作成しないようにする
set tabstop=2 "タブ幅の設定
set shiftwidth=2 "インデント幅の設定
set cursorline "カーソルライン表示
set title "タイトル表示
set helplang=ja "ヘルプ言語を日本語に
set shell=zsh "シェルをzshに指定
scriptencoding utf-8 "VimScriptの中で日本語を使用
syntax enable "シンタックスハイライトの有効化
let mapleader = "\<Space>"  "Leaderをスペースキーに割り当て
nnoremap <Leader>md :PreviewMarkdown right<CR> "Markdownプレビュー用

filetype plugin indent on " インデントをオン

set ambiwidth=double


" Treesitterのハイライトとインデントを自動で有効にする
autocmd BufReadPost,BufNewFile * TSBufEnable highlight
autocmd BufReadPost,BufNewFile * TSBufEnable indent

	"一括置換用設定
	cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's'

	" Vim Plug
	call plug#begin('~/.config/nvim/plugged')
	Plug 'vim-airline/vim-airline' "ステータスラインのカスタマイズ
	Plug 'vim-airline/vim-airline-themes'
	Plug 'tpope/vim-commentary' "GCCでコメントアウト
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'preservim/nerdtree' "ディレクトリのツリー表示
	Plug 'ryanoasis/vim-devicons' "Nerd fontのアイコン表示(先にNerd fontインストールの必要有り)
	Plug 'nvim-treesitter/nvim-treesitter' "シンタックスハイライト(少し複雑)
	Plug 'sainnhe/gruvbox-material' "Vim背景の透過
	" Plug 'dense-analysis/ale' "文法チェック(cocと重複して動いてないかも)
	Plug 'jiangmiao/auto-pairs' "カッコのペアを自動挿入
	Plug 'simeji/winresizer' "Vim画面分割
	Plug 'friendsofphp/php-cs-fixer' "PHPのコード修正
	Plug 'mattn/vim-maketable' "テーブルの作成
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'skanehira/translate.vim' "Vim内で使用できる翻訳
	Plug 'easymotion/vim-easymotion' "カーソル移動(スペース2回で行移動等)
	"Plug 'skanehira/preview-markdown.vim' "リアルタイムマークダウンプレビュー
	" Plug 'nathanaelkane/vim-indent-guides' "インデントの可視化
	Plug 'johngrib/vim-game-code-break' "テトリス
	Plug 'tjdevries/train.nvim' "移動操作練習
	Plug 'deris/vim-duzzle' "puzzle
	Plug 'magicmonty/sonicpi.nvim'
	Plug 'gen740/SmoothCursor.nvim' "カーソル追尾
	Plug 'NI57721/vim-shakyo' "写経
	" Plug 'https://github.com/adelarsq/vim-matchit'
	" "対応かっこへの移動/vim-matchupと目的がかぶってるらしいので一旦コメントアウト
	Plug 'andymass/vim-matchup'
	Plug 'honza/vim-snippets' "Vueのために
"	Plug 'shellRaining/hlchunk.nvim' "ブロックの開始と終了をハイライト
	"Plug 'rainbowhxch/accelerated-jk.nvim' "スクロールのスピードアップ
	"Plug 'kevinhwang91/promise-async' "コードブロック折りたたみ
"	Plug 'kevinhwang91/nvim-ufo' "コードブロック折りたたみ
	Plug 'vim-jp/vimdoc-ja' "日本語
	call plug#end()

	let g:indent_guides_enable_on_vim_startup = 1 "インデント可視化の設定

	" VScodeのようにAlt + jなどで行の入れ替えをおこなえるようにする
	nnoremap <A-j> :m .+1<CR>==
	nnoremap <A-k> :m .-2<CR>==
	inoremap <A-j> <Esc>:m .+1<CR>==gi
	inoremap <A-k> <Esc>:m .-2<CR>==gi
	vnoremap <A-j> :m '>+1<CR>gv=gv
	vnoremap <A-k> :m '<-2<CR>gv=gv

	" nvim-ufoの基本的なfold設定
	set foldcolumn=0
	set foldlevel=99
	set foldlevelstart=99
	set foldenable

	" Luaスクリプトの読み込み
"	luafile ~/.config/nvim/lua/ufo-setup.lua

	" NERDTree SETTINGS
	nmap <C-f> :NERDTreeToggle<CR>
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#buffer_idx_mode = 1
	let g:airline#extensions#tabline#buffer_idx_format = {
				\ '0': '0 ',
				\ '1': '1 ',
				\ '2': '2 ',
				\ '3': '3 ',
				\ '4': '4 ',
				\ '5': '5 ',
				\ '6': '6 ',
				\ '7': '7 ',
				\ '8': '8 ',
				\ '9': '9 '
				\}
	nmap <C-p> <Plug>AirlineSelectPrevTab
	nmap <C-n> <Plug>AirlineSelectNextTab
	nmap <leader>1 <Plug>AirlineSelectTab1
	nmap <leader>2 <Plug>AirlineSelectTab2
	nmap <leader>3 <Plug>AirlineSelectTab3
	nmap <leader>4 <Plug>AirlineSelectTab4
	nmap <leader>5 <Plug>AirlineSelectTab5
	nmap <leader>6 <Plug>AirlineSelectTab6
	nmap <leader>7 <Plug>AirlineSelectTab7
	nmap <leader>8 <Plug>AirlineSelectTab8
	nmap <leader>9 <Plug>AirlineSelectTab9

	" 画面分割後のウィンドウ移動
	nnoremap sj <C-w>j
	nnoremap sk <C-w>k
	nnoremap sl <C-w>l
	nnoremap sh <C-w>h
	nnoremap ss :<C-u>sp<CR><C-w>j
	nnoremap sv :<C-u>vs<CR><C-w>l

	" xキーでの削除を切り取りではなくデリートにする
	vnoremap x "_x
	nnoremap x "_x

	" %キーで対応するカッコにジャンプできるようにする
	packadd! matchit 


	" Airline SETTINGS
	let g:airline_powerline_fonts = 1
	let g:airline_mode_map = {
				\ 'n'  : 'Normal Mode',
				\ 'i'  : 'Insert Mode',
				\ 'R'  : 'Replace',
				\ 'c'  : 'Commandを打ってみても、いいんじゃないかな。',
				\ 'v'  : '気でも狂ったのかぁー！',
				\ 'V'  : 'V-Line',
				\ '⌃V' : 'V-Block',
				\ }
	let g:airline_theme = 'term'

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

	"「term」でターミナルを開く
	if has('nvim')
		command! -nargs=* Term split | terminal <args>
		command! -nargs=* Termv vsplit | terminal <args>
	endif

	" インサートモードをターミナルノーマルモードに
	tnoremap <C-c> <C-\><C-n>

	"Translate
	" 翻訳元言語
	let g:translate_source = "en"
	" 翻訳先言語
	let g:translate_target = "ja"
	" 翻訳結果ウィンドウのサイズ
	let g:translate_winsize = 50

	"" coc.nvim
	let g:coc_global_extensions = ['coc-eslint', 'coc-tsserver', 'coc-prettier', 'coc-git', 'coc-snippets', 'coc-html', 'coc-css', 'coc-phpls', 'coc-blade', '@yaegassy/coc-volar','@yaegassy/coc-tailwindcss3']

	"coc-eslint => JavaScriptコードの静的解析
	"coc-tsserver => TypeScript/JavaScriptの補完,文法チェック,自動整形など
	"coc-prettier =>コードの行折り返しなど
	"coc-snippets => スニペットの登録、呼び出しを可能にする

	" Laravel
	autocmd BufNewFile,BufRead *.blade.php set syntax=html
	autocmd BufNewFile,BufRead *.blade.php set filetype=html

	" SmoothCursor.nvim
	"autocmd VimEnter * lua require('smoothcursor').setup({type = "matrix"})

	"vim-shakyo
	nnoremap <leader>r <Plug>(shakyo-run)
	nnoremap <leader>q <Plug>(shakyo-quit)
	nnoremap <leader>c <Plug>(shakyo-clue)
