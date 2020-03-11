########################################################################
#
# Interface du gestionnaire d'archives
#
########################################################################


proc gereArchive {aid} {
global gv

if {[winfo exists .$aid} {
	return
}

# Init
wm title .$aid "Achiveur"

# Entête
set entfr [frame .$aid.entfr -borderwidth 2 -relief ridge]
label $entfr.aba -text " A R C H I V E U R "
label $entfr.ent -text " Gestionnaire d'archives " -justify center
label $entfr.ent1 -text " Archive: "
ttk::combobox $entfr.nom -textvariable gv($aid,nom) -background white\
 -postcommand [list listArch $entfr.nom]
bind $entfr.nom <<ComboboxSelected>> [list chargArch $aid]
grid $entfr.aba $entfr.ent $entfr.ent1 $entfr.nom -sticky new
grid columnconfigure $entfr $entfr.nom -weight 1

grid $entfr -row 0 -sticky new
grid columnconfigure .$aid $entfr -weight 1
grid rowconfigure .$aid $entfr -weight 0

# Espace de travail
set afffr [frame .afffr -borderwidth 2 -relief ridge]
# Liste des versions d'archives
set lver [ttk::labelframe $afffr.lver -text " Sources " -borderwidth 2 -relief ridge]
ttk::scrollbar $lver.hb -orient horizontal -command [list $lver.lb xview]
ttk::scrollbar $lver.vb -orient vertical -command [list $lver.lb yview]
listbox $lver.lb -bg white -listvariable gv(arch,verlist) -xscrollcommand [list $lver.hb set] -yscrollcommand [list $lver.vb set]

grid $lver.lb $lver.vb -sticky nesw
grid $lver.hb -sticky nesw
grid columnconfigure $lver $lver.lb -weight 1
grid rowconfigure $lver $lver.lb -weight 1

grid $lver -column 0 -sticky nesw
grid rowconfigure $afffr $lver -weight 1
grid columnconfigure $afffr $lver -weight 1

# Fichiers archivés
set lfic [ttk::labelframe $afffr.lfic -text "Fichiers archivés" -borderwidth 2 -relief ridge]
# Entête
set arent [frame $lfic.ent -borderwidth 2 -relief raised]
label $arent.entnbf -textvariable gv(arch,nbfic) -relief sunken -bg white -borderwidth 3
grid $arent.entnbf -row 0 -column 0 -sticky nesw
grid columnconfigure $arent $arent.entnbf -weight 1
label $arent.entf -text " fichiers archivés totalisant "
grid $arent.entf -row 0 -column 1 -sticky nesw
grid columnconfigure $arent $arent.entf -weight 0
label $arent.enttf -textvariable gv(arch,fic,taille) -relief sunken -bg white -borderwidth 3
grid $arent.enttf -row 0 -column 2 -sticky nesw
grid columnconfigure $arent $arent.enttf -weight 3
label $arent.ent1 -text " octets (occupant "
grid $arent.ent1 -row 0 -column 3 -sticky nesw
grid columnconfigure $arent $arent.ent1 -weight 0
label $arent.entat -textvariable gv(arch,taille) -relief sunken -bg white -borderwidth 3
grid $arent.entat -row 0 -column 4 -sticky nesw
grid columnconfigure $arent $arent.entat -weight 3
label $arent.ent2 -text " octets dans l'archive)"
grid $arent.ent2 -row 0 -column 5 -sticky nesw
grid columnconfigure $arent $arent.ent2 -weight 0

grid $arent -row 0 -sticky nesw
grid columnconfigure $lfic $arent -weight 1
grid rowconfigure $lfic $arent -weight 0

# Liste des fichiers
set ft [ficTree $lfic.ft 30 "nom taille magic perm proprio groupe statut"]  

set gv(arch,fic,treev) $ft.tree
grid $ft -row 1 -sticky news
grid columnconfigure $lfic $ft -weight 1
grid rowconfigure $lfic $ft -weight 1

grid $lfic -row 0 -column 1 -sticky news
grid rowconfigure $afffr $lfic -weight 1
grid columnconfigure $afffr $lfic -weight 3


grid $afffr -row 1 -sticky nesw
grid columnconfigure . $afffr -weight 1
grid rowconfigure . $afffr -weight 1

# Boite des boutons d'actions
set actfr [frame .actfr -borderwidth 2 -relief ridge]
button $actfr.ajout -text "Ajouter" -command ajoutArchive
button $actfr.fin -text "Quitter" -command finArchiveur
grid $actfr.fin $actfr.ajout -sticky nesw
grid rowconfigure $actfr $actfr.ajout -weight 1
grid rowconfigure $actfr $actfr.fin -weight 1


grid $actfr -row 2 -sticky nesw
grid columnconfigure . $actfr -weight 1
grid rowconfigure . $actfr -weight 0

}

# Synchronisation des données
set gv(arch,dbsync,statut) ""
toplevel .arch_db_sync
wm title .arch_db_sync "Chargement des données"
label .arch_db_sync.m1 -text "Balayage des sources de l'archive ..."
pack .arch_db_sync.m1 -fill x -expand true
label .arch_db_sync.st -textvariable gv(arch,dbsync,statut)
pack .arch_db_sync.st
update idletasks

set v0path "$gv(rep,archive)/data/personnel/Francois/v0"
#set v0path "/home/francois"
addRepTree $gv(arch,fic,treev) "" "$v0path" "$v0path" v0 "arch,nbfic" "arch,fic,taille" "arch,dbsync,statut"

#set fout [open [list "|$gv(rep,ABA_base)/utils/safefind.sh" f "$v0path"] r]
#gets $fout fic
#while {! [eof $fout]} {
#  if {"$fic" == ""} {
#      gets $fout fic
#      continue
#  }
#	set fpath [string map [list "$v0path/" ""] "$fic"]
#	set gv(arch,dbsync,statut) "$fpath"
#	set it [addFicTree $gv(arch,fic,treev) "$fic" "$v0path"]
#	set taille [file size "$fic"]
#	$gv(arch,fic,treev) set $it taille $taille
#	incr gv(arch,nbfic)
#	incr gv(arch,fic,taille) $taille
#	update idletasks
#	gets $fout fic
#}
#close $fout
destroy .arch_db_sync

#set gv(arch,dbsync,statut) "Chargement de la base de données ..."
#set gdf "$gv(rep,archive,cour,db)/Archives.db"
#charggv "$gdf" "arch,"


#foreach indf [glob -nocomplain "$gv(rep,archive,cour,db)/*.idx"] {
#	set fn [file rootname [file tail "$indf"]]
#	set fnp [string map {"_._" " "} "$fn"]
#	set pr [lindex "$fnp" 0]
#	set suf [lindex "$fnp" 1]
#	set fd [open "$indf" r]
#	gets $fd gv($pr,index,$suf)
#	close $fd
#}



#tkwait window .

proc listArch {wid} {

global gv
	set i 0
	set vlist ""
	while {$i <= $gv(arch,dernid)} {
		if {[info exists gv($i,nom)]} {
			lappend vlist "$gv($i,nom)"
		}
		incr i
	}
	$wid configure -values $vlist
	return
}

proc finArchiveur {} {

global gv

	set gdf "$gv(rep,archive,cour,db)/Archives.db"
	sauvgv w "$gdf" "arch,*" "arch,"
	foreach ind [array names gv "*,index,*"] {
		set i [string map {",index," " "} "$ind"]
		set ob [lindex "$i" 0]
		set ch [lindex "$i" 1]
		set fd [open "$gv(rep,archive,cour,db)/$ob_._$ch.idx" w]
		puts "$fd" "$gv($ind)"
		close $fd
	}
	

	destroy .
}





