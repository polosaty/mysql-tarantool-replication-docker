# Docker build of mysql-tarantool-replication

https://github.com/tarantool/mysql-tarantool-replication.git

## Build

There is a pre-builded image: `polosaty/mysql-tarantool-replication`

If you want to build with your own hands:

```shell
docker build . -t replicator
```
## Use

config example (replicatord.yml)

```yml
mysql:
    host: db
    port: 3306
    user: tarantooluser
    password: tarantoolpass
    connect_retry: 15 # seconds

tarantool:
    host: tarantool:3301
    binlog_pos_space: 512
    binlog_pos_key: 0
    connect_retry: 15 # seconds
    sync_retry: 1000 # milliseconds

mappings:
    - database: mysql_test_db
      table: test_table
      columns: [ id, value ]
      space: 515
      key_fields: [ 0 ]
```

another example: https://github.com/tarantool/mysql-tarantool-replication/blob/master/replicatord.yml

### Run with builded image

```shell
docker run --rm \
  -v ./replicatord.yml:/replicatord.yml \
  --user $UID:$GID \
  replicator ./replicatord -c /replicatord.yml -l /dev/stderr
```

### Run with pre-builded image:

```shell
docker run --rm \
  -v ./replicatord.yml:/replicatord.yml \
  --user $UID:$GID \
  polosaty/mysql-tarantool-replication \
   ./replicatord -c /replicatord.yml -l /dev/stderr
```
