#!/bin/bash

# file_input="input.txt"

# total of 18 times
file_input="input_example.txt"

echo "file: ${file_input}"
awk '
    function find_h(numLine) {
        retour = 0;
        if (numLine in arr) {

            wanted = "X";
            for (i in arr[numLine]) {
                letter = arr[numLine][i];
                # print FNR " " letter " " wanted;
                if (letter == wanted || letter == "X") {
                    if (letter == "X") { wanted = "M"; }
                    if (letter == "M") { wanted = "A"; }
                    if (letter == "A") { wanted = "S"; }
                    if (letter == "S") { wanted = "X"; retour += 1; }
                    continue;
                }
                wanted = "X";
            }

            len = length(arr[numLine]);
            wanted = "X";
            for (i=len; i>=1; i--) {
                letter = arr[numLine][i];
                # print FNR " " letter " " wanted;
                if (letter == wanted || letter == "X") {
                    if (letter == "X") { wanted = "M"; }
                    if (letter == "M") { wanted = "A"; }
                    if (letter == "A") { wanted = "S"; }
                    if (letter == "S") { wanted = "X"; retour += 1; }
                    continue;
                }
                wanted = "X";
            }
        }
        return retour;
    }

    function find_split(numLine, numCol, wanted) {
        retour = 0;
        print letter " " numLine " " numCol " " wanted;
        letter = arr[numLine][numCol];
        if (letter == wanted) {
            if (letter == "S") {
                return retour++;
            }
            wanted = arr_wanted[wanted];

            newNumLine=;
            newNumCol=;
            retour += find_split(newNumLine, newNumCol, wanted);            
        }
        return retour;
    }

    BEGIN{total=0;arr_wanted["X"]="M";arr_wanted["M"]="A";arr_wanted["A"]="S";}
    (FNR==NR){
        len = length($0);
        for (i=1; i <= len; i++) {
            arr[FNR][i] = substr(toupper($0), i, 1);
        }
        next;
    }
    {
        # total += find_h(FNR);

        if (FNR in arr) {
            len = length(arr[FNR]);
            for (i=1; i<=len; i++) {
                total += find_split(FNR, i, "X");
            }
        }
    }
    END{print "total part 1: " total;}
' "${file_input}" "${file_input}"

