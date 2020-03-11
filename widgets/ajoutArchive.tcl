###############################################
#
# Ajouter un repertoire à l'archive
#
###############################################

proc ajoutArchive {aid} {

global gv

set aid 1
set gv(1,nom) "Test"

	set fen .ajout$aid
	if {[winfo exists $fen]} {
		return
	}

	set gv(rep,ajout) [pwd]
	set gv(rep,copi) true
	toplevel $fen
	wm title $fen " Ajout dans $gv($aid,nom)"

	set rfr [ttk::frame $fen.rfr]
	ttk::label $rfr.ent -text "Répertoire à ajouter : "
	ttk::entry $rfr.rep -textvariable gv(rep,ajout) -background white
	ttk::button $rfr.sel -text " Sélectionner " -command [list selrep $rfr.rep true rep,ajout ""]
	radiobutton $rfr.copi -text " Copier " -value true -indicatoron false -variable gv(rep,copi)
	radiobutton $rfr.depl -text " Déplacer " -value false -indicatoron false -variable gv(rep,copi)
	ttk::button $rfr.go -text " Ajouter " -command [list ajRep $aid]
	grid $rfr.ent $rfr.rep $rfr.sel $rfr.copi $rfr.depl $rfr.go -sticky ew
	grid columnconfigure $rfr $rfr.ent -weight 0
	grid columnconfigure $rfr $rfr.rep -weight 1
	grid columnconfigure $rfr $rfr.sel -weight 0
	grid columnconfigure $rfr $rfr.copi -weight 0
	grid columnconfigure $rfr $rfr.depl -weight 0
	grid $rfr -sticky ne
	grid columnconfigure $fen $rfr -weight 1

	ttk::label $fen.stat -text " En attente "
	grid $fen.stat -sticky ew
	grid columnconfigure $fen $fen.stat -weight 1
	

	tkwait window $fen
	return

}

proc ajRep {aid} {

global gv

	
	set artree $gv($aid,ficTreewid)
	set bwid [winfo parent [winfo parent [winfo parent $artree]]]

}
