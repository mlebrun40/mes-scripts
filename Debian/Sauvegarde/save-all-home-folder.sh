#Si le répertoire de sauvegarde n'existe pas, le créer
if [ ! -d "/srv/sauvegarde" ]; then
    sudo mkdir -p "/srv/sauvegarde"
fi

#Si pas dans la crontab le script n'est pas déjà présent, l'ajouter pour une exécution tous les jours à 2h du matin
if ! sudo crontab -l | grep -q "backup-home"; then
    (sudo crontab -l 2>/dev/null; echo "0 2 * * * /srv/sauvegarde/script.sh # backup-home") | sudo crontab -
fi

#Sauvegarder les dossiers home de tous les utilisateurs dans le répertoire de sauvegarde sous format backup-DD-MM-YYYY.zip
DATE=$(date +%d-%m-%Y)
sudo zip -r "/srv/sauvegarde/backup-$DATE.zip" /home/*

