import re, vim

def buff(lines=None):
    if not lines:
        return list(vim.current.buffer)
    vim.current.buffer[:] = lines

def parse_buff(lines):

    if not lines:
        return

    def buff_iter():
        next = lines[0].strip()
        this = None
        for line in lines[1:]:
            this = next
            next = line.strip()
            yield this, next
        yield next, None

    records = {}
    curr = None

    for line, next in buff_iter():
        if re.match(r"^-+", line):
            continue

        if next and re.match(r"^-+", next):
            k = line.strip().replace("\s+", "").lower()
            if records.has_key(k):
                curr = records[k]
            else:
                curr = {'name': line.strip(), "address": []}
                records[k] = curr

            continue

        m = re.match(r"^(\w+):\s*(.*)$", line)
        if m:
            key = m.group(1)
            if not curr.has_key(key):
                curr[key] = set()
            att = curr.get(key.strip())
            att.add(m.group(2).strip())
            continue

        if line:
            curr['address'].append(line)
    return records

def pretty_print(records):
    out = []
    record_list = list(records.values())
    record_list.sort(key=lambda x: x['name'].lower())

    for record in record_list:
        out.append(record['name'])
        out.append("-" * len(record['name']))
        out.extend(record['address'])
        keys = [k for k in record.keys() if not k in ['name', 'address']]
        keys.sort()
        for key in keys:
            sorted_list = list(record[key])
            sorted_list.sort()
            out.append(("%s: " % key) + ", ".join(sorted_list))

        out.append("")

    return out

def clean_buff():
    lines = buff()
    buff(pretty_print(parse_buff(lines)))

if __name__ == "__main__":
    import sys
    lines = open(sys.argv[1]).readlines()
    print("\n".join(pretty_print(parse_buff(lines))))
