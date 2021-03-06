######################################################
#
# utilitaires mime
#
######################################################

set gv(mime,cols) "icone descript typeprim typesec subtypeprim subtypesec alias"
set gv(mime,ents) {Icone Desciption "Type base" "Type" "Sous Type base" "Sous Type" Alias}
set gv(mime,colw) "20 +200 +100 +200 +100 +200 +100" 

proc chargMime {} {

global gv

	set repmime "/usr/share/mime"
	foreach re [glob -nocomplain -type d "$repmime/*"] {
		foreach fic [glob -nocomplain "$re/*"] {
			set typec ""
			set descr ""
			set subtypel ""
			set icone ""
			set aliasl ""
			set extl ""
			set fd [open "$fic" r]
			gets $fd li
			set li [string trim "$li"]
			while {! [eof $fd]} {

				if {[string first "<mime-type " "$li"] >= 0} {
					set l [string map {"<" "" ">" "" "\"" ""} "$li"]
					set typec [lindex [string map {"=" " "} [lindex "$l" 2]] 1]
				} elseif {[string first "<comment>" "$li"] >= 0} {
					set descr [string map {"<comment>" "" "</comment>" "" "\"" ""} "$li"]
				} elseif {[string first "<comment xml:lang=\"fr\">" "$li"] >= 0} {
					set descr [string map {"<comment xml:lang=\"fr\">" "" "</comment>" "" "\"" ""} "$li"]
				} elseif {[string first "<alias "  "$li"] >= 0} {
					set l [string map {"<" "" "/>" "" "\"" ""} "$li"]
					set alias [string map {"=" " "} [lindex "$l" 1]]
					lappend aliasl "$alias"
				} elseif {[string first "<sub-class-of " "$li"] >= 0} {
					set l [string map {"<" "" "/>" "" "\"" ""} "$li"]
					set typec [lindex [string map {"=" " "} [lindex "$l" 1]] 1]
					lappend subtypel "$typec"
				} elseif {[string first "<glob " "$li"] >= 0} {
					set l [string map {"<" "" "/>" "" "\"" ""} "$li"]
					set typel [lindex [string map {"=" " "} [lindex "$l" 1]] 1]
					set ext [string map {"*" ""} "$typel"]
					lappend extl "$ext"
				} elseif {[string first "<generic-icon " "$li"] >= 0} {
					set l [string map {"<" "" "/>" "" "\"" ""} "$li"]
					set typel [string map {"=" " "} [lindex "$l" 1]]
					set icone [lindex "$typel" 1]
				} else {
					set no no
				}
				gets $fd li
				set li [string trim "$li"]
			}
			lappend gv(mime,type) "$typec"
			lappend gv(mime,descr) "$descr"
			lappend gv(mime,subtype) ""
			lappend gv(mime,icone) "$icone"
			lappend gv(mime,ext) "$extl"
			lappend gv(mime,alias) "$aliasl"
			foreach gv(mime,subof) "$subtypel"
		}
		close $fd
	}
	foreach type "$gv(mime,type)" sub "$gv(mime,subof)"{
		if {"$subof" != ""} {
			foreach subof "$sub" {
				set p [lsearch -exact "$gv(mime,type)" "$subof"]
				if {$p >= 0} {
					lappend gv(mime,subtype) "$type"
				}
			}
		}
	}
	unset gv(mime,subof)

	return
}


