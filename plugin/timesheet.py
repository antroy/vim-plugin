import logging, os
from datetime import datetime, date, timedelta
from collections import defaultdict
#from Tkinter import *

projectMap = {
    "tsd": "TSD",
    "bos": "Bos Interface",
    "test": "Testing",
    "com": "Common Utilities",
    "oth": "Other Projects",
    "off": "Offline",
    "plm": "BosPlm project",
    "meet": "Project Meetings",
    "lead": "Java Team Leading",
    "hand": "Sun Handover",
    "ui": "User Interfaces",
}

LOG = os.path.expanduser("~\.timesheet")
DATE_FORMAT = "%Y-%m-%d %H:%M:%S"

def timelog(proj_code=None, offset=0):
    print "projcode:", proj_code 
    if not proj_code:
        return parseLog()
    elif proj_code == "?":
        listProjectCodes()
        return

    project = projectMap.get(proj_code.lower(), None)

    if project:
        print "Starting work on", project
        now = datetime.today()
        off = timedelta(minutes=offset)

        logtime = now + off
        datestr = logtime.strftime(DATE_FORMAT)

        mssg = "%s :: %s" % (datestr, project)

        fh = open(LOG, "a")
        print >> fh, mssg
        fh.close()

    else:
        print "Project not registered!"

def listProjectCodes():
    print "\n".join(["%s: %s" % x for x in projectMap.iteritems()])

def getTimeString(total_mins):
    hours, fraction = divmod(total_mins, 60)
    #if fraction <= 15:
    #    fract_str = ""
    #elif fraction >= 45:
    #    fract_str = ""
    #    hours += 1
    #else:
    #    fract_str = "1/2"

    #return "%s%s hour%s" % (str(hours) + " " if hours else "", fract_str, "s" if hours else "")
    return "%s hour%s%s" % (str(hours), "s" if hours else "", " " + str(fraction) + " minutes" if fraction else "")
        
def parseLog():
    fh = open(LOG)
    dates = defaultdict(list)
    format = "%d %B %Y"
    now = datetime.today()
    todays_date = date.today()

    for line in fh:
        date_str, title = line.strip().split(" :: ")
        date_parsed = datetime.strptime(date_str, DATE_FORMAT)
        day = date_parsed.strftime(format)
        dates[day].append((date_parsed, title))
    fh.close()

    messages = []

    for d in sorted(dates.keys()):
        last_time = datetime.strptime(d, format)
        current_task = projectMap["off"]
        times = defaultdict(lambda: 0)
        date_title = dates[d]
        
        if todays_date == last_time.date():
            dates[day].append((now, title))
        else:
            date_title.append((datetime(last_time.year, last_time.month, last_time.day, 23, 59), current_task))

        for time, task in date_title:    
            date_diff = time - last_time
            current_mins = times[current_task]
            times[current_task] = current_mins + (date_diff.seconds / 60)

            last_time = time
            current_task = task

        messages.append("%s:" % d)
        messages.extend("    %-20s: %s" % (k, getTimeString(v)) 
                        for k, v in sorted(times.iteritems()) 
                        if not k ==  projectMap["off"])
        total = reduce(lambda x, y: x + y, (v for k, v in times.iteritems() if not k == projectMap["off"]), 0)

        messages.append("    Total               : %s" % getTimeString(total))

    return "\n".join(messages)

#def showUI():
#
#    root = Tk()
#
#    w = Label(root, text="Hello, world!")
#    w.pack()
#
#    root.mainloop()
    
