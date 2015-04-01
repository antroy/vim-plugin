if exists("b:did_ftplugin")
    finish
endif

let b:did_ftplugin = 1  " Don't load myself another time for this buffer

set foldmethod=indent
set foldenable

%foldopen!
" %g/[c]/norm jzc
nohlsearch

python << END
COMPLETED_PATTERN = r"(\s*(?:\d+\.)+)\s+(?![c])([^[ ].*)"
ITEM_PATTERN = r"(\s*)((?:\d+\.)+)"
END


function! ToggleDone()
python << END
import re
lines = buff()

"""
  1.1. [c] Stuff
  1.2. more
"""

for i in range(vim.current.range.end, 0, -1):
    if re.match(ITEM_PATTERN, lines[i]):
        m = re.match(COMPLETED_PATTERN, lines[i])
        if m:
            lines[i] = m.group(1) + " [c] " + m.group(2)
        else:
            lines[i] = re.sub(r"\[c\]\s*", "", lines[i])
        break

buff(lines)

END
endfunction

function! NewItem(level)
python << END
import re
lines = buff()
level = int(vim.eval('a:level'))

"""
  1.1. Stuff
  1.2. more
 
"""
current_line = vim.current.range.end

for i in range(current_line, 0, -1):
    m = re.match(ITEM_PATTERN, lines[i])
    if m:
        parts = m.group(2).split(".")
        parts = [int(x) for x in parts if x]
        if level > 0:
            parts.append(1)
        elif level == 0:
            parts[-1] = parts[-1] + 1
        else:
            parts = parts[:-1]
            parts[-1] = parts[-1] + 1

        indent = len(m.group(1)) + (level * 4)

        lines[current_line] = (" " * indent) + ".".join(map(str, parts)) + ". "
        break

buff(lines)

END

norm $a

endfunction

:map ;n :call NewItem(0)
:map ;s :call NewItem(1)
:map ;b :call NewItem(-1)

:map <C-Enter> :call NewItem(0)
:map <C-S-Enter> :call NewItem(1)
:map <S-Enter> :call NewItem(-1)

:imap <C-Enter> :call NewItem(0)a
:imap <C-S-Enter> :call NewItem(1)a
:imap <S-Enter> :call NewItem(-1)a

:map ;c :call ToggleDone()
:command! Clean :%!todo -r cleanup -- -m
:command! CleanAll :%!todo -r cleanup

