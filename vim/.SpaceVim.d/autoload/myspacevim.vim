function! myspacevim#before() abort
  autocmd BufEnter * silent! lcd %:p:h
  autocmd BufEnter *.rs silent! set shiftwidth=4
endfunction

function! myspacevim#after() abort
endfunction


