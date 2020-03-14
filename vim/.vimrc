" reliably determine OS per https://vi.stackexchange.com/a/2577
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

if g:os == "Windows"
    set runtimepath^=~/.vim
    set runtimepath+=~/.vim/after
endif

"
" Plugins will be downloaded under the specified directory.
" Execute :PlugInstall to install plugins
"
call plug#begin('~/.vim/plugged')

" Declare list of plugins

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'altercation/vim-colors-solarized'
Plug 'kien/ctrlp.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'flazz/vim-colorschemes'
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'bling/vim-airline'
Plug 'Lokaltog/vim-easymotion'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-unimpaired'
Plug 'majutsushi/tagbar'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'terryma/vim-multiple-cursors'

" fzf on macOS
if g:os == "Darwin"
    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf.vim'
endif

call plug#end()

syntax on
filetype plugin indent on
runtime! macros/matchit.vim

set nocompatible

set incsearch
set ignorecase
set smartcase
set showmatch
set ruler
set showcmd
set number
set norelativenumber
set modeline
set modelines=5
let mapleader = ","
set laststatus=2                " always show status line

set backspace=indent,eol,start
set autoindent
set autoread

set history=50

" kill Ex mode with fire
nnoremap Q <nop>


" adds popup menu when pressing tab on Ex command line 
set wildchar=<Tab> wildmenu wildmode=full

" set wildmenu
" set wildmode=list:longest

set fileformats=unix,dos,mac

if has("gui_running")
    set background=dark
    colorscheme solarized
    set lines=60
    set columns=180
else
    colorscheme desert256
endif

" set cursorline
" set cursorcolumn

if has("gui_win32")
    set guifont=Envy_Code_R:h10,Consolas:h10,Monaco:h15,Inconsolata:h12
    winpos 50 50
    vmap ,x :!c:\utils\x86\tidy\tidy.exe -w 0 -q -i -xml -config c:\utils\x86\tidy\xml.config
    set runtimepath^=~/.vim
    set runtimepath+=~/.vim/after

    " prevents vim from breaking the symbolic link when editing a file
    set nobackup nowritebackup
elseif has("gui_mac")
    set guifont=Consolas:h14,Monaco:h15,Inconsolata:h12
    set macmeta
	set encoding=utf8
	set ffs=unix,dos
endif

set guioptions=mrb

set ts=4
set sw=4
set expandtab

syntax enable

set exrc    " enables per-directory .vimrc files
set secure  " disables unsafe commands in local .vimrc files

set nowrap

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8 bomb
    set fileencodings=ucs-bom,utf-8,latin1
endif

" cursor up / down 1 line at a time with set wrap
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" move line commands with formatting
nnoremap <C-S-j> :m+<CR>==
nnoremap <C-S-k> :m-2<CR>==
inoremap <C-S-j> <Esc>:m+<CR>==gi
inoremap <C-S-k> <Esc>:m-2<CR>==gi
vnoremap <C-S-j> :m'>+<CR>gv=gv
vnoremap <C-S-k> :m-2<CR>gv=gv

nmap <C-S-Down> <C-S-j>
nmap <C-S-Up>   <C-S-k>
imap <C-S-Down> <C-S-j>
imap <C-S-Up>   <C-S-k>
vmap <C-S-Down> <C-S-j>
vmap <C-S-Up>   <C-S-k>

" tab navigation
nnoremap <C-Left>  :tabprev<CR>
nnoremap <C-Right> :tabnext<CR>

nnoremap <A-Home> :bprev
nnoremap <A-End> :bnext

noremap <F4> :set hlsearch! hlsearch?<CR>

" bracket matching
" nnoremap <tab> %
" vnoremap <tab> %

" prevents insanity when searching for regexs
" nnoremap / /\v
" vnoremap / /\v

" EasyMotion overrides
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

nnoremap ; :
vnoremap ; :

" tagbar
nmap <F8> :TagbarToggle<CR>

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

if has("autocmd")
    let g:do_xhtml_mappings = 'yes'
endif

nnoremap <F5> :GundoToggle<CR>

" vim:sw=4:expandtab:ts=4
