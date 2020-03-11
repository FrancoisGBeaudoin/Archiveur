set gv(ficTree,cols) "nom nbver taille magic perm proprio groupe statut stype atime ctime mtime version"
set gv(ficTree,ents) "Nom Version Taille Contenu Permission Proprio Goupe Statut Type Accès Création Modifié VersionRef"
set gv(ficTree,colw) "+300 80 200 +500 95 90 90 160 130 100 100 100 +200"

proc ficTree {fen haut dcols} {

global gv

	set f [ttk::frame $fen]
	set hb  [ttk::scrollbar $f.hb -orient horizontal -command [list $f.tree xview]]
	set vb  [ttk::scrollbar $f.vb -orient vertical -command [list $f.tree yview]]
	set tree [ttk::treeview $f.tree -columns "$gv(ficTree,cols)" -displaycolumns "$dcols"\
 -height $haut -xscrollcommand [list $hb set] -yscrollcommand [list $vb set]]

	$tree column #0 -width 70
	set i 1
	foreach cl "$dcols" {
		set p [lsearch -exact "$gv(ficTree,cols)" "$cl"]
		if {$p < 0} {
			continue
		}
		set cw [lindex "$gv(ficTree,colw)" $p]
		set en [lindex "$gv(ficTree,ents)" $p]
		set pc [string range "$cw" 0 0]
		incr p
		if {"$pc" == "+"} {
			set cw [string range "$cw" 1 end]
			$tree column #$p -width $cw -stretch true
		} else {
			$tree column #$p -width $cw
		}
		$tree heading #$p -text "$en"
	}

	grid $tree -row 0 -column 0 -sticky nesw
	grid $vb -row 0 -column 1 -sticky nsw
	grid $hb -row 1 -columnspan 2 -sticky esw

	grid $f -sticky nesw
	grid rowconfigure $f $tree -weight 1
	grid columnconfigure $f $tree -weight 1

	return $fen
}

proc addFicTree {ftree par fpath strip} {

global gv
#puts "$fpath"
	set fit [$ftree insert $par end]
	set path [string map [list "$strip/" ""] "$fpath"]
	$ftree set $fit nom [file tail "$path"]
	if {! [file exist "$fpath"]} {
		$ftree set $fit magic "inexistant"
		$ftree set $fit taille 0
		$ftree set $fit statut "inexistant"
		$ftree set $fit atime 0
		$ftree set $fit ctime 0
		$ftree set $fit mtime 0
		$ftree set $fit groupe "n/o"
		$ftree set $fit proprio "n/o"
		$ftree set $fit stype "inconnu"
		$ftree set $fit perm "inconnu"
		$ftree set $fit nbver 1
		$ftree set $fit version $fit
		
	} else {
#    file stat "$fpath" fst
#    foreach c [array names fst *] {
#    	set gvar($pref,fic,$fid,$c) "$fst($c)"
#    }
    set lfp [string length "$fpath"]
    set ls [exec ls -l "$fpath"]
    set perm [string range "$ls" 0 9]
    set mag [exec file "$fpath"]
		set magic [string trim [string range "$mag" [expr $lfp + 1] end]]
	  file stat "$fpath" st
		$ftree set $fit atime $st(atime)
		$ftree set $fit ctime $st(ctime)
		$ftree set $fit mtime $st(mtime)
		$ftree set $fit groupe $st(gid)
		$ftree set $fit proprio $st(uid)
		$ftree set $fit stype $st(type)
    $ftree set $fit magic "$magic"
		$ftree set $fit taille $st(size)
    $ftree set $fit statut "Archivé"
		$ftree set $fit perm "$perm"
    unset st
		$ftree set $fit nbver 1
		$ftree set $fit version $fit
	}

	return $fit

}

proc addRepTree {ftree par re strip aid stat} {

global gv

	set gv($stat) "Recherche des répertoires de $re ..."
#puts $re
	set ficl [lsort [glob -nocomplain "$re/.*"]]
	foreach fic [lsort [glob -nocomplain "$re/*"]] {
		lappend ficl "$fic"
	}
	set subrel ""
	set reps [string map [list "$strip" ""] "$re"]
	if {"$reps" != ""} {
		set reps [string range "$reps" 1 end]
		lappend gv($aid,index,nom) "$reps"
	puts "$reps"
#	puts "$ficl"set 
		set rit [$ftree insert $par end]
		lappend gv($aid,index,tind) $rit
		$ftree set $rit nom "$reps"
   	set lfp [string length "$re"]
    set ls [exec ls -ld "$re"]
    set perm [string range "$ls" 0 9]
    set mag [exec file "$re"]
		set magic [string trim [string range "$mag" [expr $lfp + 1] end]]
	  file stat "$re" st
		$ftree set $rit atime $st(atime)
		$ftree set $rit ctime $st(ctime)
		$ftree set $rit mtime $st(mtime)
		$ftree set $rit groupe $st(gid)
		$ftree set $rit proprio $st(uid)
		$ftree set $rit stype $st(type)
		$ftree set $rit perm "$perm"
    unset st
		$ftree set $rit magic "Répertoire"
		$ftree set $rit taille 0
		$ftree set $rit statut "Scanning ..."
		$ftree set $rit nbver 1
		$ftree set $rit version $rit
		$ftree item $rit -open true
		$ftree selection set $rit
	} else {
		set rit ""
	}
	foreach fic "$ficl" {
		if {"$fic" == "$re/.." || "$fic" == "$re/."} {
			continue
		}
		if {[file type "$fic"] == "directory"} {
			lappend subrel "$fic"
			continue
		}
		set fit [addFicTree $ftree $rit "$fic" "$strip"]
		$ftree selection set $fit
		set ftaille [$ftree set $fit taille]
		if {"$reps" != ""} {
			set rtaille [$ftree set $rit taille]
			incr rtaille $ftaille
			$ftree set $rit taille $rtaille
		}
		incr gv($aid,nbfic)
		set stype [$ftree set $fit stype]
		if { "$stype" == "file"} {
			incr gv($aid,fic,taille) $ftaille
			incr gv($aid,taille) $ftaille
		} else {
			if {"$stype" == "link"} {
				set src [file readlink "$fic"]
				incr gv($aid,fic,taille) [file size "$src"]
			}
		}

		lappend gv($aid,index,fic) [$ftree set $fit nom]
		lappend gv($aid,index,fictind) $fit
#		update idletasks
	}
#puts "$subrel"
#gets stdin reponse
	foreach subrep "$subrel" {
		if {"$subrep" == "" || "$subrep" == "$re/." || "$subrep" == "$re/.."} {
			continue
		}
		addRepTree $ftree $rit "$subrep" "$strip" "$aid" "$stat"
		
	}
	$ftree item $rit -open false
	$ftree set $rit statut "Archivé"
	return
}



