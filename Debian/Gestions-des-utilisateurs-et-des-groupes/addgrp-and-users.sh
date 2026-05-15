#!/usr/bin/env bash


echo ""
sudo groupdel developpeurweb
sudo groupdel concepteurdatabase
sudo groupdel adminsysdev
sudo groupdel developpeurjavamobile


# Création des groupes

# Groupe DeveloppeurWeb
sudo groupadd developpeurweb
# Groupe ConcepteurDB
sudo groupadd concepteurdatabase
# Groupe AdministrateurSystemesdeDeveloppement
sudo groupadd adminsysdev
# Groupe DeveloppeurJavaMobile
sudo groupadd developpeurjavamobile

# Création d'utilisateur
Exit=False
while [ $Exit == False ]
do
    echo ""
    echo "[AJOUT D'UTILISATEUR]"
    echo ""
    echo "Si vous souhaitez créer un utilisateur entrer le nom d'utilisateur au format 'nom.prenom' sinon entrer 'exit'"
    read nomutilisateur
    pass=$(openssl passwd -6 "motdepasse")
    if [ "$nomutilisateur" != "exit" ]
    then
        sudo useradd -m $nomutilisateur -p "$pass"
        echo "Si vous souhaitez l'ajouter à un groupe taper le numéro associé : developpeurweb(0) concepteurdatabase(1) adminsysdev(2) developpeurjavamobile(3) Aucun groupe(rien)"
        read groupe
        if [ "$groupe" -eq 0 ]
        then
            sudo usermod -aG developpeurweb $nomutilisateur
        elif [ "$groupe" -eq 1 ]
        then
            sudo usermod -aG concepteurdatabase $nomutilisateur
        elif [ "$groupe" -eq 2 ]
        then
            sudo usermod -aG adminsysdev $nomutilisateur
        elif [ "$groupe" -eq 3 ]
        then
            sudo usermod -aG developpeurjavamobile $nomutilisateur
        fi
    fi
    if [ "$nomutilisateur" == "exit" ]
    then
        Exit=True
    fi
done

