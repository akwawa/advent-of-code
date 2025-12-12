#!/bin/bash

# file_input="list_example.txt"
file_input="list.txt"

awk '
    function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
    function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
    function trim(s) { return rtrim(ltrim(s)); }

    (NR==FNR){list1[FNR]=trim($1); next;}
    {list2[FNR]=trim($2); list3[trim($2)]+=1;}
    END{
        diff=0;
        for (x = 1; x <= FNR; x++){
            if (list1[x] >= list2[x]) {
                diff += list1[x] - list2[x];
            } else {
                diff += list2[x] - list1[x]
            }
        }
        print "diff: " diff;

        similarity=0;
        for (x = 1; x <= FNR; x++){
            similarity += list1[x] * list3[list1[x]];
        }
        print "similarity: " similarity;
    }
' <(sort -k1 "${file_input}") <(sort -k2 "${file_input}")
