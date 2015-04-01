
if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1  " Don't load myself another time for this buffer

py import vim, sys, re
py vim.command("let path = expand('<sfile>:p:h')")
py PYPATH = vim.eval('path')
py sys.path += [PYPATH, PYPATH + "../plugin"]
py import address
py reload(address)

command! Tidy py address.clean_buff()

noremap <C-Return> :Send<Return>
inoremap <C-Return> <Esc>:Send<Return>
