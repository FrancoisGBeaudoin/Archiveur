proc ficTree {fen} {

global gvar

    set coll {nom magic taille statut} 
    set disl {nom magic taille statut}
    set f [frame $fen]
    set hb  [ttk::scrollbar $f.hb -orient horizontal -command [list $f.ftree xview]]
    set vb  [ttk::scrollbar $f.vb -orient vertical -command [list $f.ftree yview]]
    set tr [ttk::treeview $f.ftree -columns "$coll" -displaycolumns "$disl"\
            -xscrollcommand [list $hb set]\
            -yscrollcommand [list $vb set]]
    $tr heading nom -text "Nom"
    $tr column nom -stretch true
    $tr heading magic -text "Type"
    $tr column magic -width 450
    $tr heading taille -text "Taille"
    $tr column taille -stretch true
    $tr heading statut -text "État"
    $tr column statut -stretch true
    $tr column #0 -width 70

    pack $hb -side bottom -fill x -expand true -anchor sw
    pack $vb -side right -fill y -expand true -anchor ne
    pack $tr -side left -anchor nw -fill both -expand true

    return $fen
}

proc majficTree {pref gind} {

global gvar

    set coll {magic taille statut}
    set gvil {magic size statut}	
	set tr "$gvar($pref,fic,treev)"
	set tind "$gvar($gind,tind)"
	$tr set $tind nom [file tail "$gvar($gind,path)"]
	foreach c "$coll" i "$gvil" {
		set actval [$tr set $tind $c]
		if {"$actval" != "$gvar($gind,$i)"} {
			$tr set $tind $c "$gvar($gind,$i)"
		}
	}
	update idletask
	return
}

proc chargfictree {pref tree dpath} {

global gvar

}

