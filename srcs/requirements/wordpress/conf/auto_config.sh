#!/bin/sh
set -e

# ─── wait until MariaDB answers on TCP:3306 ─────────────────────
echo "⏳ Waiting for MariaDB ($MYSQL_HOST) ..."
until mysqladmin --silent --protocol=tcp \
                 -h"$MYSQL_HOST" -P3306 \
                 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" ping; do
    sleep 1
done
echo "✅ MariaDB is up"

# ─── first-run WordPress install (idempotent) ───────────────────
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "🛠  Installing WordPress ..."
    wp core download --path=/var/www/html --allow-root
    wp config create                    --allow-root --path=/var/www/html \
        --dbname="$MYSQL_DATABASE"      --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD"      --dbhost="$MYSQL_HOST":3306
    wp core install                     --allow-root --path=/var/www/html \
        --url="https://$DOMAIN_NAME"    --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER"   --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_MAIL"
    echo "✅ WordPress installed"
fi


# ─── hand off to the image’s default entrypoint (PHP-FPM) ───────
exec php-fpm7.4 -F