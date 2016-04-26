:python3 << END

import timesheet
reload(timesheet)

def parseLog():
    out = timesheet.parseLog()
    print out
    vim.command("call setreg('t', '%s')" % out)

def timelog(*args):
    out = timesheet.timelog(*args)
    if out:
        print out
        vim.command("call setreg('t', '%s')" % out)
END

:command! -nargs=* Time :python3 timelog(<args>)
:command! TimeCat :python3 timesheet.listProjectCodes()
:command! Timesheet :python3 parseLog()
:command! TimeUI :python3 timesheet.showUI()

