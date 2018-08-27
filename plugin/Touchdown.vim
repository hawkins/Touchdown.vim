" Touchdown by Josh Hawkins
" A dumb name for a dumb vim plugin for markdown file editing

if exists('g:touchdown__loaded')
  finish
endif


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

