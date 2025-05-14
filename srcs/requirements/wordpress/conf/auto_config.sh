#!/bin/sh
set -e

# 1) ensure environment vars are set
export DB_NAME="${MYSQL_DATABASE:-wordpress}"
export DB_USER="${MYSQL_USER:-sinawara}"
export DB_PASS="${MYSQL_PASSWORD:-inception}"
export DB_HOST="${MYSQL_HOST:-mariadb}"

export WP_URL="https://${DOMAIN_NAME:-localhost}"
export WP_TITLE="${WP_TITLE:-Inception Site}"
export WP_ADMIN_USER="${WP_ADMIN_USER:-admin}"
export WP_ADMIN_PASSWORD="${WP_ADMIN_PASSWORD:-adminpass}"
export WP_ADMIN_EMAIL="${WP_ADMIN_MAIL:-admin@example.com}"

cd /var/www/html

# 2) generate wp-config.php if missing
if [ ! -f wp-config.php ]; then
  echo "🛠  Generating wp-config.php…"
  wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASS" \
    --dbhost="$DB_HOST" \
    --extra-php <<PHP
// Disallow file edits from the dashboard
define( 'DISALLOW_FILE_EDIT', true );
PHP
  echo "✅  wp-config.php created."
fi

# 3) install WordPress if not installed
if ! wp core is-installed --allow-root; then
  echo "🛠  Installing WordPress…"
  wp core install \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root
  echo "✅  WordPress installed."
else
  echo "🎉  WordPress already installed, skipping."
fi

# 4) hand off to php-fpm
exec php-fpm7.4 --nodaemonize
