:py << END

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

:command! -nargs=* Time :py timelog(<args>)
:command! TimeCat :py timesheet.listProjectCodes()
:command! Timesheet :py parseLog()
:command! TimeUI :py timesheet.showUI()

