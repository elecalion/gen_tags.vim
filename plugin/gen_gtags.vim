" ============================================================================
" File: gen_gtags.vim
" Arthur: Jia Sui <jsfaint@gmail.com>
" Description:  1. Generate GTAGS under the project folder.
"               2. Add db when vim is open.
" Required: This script requires enable cscope support and GNU global.
" Usage:
"   1. Generate GTAGS
"   :GenGTAGS or <leader>gg
"   2. Clear GTAGS
"   :ClearGTAGS
" ============================================================================
let s:file = "GTAGS"

"Check cscope support
if !has("cscope")
  echomsg "Need cscope support"
  echomsg "gen_gtags.vim need cscope support"
  finish
endif

if !executable('gtags') && !executable('gtags.exe')
  echomsg "GNU Global not found"
  echomsg "gen_gtags.vim need GNU Global"
  finish
endif

if !exists('g:gen_gtags_split')
  let g:gen_gtags_split = ''
endif

set cscopetag
set cscopeprg=gtags-cscope

"Hotkey for cscope
if g:gen_gtags_split == ''
  nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
elseif g:gen_gtags_split == 'h'
  nmap <C-\>c :scs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>d :scs find d <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>e :scs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>g :scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>i :scs find i <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>s :scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>t :scs find t <C-R>=expand("<cword>")<CR><CR>
elseif g:gen_gtags_split == 'v'
  nmap <C-\>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>i :vert scs find i <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
endif

function! s:add_gtags(file)
  if filereadable(a:file)
    let l:cmd = 'silent! cs add ' . a:file
    exec l:cmd
  endif
endfunction

function! s:Add_DBs()
  let l:path = gen_tags#find_project_root()
  let l:file = l:path . '/' . s:file
  call s:add_gtags(l:file)
endfunction

"Generate GTAGS
function! s:Gtags_db_gen()
  let l:path = gen_tags#find_project_root()
  let b:file = l:path . '/' . s:file

  "If gtags file exist, run update procedure.
  if filereadable(b:file)
    call UpdateGtags()
    return
  endif

  let l:cmd = 'gtags -c ' . l:path

  function! s:Backup_cwd(path)
    let l:bak = getcwd()
    let $GTAGSPATH = a:path
    lcd $GTAGSPATH

    return l:bak
  endfunction

  function! s:Restore_cwd(bak)
    "Restore cwd
    let $GTAGSPATH = a:bak
    lcd $GTAGSPATH
    let $GTAGSPATH = ''
  endfunction

  function! s:gtags_db_gen_done()
    call s:Restore_cwd(b:bak)

    call s:add_gtags(b:file)
    unlet b:file
    unlet b:bak
  endfunction

  "Backup cwd
  let b:bak = s:Backup_cwd(l:path)

  "Has job feature, generate gtags in background
  if has('job')
    echon "Generate " | echohl NonText | echon "GTAGS" | echohl None | echon " in " |echohl Function | echon "[Background]" | echohl None

    let l:job = job_start(l:cmd, {"close_cb": "CloseHandler"})
    function! CloseHandler(job)
      call s:gtags_db_gen_done()
    endfunction

    return
  endif

  "Without job feature, use vimproc or system.
  echon "Generate " | echohl NonText | echon "GTAGS" | echohl None | echo

  call gen_tags#system(l:cmd)

  call s:gtags_db_gen_done()
  echohl Function | echo "[Done]" | echohl None
endfunction

function! s:Gtags_clear()
  let l:path = gen_tags#find_project_root()
  let l:list = ["GTAGS", "GPATH", "GRTAGS"]

  execute 'cscope kill -1'

  for l:item in l:list
    let l:file = l:path . '/' . l:item
    if filereadable(l:file)
      call delete(l:file)
    endif
  endfor
endfunction

"Command list
command! -nargs=0 GenGTAGS call s:Gtags_db_gen()
command! -nargs=0 ClearGTAGS call s:Gtags_clear()

function! UpdateGtags()
  let l:path = gen_tags#find_project_root()
  let l:file = l:path . '/' . s:file

  if !filereadable(l:file)
    return
  endif

  echon "Update " | echohl NonText | echon "GTAGS" | echohl None

  let l:cmd = 'global -u'

  call gen_tags#system_bg(l:cmd)

  echon " in " | echohl Function | echon "[Background]" | echohl None
endfunction

augroup gen_gtags
    au!
    au BufWritePost * call UpdateGtags()
augroup END

"Add db while startup
call s:Add_DBs()
