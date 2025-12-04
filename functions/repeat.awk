# awk functions/repeat.awk

# Fonction pour répéter une chaîne de caractères
# str_to_repeat : chaîne à répéter
# times : nombre de répétitions
# Retourne la chaîne répétée
function repeat(str_to_repeat, times, repeated_string, i) {
    repeated_string = ""        # initialise la chaîne résultat
    for (i = 1; i <= times; i++) {
        repeated_string = repeated_string str_to_repeat
    }
    return repeated_string
}