FROM debian:bullseye

RUN apt update && apt upgrade -y && apt-get -y install wget
RUN apt-get install -y php7.4\
    php-fpm\
    php-mysql\
    mariadb-client
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz
RUN	chown -R root:root /var/www/wordpress
RUN sed -i "s/listen = \/run\/php\/php7.4-fpm.sock/listen = wordpress:9000/g" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i "s/;clear_env = no/clear_env = no/g" /etc/php/7.4/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
COPY ./conf/auto_config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/auto_config.sh

ENTRYPOINT ["/usr/local/bin/auto_config.sh"]