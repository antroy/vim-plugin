" if exists('loaded_pyscript') || &cp
"     finish
" endif
" let loaded_pyscript=1

" pyscript buffer name
let PyScriptBufferName = "__pyscript__"

" PyScriptBufferOpen
" Open the pyscript buffer
function! s:PyScriptBufferOpen()
    " Check whether the pyscript buffer is already created
    let scr_bufnum = bufnr(g:PyScriptBufferName)
    let s:current_buff = bufname("%")
    if scr_bufnum == -1
        " open a new pyscript buffer
        exe "new " . g:PyScriptBufferName
    else
        " PyScript buffer is already created. Check whether it is open
        " in one of the windows
        let scr_winnum = bufwinnr(scr_bufnum)
        if scr_winnum != -1
            " Jump to the window which has the pyscript buffer if we are not
            " already in that window
            if winnr() != scr_winnum
                exe scr_winnum . "wincmd w"
            endif
        else
            " Create a new pyscript buffer
            exe "split +buffer" . scr_bufnum
            resize 8
        endif
    endif
endfunction

function! s:PyExecute()
python <<END
import os, tempfile
command_lines = list(vim.current.buffer)
command = "\n".join(command_lines)

tempfilename = tempfile.mktemp()
fh = open(tempfilename, 'w')
fh.write(command)
fh.close()

vim.command("wincmd j")
vim.command("pyfile %s" % tempfilename)
vim.command("wincmd k")

os.remove(tempfilename)
END
endfunction

" PyScriptMarkBuffer
" Mark a buffer as pyscript
function! s:PyScriptMarkBuffer()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
    setlocal filetype=python
endfunction

autocmd BufNewFile __pyscript__ call s:PyScriptMarkBuffer()

" Command to edit the pyscript buffer in the current window
command! -nargs=0 PyScript call s:PyScriptBufferOpen()

command! -nargs=0 PyExe call s:PyExecute()



