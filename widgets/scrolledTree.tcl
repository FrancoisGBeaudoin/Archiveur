proc scrTree {fen haut cols colw ents} {


	set f [ttk::frame $fen]
	set hb  [ttk::scrollbar $f.hb -orient horizontal -command [list $f.tree xview]]
	set vb  [ttk::scrollbar $f.vb -orient vertical -command [list $f.tree yview]]
	set sh tree
	if {[llength "$ents"] > 0} {
		set sh "tree headings"
	}
	set tree [ttk::treeview $f.tree -columns "$cols" -show "$sh" -height $haut\
 -xscrollcommand [list $hb set] -yscrollcommand [list $vb set]]

	$tree column #0 -width 70
	set i 1
	foreach cw "$colw" {
		set pc [string range "$cw" 0 0]
		if {"$pc" == "+"} {
			set cw [string range "$cw" 1 end]
			$tree column #$i -width $cw -stretch true
			set suf true
		} else {
			$tree column #$i -width $cw
		}
		incr i
	}
	set i 1
	foreach en "$ents" {
			$tree heading #$i -text "$en"
			incr i
	}
	grid $tree -row 0 -column 0 -sticky nesw
	grid $vb -row 0 -column 1 -sticky nsw
	grid $hb -row 1 -columnspan 2 -sticky esw

	grid $f -sticky nesw
	grid rowconfigure $f $tree -weight 1
	grid columnconfigure $f $tree -weight 1

	return $fen

}
