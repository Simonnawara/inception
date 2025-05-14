#!/bin/sh
set -e

# 1) Initialise the data directory if empty
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "🛠  First launch – initialising database…"
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null
  echo "✅  System tables created."
fi

# 2) Ensure the socket directory exists
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# 3) Hand off to the real server binary
echo "🚀  Starting mariadbd…"
exec /usr/sbin/mariadbd --user=mysql --console
