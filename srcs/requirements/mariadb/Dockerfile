# FROM debian:bullseye 

# RUN apt update && apt upgrade -y && apt-get install mariadb-server -y

# COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# COPY tools/setup.sh /bin/setup.sh
# RUN chmod +x /bin/setup.sh
# CMD ["/bin/setup.sh"]

FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y mariadb-server \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /run/mysqld \
 && chown -R mysql:mysql /run/mysqld

# custom server settings
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# first-boot init script
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306
VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["sh", "/usr/local/bin/setup.sh"]