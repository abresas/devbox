" Version: 1.8
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" search ignores case when using only lowercase
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
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
let mapleader=","

set ofu=syntaxComplete#Complete

" keyword and omni completion with ctrl + space
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
\ "\<lt>C-n>" :
\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>

" Make it easier to write in Greek
:set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz
let g:acp_behaviorSnipmateLength = 1
