########################################################################
#
# Interface du gestionnaire d'archives
#
########################################################################


proc gereArchive {aid} {
global gv

	if {[winfo exists .$aid]} {
		return
	}


	# Init
	toplevel .$aid
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
	set afffr [frame .$aid.afffr -borderwidth 2 -relief ridge]

	# Fichiers archivés
	set lfic [ttk::labelframe $afffr.lfic -text "Fichiers archivés" -borderwidth 2 -relief ridge]
	# Entête
	set arent [frame $lfic.ent -borderwidth 2 -relief raised]
	label $arent.entnbf -textvariable gv($aid,nbfic) -relief sunken -bg white -borderwidth 3
	grid $arent.entnbf -row 0 -column 0 -sticky nesw
	grid columnconfigure $arent $arent.entnbf -weight 1
	label $arent.entf -text " fichiers archivés totalisant "
	grid $arent.entf -row 0 -column 1 -sticky nesw
	grid columnconfigure $arent $arent.entf -weight 0
	label $arent.enttf -textvariable gv($aid,fic,taille) -relief sunken -bg white -borderwidth 3
	grid $arent.enttf -row 0 -column 2 -sticky nesw
	grid columnconfigure $arent $arent.enttf -weight 3
	label $arent.ent1 -text " octets (occupant "
	grid $arent.ent1 -row 0 -column 3 -sticky nesw
	grid columnconfigure $arent $arent.ent1 -weight 0
	label $arent.entat -textvariable gv($aid,taille) -relief sunken -bg white -borderwidth 3
	grid $arent.entat -row 0 -column 4 -sticky nesw
	grid columnconfigure $arent $arent.entat -weight 3
	label $arent.ent2 -text " octets dans l'archive)"
	grid $arent.ent2 -row 0 -column 5 -sticky nesw
	grid columnconfigure $arent $arent.ent2 -weight 0

	grid $arent -row 0 -sticky nesw
	grid columnconfigure $lfic $arent -weight 1
	grid rowconfigure $lfic $arent -weight 0

	# Liste des fichiers
	set ft [ficTree $lfic.ft 30 "nom nbver taille magic perm proprio groupe statut"]  

	set gv(arch,fic,treev) $ft.tree
	grid $ft -row 1 -sticky news
	grid columnconfigure $lfic $ft -weight 1
	grid rowconfigure $lfic $ft -weight 1

	grid $lfic -row 0 -column 1 -sticky news
	grid rowconfigure $afffr $lfic -weight 1
	grid columnconfigure $afffr $lfic -weight 3


	grid $afffr -row 1 -sticky nesw
	grid columnconfigure .$aid $afffr -weight 1
	grid rowconfigure .$aid $afffr -weight 1

	# Boite des boutons d'actions
	set actfr [frame .$aid.actfr -borderwidth 2 -relief ridge]
	button $actfr.ajout -text "Ajouter" -command [list ajoutArchive $aid]
	button $actfr.fin -text "Quitter" -command finArchiveur
	grid $actfr.fin $actfr.ajout -sticky nesw
	grid rowconfigure $actfr $actfr.ajout -weight 1
	grid rowconfigure $actfr $actfr.fin -weight 1


	grid $actfr -row 2 -sticky nesw
	grid columnconfigure .$aid $actfr -weight 1
	grid rowconfigure .$aid $actfr -weight 0

	update idletasks
	#set db "$gv(0,data,rep)/arch.tree"
	#if {[file exists "$db"]} {
	#	set gv(arch,dbsync,statut) "Chargement des données ..."
	#	update idletasks
	#	chargficTree $gv(arch,fic,treev) $db 0
	#}

	return $ft.tree

}
#
# Génération de la liste des archives
#
########################
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
#
#	Chargement des données de l'archive
#
#########################
proc chargArch {aid} {

global gv

	set artree $gv($aid,ficTreewid)
	set vertree ""
	if {! $gv(0,data,unique)} {
		# Liste des versions d'archives
		set lver [verArch $aid .$aid.afffr.lver false]
		set vertree $lver.tree

		grid $lver -row 0 -column 0 -sticky nesw
		grid rowconfigure .$aid.afffr $lver -weight 1
		grid columnconfigure .$aid.afffr $lver -weight 1
		set ait [$vertree insert "" end]
		$vertree set $ait rep "Archive Complète"
		$vertree set $ait vrep "arch"
		$vertree set $ait acts "rien"
  }
	set gv($aid,statut) ""
	toplevel .stat$aid
	wm title .stat$aid "Chargement des données"
	label .stat$aid.m1 -text "Chargement de l'archive ..."
	pack .stat$aid.m1 -fill x -expand true
	label .stat$aid.st -textvariable gv($aid,statut)
	pack .stat$aid.st
	update idletasks
	set datrep "$gv($aid,data,rep)/arch"
	set dbpath "$gv($aid,data,rep)/archTree.dat"
	if {[file readable "$dbpath"]} {
		set gv($aid,statut) "Chargement de la base de données ..."
		update idletasks
		chargficTree $artree "$dbpath" $aid
	} else {
		set gv($aid,statut) "Balayage de l'archive ..."
		update idletasks
		addRepTree $artree "" "$datrep" "$datrep" $aid $aid,statut
	}
	set dbpatharch "$dbpath"
	if {! $gv(0,data,unique)} {
		set bwid [winfo parent [winfo parent [winfo parent $artree]]]
		foreach vdon "$gv($aid,source)" {
			set vno [lindex "$vdon" 0]
			set srep [lindex "$vdon" 1]
			set acts [lindex "$vdon" 2]
			set datrep "$gv($aid,data,rep)/v$vno"
			set dbpath "$gv($aid,data,rep)/vTree$vno.dat"
			set gv(0,$vno,nbfic) 0
			set gv(0,$vno,taille) 0
			set gv(0,$vno,fic,taille) 0
			set gv(0,$vno,rep,index,nom) ""
			set gv(0,$vno,rep,index,tind) ""
			set gv(0,$vno,index,fic) ""
			set gv(0,$vno,index,fictind) ""
			set lfic [ttk::labelframe $bwid.lfic$vno -text "Fichiers archivés" -borderwidth 2 -relief ridge]
			# Entête
			set arent [frame $lfic.ent -borderwidth 2 -relief raised]
			label $arent.entnbf -textvariable gv($aid,$vno,nbfic) -relief sunken -bg white -borderwidth 3
			grid $arent.entnbf -row 0 -column 0 -sticky nesw
			grid columnconfigure $arent $arent.entnbf -weight 1
			label $arent.entf -text " fichiers archivés totalisant "
			grid $arent.entf -row 0 -column 1 -sticky nesw
			grid columnconfigure $arent $arent.entf -weight 0
			label $arent.enttf -textvariable gv($aid,$vno,fic,taille) -relief sunken -bg white -borderwidth 3
			grid $arent.enttf -row 0 -column 2 -sticky nesw
			grid columnconfigure $arent $arent.enttf -weight 3
			label $arent.ent1 -text " octets (occupant "
			grid $arent.ent1 -row 0 -column 3 -sticky nesw
			grid columnconfigure $arent $arent.ent1 -weight 0
			label $arent.entat -textvariable gv($aid,$vno,taille) -relief sunken -bg white -borderwidth 3
			grid $arent.entat -row 0 -column 4 -sticky nesw
			grid columnconfigure $arent $arent.entat -weight 3
			label $arent.ent2 -text " octets dans l'archive)"
			grid $arent.ent2 -row 0 -column 5 -sticky nesw
			grid columnconfigure $arent $arent.ent2 -weight 0

			grid $arent -row 0 -sticky nesw
			grid columnconfigure $lfic $arent -weight 1
			grid rowconfigure $lfic $arent -weight 0

			set ft [ficTree $lfic.ft 30 "nom nbver taille magic perm proprio groupe statut"]  

			set ftree $ft.tree
			grid $ft -row 1 -sticky news
			grid columnconfigure $lfic $ft -weight 1
			grid rowconfigure $lfic $ft -weight 1

			if {[file readable "$dbpath"]} {
				set gv($aid,statut) "Chargement de la base de données ..."
				update idletasks
				chargficTree $ftree "$dbpath" $aid,$vno
			} else {
				set gv($aid,statut) "Balayage de l'archive (version $vno) ..."
				update idletasks
				addRepTree $ftree "" "$datrep" "$datrep" $aid,$vno $aid,statut
			}
			set gv($aid,$vno,ficTreewid) $ftree
			set gv($aid,statut) "Mise-à-jour des versions ..."
			update idletasks
			checkVer $aid "" $vno ""

			set ait [$vertree insert "" end]
			$vertree set $ait rep "$srep"
			$vertree set $ait vrep "v$vno"
			$vertree set $ait acts "$acts"
			incr gv($aid,nbfic) $gv(0,$vno,nbfic)
			incr gv($aid,taille) $gv(0,$vno,taille)
			incr gv($aid,fic,taille) $gv(0,$vno,fic,taille)
			update idletasks
			set gv($aid,statut) "Sauvegarde des données pour la version $vno ..."
			update idletasks
			set fd [open "$dbpath" w]
			sauveficTree $ftree "" $fd
			close $fd
			set fd [open "$dbpatharch" w]
			sauveficTree $artree "" $fd
			close $fd
		}
	}

	destroy .stat$aid
	return
}


