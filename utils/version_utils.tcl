##############################################
#
# Archives en version
#
##############################################

set gv(verTree,cols) "rep vrep acts"
set gv(verTree,colw) "+300 +100 +100"
set gv(verTree,ents) {"Répertoire de la version" "Répertoire source" "Actions"}

proc verArch {aid fen top} {

global gv

	set bfr .ver$aid
	if {$top} {
		if {[winfo exists $bfr]} {
			return
		}
		toplevel $bfr
		wm title $bfr " Sources des versions "
	} else {
		set bfr $fen
		if {[winfo exists $bfr]} {
			return
		}
		set bfr [ttk::labelframe $fen -text " Sources des versions "]
	}
	set hb  [ttk::scrollbar $bfr.hb -orient horizontal -command [list $bfr.tree xview]]
	set vb  [ttk::scrollbar $bfr.vb -orient vertical -command [list $bfr.tree yview]]
	set tree [ttk::treeview $bfr.tree -columns "$gv(verTree,cols)" -displaycolumns "rep"\
 -height 30 -xscrollcommand [list $hb set] -yscrollcommand [list $vb set]]

	$tree column #0 -width 10
	set i 1
	foreach cl "rep" {
		set p [lsearch -exact "$gv(verTree,cols)" "$cl"]
		if {$p < 0} {
			continue
		}
		set cw [lindex "$gv(verTree,colw)" $p]
		set en [lindex "$gv(verTree,ents)" $p]
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

	if {$top} {
		grid rowconfigure $bfr $tree -weight 1
		grid columnconfigure $bfr $tree -weight 1
	}

	return $fen

}

proc checkVer {aid1 par1 vno par2} {

global gv

	set aid2 $aid1,$vno
	set ft1 $gv($aid1,ficTreewid)
	set lfic1 ""
	set lindficl ""
	set lrep ""
	set lindrep ""
	foreach it1 [$ft1 children $par1] {
		set type [$ft1 set $it1 stype]
		set nom [$ft1 set $it1 nom]
		if {"$type" == "directory"} {
			lappend lrep "$nom"
			lappend lindrep $it1
		} else {
			lappend lfic "$nom"
			lappend lindfic $it1
		}
	}

	set lreptrouv ""
	set lindrep2 ""
	set ft2 $gv($aid2,ficTreewid)
	foreach it2 [$ft2 children $par2] {
		set nom [$ft2 set $it2 nom]
		set type [$ft2 set $it2 stype]
		if {"$type" == "directory"} {
			set trouv [lsearch -exact "$lrep" "$nom"]
			if {$trouv >= 0} {
				set it [lindex "$lindrep" $trouv]
				lappend lreptrouv $it
				lappend lindrep2 $it2
				set nbv [$ft1 set $it nbver]
				incr nbv
				$ft1 set $it nbver $nbv
				set lver [$ft1 set $it version]
				lappend lver $vno,$it2
				$ft1 set $it version "$lver"
			}
		} else {
			set trouv [lsearch -exact "$lfic" "$nom"]
			if {$trouv >= 0} {
				if {"$type" != "link"} {
					set it [lindex "$lindfic" $trouv]
					set nbv [$ft1 set $it nbver]
					incr nbv
					$ft1 set $it nbver $nbv
					set lver [$ft1 set $it version]
					lappend lver $vno,$it2
					$ft1 set $it version "$lver"
				}
			}
		}
	}
puts "<$lreptrouv><$lindrep2>"
	foreach it1 "$lreptrouv" it2 "$lindrep2" {
		checkVer $aid1 $it1 $vno $it2
	}
	return
}




