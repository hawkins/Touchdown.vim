# Touchdown.vim

A dumb name for a dumb vim plugin for dumb Markdown editing focused on my to-do's

## Features

- Folding markdown lists cleanly
- Toggle **bold** around lines with <kbd>`<leader>`tb</kbd>
  - Works with regular text lines, list items, and even check boxes
- Toggle checkboxes with <kbd>`<leader>`tt</kbd> in list items

## Installation

Using a tool like Vundle, simply add this plugin to your `~/.vimrc`:

```
Plugin 'hawkins/Touchdown.vim'
```

## Options

You can set any of these options in your `~/.vimrc` to configure how Touchdown operates:

- `g:touchdown__ignore_empty_bold`: Set this to anything to disable adding `**` to an empty line when bold is toggled on that line
