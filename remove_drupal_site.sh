#!/bin/sh

if [[ $# -lt 1 ]]; then
	echo "Usage $0 site_name"
	exit
fi

BASE_DIR=drupal-7
site_name=$1
site_folder="${site_name}.dev"

if [[ ! -L "${site_name}" ]]; then
	echo "Site ${site_name} does not exist."
	exit
fi

rm -rf $BASE_DIR/public/sites/$site_folder
rm -f $site_name
mysqladmin -u root --password=sh1han drop $site_name

echo "Site with name $site_name has been removed successfully."