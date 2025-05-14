
FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /var/www

# 1) system packages
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
        wget ca-certificates \
        php7.4 php-fpm php-mysql mariadb-client \
 && rm -rf /var/lib/apt/lists/*

# 2) runtime dir for PHP-FPM
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

# 3) configure FPM to listen on *:9000 and keep env
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' \
        /etc/php/7.4/fpm/pool.d/www.conf \
 && sed -i 's|;clear_env = no|clear_env = no|' \
        /etc/php/7.4/fpm/pool.d/www.conf

# 4) download & unpack WordPress once
RUN wget -q https://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz \
 && tar -xzf /tmp/wp.tar.gz -C /var/www \
 && rm /tmp/wp.tar.gz \
 && mv /var/www/wordpress /var/www/html \
 && chown -R www-data:www-data /var/www/html

# 5) install wp-cli
RUN wget -q https://github.com/wp-cli/builds/raw/gh-pages/phar/wp-cli.phar \
 && chmod +x wp-cli.phar \
 && mv wp-cli.phar /usr/local/bin/wp

# 6) bootstrap script
COPY conf/auto_config.sh /usr/local/bin/auto_config.sh
RUN sed -i 's/\r$//'  /usr/local/bin/auto_config.sh \
 && sed -i '1s/^\xEF\xBB\xBF//' /usr/local/bin/auto_config.sh \
 && chmod +x /usr/local/bin/auto_config.sh

CMD ["auto_config.sh"]

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/auto_config.sh"]
