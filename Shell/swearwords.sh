#!/bin/bash
# List compiled from:
# Slate: http://goo.gl/vPC4X4
# Wikipedia: http://goo.gl/mdcyT8

swear_words=(
    'shit' 'fuck' 'damn' 'bitch' 'crap' 'dick' 'bitch' 'crap'
    'dick' 'piss' 'pussy' 'fag' 'asshole' 'cock' 'bastard' 'darn'
    'douche' 'slut' 'whore' 'christ' 'jesus' 'arse' 'bloody' 'bollocks'
)

if [[ -f "$1" ]]; then
    echo -e "\t\nCount for swear words in $1:\n\t"
    printf "%-10s %s\n" "Word:" "Count:"
    echo "------------------"
    for w in "${swear_words[@]}"; do
        n=$(egrep -o -i $w "$1" | wc -w)
        printf "%-10s %s\n" $w $n
    done
else 
    echo "Error: $1 is not a valid file"
    exit 1
fi

exit 0