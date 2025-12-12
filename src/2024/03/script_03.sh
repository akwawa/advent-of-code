#!/bin/bash

file_input="input.txt"
# file_input="input_example.txt"

echo "file: ${file_input}"
awk '
    BEGIN{total=0;}
    {
        line = $0;
        while (match(line, /mul\(([0-9]+),([0-9]+)\)/, arr)) {
            total += arr[1] * arr[2];
            line = substr(line, RSTART + RLENGTH);
        }
    }
    END{print "total part 1: " total;}
' "${file_input}"

awk '
    BEGIN{total=0; enabled=1}
    ( match($0, /mul\(([0-9]+),([0-9]+)\)/, arr) && enabled == 1) {
        total += arr[1] * arr[2];
    }
    ( match($0, /don'\''t\(\)/)) {
        enabled = 0;
    }
    ( match($0, /do\(\)/)) {
        enabled = 1;
    }
    END{print "total part 2: " total;}
' <(sed -e 's/)/)\n/g' "${file_input}")
