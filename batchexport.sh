#!/bin/bash

if [ $# -eq 0 ]
then
	echo "Usage:"
	echo "batchexport.sh <config-dir> <dump-base>"
	echo
	echo "Arguments:"
	echo "<config-dir> the absolute path to the place where config files are held"
	echo "<dump-base>  the absolute path to the place where dumps should be stored"
	echo
	echo "this path will have db_name/DATE directories put into it"
	echo
	echo "Example:"
	echo "./batchexport.sh ~/configs /tmp"
	exit
fi

which mongoexport
if [ $? -eq 1 ]
then
	echo "Preconditions:"
	echo "Expects to be able to find the mongoexport executable in the PATH"
	exit
fi

CONFIG_DIR=$1
DUMP_BASE=$2

DATE=`date "+%Y/%m/%d"`

for f in ${CONFIG_DIR}/*
do
	# Read into array called lines:
	IFS=$'\n' read -d '' -r -a lines < $f
		
	HOST=${lines[0]}
	# Trim the db name as it's used as part of a filename:
	DB_NAME=`echo ${lines[1]} | xargs`
	
	DUMP_DIR="${DUMP_BASE}/${DB_NAME}/${DATE}"
	mkdir -p $DUMP_DIR 
	
	echo
	echo "Performing Mongo Export to directory ${DUMP_DIR}"

	# lines 4-N are the names of the collections - slice it:
	COLLECTIONS=("${lines[@]:4}") 

	for collection in "${COLLECTIONS[@]}"
	do
		FILE_NAME="${collection}.json"

		FILE_LOC="${DUMP_DIR}/${FILE_NAME}"

		echo "Starting Mongo Export to $FILE_LOC"

		mongoexport -h ${HOST} -d ${DB_NAME} -c ${collection} -u ${lines[2]} -p ${lines[3]} -o ${FILE_LOC}
	done
	echo
	echo "Completed Mongo Export to directory ${DUMP_DIR}"
done
