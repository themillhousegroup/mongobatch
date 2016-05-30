#!/bin/bash

if [ $# -ne 3 ]
then
	echo "Usage:"
	echo "seed-database.sh <config-dir> <load-base> <db-name>"
	echo
	echo "Arguments:"
	echo "<config-dir> the path to the place where config files are held"
	echo "<load-base>  the path to the JSON data to be imported"
	echo "<db-name>    the NAME of the database to import into"
	echo
	echo "Example:"
	echo "./seed-database.sh ~/configs /tmp my-nice-database"
	exit
fi

which mongoimport
if [ $? -eq 1 ]
then
	echo "Preconditions:"
	echo "Expects to be able to find the mongoimport executable in the PATH"
	exit
fi

CONFIG_DIR=$1
LOAD_BASE=$2
DB_NAME=$3

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"

listfiles ${CONFIG_DIR} ${DB_NAME}

echo "Processing: ${CONFIG_FILES}"

for f in ${CONFIG_FILES} 
do

  readsinglefile $f
	
	echo
	echo "Performing Mongo Database Seed from directory ${LOAD_BASE}"

	for collection in "${COLLECTIONS[@]}"
	do
		FILE_NAME="${collection}.json"

		FILE_LOC="${LOAD_BASE}/${FILE_NAME}"

		echo "Starting Mongo Import of collection $collection from seed file $FILE_LOC"

		mongoimport -h ${HOST} -d ${DB_NAME} -c ${collection} -u ${USERNAME} -p ${PASSWORD} --drop ${FILE_LOC}
	done
	echo
	echo "Completed Mongo Database Seed from directory ${LOAD_BASE}"
done
