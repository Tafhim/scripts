#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage $0 site_name [version]"
	exit 1
fi

if [ -z "$2" ]; then
	DRUPAL_BASE="latest"
else
	DRUPAL_BASE="drupal-$2"
fi

USER=`id -un`
VHOST_DIR="/home/${USER}/workspace/php/projects"
BASE_DIR="/home/${USER}/src/php/drupal/${DRUPAL_BASE}"

SITE_NAME=$1
SITE_DIR="$VHOST_DIR/${SITE_NAME}"
VHOST_NAME="${SITE_NAME}.dev"

if [ -d "${SITE_DIR}" ]; then
	echo "Site ${SITE_NAME} already exists."
	exit 1
fi

cd "$VHOST_DIR"

ln -s $BASE_DIR $SITE_NAME
cd $SITE_DIR/sites

mkdir -p $VHOST_NAME/files $VHOST_NAME/modules/contrib $VHOST_NAME/modules/features $VHOST_NAME/modules/custom $VHOST_NAME/themes $VHOST_NAME/libraries
cp default/default.settings.php $VHOST_NAME/settings.php
chmod a+w $VHOST_NAME/files $VHOST_NAME/settings.php

MYSQL_USER=$SITE_NAME
MYSQL_DB_NAME="drupal_${SITE_NAME}"
MYSQL_QUERY="CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY 'sph123';

GRANT USAGE ON *.* TO '$MYSQL_USER'@'localhost' IDENTIFIED BY 'sph123';
GRANT USAGE ON *.* TO '$MYSQL_USER'@'%' IDENTIFIED BY 'sph123';
GRANT USAGE ON *.* TO '$MYSQL_USER'@'`hostname`' IDENTIFIED BY 'sph123';

CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME;

GRANT ALL PRIVILEGES ON $MYSQL_DB_NAME.* TO '$MYSQL_USER'@'%';"

mysql -u root --password=sph123 -e "$MYSQL_QUERY" 

mysqladmin -u root --password=sph123 flush-privileges
mysqladmin -u root --password=sph123 reload

echo "Site with name $SITE_NAME has been created successfully."
echo "You can access the new drupal site using url http://$VHOST_NAME/"
