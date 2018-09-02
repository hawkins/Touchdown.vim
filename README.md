# Touchdown.vim

A Vim plugin for Markdown editing focused on To-Do lists, supporting GitHub Flavored Markdown

## Features

- Folding markdown lists cleanly
- Toggle **bold** around lines with <kbd>`<leader>`tb</kbd>
  - Works with regular text lines, list items, and even check boxes
- Toggle checkboxes with <kbd>`<leader>`tt</kbd> in list items
- Indent/outdent with <kbd>Tab</kbd>/<kbd>Shift</kbd>+<kbd>Tab</kbd>
- Easily navigate to list items at the same indentation with <kbd>CTRL</kbd>+<kbd>Up</kbd>, <kbd>CTRL</kbd>+<kbd>Down</kbd>, etc
  - Thanks to the great folks behind [the Vim wiki](http://vim.wikia.com/wiki/Move_to_next/previous_line_with_same_indentation)

## Installation

Using a tool like Vundle, simply add this plugin to your `~/.vimrc`:

```
Plugin 'hawkins/Touchdown.vim'
```

I also suggest you check out `tpope/vim-markdown` and `vim-prettier` for a better Markdown experience.

## Options

You can set any of these options in your `~/.vimrc` to configure how Touchdown operates:

- `g:touchdown__ignore_empty_bold`: Set this to anything to disable adding `**` to an empty line when bold is toggled on that line
- `g:touchdown__no_indent`: Set this to anything to disable <kbd>Tab</kbd> to indent and <kbd>Shift</kbd>+<kbd>Tab</kbd> to outdent
- `g:touchdown__checkbox_states`: Set this to an array of characters to rotate between when toggling a checkbox. Defaults to `[' ', 'x', ' ']`
