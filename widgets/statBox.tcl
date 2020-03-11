proc statBox {fen gind} {

global gvar

    set stbox [ttk::frame $fen -borderwidth 2 -relief ridge]
    ttk::label $stbox.ent -text " Statut " -relief raised
    ttk::label $stbox.ico -text " " -relief sunken
    ttk::label $stbox.mes -textvariable gvar($gind) -relief sunken
    pack $stbox.ent -side left
    pack $stbox.mes -side right -fill x -expand true
    pack $stbox.ico -side right
    
    return $stbox
}
