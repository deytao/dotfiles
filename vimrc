set shell=/bin/bash
set nocompatible

let mapleader='\'

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'dart-lang/dart-vim-plugin'
Plug 'ayu-theme/ayu-vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Yggdroot/indentLine'
Plug 'alvan/vim-closetag'
Plug 'davidhalter/jedi-vim'
Plug 'garbas/vim-snipmate'
Plug 'itchyny/lightline.vim'
Plug 'kien/ctrlp.vim'
Plug 'kovisoft/slimv'
Plug 'lepture/vim-jinja'
Plug 'michaeljsmith/vim-indent-object'
Plug 'scrooloose/nerdcommenter'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'thosakwe/vim-flutter'
Plug 'vim-scripts/argtextobj.vim'
Plug 'wincent/ferret'
Plug 'w0rp/ale'
call plug#end()

set background=dark
set t_Co=256
set termguicolors     " enable true colors support
"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
let ayucolor="dark"   " for dark version of theme
colorscheme ayu
hi! CursorLineNr cterm=bold ctermfg=64
set ai
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set relativenumber
set nu
set incsearch
set hlsearch
set ruler
set showcmd
set backspace=indent,eol,start
set nowrap

" Status line with lightline
set laststatus=2
set noshowmode
let g:lightline={ 'colorscheme': 'ayu' }

map Y y$

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

nnoremap <leader>T :set expandtab<cr>:retab!<cr>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

autocmd BufRead,BufNewFile *.twig set syntax=htmljinja
autocmd FileType html,htmljinja,htmldjango let g:closetag_html_style=1
autocmd FileType html,htmljinja,htmldjango source ~/.vim/bundle/vim-closetag/plugin/closetag.vim

" Lisp
let g:lisp_rainbow=1

let g:pymode_options_max_line_length = 180
let g:pymode_lint_options_pep8 = {'max_line_length': 180}

nnoremap <leader>fa :FlutterRun<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>
