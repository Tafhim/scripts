#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage $0 site_name [version]"
	exit 1
fi

if [ -z "$2" ]; then
	DRUPAL_PROFILE="standard"
else
	DRUPAL_PROFILE=$2
fi

if [ -z "$3" ]; then
	DRUPAL_BASE="latest"
else
	DRUPAL_BASE="drupal-$3"
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
MYSQL_PASSWORD="sph123"
MYSQL_DB_NAME="drupal_${SITE_NAME}"
MYSQL_QUERY="CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

GRANT USAGE ON *.* TO '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT USAGE ON *.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT USAGE ON *.* TO '$MYSQL_USER'@'`hostname`' IDENTIFIED BY '$MYSQL_PASSWORD';

CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME;

GRANT ALL PRIVILEGES ON $MYSQL_DB_NAME.* TO '$MYSQL_USER'@'%';"

mysql -u root --password=$MYSQL_PASSWORD -e "$MYSQL_QUERY" 

mysqladmin -u root --password=$MYSQL_PASSWORD flush-privileges
mysqladmin -u root --password=$MYSQL_PASSWORD reload

cd $VHOST_NAME

drush site-install --db-url=mysql://$MYSQL_USER:$MYSQL_PASSWORD@localhost/$MYSQL_DB_NAME --site-name="$SITE_NAME" --account-email=$USER@sphinxcorporation.com --account-pass=$MYSQL_PASSWORD --sites-subdir=$VHOST_NAME --db-su=root --db-su-pw=$MYSQL_PASSWORD -y $DRUPAL_PROFILE

echo "Site with name $SITE_NAME has been created & configured successfully."
echo "Admin username is admin, password is $MYSQL_PASSWORD & email is $USER@sphinxcorporation.com"  
echo "You can access the new drupal site using url http://$VHOST_NAME/"
