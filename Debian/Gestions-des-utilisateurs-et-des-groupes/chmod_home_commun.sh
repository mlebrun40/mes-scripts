#!/usr/bin/env bash

echo ""
echo "Script de gestion des droits d'accès pour les répertoires personnels et communs"
echo ""

# Tableau contenant les noms des 4 services
declare -a services=("admsysdev" "devweb" "devjava" "conceptbd")

# Tableau associatif reliant chaque service à son groupe utilisateur
# Format : services["clé"] = "nom_du_groupe"
declare -A groupes
groupes["admsysdev"]="adminsysdev"
groupes["devweb"]="developpeurweb"
groupes["devjava"]="developpeurjavamobile"
groupes["conceptbd"]="concepteurdatabase"

# ============================================================================
# QUESTION 1 : Création des répertoires communs pour chaque service
# ============================================================================

echo ""
echo "Création des répertoires communs"

# Boucle : parcourir chaque service du tableau
for service in "${services[@]}"; do
    
    # Définir le chemin du répertoire commun
    # Exemple : /home/commun_devweb
    repertoire_commun="/home/commun_$service"
    
    # Vérifier si le répertoire existe déjà
    if [ ! -d "$repertoire_commun" ]; then
        echo "Création du répertoire commun : $repertoire_commun"
        sudo mkdir -p "$repertoire_commun"
    else
        echo "Le répertoire $repertoire_commun existe déjà"
    fi
done

echo ""
echo "Gestion des droits d'accès"
echo ""

echo "--- Partie 1 : Attribution du groupe propriétaire ---"
for service in "${services[@]}"; do
    repertoire_commun="/home/commun_$service"
    groupe=${groupes[$service]}
    
    echo "Changement du groupe propriétaire de $repertoire_commun en $groupe"
    sudo chgrp "$groupe" "$repertoire_commun"
done

echo ""

echo "--- Partie 2 : Sécurisation des répertoires personnels ---"
echo "Application des droits 700 sur les répertoires personnels"

for home_dir in /home/*; do
    if [ -d "$home_dir" ] && [ "$(basename "$home_dir")" != "commun_admsysdev" ] && [ "$(basename "$home_dir")" != "commun_devweb" ] && [ "$(basename "$home_dir")" != "commun_devjava" ] && [ "$(basename "$home_dir")" != "commun_conceptbd" ]; then
        echo "Sécurisation de $home_dir"
        sudo chmod 700 "$home_dir"
    fi
done

echo ""

# PARTIE 3 : Configurer les droits des répertoires communs avec sticky bit
echo "--- Partie 3 : Configuration des répertoires communs avec sticky bit ---"
echo ""
echo "Permissions appliquées :"
echo "  - Propriétaire (user) : rwx (lecture, écriture, exécution)"
echo "  - Groupe : rwx (lecture, écriture, exécution)"
echo "  - Sticky bit ( voir cours) : Empêche la suppression des fichiers des autres"
echo ""

for service in "${services[@]}"; do
    repertoire_commun="/home/commun_$service"
    groupe=${groupes[$service]}
    
    echo "Configuration de $repertoire_commun (groupe: $groupe)"
    
    # chmod 1770 = sticky bit (1) + rwx propriétaire (7) + rwx groupe (7) + --- autres (0)
    sudo chmod 1770 "$repertoire_commun"
    sudo chmod -R 1770 "$repertoire_commun" 2>/dev/null
done

echo ""
echo " FINI ! Les répertoires communs sont prêts à être utilisés par les membres de chaque service."
echo ""