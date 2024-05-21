#!/bin/sh
NOMSAV="sdcard"
CHEMINSAV="/mnt/nfs/Documents/sav/pipoberrypi"
SDCARD="/dev/mmcblk0"
#SDCARD="/home/pipo/bin"
DATE=$(date "+%y%m%d")
LOG=savpipoberrypi.txt
DOSSIERLOGS="/mnt/nfs/Documents/scripts/logs/"
NBSAV=7
echo "[`date`] sauvegarde de la carte SD" | tee -a "$DOSSIERLOGS"$DATE"$LOG" 
sudo dd if="${SDCARD}" bs=4M of="${CHEMINSAV}/${NOMSAV}_temp.img" conv=fsync status=progress >> "$DOSSIERLOGS"$DATE"$LOG" 2>&1
echo "[`date`] sauvegarde realisee" | tee -a "$DOSSIERLOGS"$DATE"$LOG"
echo "[`date`] Demarrage de la compression avec pishrink"| tee -a "$DOSSIERLOGS"$DATE"$LOG"
sudo ./pishrink.sh -z "${CHEMINSAV}/${NOMSAV}_temp.img"
tar -czf "${CHEMINSAV}/${NOMSAV}_temp.tar.gz" "${CHEMINSAV}/${NOMSAV}_temp.img" | tee -a "$DOSSIERLOGS"$DATE"$LOG" 
echo "[`date`] controle de l'archive" | tee -a "$DOSSIERLOGS"$DATE"$LOG" 
if gzip -t "${CHEMINSAV}/${NOMSAV}_temp.tar.gz"; then 
echo "[`date`] Archive ok"| tee -a "$DOSSIERLOGS"$DATE"$LOG" 

#for (( c=NBSAV; c>=1; c-- ))
#do
#D=(( c - 1 ))
#if [ -f "${CHEMINSAV}/${NOMSAV}${D}.tar.gz" ]; then
#  mv "${CHEMINSAV}/${NOMSAV}6.gz" "${CHEMINSAV}/${NOMSAV}${c}.tar.gz"
#fi
#done

if [ -f "${CHEMINSAV}/${NOMSAV}6.gz" ]; then
  mv "${CHEMINSAV}/${NOMSAV}6.gz" "${CHEMINSAV}/${NOMSAV}7.gz"
fi
if [ -f "${CHEMINSAV}/${NOMSAV}5.gz" ]; then
  mv "${CHEMINSAV}/${NOMSAV}5.gz" "${CHEMINSAV}/${NOMSAV}6.gz"
fi
if [ -f "${CHEMINSAV}/${NOMSAV}4.gz" ]; then
  mv "${CHEMINSAV}/${NOMSAV}4.gz" "${CHEMINSAV}/${NOMSAV}5.gz"
fi
if [ -f "${CHEMINSAV}/${NOMSAV}3.gz" ]; then
  mv "${CHEMINSAV}/${NOMSAV}3.gz" "${CHEMINSAV}/${NOMSAV}4.gz"
fi
if [ -f "${CHEMINSAV}/${NOMSAV}2.gz" ]; then
  mv "${CHEMINSAV}/${NOMSAV}2.gz" "${CHEMINSAV}/${NOMSAV}3.gz"
fi
if [ -f "${CHEMINSAV}/${NOMSAV}1.gz" ]; then
  mv "${CHEMINSAV}/${NOMSAV}1.gz" "${CHEMINSAV}/${NOMSAV}2.gz"
fi
if [ -f "${CHEMINSAV}/${NOMSAV}0.gz" ]; then
  mv "${CHEMINSAV}/${NOMSAV}0.gz" "${CHEMINSAV}/${NOMSAV}1.tar.gz"
fi

 mv "${CHEMINSAV}/${NOMSAV}_temp.tar.gz" "${CHEMINSAV}/${NOMSAV}0.tar.gz"


echo "[`date`] Voila c'est fini"| tee -a "$DOSSIERLOGS"$DATE"$LOG" 
else 
echo "[`date`] archive corrompue, operation avortee" | tee -a "$DOSSIERLOGS"$DATE"$LOG"
fi
