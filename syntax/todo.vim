" Vim syntax file

syn sync fromstart

syn match header    "^.*\n[=]\+"
syn match date      "\d\{1,2}\s\+\w\+\(\s\+\d\{4}\)\?:"
syn match item      "^\s*\(\d\+\.\)\+.*$"
" syn match done_item "^\s*\(\d\+\.\)\+\s*\[c\].*$"

syn match meta "\w\+:" contained
syn region metadata start="^\s*(" end=")\s*$" contains=meta


let spaceAtStart="^\s\+"
let decimal="\(\d\+\.\)"
let zeroOrMoreDecimals="\(\%(\d\+\.\)\{-}\)"
let spaceCompleteAndZeroOrMoreLines="\s*\[c\]\_.\{-}"
let nextNumber="\%[\1]\d\. "
let lookaheadToNextNumber="\(\s*".nextNumber."\)\@="

syn match done_item "^\(\%(\d\+\.\)\+\)\s*\[c\]\_.\{-}\_^\%(\s*\%[\1]\d\+\.\D\)\@="

"syn match done_item "^\s\+\(\%(\d\.\)\+\)\s*\[c\]\_.\{-}\_^\%(\s*\%[\1]\d\. \)\@="
"syn match done_item "^\s\+\(\%(\d\.\)\{-}\)\(\d\.\)\s*\[c\]\_.\{-}\_^\(\s*\%[\1]\d\. \)\@="
syn match done_sub_item "^\s*\(\%(\d\+\.\)\+\)\s*\[c\]\_.\{-}\%(------\|\s*\%[\1]\%(\d\+\.\)\+ \|\%$\)\@="

syn region endcomment start="^---\+" end="\%$"

hi link date Constant
hi link item Function
hi done_item guifg=Pink gui=italic
hi done_sub_item guifg=Gray gui=italic
hi link header Keyword
hi link metadata Comment
hi link endcomment Comment
hi link meta Exception

