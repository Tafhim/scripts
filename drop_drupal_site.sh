#!/bin/sh

if [ -z "$1" ]; then
	echo "Usage $0 site_name"
	exit 1
fi

USER=`id -un`
VHOST_DIR="/home/${USER}/workspace/php/projects"

SITE_NAME=$1
SITE_DIR="$VHOST_DIR/${SITE_NAME}"
VHOST_NAME="${SITE_NAME}.dev"

if [ ! -L "$SITE_DIR" ]; then
	echo "Site $SITE_NAME does not exist."
	exit 2
fi

echo "Are you sure you want to drop site $SITE_NAME?? Please type y or n. default [n]"
read answer

if [ "$answer" != "y" ]; then
	echo "Operation aborted"
	exit 1
fi

chmod a+w "$SITE_DIR/sites/$VHOST_NAME"
rm -rf "$SITE_DIR/sites/$VHOST_NAME"
rm -f $SITE_DIR

MYSQL_USER=$SITE_NAME
MYSQL_PASSWORD="sph123"
MYSQL_DB_NAME="drupal_${SITE_NAME}"

MYSQL_QUERY="DROP USER $MYSQL_USER@'%'; 
DROP USER $MYSQL_USER@'localhost'; 
DROP USER $MYSQL_USER@'`hostname`';"

mysql -u root --password=$MYSQL_PASSWORD -e "$MYSQL_QUERY"

mysqladmin -u root --password=$MYSQL_PASSWORD flush-privileges
mysqladmin -u root --password=$MYSQL_PASSWORD reload 
mysqladmin -u root --password=$MYSQL_PASSWORD -f drop $MYSQL_DB_NAME

echo "Site with name $site_name has been removed successfully."
