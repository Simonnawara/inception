#!/bin/sh
set -e

echo "⏳ Waiting for MariaDB ($MYSQL_HOST) ..."
until mysqladmin --silent --protocol=tcp \
                 -h"$MYSQL_HOST" -P3306 \
                 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" ping ; do
    sleep 1
done
echo "✅ MariaDB is up"

# ─── install only if WP tables are NOT in the DB ────────────────
if ! wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
    echo "🛠  Installing WordPress ..."
    wp config create --allow-root --path=/var/www/html \
        --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" --dbhost="$MYSQL_HOST":3306
    wp core install  --allow-root --path=/var/www/html \
        --url="https://$DOMAIN_NAME" --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_MAIL"
    echo "✅ WordPress installed"
else
    echo "🔄 WordPress already installed – skipping installer"
fi

# ─── start PHP-FPM in foreground ───────────────────────────────
exec php-fpm7.4 -F
