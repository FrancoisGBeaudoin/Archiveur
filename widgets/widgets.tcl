##################################################
#
#	Widgets
#
##################################################

proc selrep {defen existe gind m} {

global gv

	set chrep [tk_chooseDirectory -initialdir "$gv($gind)"\
 -mustexist $existe -parent $defen -title "Sélection du répertoire"]
	if {"$chrep" != ""} {
		set gv($gind) "$chrep"
	}
	return
}

proc selfic {defen muli gind m} {

global gv

	set chfic [tk_getOpenFile -initialdir "$gv($gind)"\
 -multiple $multi -parent $defen -title "Sélection du fichier"]
	if {"$chfic" != ""} {
		set gv($gind) "$chfic"
	}
	return
}

proc popfen {fen type mes} {

	set fenn ".popfen$type"
	toplevel $fenn
	wm title $fenn " $type "
	wm overrideredirect $fenn true
	wm transient $fenn $fen
	label $fenn.m -text "$mes"
	pack $fenn.m -fill both
	button $fenn.ok -text "OK" -command [list destroy $fenn]
	pack $fenn.ok -fill x
	tkwait window $fenn
	return
}

