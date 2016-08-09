
#mongobatch
A collection of scripts for performing batch operations on one-or-more MongoDB instances.

### Conventions

Call a script with no arguments to get help about how to invoke it.

Scripts will check any preconditions (e.g. existence of some external executable) and exit if they are not satisfied.

All the scripts here use a convention where they expect to be passed the location (absolute or relative) of a directory containing one-or-more configuration files.

Each file represents a database to be operated on using one of the tools.

The filename is *unimportant*. The contents **must** be:

```
        host:port
        database-name
        username
        password
        collection1
        collection2
        ...
        collectionN     
```

By default, each of the files in this directory (referred to internally as the config directory) will be processed by each script.

### The Scripts
___

#### batchexport.sh
Does a Mongo Export (JSON format) of each collection in each database found in the configuration directory.
######Preconditions:
- The `mongoexport` tool must be in the `PATH`
 
###### Arguments
- The path to the config directory (absolute or relative to the script)
- The absolute path of the directory to write the JSON files
- (Optionally) `--database=database-name` - the name of a single database to operate on 
- (Optionally) `--collection=coll-name` - the name of a single collection to operate on 
- (Optionally) any extra arguments (for example, `--type=csv`) will be passed to `mongoexport`

###### Output
- The output directory will have a subdirectory corresponding to each `database-name`
- Within each `database-name` will be date subdirectories `yyyy`, `mm` and `dd`, and then a `.json` file corresponding to each `collection` in the config file

###### Example 
Given the following input file:

```
        mymongo:27017
        my-nice-db
        username
        password
        users
        pictures
        articles     
```
If invoked with `/tmp` as the output directory on May 13, 2016, `/tmp` would then look like:

```
/tmp/my-nice-db/2016/05/13/
    			           users.json
                           pictures.json
                           articles.json 
 ```
 
###### Notes
 - If reinvoked on the same day, files will be overwritten.
 - If reinvoked on a different day, any existing structure and content in the output directory will be preserved, and new subdirectories added as needed for the new date.
  

### Still To Come
- `batchimport`
- `seed-database`
- `execute-script`


