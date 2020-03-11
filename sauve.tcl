
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

