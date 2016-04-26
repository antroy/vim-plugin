setlocal spell

function! RenderGraphs(...)
python3 << EOF
import os, re
from subprocess import Popen, PIPE

num_args = int(vim.eval("a:0"))
if num_args >= 1:
    graph_name = "|".join(vim.eval("a:000"))
else:
    graph_name = ".*"

directory = os.path.split(vim.current.buffer.name)[0]
class DotFile(object):
    def __init__(self, name):
        self.name = name
        self.content = []

    def add(self, line):
        self.content.append(line)
    
    def render(self):
        print "Rendering", self.name
        outputfile = os.path.join(directory, "%s.png" % self.name)
        data = "\n".join(self.content)
        command = ["dot", "-Tpng", '-o%s' % outputfile]
        pipe = Popen(command, stdout=PIPE, stdin=PIPE)
        o, e = pipe.communicate(data)

dot_files = []
in_graph = False

for line in vim.current.buffer:
    m = re.search(r'''^digraph\s+"(%s)"\s*{''' % graph_name, line)
    if m:
        dot = DotFile(m.group(1))
        dot_files.append(dot)
        in_graph = True
    if in_graph:
        dot.add(line)
    if in_graph and line.startswith("}"):
        in_graph = False

for dot in dot_files:
    dot.render()

EOF
endfunction

:command! -nargs=* Render :call RenderGraphs(<f-args>)

