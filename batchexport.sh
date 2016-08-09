#!/bin/bash

if [ $# -eq 0 ]
then
	echo "Usage:"
	echo "batchexport.sh <config-dir> <dump-base> [db-name]"
	echo
	echo "Arguments:"
	echo "<config-dir> the absolute path to the place where config files are held"
	echo "<dump-base>  the absolute path to the place where dumps should be stored"
    echo "[--database=db-name]    (optional) only process collections in the given database"
    echo "[--collection=coll-name]    (optional) only process the named collection"
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
shift
DUMP_BASE=$1
shift
for i in "$@"
do 
case $i in 
	--database=*)
	DB_NAME="${i#*=}"
	shift
	;;
	--collection=*)
	COLL_NAME="${i#*=}"
	shift
	;;
esac
done
	

DATE=`date "+%Y/%m/%d"`

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"

listfiles ${CONFIG_DIR} ${DB_NAME}

echo "Processing: ${CONFIG_FILES}"

for f in ${CONFIG_FILES} 
do

  readsinglefile $f
	
	DUMP_DIR="${DUMP_BASE}/${DB_NAME}/${DATE}"
	mkdir -p $DUMP_DIR 
	
	echo
	echo "Performing Mongo Export to directory ${DUMP_DIR}"

	for collection in "${COLLECTIONS[@]}"
	do
		if [ -z ${COLL_NAME+x} ] || [ ${COLL_NAME} == ${collection} ] ; then 
			FILE_NAME="${collection}.json"

			FILE_LOC="${DUMP_DIR}/${FILE_NAME}"

			echo "Starting Mongo Export to $FILE_LOC"
				
			# Call mongoexport, feeding any remaining args in unchanged:
			mongoexport -h ${HOST} -d ${DB_NAME} -c ${collection} -u ${USERNAME} -p ${PASSWORD} -o ${FILE_LOC} $@
		fi
	done
	echo
	echo "Completed Mongo Export to directory ${DUMP_DIR}"
done
