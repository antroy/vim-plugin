
if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1  " Don't load myself another time for this buffer

python3 << END
import vim, sys, re
from imp import reload

vim.command("let path = expand('<sfile>:p:h')")
PYPATH = vim.eval('path')
sys.path += [PYPATH, PYPATH + "../plugin"]
import address
reload(address)
END

command! Tidy py address.clean_buff()

noremap <C-Return> :Send<Return>
inoremap <C-Return> <Esc>:Send<Return>
