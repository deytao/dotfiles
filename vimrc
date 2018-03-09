set nocompatible
filetype off

let mapleader='\'

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'

" vim-scripts repos
Plugin 'closetag.vim'
Plugin 'ctrlp.vim'
Plugin 'snipMate'
Plugin 'vim-indent-object'

" original repos
Plugin 'altercation/vim-colors-solarized'
Plugin 'itchyny/lightline.vim'
Plugin 'kovisoft/slimv'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-obsession'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-speeddating'
Plugin 'vim-scripts/argtextobj.vim'
Plugin 'w0rp/ale'
Plugin 'Yggdroot/indentLine'

filetype plugin on
syntax on
set background=dark
set t_Co=256
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
colorscheme solarized
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
let g:lightline={ 'colorscheme': 'solarized' }

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
autocmd FileType html,htmljinja,htmldjango source ~/.vim/bundle/closetag.vim/plugin/closetag.vim

" Lisp
let g:lisp_rainbow=1

let g:pymode_options_max_line_length = 180
let g:pymode_lint_options_pep8 = {'max_line_length': 180}
