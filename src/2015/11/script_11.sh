#!/bin/bash

pass="${1:-vzbxkghb}"

# rule_1 : Passwords must include one increasing straight of at least three letters, like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't count.
# rule_2 : Passwords may not contain the letters i, o, or l, as these letters can be mistaken for other characters and are therefore confusing.
# rule_3 : Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.

echo "pass: ${pass}"

awk -v pass="${pass}" '
    function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
    function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
    function trim(s) { return rtrim(ltrim(s)); }
    function rule_1(str){
        split("a b c d e f g h j k m n p q r s t u v w x y z", valuesAsValues);
        for (i in valuesAsValues) { valuesAsKeys[valuesAsValues[i]] = i; }

        for (i=1; i<=length(str)-2; i++) {
            str_1 = substr(str, i, 1);
            pos_str_1 = valuesAsKeys[str_1];
            if (valuesAsKeys[substr(str, i+1, 1)] == pos_str_1+1) {
                if (valuesAsKeys[substr(str, i+2, 1)] == pos_str_1+2) {
                    return 0;
                }
            }
        }
        return 1;
    }
    function rule_2(str){
        for (i=2; i<=length(str); i++) {
            str_actuelle = substr(str, i, 1);
            if (str_actuelle == "i" || str_actuelle == "o" || str_actuelle == "l") {
                return 1;
            }
        }
        return 0;
    }
    function rule_3(str){
        pair = 0;
        letter = "";
        for (i=1; i<=length(str)-1; i++) {
            str_1 = substr(str, i, 1);
            if (substr(str, i+1, 1) == str_1 && letter != str_1) {
                i++;
                letter = str_1;
                pair++;
                if (pair >= 2) {
                    return 0;
                }
            }
        }
        return 1;
    }
    function valide_password(str){
        split("a b c d e f g h i j k l m n o p q r s t u v w x y z", allValuesAsValues);
        for (i in allValuesAsValues) { allValuesAsKeys[allValuesAsValues[i]] = i; }

        for (i=1; i<=length(str)-1; i++) {
            str_actuelle = substr(str, i, 1);
            if (str_actuelle == "i" || str_actuelle == "o" || str_actuelle == "l") {
                pos_str_actuelle = allValuesAsKeys[str_actuelle];
                new_str = substr(str, 1, i-1) allValuesAsValues[pos_str_actuelle + 1];
                while (length(new_str) < length(str)) { new_str = new_str "a"; }
                return new_str;
            }
        }
        return str;
    }
    function next_password(str){
        split("a b c d e f g h j k m n p q r s t u v w x y z", valuesAsValues);
        for (i in valuesAsValues) { valuesAsKeys[valuesAsValues[i]] = i; }

        str_post = "";
        for (i=length(str); i>=1; i--) {
            str_1 = substr(str, i, 1);
            pos_str_1 = valuesAsKeys[str_1];
            if (pos_str_1+1 in valuesAsValues) {
                return substr(str, 1, i-1) valuesAsValues[pos_str_1+1] str_post;
            }
            str_post = str_post "a";
        }
    }
    BEGIN {
        trouve = 0;
        pass = valide_password(pass);
        print "valid:" pass;
        while (trouve == 0) {
            pass = next_password(pass);

            if (rule_1(pass) == 1) { trouve = 0; continue;}
            if (rule_2(pass) == 1) { trouve = 0; continue;}
            if (rule_3(pass) == 1) { trouve = 0; continue;}
            trouve = 1;
        }
        print "result_1 "pass;

        trouve=0;
        while (trouve == 0) {
            pass = next_password(pass);

            if (rule_1(pass) == 1) { trouve = 0; continue;}
            if (rule_2(pass) == 1) { trouve = 0; continue;}
            if (rule_3(pass) == 1) { trouve = 0; continue;}
            trouve = 1;
        }
        print "result_2 "pass;
    }
' /dev/null
