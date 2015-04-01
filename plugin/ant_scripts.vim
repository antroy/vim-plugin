py import vim, sys, re
py vim.command("let path = expand('<sfile>:p:h')")
py PYPATH = vim.eval('path')
py sys.path += [r'%s' % PYPATH]
py import ant_scripts
py reload(ant_scripts)
py from ant_scripts import *

" CVS Commands
:command! Update !cvs update %
:command! Commit !echo commit -m "<f-args>" %


:command! -range SortLines <line1>,<line2>py sort_buffer()
:command! -range RevLines <line1>,<line2>py reverse_buffer()
:command! -range -nargs=1 SortRe <line1>,<line2>py sort_buffer(re_cmp(<f-args>))
:command! -range RemDup    <line1>,<line2>py remove_dups()
:command! -range CountDup  <line1>,<line2>py count_dups()
:command! -range -nargs=1 Rot <line1>,<line2>py rot(<f-args>)
:command! -range Inc <line1>,<line2>py increment()
:command! -range IncL <line1>,<line2>py increment("left")
:command! -range IncR <line1>,<line2>py increment("right")

function! Lower(text)
    py text = vim.eval("a:text")
    py vim.command('let @m = "' + text.lower() + '"')
    return @m
endfunction

function! Upper(text)
    py text = vim.eval("a:text")
    py vim.command('let @m = "' + text.upper() + '"')
    return @m
endfunction

function! CapsCase(text)
    py transform_match(caps_case)
    return @m
endfunction

function! LowerCaps(text)
    py transform_match(lower_case)
    return @m
endfunction

function! CamelCase(text)
    py transform_match(CamelCase)
    return @m
endfunction

function! LowerCamel(text)
    py transform_match(camelCase)
    return @m
endfunction

function! CleanDiffLog()
    %g/^Files changed between/norm dd
    %g/\v^\s*$/norm dd
    %g/^File/norm dw
    %s/\vchanged from revision [0-9.]+ to //ge
    %s/\vis new; [0-9a-zA-Z_.-]+ revision //ge
    py align_cols()
    py sort_buffer(prop_biased_sort)
endfunction

function! Sub(search, replace)
py sub_with_function()
endfunction

command! -range -nargs=* S <line1>,<line2>call Sub(<f-args>)

