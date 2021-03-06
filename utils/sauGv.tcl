####################################################################
#
#   Procédure de sauvegarde des données
#
#   Syntaxe: sauvGv mode fichier
#
#   Arguments:
#       mode        Mode d'ouverture du fichier de données (mode de open)
#       fichier     Path du ficher où inscrire les données
#
#   La procédure écrit les données dans le format:
#       <indice>\t=\t<valeur de gv($indice)>
#
####################################################################

proc sauvGv {mode fichier} {

global gv

    set donf [open "$fichier" $mode]
    foreach i [array names gv] {
        puts $donf "$i\t=\t$gv($i)"
    }
    close $donf
    return ok
}

####################################################################
#
#   Procédure de chargement des données
#
#   Syntaxe: chargGv fichier
#
#   Arguments:
#       fichier     Path du ficher de données. Format:
#         <indice>\t=\t<valeur de gv($indice)>
#
#   La procédure lit les données dans le format:
#
####################################################################

proc chargGv {fichier} {

global gv

    if {! [file readable "$fichier"]} {
        return "$fichier illisible"
    }
    set df [open "$fichier" r]
    gets $df li
    set lind ""
    while {! [eof $df]} {
        set ind ""
        set p [string first "\t=\t" "$li"]
        if {$p < 0} {
            set gv($pa$lind) "$gv($pa$lind) $li"
        } else {
            set ind [string range "$li" 0 $p-1]
            set gv($pa,$ind) [string trim [string range "$li" $p+3 end]]
            set lind "$ind"
        }
        gets $df li
    }
    close $df
    return ok
}

