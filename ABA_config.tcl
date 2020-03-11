############################################################
#
#                     A B A
#               Fichier de configuraiton
#
#
############################################################


set gv(serveur) "localhost"
set gv(port_ssh) 22
set gv(rep,data_dir_base) [exec pwd]

set gv(serveur,utilisateur) "$env(USER)"
set gv(serveur) "localhost"
set gv(port_ssh) 333
set gv(rep,ABA_base) "/media/francois/aed891d2-62a3-439d-8278-6968daeafa38/Archiveur/test"

# Archive
set gv(rep,archive) "$gv(rep,ABA_base)/Archive"
set gv(rep,archive,data) "$gv(rep,archive)/data"
set gv(rep,archive,db) "$gv(rep,archive)/db"
set gv(arch,classe) {system public personnel} 

    
# Fichier de config personnel
set gv(ABA) "~./ABA"

cd "$gv(rep,ABA_base)"

set gv(system,nom) [exec uname -n]

# Algorythme de la signature
set gv(sig_cmd) md5sum

foreach ut {archive repertoirevsr fichierv2 sauGvar lien} {
	source "$gv(rep,ABA_base)/utils/$ut.tcl"
}

