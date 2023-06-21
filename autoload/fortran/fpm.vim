" Convenience functions to integrate vim and fpm
"
" Autor: Alexey Vyskubov
" License: BSD 2-clause

" The following global variables can be used:
" g:vim_fortran_fpm_fpm -- the name of "fpm" command. By default "fpm".
" g:vim_fortran_fpm_gfortran -- the name of "gfortran" command. By default
" "gfortran".
" g:vim_fortran_fpm_failure_hl -- the name of highlight element for failure
" popups. By default "WarningMsg".
" g:vim_fortran_fpm_failure_time -- the time to show failure popup for, in ms.
" By default 5000.
" g:vim_fortran_fpm_success_hl -- the name of highlight element for success
" popups. By default "Comment".  g:vim_fortran_fpm_success_time -- the time to
" show success popup for, in ms. By
" default 1000.

function! fortran#fpm#checkTools()
  let fpm = get(g:, "vim_fortran_fpm_fpm", "fpm")
  let gfortran = get(g:, "vim_fortran_fpm_gfortran", "gfortran")
  let fHl = get(g:, "vim_fortran_fpm_failure_hl", "WarningMsg")
  let fT = get(g:, "vim_fortran_fpm_failure_time", 5000)
  let sHl = get(g:, "vim_fortran_fpm_success_hl", "Comment")
  let sT = get(g:, "vim_fortran_fpm_success_time", 1000)

  " Check for FPM
  if !executable(fpm)
    let msg = "Cannot find '" .. fpm .. "'"
    echomsg msg
    call popup_notification(msg, #{line: 0, col: 0, highlight: fHl, time: fT})
    return 0
  endif

  " Check for FPM fortran compiler
  if empty($FPM_FC)
    let fpm_fc = gfortran
  else
    let fpm_fc = $FPM_FC
  endif
  if !executable(fpm_fc)
    let msg = "Cannot find '" .. fpm_fc .. "'"
    echomsg msg
    call popup_notification(msg, #{line: 0, col: 0, highlight: fHl, time: fT})
    return 0
  endif

  let msg = "Using fpm at '" .. exepath(fpm) .. "' and compiler at '"
        \ .. exepath(fpm_fc) .. "'"
  echomsg msg
  call popup_notification(msg, #{line: 0, col: 0, highlight: sHl, time: sT})
  return 1
endfunction

function! fortran#fpm#SetRunArgs()
  call inputsave()
  let g:vim_fortran_fpm_run_args = input("Arguments: ")
  call inputrestore()
endfunction

function! fortran#fpm#EditToml()
  let bufnum = bufnr("^fpm.toml$")
  if bufnum > 0
    buffer fpm.toml
  else
    tabedit fpm.toml
  endif
endfunction

function! fortran#fpm#RunTests()
  let fpm = get(g:, "vim_fortran_fpm_fpm", "fpm")
  let res = system(fpm .. " test")
  if v:shell_error
    let g:vim_fortran_fpm_failed_tests = res
    let fHl = get(g:, "vim_fortran_fpm_failure_hl", "WarningMsg")
    let fT = get(g:, "vim_fortran_fpm_failure_time", 5000)
    let msg = "Tests failed. Output in g:vim_fortran_fpm_failed_tests."
          \ .. "\n" .. g:vim_fortran_fpm_failed_tests
    call popup_notification(split(msg, "\n"),
          \ #{line: 0, col: 0, highlight: fHl, time: fT})
          \ g:FpmTestsFailureMessageHl})
    return 0
  else
    let sHl = get(g:, "vim_fortran_fpm_success_hl", "Comment")
    let sT = get(g:, "vim_fortran_fpm_success_time", 1000)
    call popup_notification("Tests passed.",
          \ #{line: 0, col: 0, time: sT, highlight: sHl})
    return 1
  endif
endfunction

function! fortran#fpm#Run(...)
  if get(a:, 0)
    let rel = " --profile release"
  else
    let rel = ""
  endif

  if exists("g:vim_fortran_fpm_run_args")
    let args = " -- " .. g:vim_fortran_fpm_run_args
  else
    let args = ""
  endif

  let fpm = get(g:, "vim_fortran_fpm_fpm", "fpm")
  let cmd = "!" .. fpm .. " run" .. rel .. args

  " If you want console window of fortran program to stay open, put in the end
  " of the program something like `read(*, *)`.
  silent execute cmd
endfunction

function! fortran#fpm#RunDebugTarget()
  call fortran#fpm#Run(v:false)
endfunction

function! fortran#fpm#RunReleaseTarget()
  call fortran#fpm#Run(v:true)
endfunction

function! fortran#fpm#StartDebugging()
  let fpm = get(g:, "vim_fortran_fpm_fpm", "fpm")
  let res = split(system(fpm .. " build --list"), "\n")
  for l in res
    if l =~ "\\<app\\>"
      let cmd = "Termdebug " .. l
      silent execute cmd
      break
    endif
  endfor
endfunction

function! fortran#fpm#Setup()
  let fpm = get(g:, "vim_fortran_fpm_fpm", "fpm")
  let &makeprg = fpm

  if empty($FPM_FC) || $FPM_FC == "gfortran"
    compiler gfortran_fpm
  endif

  if $FPM_FC == "ifort"
    compiler ifort
  endif

endfunction
