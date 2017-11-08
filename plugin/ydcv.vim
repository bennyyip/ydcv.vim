" ydcv.vim      ydcv in Vim
" Author:       Ben Yip
" Version:      1.0
" URL:          https://github.com/bennyyip/ydcv.vim
" ---------------------------------------------------------------------
if  exists("g:loaded_ydcv")
  finish
endif
let g:loaded_ydcv = 1

function! s:ydcv(...)
  let vwidth = 35
  if (a:0 == 0)
    let isvisual = visualmode(" ")
    if isvisual == 'v'
      let word = s:GetVisual()
    else
      let word = expand("<cword>")
    endif
  else
    let word = a:1
  endif

  " Init
  if ( word == "" )
    return
  endif

  " Build Window

  let save_cursor = getpos('.')
  let vwinnum=bufnr('__Dictionary')
  if getbufvar(vwinnum, 'Dictionary') == 'Dictionary'
    let vwinnum = bufwinnr(vwinnum)
  else
    let vwinnum = -1
  endif

  if ( vwinnum >= 0 )
    if vwinnum != bufwinnr('%')
      execute "normal \<c-w>".vwinnum."w"
    endif
    setlocal modifiable
    silent %d _
  else

    " Make Title
    if (!exists('s:bufautocommandsset'))
      auto BufEnter *Dictionary let b:sav_titlestring = &titlestring | let &titlestring = '%{strftime("%c")}' | let b:sav_wrapscan = &wrapscan
      auto BufLeave *Dictionary let &titlestring = b:sav_titlestring | let &wrapscan = b:sav_wrapscan
      let s:bufautocommandsset=1
    endif

    auto BufEnter *Dictionary call s:Exit_Only_One_Window()

    execute 'bo '.vwidth.'vsplit __Dictionary'
    setlocal noswapfile
    setlocal buftype=nowrite
    setlocal bufhidden=delete
    setlocal nonumber
    setlocal nowrap
    setlocal norightleft
    setlocal foldcolumn=0
    setlocal modifiable
    setlocal nolist
    set nowrapscan

    let b:Dictionary = 'Dictionary'
  endif

  let vwinnum=bufnr('__Dictionary')

  let curpos = ['.', 0, 0, 0]
  call setpos('.', curpos)
  set winfixwidth
  let job = job_start("ydcv ".word,{"out_io":"buffer", "out_buf": vwinnum})
  " FIXME: setlocal nomodifiable after job is done.
  " setlocal nomodifiable
  highlight DicKeyword ctermbg=green ctermfg=black guibg=green guifg=black
  call matchadd("DicKeyword", word)
  execute "normal \<c-w>wk"
  call setpos('.', save_cursor)

endfunction

command! -nargs=* Ydcv call s:ydcv(<f-args>)

function! s:Exit_Only_One_Window()
  if winbufnr(2) == -1
    if tabpagenr('$') == 1
      bdelete
      quit
    else
      close
    endif
  endif
endfunction

function! s:GetVisual()
  let start = line("'<")
  let end = line("'>")
  if start != end
    return ""
  endif
  let line = getline(start)
  let selection = strpart(line, col("'<")-1, col("'>")-col("'<"))
  return selection
endfunction
