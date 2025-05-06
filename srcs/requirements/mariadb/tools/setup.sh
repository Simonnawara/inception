#!/bin/sh
set -e

# ─── 1. defaults  ────────────────────────────────────────────────────────────
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-sinawara}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-inception}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-inception}

# ─── 2. initialise datadir if empty ──────────────────────────────────────────
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🛠  First launch – initialising database..."

    # create system tables (harmless if datadir truly empty)
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null

    # start a local server with NO networking and NO auth checks
    mysqld_safe --skip-networking --skip-grant-tables &
    pid="$!"

    # wait until the socket answers
    until mysqladmin --protocol=socket --silent ping ; do
        sleep 1
    done

    # configure everything in one shot
    mysql --protocol=socket <<-EOSQL
        FLUSH PRIVILEGES;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

    # shut the temp server down
    mysqladmin --protocol=socket -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$pid"
	echo "$pid"
    echo "✅  Database initialised."
fi

# ─── 3. launch MariaDB normally ─────────────────────────────────────────────
echo "🚀  Starting mysqld..."
exec mysqld_safe