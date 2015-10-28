#!/bin/bash

# Script para generar la configuración que proviene del script de php
#
#
#@Author: Carlos Latorre Sánchez
#El parametro $0 corresponde a el nombre del script asi que no se puede gastar

####################COMPROBACION DE PARAMETROS ##################################
if [ $# -ne 5 ]
then
  echo "Número de parámetros incorrectos"
  echo "Sintaxis: $0 usuario contraseña usuariobd contraseñabd subdominio"
	exit 1
fi


########################PARAMETROS GLOBALES#################################
USER=$1
PASS=$2
USERDB=$3
PASSDB=$4
SUBDOMAIN=$5
DOMINIO=$SUBDOMAIN.dev.cowalenciawebs.com
APACHE_VHOST=$SUBDOMAIN.conf
APACHE_RELOAD='service apache2 reload'
APACHE_DIRECTORY=/etc/apache2/sites-available/
HOME_USER=/var/www/$SUBDOMAIN
EMAIL='persona@correotuempresa.com'
WORDPRESS_INSTALL_PATH=/var/www/wordpress/
MYSQL=`which mysql`


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
#Generamos la BD en mysql
#Generamos todas las consultas en variables y luego las agregamos en la variable SQL
Q1="CREATE DATABASE IF NOT EXISTS $DB_NAME;"
Q2="GRANT USAGE ON *.* TO $DB_USER@localhost IDENTIFIED BY '$DB_PASS';"
Q3="GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@localhost;"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
$MYSQL -u $DB_ROOT -p$DB_ROOT_PASS -e "$SQL"

#Generamos el vhost de apache y lo iniciamos
cat <<-EOF > $APACHE_VHOST
<VirtualHost *:80>
        ServerAdmin $EMAIL
        ServerName $DOMINIO
        DocumentRoot $HOME_USER
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory $HOME_USER>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>

        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory "/usr/lib/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Order allow,deny
                Allow from all
        </Directory>
</VirtualHost>
EOF
mv $APACHE_VHOST $APACHE_DIRECTORY
a2ensite $APACHE_VHOST
$APACHE_RELOAD
#Enviamos un correo con los datos y el log y los errores

#Generamos el codigo de salida 0
exit 0
