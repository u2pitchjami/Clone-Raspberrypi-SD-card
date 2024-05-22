#!/bin/sh
#variables
NOMSAV="sdcard" #nom du fichier de sauvegarde
CHEMINSAV="/mnt/nfs/Documents/sav/pipoberrypi" #chemin où sera sauvegarder l'image
SDCARD="/dev/mmcblk0" #chemin du support à sauvegarder
DATE=$(date "+%y%m%d")
LOG=savpipoberrypi.txt
DOSSIERLOGS="/mnt/user/Documents/scripts/logs/${DATE}${LOG}" #logs
NBSAV=7 #nb de sauvegardes à conserver
echo "[`date`] sauvegarde de la carte SD" | tee -a "$DOSSIERLOGS" 
#ssh -p 2100 -t "$SSHAUTH" "sudo dd if="${SDCARD}" bs=4M" status=progress | dd of="${CHEMINSAV}/${NOMSAV}_temp.img" conv=fsync status=progress >> "$DOSSIERLOGS"$DATE"$LOG" 2>&1
sudo dd if="${SDCARD}" bs=4M status=progress of="${CHEMINSAV}/${NOMSAV}_temp.img" conv=fsync status=progress >> "$DOSSIERLOGS" 2>&1
echo "[`date`] sauvegarde realisee" | tee -a "$DOSSIERLOGS"
echo "[`date`] Demarrage de la compression avec pishrink"| tee -a "$DOSSIERLOGS"
#lancement du script pischrink.sh
sudo ./pishrink.sh -z "${CHEMINSAV}/${NOMSAV}_temp.img"
#compression de l'image
tar -czf "${CHEMINSAV}/${NOMSAV}_temp.tar.gz" "${CHEMINSAV}/${NOMSAV}_temp.img.gz" | tee -a "$DOSSIERLOGS" 
echo "[`date`] controle de l'archive" | tee -a "$DOSSIERLOGS" 
#contrôle de l'image
  if gzip -t "${CHEMINSAV}/${NOMSAV}_temp.tar.gz"; then 
  echo "[`date`] Archive ok"| tee -a "$DOSSIERLOGS" 
#si contrôle ok renommage des anciennes sauvegardes
    for (( c=NBSAV; c>=1; c-- ))
    do
    D=$(( c - 1 ))
      if [ -f "${CHEMINSAV}/${NOMSAV}${D}.tar.gz" ]; then
      mv "${CHEMINSAV}/${NOMSAV}${D}.tar.gz" "${CHEMINSAV}/${NOMSAV}${c}.tar.gz"
      fi
    done
#renommage du fichier temporaire en sauvegarde normale
mv "${CHEMINSAV}/${NOMSAV}_temp.tar.gz" "${CHEMINSAV}/${NOMSAV}0.tar.gz"
echo "[`date`] Voila c'est fini"| tee -a "$DOSSIERLOGS" 
else 
echo "[`date`] archive corrompue, operation avortee" | tee -a "$DOSSIERLOGS"
fi