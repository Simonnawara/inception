-echo "Attente de la base de données MariaDB ($SQL_HOST)..."
-while ! mysqladmin ping -h"$SQL_HOST" --silent; do
+# Wait for MariaDB
+echo "⏳ Waiting for MariaDB ($MYSQL_HOST)…"
+while ! mysqladmin --silent --protocol=tcp \
+        -h"$MYSQL_HOST" -P3306 \
+        -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" ping; do
     sleep 1
 done
 echo "✅ MariaDB est prêt !"
 …
-if [ ! -f /var/www/wordpress/wp-config.php ]; then
+if [ ! -f /var/www/html/wp-config.php ]; then
     echo "🛠 Configuration initiale de WordPress…"
     wp core download --allow-root --path=/var/www/html
     wp config create \
-        --dbname="$SQL_DATABASE" \
-        --dbuser="$SQL_USER" \
-        --dbpass="$SQL_PASSWORD" \
-        --dbhost="$SQL_HOST":3306 \
+        --dbname="$MYSQL_DATABASE" \
+        --dbuser="$MYSQL_USER" \
+        --dbpass="$MYSQL_PASSWORD" \
+        --dbhost="$MYSQL_HOST":3306 \
         --path=/var/www/html --allow-root
     wp core install \
         --url="https://$DOMAIN_NAME" \
         --title="$WP_TITLE" \
         --admin_user="$WP_ADMIN_USER" \
         --admin_password="$WP_ADMIN_PASSWORD" \
         --admin_email="$WP_ADMIN_EMAIL" \
-        --path='/var/www/wordpress'
+        --path='/var/www/html' --allow-root
