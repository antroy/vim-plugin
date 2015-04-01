function! RunCtags()
    let curdir = "%:p:h"
    let base = curdir
    let found = 0

    while found == 0
        let base = base.":h"
        let path =  expand(base)
        if strlen(path) == 1
            let found = 2
            echo "Hit root dir without finding a project root."
        endif

        let vcs_dir = globpath(path, '{.git,.svn}')

        if path == "src" || len(vcs_dir) > 0
            let found = 1
            execute "!ctags -R -f " . path ."/tags " . path
            echo "!ctags -R -f " . path ."/tags " . path
        endif
    endwhile
endfunction

command! Ctags :call RunCtags()
