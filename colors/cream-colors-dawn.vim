" Vim color file
" Maintainer: Ajit J. Thakkar (ajit AT unb DOT ca)
" Last Change:	2003 Feb. 23

" This GUI-only color scheme has a light grey background, and is a softer
" variant of the default and morning color schemes.

set background=light
hi clear
if exists("syntax_on")
	syntax reset
endif

"let colors_name = "dawn"

hi Normal	guifg=Black guibg=grey90

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg	guifg=White guibg=HotPink
hi IncSearch	gui=NONE guifg=fg guibg=LightGreen
hi ModeMsg	gui=bold guifg=fg guibg=bg
hi StatusLine	gui=NONE guifg=DarkBlue guibg=grey70
hi StatusLineNC	gui=NONE guifg=grey90 guibg=grey70
hi VertSplit	gui=NONE guifg=grey70 guibg=grey70
hi Visual	gui=reverse guifg=Grey guibg=fg
hi VisualNOS	gui=underline,bold guifg=fg guibg=bg
hi DiffText	gui=bold guifg=Blue guibg=LightYellow
"hi Cursor	guifg=NONE guibg=Green
hi Cursor	guifg=NONE guibg=Black
hi lCursor	guifg=NONE guibg=Cyan
hi Directory	guifg=Blue guibg=bg
" CREAM
"hi LineNr	guifg=Brown guibg=bg
hi LineNr	guifg=Brown guibg=grey80
" END CREAM
hi MoreMsg	gui=bold guifg=SeaGreen guibg=bg
"hi NonText	gui=bold guifg=Blue guibg=grey80
hi Question	gui=bold guifg=SeaGreen guibg=bg
hi Search	guifg=fg guibg=PeachPuff
"hi SpecialKey	guifg=Blue guibg=bg
hi Title	gui=bold guifg=Magenta guibg=bg
hi WarningMsg	guifg=Red guibg=bg
hi WildMenu	guifg=fg guibg=PeachPuff
hi Folded	guifg=DarkBlue guibg=#d0d0d0
hi FoldColumn	guifg=DarkBlue guibg=Grey
hi DiffAdd	gui=bold guifg=Blue guibg=LightCyan
hi DiffChange	gui=bold guifg=fg guibg=MistyRose1
hi DiffDelete	gui=NONE guifg=LightBlue guibg=LightCyan

" Colors for syntax highlighting
hi Constant	gui=NONE guifg=SteelBlue guibg=bg
hi String	gui=NONE guifg=Maroon guibg=bg
hi Special	gui=bold guifg=DarkSlateBlue guibg=bg
hi Statement	gui=NONE guifg=Brown guibg=bg
hi Ignore	gui=NONE guifg=bg guibg=bg
hi ToDo		gui=NONE guifg=Blue guibg=LightYellow
hi Error	gui=NONE guifg=White guibg=HotPink
hi Comment	gui=NONE guifg=RoyalBlue guibg=NONE
hi Identifier	gui=NONE guifg=DarkCyan guibg=NONE
hi PreProc	gui=NONE guifg=Purple guibg=NONE
hi Type		gui=NONE guifg=SeaGreen guibg=NONE
hi Underlined	gui=underline guifg=SlateBlue guibg=bg

"+++ Cream:

" invisible characters
highlight NonText         guifg=#aaaabb guibg=#e0e0e0 gui=none
highlight SpecialKey      guifg=#aaaabb guibg=grey90 gui=none

" statusline
highlight User1  gui=bold guifg=#bbbbbb guibg=#f3f3f3
highlight User2  gui=bold guifg=#000000 guibg=#f3f3f3
highlight User3  gui=bold guifg=#0000ff guibg=#f3f3f3
highlight User4  gui=bold guifg=#ff0000 guibg=#f3f3f3

" bookmarks
highlight Cream_ShowMarksHL gui=bold guifg=blue guibg=grey80 ctermfg=blue ctermbg=lightblue cterm=bold

" spell check
highlight BadWord gui=bold guifg=DarkBlue guibg=#ddcccc ctermfg=black ctermbg=lightblue

" current line
highlight CurrentLine term=reverse ctermbg=0 ctermfg=14 gui=none guibg=#eeeecc

" email
highlight EQuote1 guifg=#0000cc
highlight EQuote2 guifg=#6666cc
highlight EQuote3 guifg=#9999cc
highlight Sig guifg=#999999

"+++

