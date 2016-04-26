python3 import vim, sys, re
python3 vim.command("let path = expand('<sfile>:p:h')")
python3 PYPATH = vim.eval('path')
python3 sys.path += [r'%s' % PYPATH]
python3 import ant_scripts
python3 reload(ant_scripts)
python3 from ant_scripts import *

" CVS Commands
:command! Update !cvs update %
:command! Commit !echo commit -m "<f-args>" %


:command! -range SortLines <line1>,<line2>python3 sort_buffer()
:command! -range RevLines <line1>,<line2>python3 reverse_buffer()
:command! -range -nargs=1 SortRe <line1>,<line2>python3 sort_buffer(re_cmp(<f-args>))
:command! -range RemDup    <line1>,<line2>python3 remove_dups()
:command! -range CountDup  <line1>,<line2>python3 count_dups()
:command! -range -nargs=1 Rot <line1>,<line2>python3 rot(<f-args>)
:command! -range Inc <line1>,<line2>python3 increment()
:command! -range IncL <line1>,<line2>python3 increment("left")
:command! -range IncR <line1>,<line2>python3 increment("right")

function! Lower(text)
    python3 text = vim.eval("a:text")
    python3 vim.command('let @m = "' + text.lower() + '"')
    return @m
endfunction

function! Upper(text)
    python3 text = vim.eval("a:text")
    python3 vim.command('let @m = "' + text.upper() + '"')
    return @m
endfunction

function! CapsCase(text)
    python3 transform_match(caps_case)
    return @m
endfunction

function! LowerCaps(text)
    python3 transform_match(lower_case)
    return @m
endfunction

function! CamelCase(text)
    python3 transform_match(CamelCase)
    return @m
endfunction

function! LowerCamel(text)
    python3 transform_match(camelCase)
    return @m
endfunction

function! CleanDiffLog()
    %g/^Files changed between/norm dd
    %g/\v^\s*$/norm dd
    %g/^File/norm dw
    %s/\vchanged from revision [0-9.]+ to //ge
    %s/\vis new; [0-9a-zA-Z_.-]+ revision //ge
    python3 align_cols()
    python3 sort_buffer(prop_biased_sort)
endfunction

function! Sub(search, replace)
python3 sub_with_function()
endfunction

command! -range -nargs=* S <line1>,<line2>call Sub(<f-args>)

