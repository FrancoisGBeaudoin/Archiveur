#!/bin/bash
#######################################################
#
# Procédure de signature des fichier
#
# Syntaxe: sigFic.sh fid algo fpath rep_donnees
#
# Argument: fid             Identifiant unique pour le fichier
#           algo            Algorytme de calcul de la signature
#           fpath           Fichier
#           rep_donnees     Répertoire où les données
#                           générées seront déposées.
#
#   La procédure intercepte la sortie de la commande et
# la redirige dans des fichers sigFic<fid>.out dans le
# répertoire spécifié par 'rep_donnees'. Les errreurs
# sont rediriger dans le fichier sigFic<fid>.err
#
######################################################

# set -x
# echo "nbarg=$#"
# echo "arg1=$1"
# echo "arg1=$2"
# echo "arg1=$3"
# echo "arg1=$4"
# echo "arg1=$5"
# echo "arg1=$6"

if [[ $# -ne 4 ]]
then
   echo "Argument(s) absent(s)"
   echo "Syntaxe: sigFic.sh fid algo path rep_donnees"
   exit 1
fi
ficid=$1
cmd=$2
fic=$3
rdest=$4
fn=sigFic$ficid


if [[ ! -r "$fic" ]]
then
  echo ">> $fic illisible"
  exit 2
fi

if [[ ! -e "$rdest" ]]
then
  mkdir -p "$rdest"
else
  if [[ ! -d "$rdest" ]]
  then
    echo "$rdest n'est pas un répertoire"
    exit 2
 fi
fi
if [[ ! -e "$rdest/procres" ]]
then
  mkdir -p "$rdest/procres"
fi

if [[ -e $rdest/run/$fn ]]
then
  echo "Il y a déjà un signature en cour pour $fid" >"$rdest/procres/$fn.err"
  exit 100
fi   

touch "$rdest/run/$fn"


$cmd "$fic" >"$rdest/tmp/$fn.out" 2>"$rdest/tmp/$fn.err"
if [[ $? == 0 ]]
then
  rm "$rdest/tmp/$fn.err"
fi
mv $rdest/tmp/$fn.* $rdest/procres/

rm $rdest/run/$fn