proc sauveficTree {ftree par fd} {

global gv

	set avchild ""
	foreach it [$ftree children $par] {
		puts -nonewline $fd "$par,$it|"
		foreach col "$gv(ficTree,cols)" {
			set val [$ftree set $it $col]
			puts -nonewline $fd "$val|"
		}
		puts $fd ""
		if {[$ftree children $it] != ""} {
			lappend avchild "$it"
		}
	}
	foreach it "$avchild" {
		if {"$it" != ""} {
			sauveficTree $ftree $it $fd
		}
	}
	flush $fd
	return
}

proc chargficTree {ftree fpath aid} {

global gv

	set fd [open "$fpath" r]
	gets $fd li
	while {! [eof "$fd"]} {
		set p [string first "|" "$li"]
		set lli [string length "$li"]
		if {$p < 0} {
			return "<<Erreur>>: Format non conforme"
		}
		set ind [string trim [string range "$li" 0 $p-1]]
		set vp [string first "," "$ind"]
		set par ""
		if {$vp >= 0} {
			set par [string range "$ind" 0 $vp-1]
			if {! [$ftree exists $par]} {
				return "<<Erreur>>: Parent $it inexistant"
			}
		}
		incr vp
		set it [string range "$ind" $vp end]
		$ftree insert $par end -id $it
		incr p
		set colno 0
		set pf [string first "|" "$li" $p]
		foreach col "$gv(ficTree,cols)" {
#puts "$col"
			$ftree set $it $col [string range "$li" $p $pf-1]
			set p [expr $pf + 1]
			incr colno
			set pf [string first "|" "$li" $p]
		}

		set nom [$ftree set $it nom]
		set type [$ftree set $it stype]
		if {"$type" == "directory"} {
			lappend gv($aid,index,nom) "$nom"
			lappend gv($aid,index,tind) $it
		} else {
			set ftaille [$ftree set $it taille]
			lappend gv($aid,index,fic) "nom"
			lappend gv($aid,index,fictind) $it
			incr gv($aid,nbfic)
			if { "$type" == "file"} {
				incr gv($aid,fic,taille) $ftaille
				incr gv($aid,taille) $ftaille
			} else {
#				if {"$type" == "link"} {
#					incr gv($aid,taille) [file size [file readlink "$fic"]]
#				}
				set dummy d
			}
			
		}
		gets $fd li
#update idletasks
		
	}
	close $fd
}

proc compficTree {tree1 par1 aid1 tree2 par2 aid2} {

global gv

#	$tree1 tag configure egal -background lightgreen
#	$tree1 tag configure diff -background lightyellow
#	$tree1 tag configure absent -background lightred

	$tree2 tag configure egal -background lightgreen
	$tree2 tag configure diff -background lightyellow
	$tree2 tag configure absent -background lightred

	set egal ""
	foreach va "$gv(avl1)" it "$gv(avitl1)" {
		set p [lsearch -exact "$gv(avl2)"	"$va"]
		if {$p < 0} {
			$tree1 tag add absent $it
		} else {
			$tree1 tag add egal $it
			set it2 [lindex "$gv(avitl2" $p]
			$tree2 tag add egal $it2
			set gv(avl2) [lreplace "$gv(avl2)" $p $p]
			set gv(avitl2) [lreplace "$gv(avitl2)" $p $p]
		}

	}

	

}

proc listrepTree {tree par vl vitl vchild} {

global gv
	
	foreach it [$tree children $par] {
		set v ""
		foreach col "$gv(ficTree,cols)" {
			set val [$tree set $it $col]
			set v "$v|$val"
		}
		lappend gv($vl) "$v"
		lappend gv($vitl) "$par,$it"
		if {[$tree children $it] != ""} {
			lappend gv($vchild) "$it"
		}
	}
	foreach it "$gv($vchild)" {
		if {"$it" != ""} {
			listrepTree $tree $it $vl $vitl $vchild
		}
	}
	return
}





