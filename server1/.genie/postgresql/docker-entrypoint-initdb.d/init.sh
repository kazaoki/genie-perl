#!/bin/sh

# Port change
# -----------
echo "port = $POSTGERS_PORT" >> $PGDATA/postgresql.conf

# echo "!!??"



# TimeZone set
# ------------
# cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# echo 'Asia/Tokyo' > /etc/timezone

# Package update & lang setting
# -----------------------------
# apt-get update
# apt-get upgrade -y
# apt-get install -y locales
# echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen
# echo "ja_JP.EUC-JP EUC-JP" >> /etc/locale.gen
# /usr/sbin/locale-gen
# export LANG=ja_JP.UTF-8
# export LC_ALL=ja_JP.UTF-8
# /usr/sbin/update-locale LANG=ja_JP.UTF-8
# pg_ctl reload

# gosu postgres pg_ctl reload



# export POSTGERS_LC_COLLATE=ja_JP.utf8
# export POSTGERS_LC_CTYPE=ja_JP.utf8

# CREATE DATABASE "sample" WITH ENCODING '${POSTGERS_ENCODING}' LC_COLLATE '${POSTGERS_LC_COLLATE}' LC_CTYPE '${POSTGERS_LC_CTYPE}';

# createdb sample --encoding=UTF-8 --locale=ja_JP.UTF-8 -U postgres


# psql -U genie_user1 genie_db1 -l
# psql -U genie_user1 genie_db1


# cp -p /usr/share/zoneinfo/Japan /etc/localtime
# psql --username postgres <<-EOSQL
# 	ALTER DATABASE "$POSTGRES_DB" SET ENCODING TO '${POSTGERS_ENCODING}'
# EOSQL
#	ALTER DATABASE "$POSTGRES_DB" SET ENCODING '${POSTGERS_ENCODING}' LC_COLLATE '${POSTGERS_LC_COLLATE}' LC_CTYPE '${POSTGERS_LC_CTYPE}'
# psql --username postgres <<-EOSQL
# 	CREATE DATABASE "sample" WITH ENCODING '${POSTGERS_ENCODING}' LC_COLLATE '${POSTGERS_LC_COLLATE}' LC_CTYPE '${POSTGERS_LC_CTYPE}';
# EOSQL

# psql -U genie_user1 genie_db1 -l

# update-locale LANG=ja_JP.UTF-8
# update-locale LANG=ja_JP.UTF-8

# gosu postgres 
# gosu postgres pg_ctl -D "$PGDATA" -o "-c listen_addresses=''" -w start
# gosu postgres pg_ctl reload
