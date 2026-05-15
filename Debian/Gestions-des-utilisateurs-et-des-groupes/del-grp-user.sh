#!/usr/bin/env bash

echo ""
echo "Script de suppression des utilisateurs, groupes et dossiers home"
echo ""

supprimerungrp(){
GROUPE1=$1
MEMBRES=$(grep "^${GROUPE1}:" /etc/group | cut -d: -f4)

if [ -z "$MEMBRES" ]; 
then
    echo "Le groupe $GROUPE1 est vide ou n'existe pas."
else
    for user in $(echo $MEMBRES | tr ',' ' '); do # Je remplace les virgules par des espaces pour récupérer les utilisateurs de façon exploitable
        if id -nG "$user" | grep -qw "$GROUPE1"; then # Je vérifie que l'utilisateur est bien dans le groupe à supprimer
            if [ $(id -nG "$user" | wc -w) -eq 1 ]; then # Vérifier si l'utilisateur n'est pas dans un autre groupe, s'il n'est que dans le groupe à supprimer alors supprimer aussi son dossier home (wc compte le nombre de groupes de l'utilisateur)
                echo "Suppression de l'utilisateur $user et de son dossier home" # Je dis quel utilisateur est supprimé
                sudo userdel --remove-all-files $user
            else
                echo "L'utilisateur $user n'est pas que dans ce groupe, retrait uniquement du groupe $GROUPE1"
                sudo usermod -G $(id -nG "$user" | tr ' ' '\n' | grep -v "$GROUPE1" | tr '\n' ',') $user # tr sert à remplacer les espaces par des retours à la ligne et inversement 
fi
fi
echo "Suppression du groupe $GROUPE1"
sudo groupdel $GROUPE1
}

echo ""
echo "Quel groupe souhaitez-vous interroger ?"
echo ""
read groupe
supprimerungrp $groupe