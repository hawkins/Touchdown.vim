" Touchdown by Josh Hawkins
" A dumb name for a dumb vim plugin for markdown file editing

if exists('g:touchdown__loaded')
  finish
endif


" Folding for markdown lists
function! IndentLevel(lnum)
  return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
  let numlines = line('$')
  let current = a:lnum + 1

  while current <= numlines
    if getline(current) =~? '\v\S'
      return current
    endif

    let current += 1
  endwhile

  return -2
endfunction

function! GetListFold(lnum)
  if getline(a:lnum) =~? '\v^\s*$'
    return '-1'
  endif

  let this_indent = IndentLevel(a:lnum)
  let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

  if next_indent == this_indent
    return this_indent
  elseif next_indent < this_indent
    return this_indent
  elseif next_indent > this_indent
    return '>' . next_indent
  endif
endfunction

set foldmethod=expr
set foldexpr=GetListFold(v:lnum)


" GitHub Flavored Markdown states
let g:touchdown__checkbox_states = [' ', 'x', ' ']

"
" Toggle checkboxes
"
fun! Touchdown#ToggleCheckbox()
  let original_line = getline('.')
  let current_line = copy(original_line)
  
  " If we have a checkbox here
  if(match(current_line, '\[.\]') != -1)
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
endfun
command! ToggleCheckbox call Touchdown#ToggleCheckbox()
nmap <silent> <leader>tt :ToggleCheckbox<cr>


let g:touchdown__loaded = 1

