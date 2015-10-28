#!/bin/bash

# Script para generar la configuración que proviene del script de php
#
#
#@Author: Carlos Latorre Sánchez
#El parametro $0 corresponde a el nombre del script asi que no se puede gastar

USER=$1
PASS=$2
USERDB=$3
PASSDB=$4
SUBDOMAIN=$5

########################PARAMETROS GLOBALES#################################
HOME_USER=/var/www/$SUBDOMAIN
EMAIL='persona@correotuempresa.com'
WORDPRESS_INSTALL_PATH=/var/www/wordpress/


########## VARIABLE CONEXIÓN BD #####################3
DB_ROOT='root'
DB_ROOT_PASS='prueba'
DB_USER=$USERDB
DB_PASS=$PASSDB
DB_NAME=$USERDB


#################### LOG ##########################################

LOG_PATH=/var/www/ftp.log
ERROR_LOG_PATH=/var/Www/error_ftp.log



#Generamos la copia de wordpress limpio

cp -rf $WORDPRESS_INSTALL_PATH $HOME_USER

#Comenzamos creando el usuario en el sistema y creandole su directorio raiz de donde colgara todo
#lo dejamos en stanby porque el home lo podemos generar con la instalacion de wordpress
#mkdir -p $home_user$user
useradd -d $HOME_USER -p $PASS $USER

#Generamos la base de datos con los datos del usuario y su contraseña
echo 'CREATE DATABASE '$DB_NAME';' > database.sql

mysql -u $DB_ROOT -p$DB_ROOT_PASS < database.sql
rm -rf database.sql

#Generamos la BD en mysql

echo 'CREATE USER '$DB_USER'@localhost IDENTIFIED BY '$DB_PASS';' > database.sql
mysql -u $DB_ROOT -p$DB_ROOT_PASS $DB_NAME < database.sql

echo 'GRANT ALL PRIVILEGES '$DB_NAME'.* TO '$DB_USER'@localhost;' > database.sql
mysql -u $DB_ROOT -p$DB_ROOT_PASS $DB_NAME < database.sql

rm -rf database.sql
#Generamos el vhost de apache y lo iniciamos

#Enviamos un correo con los datos y el log y los errores
