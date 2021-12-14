if !exists("g:vimnotes_extension")
  let g:vimnotes_extension = ".md"
endif

if !exists("g:vimnotes_dir")
  let g:vimnotes_dir = "$HOME/vimnotes"
endif

let s:diary_dir = g:vimnotes_dir . "/diary"
let s:topic_dir = g:vimnotes_dir . "/topics"

function! s:NotesOpenDiary()
  let l:file = s:diary_dir . "/" . strftime("%F") . g:vimnotes_extension
  execute "vsp " . l:file
  autocmd BufWritePost <buffer> bdelete
endfunction

function! s:NotesOpenTopic(topic)
  let l:file = s:topic_dir . "/" . a:topic . g:vimnotes_extension
  execute "vsp " . l:file
  autocmd BufWritePost <buffer> bdelete
endfunction

command! NotesOpenDiary call s:NotesOpenDiary()
command! -nargs=1 NotesOpenTopic call s:NotesOpenTopic(<q-args>)
