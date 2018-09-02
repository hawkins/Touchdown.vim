" Touchdown by Josh Hawkins
" A Vim plugin for Markdown editing focused on To-Do lists, supporting GitHub Flavored Markdown

if exists('g:touchdown__loaded')
  finish
endif

" Indent lines
if(!exists('g:touchdown__no_indent'))
  nmap <silent> <tab> >>
  nmap <silent> <S-tab> <<
endif

if(!exists('g:touchdown__checkbox_states'))
  " GitHub Flavored Markdown states
  let g:touchdown__checkbox_states = [' ', 'x', ' ']
endif

"
" Toggle checkboxes
"
function! ToggleMarkdownCheckbox()
  let original_line = getline('.')
  let current_line = copy(original_line)
  
  if(IsLineACheckbox(current_line))
    for state in g:touchdown__checkbox_states
      if(match(current_line, '\[' . state . '\]') != -1)
        let state_index = index(g:touchdown__checkbox_states, state)
        let next_state = g:touchdown__checkbox_states[state_index + 1]
        let current_line = substitute(current_line, '\[' . state . '\]', '[' . next_state . ']', '')
        break
      endif
    endfor
  endif

  " Update the line back in vim
  if(original_line != current_line)
    call setline('.', current_line)
  endif
endfunction
command! ToggleCheckbox call ToggleMarkdownCheckbox()
nmap <silent> <leader>tt :ToggleCheckbox<cr>

" Returns 1 if line is a list item ( - test, * test), 0 otherwise
function! IsLineAListItem(line)
  " TODO: The engine is aggresively lazy, and that's making part
  " of this process a headache, so we'll split regular expressions
  " on this function call, and ultimately thus this if  statement
  " below, until I'm a wee bit smarter about this problem.
  if(match(a:line, '^\s*[-\*]\s') != -1)
    return 1
  else
    return 0
  endif
endfunction

" Returns 1 if line is a checkbox line (- [ ], * [ ]), 0 otherwise
function! IsLineACheckbox(line)
  " Note: every checkbox is a line item, too
  if(match(a:line, '^\s*[-\*]\s\[.\]') != -1)
    return 1
  else
    return 0
  endif
endfunction

"
" Bold lines
"
function! ToggleBoldLine()
  let current_line = getline('.')

  " Handle 'empty' lines
  if(match(current_line, '^\s*$') != -1)
    if(!exists('g:touchdown__ignore_empty_bold'))
      call setline('.', '**')
    endif
    return
  else
    if(match(current_line, '^\s*\*\*\s*$') != -1 && !exists('g:touchdown__ignore_empty_bold'))
      let current_line = substitute(current_line, '\(^\s*\)\*\*\(\s*\)$', '\1\2', '')
      call setline('.', current_line)
      return
    endif
  endif

  " If the line is already bolded...
  " TODO: Checkbox logic missing from this regex
  if(match(current_line, '^\s*[-\*]\=\s*\(\[.\]\s*\)\=\*\*') != -1)
    " Then remove the bold
    if(IsLineACheckbox(current_line))
      let current_line = substitute(current_line, '\(^\s*\)\@<=\([-\*]\s\[.\]\s*\)\*\*', '\2', 1)
    else
      if(IsLineAListItem(current_line))
        let current_line = substitute(current_line, '\(^\s*\)\@<=\([-\*]\s*\)\*\*', '\2', 1)
      else
        let current_line = substitute(current_line, '\(^\s*\)\*\*', '\1', 1)
      endif
    endif

    let current_line = substitute(current_line, '\*\*$', '', 1)
  else
    " Otherwise add the bold
    if(IsLineACheckbox(current_line))
      let current_line = substitute(current_line, '\(^\s*\)\@<=\([-\*]\s\[.\]\s*\)', '\2**', 1)
    else
      if(IsLineAListItem(current_line))
        let current_line = substitute(current_line, '\(^\s*\)\@<=\([-\*]\s*\)', '\2**', 1)
      else
        let current_line = substitute(current_line, '\(^\s*\)\@<=\(\S\)', '**\2', 1)
      endif
    endif

    let current_line = substitute(current_line, '\S\@<=$', '**', 1)
  endif

  call setline('.', current_line)
endfunction!
command! ToggleBold call ToggleBoldLine()
nmap <silent> <leader>tb :ToggleBold<cr>


let g:touchdown__loaded = 1

