" Compiler: GNU Fortran Compiler (for FPM)
" Maintainer: Alexey Vyskubov <alexey@ocaml.nl>
" Version: 0.1.0
" Last Change: 2023-06-21
" License: BSD 2-clause

if exists('current_compiler')
    finish
endif
let current_compiler = 'gfortran_fpm'
let s:keepcpo= &cpo
set cpo&vim

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" An error message starts with <file>:<line>:<column>: (%A below)
" followed by an empty line (the first %C below)
" and some lines, starting with spaces (the second %C below).
" It ends with Error: message (%Z below).
" I think fpm treats warnings as errors and warning messages are never
" displayed.
" The generic compiler information is ignored (%-G).
CompilerSet errorformat=%A%f:%l:%c:,%C,%C\ %.%#,%Z%trror:\ %m,%-G%.%#

let &cpo = s:keepcpo
unlet s:keepcpo
