#!/bin/sh

if [ -z "$1" ]
  then
    echo "Usage: $0 pattern"
	exit 1
fi

echo "Are you sure you want to find all files matched with pattern $1 from `pwd` directory?? Please type y or n. default [n]"
read answer

if [ "$answer" = "y" ] 
then
#	find `pwd` -type f -name "$1" -exec rm -i {} \;
	echo "Files removed." 
else
	echo "Operation aborted"
fi
