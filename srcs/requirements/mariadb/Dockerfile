# ────────────────────────────────────────────────────────────
# MariaDB image for 42-Inception
# ────────────────────────────────────────────────────────────
FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

# 1) install server
RUN apt-get update \
 && apt-get install -y --no-install-recommends mariadb-server \
 && rm -rf /var/lib/apt/lists/* \
 \
 # 2) wipe the pre-seeded datadir that the Debian package creates
 && rm -rf /var/lib/mysql/* \
 \
 # 3) make sure the runtime socket dir exists & is writable
 && mkdir -p /run/mysqld \
 && chown mysql:mysql /run/mysqld

# 4) custom conf + bootstrap script
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/setup.sh     /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# 5) metadata
EXPOSE 3306
VOLUME ["/var/lib/mysql"]
ENTRYPOINT ["/usr/local/bin/setup.sh"]
