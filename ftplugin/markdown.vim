" Touchdown by Josh Hawkins
" A Vim plugin for Markdown editing focused on To-Do lists, supporting GitHub Flavored Markdown

if exists('g:touchdown__markdown__loaded')
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
  if (IsLineAListItem(getline(v:foldstart)))
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

let g:touchdown__markdown_loaded=1
