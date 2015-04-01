" Vim syntax file

syn sync fromstart
"
syn match header    "^.*\n[-]\+"
syn match type_dec  "^\w\+:"
syn match addr_url  "<\@<=[0-9a-zA-Z//:.@_-]\+>\@="
syn match angles  "<\|>"
syn match nickname  "(\w\+)"

hi link type_dec Constant
"hi link item Function
hi nickname guifg=LightBlue gui=italic
"hi done_sub_item guifg=Gray gui=italic
hi link header Keyword
"hi link endcomment Comment
hi link addr_url Function
hi link angles Comment
