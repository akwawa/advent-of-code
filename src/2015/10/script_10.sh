#!/bin/bash

# file_input="list_example.txt"
# file_input="list.txt"

# input 1113222113
input="${1}"
nb_iteration_1="${2:-"1"}"
nb_iteration_2="${3:-"1"}"

if [ -z "${input}" ]; then
    echo "Input nécessaire"
    exit 1
fi

transform() {
    local input="${1}"
    awk -v input="${input}" '
        function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
        function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
        function trim(s) { return rtrim(ltrim(s)); }
        END {
            longueur_input = length(input);
            chiffre_precedent = substr(input, 1, 1);
            nb_chiffre = 1;
            chaine_sortie="";
            for (i=2; i<=longueur_input; i++) {
                chiffre_actuel = substr(input, i, 1);
                if (chiffre_precedent == chiffre_actuel) {
                    nb_chiffre++;
                    continue;
                }
                chaine_sortie = chaine_sortie "" nb_chiffre "" chiffre_precedent;
                chiffre_precedent = chiffre_actuel;
                nb_chiffre = 1;
            }
            chaine_sortie = chaine_sortie "" nb_chiffre "" chiffre_precedent;

            print chaine_sortie;
        }
    ' /dev/null
}

result="${input}"
echo "0 ${result}"
for i in $(seq 1 ${nb_iteration_1}); do
    result=$(transform "${result}")
    # echo "${i} ${result}"
done

echo "puzzle 1 : ${#result}"

result2="${result}"
for i in $(seq 1 ${nb_iteration_2}); do
    result2=$(transform "${result2}")
    # echo "${i} ${result2}"
done

echo "puzzle 2 : ${#result2}"
