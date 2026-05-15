#!/usr/bin/env bash

echo ""
echo "Script de liste des utilisateurs d'un groupe"
echo ""

listungrp(){
GROUPE1=$1
MEMBRES=$(grep "^${GROUPE1}:" /etc/group | cut -d: -f4)

if [ -z "$MEMBRES" ]; 
then
    echo "Le groupe $GROUPE1 est vide ou n'existe pas."
else
    echo "Les membres de $GROUPE1 sont : $MEMBRES"
fi

}

echo ""
echo "Quel groupe souhaitez-vous interroger ?"
echo ""
read groupe
listungrp $groupe