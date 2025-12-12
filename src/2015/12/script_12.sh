#!/bin/bash

jq "." input_1.json >  input_1_better.json

awk -v pass="${pass}" '
    function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
    function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
    function trim(s) { return rtrim(ltrim(s)); }
    BEGIN { result_1=0; result_2=0; debut_objet[0]=0;}
    {
        for (i=1; i<=NF; i++) {
            if (match($i, /^([-+]*[[:digit:]]+)[,]*$/, arr)) {
                result_1 = result_1 + arr[1];
            }
        }
    }

    {
        if ($0 ~ /}[,]*$/) {
            debut_objet = 0;
            result_2 = result_2 + result_temp;
        }
        if ($0 ~ /{$/) {
            debut_objet[length(debut_objet)] = 1;
        }
        if ($0 ~ /: "red"/) {
            print $0;
        }
    }
    END {
        print "result_1: " result_1;
        print "result_2: (KO): " result_2;
    }
' ./input_1_better.json

# --- Part Two ---

# Uh oh - the Accounting-Elves have realized that they double-counted everything red.

# Ignore any object (and all of its children) which has any property with the value "red". Do this only for objects ({...}), not arrays ([...]).

#     [1,2,3] still has a sum of 6.
#     [1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is ignored.
#     {"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire structure is ignored.
#     [1,"red",5] has a sum of 6, because "red" in an array has no effect.


