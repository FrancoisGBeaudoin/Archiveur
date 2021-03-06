##################################################
#
# Gestionnaire d'archive
#
##################################################

package require Tk

global gv

foreach src {widgets scrolledTree creerArchive gererArch} {
	source widgets/$src.tcl
}

foreach src {fictree_utils sauGv version_utils} {
	source utils/$src.tcl
}

set gv(rep,arch_base) "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test"
set gv(arch,dbfic) archive.dat
set gv(arch,dernid) -1

# Archive de base
  set gv(0,nom) "Archive de François"
  set gv(0,data,rep) "$gv(rep,arch_base)/Archive/data/personnel/Francois"
  set gv(0,tmax) 0
  set gv(0,data,link) true
  set gv(0,data,rep_vide) true
  set gv(0,data,unique) false
#{0 "/home/francois" copi}
  set gv(0,source) {{1 /home/francois.save depl}\
 {2 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/Actuel" depl}\
 {3 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/AvantDernier" depl}\
 {4 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/fr0917" depl}\
 {5 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/frankb" depl}\
 {6 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/frank2" depl}\
 {7 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/frank" depl}\
 {8 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/francois" depl}\
 {9 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/francois.last" depl}\
 {10 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/francois1" depl}\
 {11 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/francois_arch" I00E depl clean}
 {12 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/francois_storage" depl}\
 {13 "/media/francois/378b418c-96e8-495b-b2ee-f41586424bb6/home/frank" copi}\
 {14 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/Mint 18.2" depl}\
 {15 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/franlm17.1" depl}\
 {16 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/oldsarahfrancois" depl}\
 {17 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/oldsarahfrank" depl}\
 {18 "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test/Archive/data/personnel/francois.arch1/francoislm14" depl}\
 {19 "/media/francois/1e9d9476-7397-45d4-8e71-38f2cd430a54/Storage/francois" depl}\
 {20 "/media/francois/1e9d9476-7397-45d4-8e71-38f2cd430a54/Storage/home/francois" depl}\
 {21 "/media/francois/1e9d9476-7397-45d4-8e71-38f2cd430a54/Storage/home/frank" depl}\
 {22 "/media/francois/1e9d9476-7397-45d4-8e71-38f2cd430a54/Storage/home/inter" depl}\
 {23 "/media/francois/1e9d9476-7397-45d4-8e71-38f2cd430a54/Storage/Projets" depl}}
  set gv(0,rep,exclure) {"*/lost+found"}
  set gv(0,fic,exclure) {}
  set gv(0,statut) "Archivé"
	set gv(0,categ) ""
	set gv(0,nbfic) 0
	set gv(0,taille) 0
	set gv(0,fic,taille) 0
	set gv(0,rep,index,nom) ""
	set gv(0,rep,index,tind) ""
	set gv(0,index,fic) ""
	set gv(0,index,fictind) ""
	set gv(0,derversionid) 23

	set gv(0,ficTreewid) [gereArchive 0]
	chargArch 0

#tkwait window .

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








