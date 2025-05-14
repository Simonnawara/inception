# ── build only from Debian, no hub images ─────────────────────────
FROM debian:bullseye-slim

# 1-a  install server
RUN apt-get update \
 && apt-get install -y --no-install-recommends mariadb-server pwgen \
 && rm -rf /var/lib/apt/lists/*

# 1-b  make *mysql* always UID 999 / GID 999 (matches we’ll give the host dir)
RUN groupmod -g 999 mysql \
 &&  usermod  -u 999 mysql

# 1-c  open the TCP listener to the bridge network
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# 1-d  first-boot SQL: creates DB, user, grants
COPY conf/init.sql /docker-entrypoint-initdb.d/99-init.sql:ro


# 1-e  tiny entry-point that prints “ready” to stdout
COPY tools/setup.sh  /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306
ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["mysqld_safe"]
