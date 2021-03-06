######################################################
#
#	Utilitaires des achives
#
######################################################

proc creerArch {aid} {

global gv

	set fen .crarch$aid
	if {[winfo exists $fen]} {
		return
	}
  set gv($aid,nom) "Archive"
  set gv($aid,data,rep) ""
  set gv($aid,tmax) 0
  set gv($aid,data,link) true
  set gv($aid,data,rep_vide) true
  set gv($aid,data,unique) unique
  set gv($aid,source) ""
	set gv($aid,source,act) ""
  set gv($aid,rep,exclure) {"*/lost+found"}
  set gv($aid,fic,exclure) {}
  set gv($aid,statut) Initialisation

	toplevel $fen
	wm title $fen "Création d'une archive"

	set fr1 [ttk::frame $fen.fr1 -relief ridge]
	ttk::label $fr1.ent1 -text "Nom de l'archive "
	ttk::entry $fr1.nom -textvariable gv($aid,nom) -background white
	grid $fr1.ent1 -row 0 -column 0 -sticky e
	grid $fr1.nom -row 0 -column 1 -sticky ew
	grid columnconfigure $fr1 $fr1.ent1 -weight 0
	grid columnconfigure $fr1 $fr1.nom -weight 1
	grid $fr1 -sticky ew
	grid columnconfigure $fen $fr1 -weight 1

	set fr2 [ttk::frame $fen.fr2 -relief ridge]
	ttk::label $fr2.ent1 -text "Rṕertoire d'archivage "
	ttk::entry $fr2.rep -textvariable gv($aid,data,rep) -background white
	ttk::button $fr2.sel -text " Sélectionner " -command [list selrep $fr2.rep false "$aid,data,rep" "Sélectionner le répertoire d'archivage"]
	grid $fr2.ent1 -row 0 -column 0 -sticky e 
	grid $fr2.rep -row 0 -column 1 -sticky ew
	grid $fr2.sel -row 0 -column 2 -sticky ew
	grid columnconfigure $fr2 $fr2.ent1 -weight 0
	grid columnconfigure $fr2 $fr2.rep -weight 1
	grid columnconfigure $fr2 $fr2.sel -weight 0
	grid $fr2 -sticky ew
	grid columnconfigure $fen $fr2 -weight 1

	set fr3 [ttk::frame $fen.fr3 -relief ridge]
	ttk::label $fr3.ent1 -text " Conserver les fichiers comme "
	checkbutton $fr3.unique -text "unique " -indicatoron false -command [list fliplink $fr3.unique $fr3.link $aid]
	checkbutton $fr3.link -text " créer des liens symbolique " -indicatoron false -state disable -command [list setlink $fr3.link $aid]
	grid $fr3.ent1 -row 0 -column 0 -sticky ew
	grid $fr3.unique -row 0 -column 1 -sticky ew
	grid $fr3.link -row 0 -column 2 -sticky ew
	grid columnconfigure $fr3 $fr3.ent1 -weight 0
	grid columnconfigure $fr3 $fr3.unique -weight 1
	grid columnconfigure $fr3 $fr3.link -weight 1
	grid $fr3 -sticky ew
	grid columnconfigure $fen $fr3 -weight 1

	return
}	

proc fliplink {uniq link aid} {

global gv
	set val [$uniq cget -text]
	if {"$val" == "unique "} {
		$uniq configure -text "version "
		$link configure -state normal
		set gv($aid,data,unique) true
	} else {
		$uniq configure -text "unique "
		$link configure -state disable
		set gv($aid,data,unique) false
	}
	return
}

proc setlink {link aid} {

global gv
	set val [$link cget -text]
	if {"$val" == " créer des liens symbolique "} {
		set gv($aid,data,link) false
		$link configure -text " copier les fichiers "
	} else {
		set gv($aid,data,link) trur
		$link configure -text " créer des liens symbolique "
	}
	return
}

