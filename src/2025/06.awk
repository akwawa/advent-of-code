#/usr/bin/awk -f src/2025/06.awk data/2025/06.in

BEGIN {
    FS = " " # Séparateur de champs = virgule
    part1 = part2 = 0;
    delete total;
    delete total2;
}

END {
    for (i in total) {
        soustotal = total[i][1];
        for (j=2; j<NR; j++) {
            alg = total[i][NR];
            if (alg == "+") {
                soustotal += total[i][j];
            } else if (alg == "*") {
                soustotal *= total[i][j];
            } else {
                print "Erreur: opérateur inconnu", alg;
            }
        }
        part1 += soustotal;
        # print length(total[i]);
    }

    # parcours par colonne
    sousTotal = 0;
    alg = "-1";
    for (c = 1; c <= max_col; c++) {
        chiffre = "";
        premier = 0;
        for (r = 1; r <= max_row; r++) {
            if (col[c, r] == "+") {
                alg = "+";
                premier = 1;
            } else if (col[c, r] == "*") {
                alg = "*";
                premier = 1;
            } else if (col[c, r] ~ /[0-9]/) {
                chiffre = chiffre col[c, r];
            } else if (col[c, r] != " ") {
                printf "error |%s|\n", col[c, r];
            }
        }
        if (int(chiffre) == 0) { alg = "-1"; }
        if (premier == 1) {
            sousTotal = chiffre;
        } else {
            if (alg == "-1") {
                part2 += sousTotal;
                sousTotal = 0;
            }
            else if (alg == "*") { sousTotal *= chiffre; }
            else if (alg == "+") { sousTotal += chiffre; }
            else { print "erreur"; }
        }
    }
    part2 += sousTotal;

    printf "Part 1: %d\n", part1;
    printf "Part 2: %d\n", part2;
}

{
    for (i = 1; i <= NF; i++) {
        total[i][NR] = $i;
    }

    for (i = 1; i <= length($0); i++) {
        total2[i][NR] = substr($0, i, 1);
    }

    # stocke chaque caractère dans un tableau 2D [col, row]
    for (i = 1; i <= length($0); i++) {
        col[i, NR] = substr($0, i, 1);
        if (NR > max_row) max_row = NR;
        if (i > max_col) max_col = i;
    }
}
