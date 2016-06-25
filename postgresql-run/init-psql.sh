#!/bin/bash
gosu postgres postgres --single -jE <<-EOSQL
    CREATE USER "$ORG_DB_USER" WITH PASSWORD '$ORG_DB_PASS' ;
EOSQL
echo

# by writing TEMPLATE template0, you can create a virgin database containing only the standard objects 
# predefined by your version of PostgreSQL. This is useful if you wish to avoid copying any installation-local objects
# that might have been added to template1
gosu postgres postgres --single -jE <<-EOSQL
    CREATE DATABASE "$ORG_DB_NAME" OWNER "$ORG_DB_USER" ENCODING 'UTF8' TEMPLATE template0;
EOSQL
echo

# Create postgresql log folder for $ORG_NAME
if [ ! -d /var/log/postgresql/$ORG_NAME ]; then
        mkdir -p /var/log/postgresql/$ORG_NAME
fi
chown -R postgres /var/log/postgresql/$ORG_NAME

# Enable log for server
cat <<EOT >> /data/postgresql/postgresql.conf
log_destination = 'stderr'
logging_collector = on
log_directory = '/var/log/postgresql/${ORG_NAME}'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_file_mode = 0600
log_min_error_statement = error

# (slow logs) representing how many milliseconds the query has to run before it's logged
log_min_duration_statement = 10000

log_line_prefix = '%t:%r:%u@%d:[%p]: '

#  logs all data definition statements, such as CREATE, ALTER, and DROP statements
log_statement = 'ddl'
EOT