call pathogen#infect()
filetype on
syntax on
set background=dark
set t_Co=256
let g:solarized_termcolors=256
colorscheme solarized
set nocompatible
set ai
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nu
set incsearch
set hlsearch
set ruler
set showcmd
set backspace=indent,eol,start
set nowrap
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [LEN=%L] 

map Y y$

inoremap jk <Esc>  " Esc is so far...
nnoremap <leader>T :set expandtab<cr>:retab!<cr>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
