import re, operator, vim, string, datetime

def insert_at_cursor(text):
    vim.command("normal i" + text )

def insert_date():
    date = datetime.datetime.today()
    insert_at_cursor(str(date).split()[0])

def tokenize(word):
    if "_" in word:
        parts = map(string.lower, word.split("_"))

        return parts
    else:
        parts = []
        current = []

        for char in word:
            if char.isupper():
                if current:
                    parts.append("".join(current))
                    current = [char]
                else:
                    current.append(char)
            else:
                current.append(char)
        if current:
            parts.append("".join(current))

        parts = map(string.lower, parts)

        return parts

def CamelCase(accumulation, word):
    word = word.lower()
    return accumulation + word.title()

def camelCase(accumulation, word):
    word = word.lower()
    if accumulation:
        return accumulation + word.title()
    else:
        return word

def lower_case(accumulation, word):
    word = word.lower()
    if accumulation:
        return "%s_%s" % (accumulation, word)
    else:
        return word

def caps_case(accumulation, word):
    word = word.upper()
    if accumulation:
        return "%s_%s" % (accumulation, word)
    else:
        return word

def transform(word, transformation):
    return reduce(transformation, tokenize(word), "")

def partial(fn, **init_kw):
    def out(**kw):
        all_kw = dict(init_kw)
        all_kw.update(kw)
        return fn(**all_kw)
    return out

def transform_sentence(sentence, transformation):
    out = []
    trans = partial(transform, transformation=transformation)

    def replacement(match):
        return trans(word=match.group(0))

    return re.sub("\w+", replacement, sentence)

def transform_match(transformation):
    text = vim.eval("a:text")
    try:
        i = int(text)
        text = vim.eval("submatch(%s)" % i)
    except:
        pass
    out = transform_sentence(text, transformation)
    vim.command('let @m = "%s"' % out)

PROP_STRING = ".properties"

def prop_biased_sort(x, y):
    xprop = PROP_STRING in x
    yprop = PROP_STRING in y

    ordinary_comp = not operator.xor(xprop, yprop)

    if ordinary_comp:
        return cmp(x, y)
    elif xprop:
        return 1
    else:
        return -1

pbs = prop_biased_sort

def get_buffer_or_range():
    if len(vim.current.range) > 1:
        return vim.current.range
    else:
        return vim.current.buffer

def sort_buffer(cmp=None):
    buff = get_buffer_or_range()

    lines = buff[:]
    lines.sort(cmp)
    buff[:] = lines

def reverse_buffer(cmp=None):
    buff = get_buffer_or_range()

    lines = buff[:]
    lines.reverse()
    buff[:] = lines

def re_cmp(regex):
    p = re.compile(regex)
    group_count = len(p.groupindex)
    def _cmp(one, two):
        m1 = p.search(one)
        m2 = p.search(two)

        if group_count:
            tup1 = tuple(m1.groupdict()[key] for key in sorted(m1.groupdict().keys()))
            tup2 = tuple(m2.groupdict()[key] for key in sorted(m2.groupdict().keys()))
        elif p.groups:
            tup1 = m1.groups()
            tup2 = m2.groups()
        else:
            return cmp(one, two)

        return cmp(tup1, tup2)
    return _cmp

def remove_dups():
    lines = get_buffer_or_range()
    out = []
    s = set()
    for line in lines:
        if line not in s:
            out.append(line)
            s.add(line)

    lines[:] = out

def count_dups():
    lines = get_buffer_or_range()
    out = []
    s = {}
    for line in lines:
        if line not in s:
            s[line] = 1
        else:
            s[line] = s[line] + 1

    out = ["[%04d] %s" % (s[k], k) for k in s]
    out.sort()

    lines[:] = out

def align_cols():
    lines = vim.current.buffer[:]

    temp = [line.split() for line in lines]
    col_count = reduce(min, map(len, temp))

    def fn(x, y):
        return max(x, len(y[i]))

    for i in range(col_count):
        max_width = reduce(fn , temp, 0)
        for line in temp:
            val = line[i]
            line[i] = val + " " * (max_width - len(val) + 4)

    lines = ["".join(col) for col in temp]

    vim.current.buffer[:] = lines

class match_wrapper(object):
    def __init__(self, match):
        self.match = match

    def __getitem__(self, index):
        return self.match.group(index)

def get_funct(fn):
    def out(m):
        wrapper = match_wrapper(m)
        return fn(wrapper)
    return out


def sub_with_function():
    s =  vim.eval("a:search")
    r =  vim.eval("a:replace")

    fn = None

    fn_temp = "lambda m: %s"

    if r.startswith("fn::"):
        fn = get_funct(eval(fn_temp % r[4:]))

    range = vim.current.range
    out = []

    for line in range:
        out.append(re.sub(s, fn if fn else r, line))

    range[:] = out

CHARS = string.ascii_lowercase

def rot(num_or_char):
    try:
        num = int(num_or_char)
    except:
        num = CHARS.find(num_or_char)
        if not (0 <= num < 26):
            print("'%s' is not an ASCII lower case letter!" % num_or_char)
            return

    if not (0 <= num < 26):
        print("'%s' is not in the range 0-25!")
        return

    tt = string.maketrans(CHARS, CHARS[num:] + CHARS[0:num])

    buff = get_buffer_or_range()
    lines = buff[:]
    buff[:] = map(lambda x: x.translate(tt), lines)

def increment(justification=None):
    PATTERN = r"^\s*\d+(.*)"
    buff = get_buffer_or_range()

    count_of_numbered_lines = len([1 for line in buff if re.match(PATTERN, line)])
    width_of_count = len(str(count_of_numbered_lines))

    if justification == "left":
        templ = "%%-%dd%%s" % width_of_count
    elif justification == "right":
        templ = "%%%dd%%s" % width_of_count
    else:
        templ = "%d%s"

    lines = []
    count = 1
    for line in buff:
        m = re.match(PATTERN, line)
        if m:
            lines.append(templ % (count, m.group(1)))
            count += 1
        else:
            lines.append(line)

    buff[:] = lines


def xpath(xp, filename):
    try:
        from lxml import etree
    except:
        return 0

    import sys, datetime as dt

    def uppercase(dummy, a):
        if not a:
            return ""
        out = a[0].text.upper()
        return out

    def current_date(dummy):
        now = dt.datetime.now()
        return "%s-%s-%s" % (now.year, now.month, now.day)

    def adjust_to_tz(dummy, date, tz=None):
        return date

    fn_ns = etree.FunctionNamespace(None)

    fn_ns['upper-case'] = uppercase
    fn_ns['current-date'] = current_date
    fn_ns['adjust-date-to-timezone'] = adjust_to_tz
    fn_ns['xs:date'] = adjust_to_tz

    ns = {'cmf': 'http://jdwilliams.co.uk/cmf'}
    fh = open(sys.argv[1])
    doc = etree.parse(fh)
    fh.close()

    fh = open(sys.argv[2])
    xpaths = [line.strip() for line in fh if line.strip()]
    fh.close()

    try:
        nodes = doc.xpath(xp, namespaces=ns)
    except Exception as ex:
        pass

    if nodes:
        return [n.sourceline for n in nodes if n.sourceline]


