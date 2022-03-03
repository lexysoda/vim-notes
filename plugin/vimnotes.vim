if exists("g:loaded_vimnotes")
  finish
endif
let g:loaded_vimnotes = 1

if !exists("g:vimnotes_extension")
  let g:vimnotes_extension = ".md"
endif

if !exists("g:vimnotes_dir")
  let g:vimnotes_dir = "$HOME/vimnotes"
endif

if !exists("g:vimnotes_timeformat")
  let g:vimnotes_timeformat = "%F"
endif

let s:diary_dir = g:vimnotes_dir . "/diary"
let s:topic_dir = g:vimnotes_dir . "/topics"

function! s:NotesOpenDiary()
  let l:file = s:diary_dir . "/" . strftime(g:vimnotes_timeformat) . g:vimnotes_extension
  execute "vsp " . l:file
  call s:SetBufferDiary()
endfunction

function! s:NotesOpenTopic(topic)
  let l:file = s:topic_dir . "/" . a:topic . g:vimnotes_extension
  execute "vsp " . l:file
endfunction

function! s:SwitchDiaryIndex(rel)
  let l:dates = s:DiaryFiles()
  let l:cur = l:dates->index(expand('%:t:r'))
  let l:selection = l:dates->get(l:cur + a:rel)
  if l:selection == 0
    return
  endif
  execute "e " . s:diary_dir . "/" . l:selection . g:vimnotes_extension
  call s:SetBufferDiary()
endfunction

function! s:DiaryFiles()
  let l:dates = globpath(s:diary_dir, '*', 0, 1)->map({_, val -> fnamemodify(val, ':t:r')})
  let l:dates = l:dates + [strftime(g:vimnotes_timeformat)]
  eval l:dates->sort({d1, d2 -> s:ToEpoch(d1) > s:ToEpoch(d2)})
  return l:dates->uniq()
endfunction

function! s:ToEpoch(d)
  return systemlist('date -d ' . shellescape(a:d) . ' +"%s"')[0]
endfunction

function! s:SetBufferDiary()
  nnoremap <buffer> <C-o> :call <SID>SwitchDiaryIndex(-1)<CR>
  nnoremap <buffer> <C-i> :call <SID>SwitchDiaryIndex(1)<CR>
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
