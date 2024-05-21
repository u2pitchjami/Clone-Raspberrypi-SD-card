#!/bin/sh
NOMSAV="sdcard"
CHEMINSAV="/mnt/nfs/Documents/sav/pipoberrypi"
SDCARD="/dev/mmcblk0"
#SDCARD="/home/pipo/bin"
DATE=$(date "+%y%m%d")
LOG=savpipoberrypi.txt
DOSSIERLOGS="/mnt/nfs/Documents/scripts/logs/"

echo "[`date`] sauvegarde de la carte SD" | tee -a "$DOSSIERLOGS"$DATE"$LOG" 
sudo dd if="${SDCARD}" status=progress | gzip -1 - | dd of="${CHEMINSAV}/${NOMSAV}_temp.gz" bs=1MB status=progress >> "$DOSSIERLOGS"$DATE"$LOG" 2>&1
echo "[`date`] sauvegarde realisee" | tee -a "$DOSSIERLOGS"$DATE"$LOG"

echo "[`date`] controle de l'archive" | tee -a "$DOSSIERLOGS"$DATE"$LOG" 
if gzip -t "${CHEMINSAV}/${NOMSAV}_temp.gz"; then 
echo "[`date`] Archive ok"| tee -a "$DOSSIERLOGS"$DATE"$LOG" 

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
  mv "${CHEMINSAV}/${NOMSAV}0.gz" "${CHEMINSAV}/${NOMSAV}1.gz"
fi

 mv "${CHEMINSAV}/${NOMSAV}_temp.gz" "${CHEMINSAV}/${NOMSAV}0.gz"

echo "[`date`] Demarrage de la compression avec pishrink"| tee -a "$DOSSIERLOGS"$DATE"$LOG"
sudo ./pishrink.sh -z "${CHEMINSAV}/${NOMSAV}0.gz"

echo "[`date`] Voila c'est fini"| tee -a "$DOSSIERLOGS"$DATE"$LOG" 
else 
echo "[`date`] archive corrompue, operation avortee" | tee -a "$DOSSIERLOGS"$DATE"$LOG"
fi
