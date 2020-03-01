#!/bin/bash
###################################################################
# Nome : backup_mariadb[Server2].sh				  #
# Script para Backup e Restore dos dados do MariaDB		  #
# Criacao : 29/02/2020 - AdailSilva				  #
###################################################################

echo "MariaDB - Trabalho FSA [LPIC-1 e LPIC-2] - Aluno AdailSilva"

echo "Iniciando configuração do Servidor:"

# Setando hostname [Server2]:
echo "Setando Hostname..."
sudo hostnamectl set-hostname server2.example.net
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
# 1 - Logando no banco;
# 2 - Criar usuário backup e definir sua senha;
# 3 - Dar os privilégios para poder efetuar as rotinas de backup;
# 4 - Recarregar privilégios;
# 5 - Criar banco de dados "legacy";
# 6 - Listar todos os bancos de dados;
# 7 - Sair do MariaDB;
# 8 - Restaurar Bando de dados vindo de Server1;
# 9 - Selecionar todos os dados contidos.
mysql -u root -e "
CREATE USER IF NOT EXISTS backup@localhost IDENTIFIED BY 'Hacker101';
GRANT SELECT, CREATE, ALTER, DROP, INSERT, RELOAD, SHOW DATABASES, LOCK TABLES ON *.* TO 'backup'@'localhost';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS legacy;
USE legacy;
SHOW DATABASES;
\q;"

# Iniciar rotina de Restore:
echo "Iniciando rotina de restore do banco de dados vindo de Server1..."
mysql -u backup -p"Hacker101" legacy < ~/*.sql

# Restore Concluído:
echo "Restaração do Banco de dados do Server1 carregado e finalizado em Server2 com sucesso!"
