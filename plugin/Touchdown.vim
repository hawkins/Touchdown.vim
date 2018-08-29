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

function! GetFoldText()
  if (match(getline(v:foldstart), "[\s\t]*[-\*][\s\t]*.*") != -1)
    let nl = v:foldend - v:foldstart
    let linetext = substitute(getline(v:foldstart),"-","+",1)
    let txt =  linetext . "\t (" . nl . ' lines hidden)'
  else
    let txt = foldtext()
  endif

  return txt
endfunction
setlocal foldtext=GetFoldText()
setlocal foldmethod=expr
setlocal foldexpr=GetListFold(v:lnum)
setlocal fillchars=fold:\ 

" GitHub Flavored Markdown states
let g:touchdown__checkbox_states = [' ', 'x', ' ']

"
" Toggle checkboxes
"
function! ToggleMarkdownCheckbox()
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
endfunction
command! ToggleCheckbox call ToggleMarkdownCheckbox()
nmap <silent> <leader>tt :ToggleCheckbox<cr>

"
" Bold lines
"
function! ToggleBoldLine()
  let current_line = getline('.')
  " See if this is a list item, if it starts with \s*[-\*]
  let current_line = substitute(current_line, '\(^\s*\)\@<=\([-\*]\=\s*\)\(\S\)\@=', '\2\3**', '')
  
  " Now do the same for the end of the line
  " substitute(current_line, )
  call setline('.', current_line)
endfunction!
command! ToggleBold call ToggleBoldLine()
nmap  <leader>tb :ToggleBold<cr>


let g:touchdown__loaded = 1

