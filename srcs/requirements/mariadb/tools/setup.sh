#!/bin/sh
set -e

# ─── 1. defaults ────────────────────────────────────────────────────────────────
MYSQL_DATABASE=wordpress
MYSQL_USER=sinawara
MYSQL_PASSWORD=inception
MYSQL_ROOT_PASSWORD=inception

# ─── 2. initialise datadir if empty ─────────────────────────────────────────────
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🛠  First launch – initialising database..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null

    **# start server without network & without auth**
    mysqld_safe --skip-networking --skip-grant-tables &
    pid=$!

    # wait until the server is really up
    until mysqladmin ping --silent ; do
        sleep 1
    done

    # now configure everything in one shot
    mysql <<-EOSQL
        FLUSH PRIVILEGES;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

    # stop temp server
    mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$pid"
    echo "✅  Database initialised."
fi

echo "🚀  Starting mysqld..."
exec mysqld_safe