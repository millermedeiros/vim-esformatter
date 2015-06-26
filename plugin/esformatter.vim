" ============================================================================
" File:        esformatter.vim
" Maintainer:  Miller Medeiros <http://blog.millermedeiros.com/>
" Description: Expose commands to execute the esformatter binary on normal and
"              visual modes.
" Last Change: 2015-06-26
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================

" heavily inspired by: https://gist.github.com/nisaacson/6939960

if !exists('g:esformatter_debug') && (exists('loaded_esformatter') || &cp)
  finish
endif

let loaded_esformatter = 1

function! s:EsformatterNormal()
  " store current cursor position and change the working directory
  let win_view = winsaveview()
  let file_wd = expand('%:p:h')
  let current_wd = getcwd()
  execute ':lcd' . file_wd

  " pass whole buffer content to esformatter
  let output = system('esformatter', join(getline(1,'$'), "\n"))

  if v:shell_error
    echom "Error while executing esformatter! no changes made."
    echo output
  else
    " delete whole buffer content and append the formatted code
    normal! ggdG
    call append(0, split(output, "\n"))
    " need to delete the last line since append() will add an extra line
    execute ':$d'
  endif

  " Clean up: restore previous cursor position and working directory
  call winrestview(win_view)
  execute ':lcd' . current_wd
endfunction


function! s:EsformatterVisual() range
  " store current cursor position and change the working directory
  let win_view = winsaveview()
  let file_wd = expand('%:p:h')
  let current_wd = getcwd()
  execute ':lcd' . file_wd

  " get lines from the current selection and store the first line number
  let range_start = line("'<")
  let input = getline("'<", "'>")

  " if first/last lines are empty they will be removed after the formatting so
  " we set a flag to restore it later
  let restore_first_line = 0
  if input[0] == ''
    let restore_first_line = 1
  endif
  let restore_last_line = 0
  if input[-1] == ''
    let restore_last_line = 1
  endif

  let output = system('esformatter', join(input, "\n"))

  if v:shell_error
    echom 'Error while executing esformatter! no changes made.'
    echo output
  else
    " delete the old lines
    normal! gvd

    let new_lines = split(l:output, '\n')

    if 1 == restore_first_line
      call insert(new_lines, '')
    endif
    if 1 == restore_last_line
      call add(new_lines, '')
    endif

    " add new lines to the buffer
    call append(range_start - 1, new_lines)

    " Clean up: restore previous cursor position
    call winrestview(win_view)
    " recreate the visual selection and cancel it, so that the formatted code
    " can be reselected using gv
    execute "normal! V" . (len(new_lines)-1) . "j\<esc>"
  endif

  " Clean up: restore working directory
  execute ':lcd' . current_wd
endfunction

command! -range=0 -complete=shellcmd Esformatter call s:EsformatterNormal()
command! -range=% -complete=shellcmd EsformatterVisual call s:EsformatterVisual()
