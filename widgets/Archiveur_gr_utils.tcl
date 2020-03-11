

proc ajoutArchive {} {

global gvar

    if {[winfo exists .addArch]} {
#        tk_dialog .warnaddArch "Archive occupée" "Il y a une mise-a-jour de l'archive en cours" ::tk::icons::warning 0 Ok
        return
    }
    toplevel .addArch
    wm title .addArch "Ajout de fichier"
    set fr1 [ttk::labelframe .addArch.selrep -text "Sélection des fichiers"]
    ttk::button $fr1.ajrep -textvariable gvar(arch,ajout_rep) -command [list selRepajoutArch $fr1.ajrep]
	pack $fr1.ajrep -fill x -expand true
	set fr2 [frame $fr1.actb]
    ttk::button $fr2.ajok -text "Ajouter à l'archive" -command [list repToArch .addArch]
    ttk::checkbutton $fr2.eff -text "Effacer les fichiers de la source" -variable gvar(arch,eff)
	ttk::button $fr2.annule -text "Annuler" -command [list destroy .addArch]
	pack $fr2.eff -side left -fill x -expand true
	pack $fr2.ajok -side right -fill x -expand true
	pack $fr2.annule -side right -fill x

    pack $fr1 -fill x -expand true
	pack $fr2 -fill x -expand true
}

proc selRepajoutArch {bouton} {

global gvar

	set repsel [tk_chooseDirectory -initialdir "$gvar(arch,ajout_rep)" -mustexist true -parent $bouton -title "Sélection d'un répertoire"]
	if {[file readable "$repsel"]} {
		set gvar(arch,ajout_rep) "$repsel"
	}
	return
}


proc repToArch {fen} {

global gvar

#    if {$gvar(arch,eff) == 1} {
#        set gvar(arch,eff) [tk_dialog .warnaddArch "Archivage de $gvar(arch,ajout_rep)"\
#                             "Les fichiers de $gvar(arch,ajout_rep) seront effacés. Confirmez" warn $gvar(arch,eff) Non Ok]
#    }

	set rid [rep_init arch,ar 0 0 "$path"]
    set lfic [ttk::labelframe $fen.rtafr -text "Archivage de $gvar(arch,ajout_rep)" -borderwidth 2 -relief ridge]

    set gvar(arch,ar,nbfic) 0
    set gvar(arch,ar,nbrep) 0
    set gvar(arch,ar,fic,taille) 0
    # Entête
    set arent [frame $lfic.ent -borderwidth 2 -relief raised]
    label $arent.entnbf -textvariable gvar(arch,ar,nbfic) -relief sunken -bg white -borderwidth 3
    label $arent.entf -text " fichiers archivés dans "
    label $arent.entat -textvariable gvar(arch,ar,nbrep) -relief sunken -bg white -borderwidth 3
    label $arent.ent2 -text " répertoires totalisant "
    label $arent.enttf -textvariable gvar(arch,ar,fic,taille) -relief sunken -bg white -borderwidth 3
    label $arent.ent1 -text " octets"
    pack $arent.ent1 -side right -anchor ne
    pack $arent.enttf -side right -fill x -expand true
    pack $arent.ent2 -side right 
    pack $arent.entat -side right -fill x -expand true
    pack $arent.entf -side right
    pack $arent.entnbf -side left -fill x -expand true -anchor nw
    pack $arent -fill x -expand true
    # Arbre des fichiers
    set ft [ficTree $lfic.ft]
    set gvar(arch,ar,fic,treev) $ft.ftree
    $ft.ftree tag configure illisible -background #D05948
    $ft.ftree tag configure ok -background #A7E391
    $ft.ftree tag configure encour -background #EBC6AE
    pack $ft -fill both -expand true -anchor nw
    pack $lfic -fill both -expand true


	
	set gvar(arch,ar,rep,$rid,tind) {}


	return    
    
    
}

proc grrep_scan {parid path} {

global gvar

#	set paid $parid
#	set partind {}
#	if {"$parid" == ""} {
#		set paid 0
#	} else {
#		 set partind "$gvar(arch,ar,$parid,tmpind)"
#	}
    
    set tree "$gvar(arch,ar,fic,treev)"
#	set tindcour [$tree insert $partind end -text [file tail "$path"] -tags encour]
#    set gvar(arch,ar,rep,$rid,tind) "$tindcour"
#	majficTree "arch,ar" "arch,ar,rep,$rid"
#    if {! [file readable "$path"]} {
#        set gvar(arch,ar,rep,$rid,statut) "ILLISIBLE"
#		$tree tag remove encour "$tindcour"
#		$tree tag add illisible "$tindcour"
#		majficTree "arch,ar" "arch,ar,rep,$rid"
#		return "illisible"
#	}
#	incr gvar(arch,ar,nbrep)
	set gvar(arch,ar,rep,$rid,statut) "En traitement ..."
	set ajrep "$gvar(arch,ajout_rep)"

	set ptind $gvar(arch,ar,rep.$rid,tind)
	# Traitement des fichiers
	foreach fic "$listf" {
		set fid [fic_init arch,ar 0 $rid "$ajrep/$fic"]
		set ftind [$tree insert $ptind end]
		if {[lsearch -regexp "$gvar(arch,fic,exclure)" "$ajrep/$fic"] < 0} {
			set gvar(arch,ar,fic,$fid,statut) "Signature ..."
			exec "$gvar(rep,ABA_base)/utils/sigFic.sh" $fid "$gvar(sig_cmd)" "$en" "$dbrep" "&"
	    	cascade arch,ar $parid size ajout $gvar(arch,ar,fic,$fid,size)
			lappend gvar(arch,ar,rep,$parid,fics) $fid
			incr gvar(arch,ar,nbfic)
			
			
			
                
	    		 } else {
	    			ABAlog warning ">> Rejeté: $en (dans exclure)"
	    		 }
			
	    	}
    }
    set f [open "$gvar(rep,bck)/envoi/répertoire/$id.dat" w]
    puts $f "<$id>"
    foreach ch [array names gvar rep,$id,*] {
        puts $f "$gvar($ch)"
    }
    close $f
    lappend gvar(rep,$gvar(rep,$id,parid),reps) $id



}

