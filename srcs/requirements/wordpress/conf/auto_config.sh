#!/bin/bash
set -e

echo "Attente de la base de données MariaDB ($SQL_HOST)..."
while ! mysqladmin ping -h"$SQL_HOST" --silent; do
    sleep 1
done
echo "✅ MariaDB est prêt !"

# Debug
echo "📁 Vérification de /var/www/wordpress..."
ls -la /var/www/wordpress

# Si WordPress n'est pas encore configuré
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "🛠 Configuration initiale de WordPress..."

    wp config create --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost="$SQL_HOST":3306 \
        --path='/var/www/wordpress'

    wp core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path='/var/www/wordpress'

    echo "✅ WordPress installé avec succès."
else
    echo "ℹ️ WordPress est déjà configuré."
fi

mkdir -p /run/php

echo "🚀 Lancement de PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
