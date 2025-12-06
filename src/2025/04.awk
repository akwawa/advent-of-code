#/usr/bin/awk -f src/2025/04.awk data/2025/04.in

BEGIN {
    FS = "," # Séparateur de champs = virgule
    part1 = part2 = 0;
}

END {
    part1 = part2 = paper_removed = remove_roll_of_paper(originalArray);;
    while (paper_removed > 0) {
        paper_removed = remove_roll_of_paper(originalArray);
        part2 += paper_removed;
    };

    printf "Part 1: %d\n", part1;
    printf "Part 2: %d\n", part2;
}

function remove_roll_of_paper(originalArray, i, j, nb_roll, char, nb_roll_removed) {
    nb_roll_removed=0;
    delete arrToRemove;
    for (i = 1; i <= FNR; i++) {
        for (j = 1; j <= length($0); j++) {
            nb_roll = 0;
            char = substr(originalArray[i,j], 1);
            if (char == "@") {
                if (char_is_same("@", originalArray[i-1,j-1])) { nb_roll++; }
                if (char_is_same("@", originalArray[i-1,j])) { nb_roll++; }
                if (char_is_same("@", originalArray[i-1,j+1])) { nb_roll++; }

                if (char_is_same("@", originalArray[i,j-1])) { nb_roll++; }
                if (char_is_same("@", originalArray[i,j+1])) { nb_roll++; }
                
                if (char_is_same("@", originalArray[i+1,j-1])) { nb_roll++; }
                if (char_is_same("@", originalArray[i+1,j])) { nb_roll++; }
                if (char_is_same("@", originalArray[i+1,j+1])) { nb_roll++; }

                if (nb_roll < 4) {
                    nb_roll_removed++;
                    arrToRemove[i,j] = 1;
                }
            }
        }
    }
    for (k in arrToRemove) {
        split(k, idx, SUBSEP);
        originalArray[idx[1],idx[2]] = ".";
    }
    return nb_roll_removed;
}

function char_is_same(a, b) { return (a == b); }

{
    for (i = 1; i <= length($0); i++) {
        originalArray[NR,i] = substr($0, i, 1);
    }
}
