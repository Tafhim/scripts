#!/bin/sh

SITE_NAME="testsite"
MYSQL_USER=$SITE_NAME
MYSQL_DB_NAME="drupal_${SITE_NAME}"
MYSQL_QUERY="CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY 'sph123';

GRANT USAGE ON *.* TO '$MYSQL_USER'@'localhost' IDENTIFIED BY 'sph123';
GRANT USAGE ON *.* TO '$MYSQL_USER'@'%' IDENTIFIED BY 'sph123';

CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME;

GRANT ALL PRIVILEGES ON $MYSQL_DB_NAME.* TO '$MYSQL_USER'@'%';"

mysql -u root --password=sph123 -e "$MYSQL_QUERY" 

mysqladmin -u root --password=sph123 flush-privileges
mysqladmin -u root --password=sph123 reload
