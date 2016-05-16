# Common code to read the "configuration file" format used by all scripts
# List all the files that need to be iterated over.
# Handles the "just the named one, please" case
function listfiles() {
  local config_dir=$1
  local db_name_only=$2

  CONFIG_FILES=${config_dir}/*
  if [ -n "$db_name_only" ]
  then
    finddbfile $db_name_only
  fi
} 

# Find the file that contains the given DB name
function finddbfile() {
  local target=$1
  for f in ${CONFIG_FILES}
  do
    readsinglefile $f
  
    if [ "$target" == "${DB_NAME}" ]
    then
      echo "found $target in file $f"
      CONFIG_FILES=$f    
      return
    fi
  done
  echo "No match for target DB named $target; will not continue."
  exit
}

function readsinglefile() {

	# Read into array called lines:
	IFS=$'\n' read -d '' -r -a lines < $1
		
	HOST=${lines[0]}
	# Trim the db name as it's used as part of a filename:
	DB_NAME=`echo ${lines[1]} | xargs`

  USERNAME="${lines[2]}"
  PASSWORD="${lines[3]}"

	# lines 4-N are the names of the collections - slice it:
	COLLECTIONS=("${lines[@]:4}") 
}
