#!/bin/bash

file_input="input.txt"
# file_input="input_example.txt"

# Partie 1
awk '
    # Fonction pour trier une ligne en ordre croissant ou décroissant
    function sort_line(line, order, arr, n, i) {
        split(line, arr, " ")      # Divise la ligne en un tableau
        n = asort(arr)             # Trie le tableau en ordre croissant
        result = ""                # Réinitialise le résultat
        if (order == "desc") {
            for (i = n; i > 0; i--) {
                result = result (i < n ? " " : "") arr[i]  # Construit la chaîne triée
            }
        } else {
            for (i = 1; i <= n; i++) {
                result = result (i > 1 ? " " : "") arr[i]  # Construit la chaîne triée
            }
        }
        return result;
    }

    BEGIN{nb_safe=0;}
    {
        line_asc = sort_line($0, "asc");
        line_desc = sort_line($0, "desc");
        if ($0 == line_asc || $0 == line_desc) {
            prev=0;
            for (x = 1; x <= NF; x++) {
                if (x > 1) {
                    if ($x >= prev) {
                        diff = $x - prev;
                    } else {
                        diff = prev - $x;
                    }
                    if (diff < 1 || diff > 3) {
                        next;
                    }
                }
                prev=$x;
            }
            nb_safe++;
        }
    }
    END{print "nb_safe: " nb_safe;}
' "${file_input}"

# Partie 2
awk '
    function remove_one(arr, n, possibilities) {
        ind = 1
        # Imprimer la combinaison complète
        for (i = 1; i <= n; i++) {
            possibilities[ind] = possibilities[ind] " " arr[i]
        }
        ind++;

        # Générer les combinaisons en supprimant un nombre à chaque fois
        for (i = 1; i <= n; i++) {
            for (j = 1; j <= n; j++) {
                if (j != i) {
                    possibilities[ind] = possibilities[ind] " " arr[j]
                }
            }
            ind++;
        }
    }

    function valide_string(str) {
        split(str, arr, " ")
        n = length(arr);

        prev=arr[1];
        prev2=arr[1];
        prev_order="";
        order="";
        nb_error = 0;

        for (x = 2; x <= n; x++) {
            if (arr[x] > prev) {
                order = "asc";
                diff = arr[x] - prev;
            } else {
                order = "desc";
                diff = prev - arr[x];
            }
            if (x > 2 && order != prev_order) { nb_error += 1; }
            if (diff < 1 || diff > 3) { nb_error += 10;}
            prev_order = order;
            prev2 = prev;
            prev = arr[x];
        }
        return nb_error;
    }

    BEGIN{nb_safe=0;}
    {
        delete possibilities;
        split($0, arr, " ");
        n = length(arr);
        remove_one(arr, n, possibilities);
        for (i in possibilities) {
            nb_error = valide_string(possibilities[i]);
            # print possibilities[i] " - " nb_error;
            if (nb_error == 0) {
                nb_safe++;
                next;
            }
        }
    }
    END{print "nb_safe with Dampener: " nb_safe;}
' "${file_input}"
