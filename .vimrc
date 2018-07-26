set nocompatible
filetype off

"###########"
"  Plugins  "
"###########"

" set the runtime path to include Vundle and initialize
set rtp+=/root/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Yggdroot/indentLine'

" https://github.com/gabrielelana/vim-markdown
Bundle 'gabrielelana/vim-markdown'

call vundle#end()
filetype plugin indent on
" :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"########"
"  Auto  "
"########"

augroup Shebang
  autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python\<nl>\"|$
  autocmd BufNewFile *.sh 0put =\"#!/bin/bash\<nl>\"|$
  autocmd BufNewFile *.pl 0put =\"#!/usr/bin/perl\<nl>\"|$
  autocmd BufNewFile *.pm 0put =\"#!/usr/bin/perl\<nl>\"|$
augroup END

"############"
"  Markdown  "
"############"
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_input_abbreviations = 0

"##########"
"  Syntax  "
"##########"

"############"
"  Shortcuts "
"############"

let mapleader = ","
set pastetoggle=<F11>

"############"
"  Personal  "
"############"
set background=dark

syntax on

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" IndentLine
let g:indentLine_char = '|'
let g:indentLine_color_term = 239
let g:indentLine_enabled = 1
