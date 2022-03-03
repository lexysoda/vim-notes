if exists("g:loaded_vimnotes")
  finish
endif
g:loaded_vimnotes = 1

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
endfunction

function! s:NotesOpenTopic(topic)
  let l:file = s:topic_dir . "/" . a:topic . g:vimnotes_extension
  execute "vsp " . l:file
endfunction

command! NotesOpenDiary call s:NotesOpenDiary()
command! -nargs=1 NotesOpenTopic call s:NotesOpenTopic(<q-args>)

if !exists("g:loaded_fzf_vim")
  finish
endif

command! -bang -nargs=* NotesFZF
  \ call fzf#vim#ag(<q-args>,
  \                 fzf#vim#with_preview({"dir": g:vimnotes_dir}, "right:50%"),
  \                 <bang>0)
