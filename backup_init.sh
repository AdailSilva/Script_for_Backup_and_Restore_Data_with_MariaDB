#!/bin/bash
###################################################################
# Nome : backup_init.sh					  	  #
# Script para Backup e Restore dos dados do MariaDB		  #
# Criacao : 29/02/2020 - AdailSilva				  #
###################################################################

echo "MariaDB - Trabalho FSA [LPIC-1 e LPIC-2] - Aluno AdailSilva"
sleep 1

echo "Iniciando Transferência do script 'backup_mariadb[Server1].sh' para SERVER1..."
scp /home/adailsilva/Documents/backup_mariadb\[Server1\].sh backup@18.10.159.184:/home/backup/
sleep 1

echo "Alterando permissão do script 'backup_mariadb[Server1].sh' para execução remota EM SERVER1..."
ssh backup@18.10.159.184 'chmod +x /home/backup/backup_mariadb[Server1].sh'
sleep 1

echo "Iniciando Transferência do script 'backup_mariadb[Server2].sh' para SERVER2..."
scp /home/adailsilva/Documents/backup_mariadb\[Server2\].sh backup@18.10.159.183:/home/backup/
sleep 1

echo "Alterando permissão do script 'backup_mariadb[Server2].sh' para execução remota EM SERVER2..."
ssh backup@18.10.159.183 'chmod +x /home/backup/backup_mariadb[Server2].sh'
