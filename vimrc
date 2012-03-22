call pathogen#infect()
filetype on
filetype plugin on
syntax on
set background=dark
set t_Co=256
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
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

nnoremap <leader>T :set expandtab<cr>:retab!<cr>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" template language support (SGML / XML too)
" ------------------------------------------
" and disable taht stupid html rendering (like making stuff bold etc)

"fun! SelectHTML()
    "let n = 1
    "while n < 50 && n < line("$")
        "" check for jinja
        "if getline(n) =~ '{%\s*\(extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
            "set ft=htmljinja
            "return
        "endif
        "" check for mako
        "if getline(n) =~ '<%\(def\|inherit\)'
            "set ft=mako
            "return
        "endif
        "" check for genshi
        "if getline(n) =~ 'xmlns:py\|py:\(match\|for\|if\|def\|strip\|xmlns\)'
            "set ft=genshi
            "return
        "endif
        "let n = n + 1
    "endwhile
    "" go with html
    "set ft=html
"endfun

"let g:jinja_syntax_html=0
"autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
"autocmd BufNewFile,BufRead *.html,*.htm  call SelectHTML()
"let html_no_rendering=1

autocmd FileType html,jinjahtml,htmldjango let b:closetag_html_style=1
autocmd FileType html,jinjahtml,htmldjango source ~/.vim/bundle/closetag/plugin/closetag.vim
