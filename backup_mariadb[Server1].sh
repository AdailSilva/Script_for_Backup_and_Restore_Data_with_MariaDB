#!/bin/bash
###################################################################
# Nome : backup_mariadb[Server1].sh				  #
# Script para Backup e Restore dos dados do MariaDB		  #
# Criacao : 29/02/2020 - AdailSilva				  #
###################################################################

echo "MariaDB - Trabalho FSA [LPIC-1 e LPIC-2] - Aluno AdailSilva"

echo "Iniciando configuração do Servidor:"

# Setando hostname [Server1]:
echo "Setando Hostname..."
sudo hostnamectl set-hostname server1.example.net
sleep 1

echo "Instalando os grupos de banco de dados do MariaDB..."
sleep 1

echo "Verificando hostname..."
# Para ver a configuração atual de host:
hostnamectl

sleep 1
echo "Instalando o banco de dados MariaDB..."
# Instalar MariaDB:
sudo yum install mariadb-server -y

sleep 1
echo "Iniciando o serviço MariaDB..."
# Iniciar o mariadb.service:
sudo systemctl start mariadb.service

sleep 1
echo "Servico MariaDB está ativo?"
# Verificar se o serviço mariadb.service está ativo:
sudo systemctl is-active mariadb.service

sleep 1
echo "Habilitando o servico MariaDB..."
# Ativar o mariadb.service no momento da inicialização do servidor:
sudo systemctl enable mariadb.service

sleep 1
echo "Servico MariaDB está habilitado?"
# Verificar se o serviço mariadb.service está habilitado:
sudo systemctl is-enabled mariadb.service

sleep 1
echo "Iniciando o firewall..."
# Iniciar Firewall:
sudo systemctl start firewalld.service

sleep 1
echo "Servico firewalld está ativo?"
# Verificar se o serviço firewalld.service está ativo:
sudo systemctl is-active firewalld.service

sleep 1
echo "Habilitando o firewall..."
# Defina para iniciar após a reinicialização:
sudo systemctl enable firewalld.service

sleep 1
echo "Servico firewall está habilitado?"
# Verificar se o serviço firewalld.service está habilitado:
sudo systemctl is-enabled firewalld.service

sleep 1
echo "Habilitando no firewall o serviço MariaDB de forma permanente..."
sudo firewall-cmd --zone=public --add-service=mysql --permanent

sleep 1
echo "Criando o banco de dados legacy..."
# Logando no banco:
# 1 - Logando no banco:
# 2 - Criar usuário backup e definir sua senha:
# 3 - Dar os privilégios para poder efetuar as rotinas de backup:
# 4 - Recarregar privilégios:
# 5 - Criar banco de dados "legacy":
# 6 - Selecionar o Banco "legacy":
# 7 - Criar tabela "manufacturer":
# 8 - Listar todos os bancos de dados:
# 9 - Sair do MariaDB:
# 10 - Inserir valores para teste:
# 11 - Descrever tabela "manufacturer"
# 12 - Selecionar todos os dados contidos.
mysql -u root -e "
CREATE USER IF NOT EXISTS backup@localhost IDENTIFIED BY 'Hacker101';
GRANT SELECT, CREATE, ALTER, DROP, INSERT, RELOAD, SHOW DATABASES, LOCK TABLES ON *.* TO 'backup'@'localhost';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS legacy;
USE legacy;
CREATE TABLE IF NOT EXISTS legacy.manufacturer (
  id BIGINT(50) NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  address VARCHAR(150),
  email VARCHAR(30),
  PRIMARY KEY (id))
ENGINE = InnoDB;
SHOW DATABASES;
INSERT INTO legacy.manufacturer (name,address,email) values ('Faculdade Santo Agostinho','Av. Prof. Valter Alencar, 665 - São Pedro, Teresina - PI, 64019-625','pos-graduacao@fsa.com.br');
DESCRIBE legacy.manufacturer;
SELECT * FROM legacy.manufacturer;
\q;"

# Iniciar rotina de Back-UP:
echo "Iniciando rotina de backup do banco de dados..."

# Criar pasta para armazenar Back-UPs localmente:
mkdir ~/backups/

mysqldump -u backup -p"Hacker101" legacy --single-transaction --quick --lock-tables=false > ~/backups/legacy-backup-$(date +%F).sql

# Copiar Back-UP para outra Instância (server2.example.net):
echo "Transferindo backup..."
#scp ~/backups/* backup@server2.example.net:/home/backup/
scp -r ~/backups/* backup@18.10.159.183:/home/backup/

echo "Transferido backup com sucesso!"
