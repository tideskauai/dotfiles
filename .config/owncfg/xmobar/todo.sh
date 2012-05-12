#!/bin/bash

done_code="<fc=#B2FBA4>x</fc>"
undone_code="<fc=#FBA4A8>x</fc>"
ast=$(awk -F'=' '/ast/ {print $2}' ~/.config/owncfg/xmobar/todo)
it=$(awk -F'=' '/it/ {print $2}' ~/.config/owncfg/xmobar/todo)
nook=$(awk -F'=' '/nook/ {print $2}' ~/.config/owncfg/xmobar/todo)
med=$(awk -F'=' '/med/ {print $2}' ~/.config/owncfg/xmobar/todo)

if [[ $ast = 0 ]]; then
    ast=$undone_code
else    
    ast=$done_code
fi

if [[ $it = 0 ]]; then
    it=$undone_code
else
    it=$done_code
fi

if [[ $nook = 0 ]]; then
    nook=$undone_code
else
    nook=$done_code
fi

if [[ $med = 0 ]]; then
    med=$undone_code
else
    med=$done_code
fi

echo "[ med: $med | ast: $ast | it: $it | nook: $nook ]"
