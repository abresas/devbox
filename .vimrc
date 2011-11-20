" Version: 1.8
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set bs=2
set ignorecase
set smartcase
set autoindent
set incsearch
set ruler
syntax on
setlocal spell spelllang=en
set nospell
set encoding=utf-8
set number
set smartindent
nnoremap j gj
nnoremap k gk
let mapleader=","
nmap <Leader>x <Plug>ToggleAutoCloseMappings

" keyword and omni completion with ctrl + space
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
\ "\<lt>C-n>" :
\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>
