"============================================================
"
" .vimrc
"
"============================================================

"----------------------------------------------------
" vim-plug
"----------------------------------------------------
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug', {'dir': '~/.vim/plugged/vim-plug/autoload'}
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf'
Plug 'itchyny/lightline.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'vim-scripts/taglist.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'terryma/vim-expand-region'
Plug 'leafgarland/typescript-vim'


Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'ryanolsonx/vim-lsp-javascript'
Plug 'ryanolsonx/vim-lsp-typescript'

call plug#end()

"----------------------------------------------------
" キーマップ
"----------------------------------------------------
let mapleader = "\<Space>"
" 新しいファイルを開く
nnoremap <Leader>o :CtrlP<CR>
" <Space><Space>でビジュアルラインモードに切替
nmap <Leader><Leader> V
" vを押すたびに1文字>単語>段落...を選択する
vmap v <Plug>(expand_region_expand)
" <C-v>で前回の選択範囲に戻す
vmap <C-v> <Plug>(expand_region_shrink)

"----------------------------------------------------
" vim-trailing-whitespace
"----------------------------------------------------
let g:extra_whitespace_ignored_filetypes = ['unite']

"----------------------------------------------------
" ctags, taglist
"----------------------------------------------------
" Fixme: set tags = tagsするとvimの起動で一旦止まる
"set tags = tags
let Tlist_Ctags_Cmd        = "/usr/local/bin/ctags"  " ctagsのコマンド
let Tlist_Show_One_File    = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow  = 1
" \lでtaglistの開閉
map <silent> <leader>l :TlistToggle<CR>

"----------------------------------------------------
" エンコード
"----------------------------------------------------
let &termencoding = &encoding
set encoding=utf-8

"----------------------------------------------------
"一般
"----------------------------------------------------
set t_Co=256                    "256色化
set history=100                 "コロンコマンドを記録する数
set fileformats=unix,dos,mac    "改行コード識別
"編集中の内容を保ったまま別の画面に切替えられるようにする
set hid
"外部のエディタで編集中のファイルが変更されたら自動で読み直す
set autoread

"syntax enable
set background=dark
let g:color_name = "ChocolateLiquor"

"----------------------------------------------------
"検索関連
"----------------------------------------------------
set ignorecase        "検索文字列が小文字の場合は大文字小文字を区別しない
set smartcase         "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan          "検索時に最後まで行ったら最初に戻る
set noincsearch       "検索文字列入力時に順次対象文字列にヒットしない
"Esc連打で検索時にハイライトを消す
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"----------------------------------------------------
"装飾関連
"----------------------------------------------------
set number                  "行番号を表示
set title                   "タイトルをウィンドウ枠に表示
set ruler                   "カーソルの現在値を表示する
set nolist                  "タブや改行を表示しない
set showcmd                 "入力中のコマンドをステータスに表示する
set showmatch               "括弧入力時の対応する括弧を表示
set wildmenu                "補間候補を表示する
set wildmode=list:longest
set laststatus=2            "ステータスラインを常に表示
syntax on	                  "シンタックスハイライトを有効にする
set hlsearch                "検索結果文字列のハイライトを有効にする

"ステータスラインに文字コードと改行文字を表示する
if winwidth(0) >= 120
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=%l,%c%V%8P
else
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=%l,%c%V%8P
endif

"----------------------------------------------------
"編集、文書整形関連
"----------------------------------------------------
set backspace=indent,eol,start
set autoindent              "自動的にインデントする
"set smartindent            "インデントはスマートインデント(賢いインデント)
set tabstop=2               "タブ幅
set shiftwidth=2            "cindentやautoindent時に挿入されるタブ幅
set softtabstop=0
set expandtab               "タブの入力を空白文字に置き換える

"----------------------------------------------------
"ファイル関連
"----------------------------------------------------
set nobackup                "バックアップファイルを残さない

"----------------------------------------------------
"マップ定義
"----------------------------------------------------
map <Left> :bp<CR>
map <Right> :bn<CR>

"----------------------------------------------------
"autocmd
"----------------------------------------------------
if has("autocmd")
  filetype plugin on
  autocmd FileType text setlocal textwidth=78
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
  filetype indent on

  autocmd FileType * setlocal formatoptions-=ro
  autocmd FileType html :set indentexpr=
  autocmd FileType xhtml :set indentexpr=

  " Indent
  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 noet
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 noet
  autocmd FileType diff       setlocal sw=2 sts=2 ts=2 noet
  autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 noet
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType eruby      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vb         setlocal sw=4 sts=4 ts=4 noet
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xhtml      setlocal sw=2 sts=2 ts=2 noet
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 noet
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et
  autocmd FileType jade       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scss       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType typescript setlocal sw=2 sts=2 ts=2 et
endif " has("autocmd")

"----------------------------------------------------
"Unite
"----------------------------------------------------
nnoremap    [unite]   <Nop>
nmap    f [unite]

nnoremap <silent> [unite]c  :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]u  :<C-u>UniteWithBufferDir -buffer-name=files -prompt=%\  buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]b  :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]r  :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
nnoremap <silent> [unite]l  :<C-u>Unite colorscheme<CR>
nnoremap  [unite]f  :<C-u>Unite source<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " Overwrite settings.
endfunction

let g:unite_source_file_mru_limit = 200
let g:unite_cursor_line_highlight = 'TabLineSel'
let g:unite_abbr_highlight = 'TabLine'

" For vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
nnoremap <silent> <Leader>e :<C-u>VimFilerBufferDir<CR>

" For optimize.
let g:unite_source_file_mru_filename_format = ''

"----------------------------------------------------
"Neocomplcache
"----------------------------------------------------
let g:neocomplcache_enable_at_startup = 1
function InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k\|<\|/'
    return "\<tab>"
  elseif exists('&omnifunc') && &omnifunc == ''
    return "\<c-n>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

"----------------------------------------------------
"Nginx
"----------------------------------------------------
au BufRead,BufNewFile /etc/nginx/* set ft=nginx

"----------------------------------------------------
" NRDTree
"----------------------------------------------------
nnoremap <silent><C-e> :NERDTreeToggle<CR>

"----------------------------------------------------
" 貼り付け時にペーストバッファを上書きしない
"----------------------------------------------------
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()


"----------------------------------------------------
" コード補完(lsp)
"----------------------------------------------------
if executable('typescript-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx'],
        \ })
endif
if executable('typescript-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'javascript support using typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
endif


