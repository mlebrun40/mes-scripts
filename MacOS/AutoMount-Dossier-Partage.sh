#!/bin/zsh

NAS_IP="192.168.1.100"
SHARE_NAME="nomdupartage"
SMB_USER="nomdutilisateur"
SMB_PASS="motdepasse"

if ping -c 1 -W 2 "$NAS_IP" &> /dev/null; then
    osascript -e "try" -e "mount volume \"smb://${SMB_USER}:${SMB_PASS}@${NAS_IP}/${SHARE_NAME}\"" -e "end try"
    osascript -e 'display notification "Connecté au serveur de fichiers." with title "Connexion NAS"'
else
    osascript -e 'display notification "Serveur injoignable." with title "Erreur Réseau"'
fi
