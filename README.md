All the scripts here use a convention where they expect to be passed the absolute 
location of a `config` directory containing one-or-more configuration files.

Each file represents a database to be operated on using one of the tools.

The filename is unimportant. The contents **must** be:

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

By default, each of these files in the `config` directory will be processed by the each tool.
