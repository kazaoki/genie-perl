#!/bin/sh

# # -- general
# echo ". /etc/bashrc" >> /root/.bashrc

# # -- volume sync mode
# if [[ $LAMP_NO_SYNC == 1 ]]; then
#   rsync -rtuv --delete /var/www/contents/ /var/www/contents_cp/
#   chown -R lamp:lamp /var/www/contents_cp
#   find /var/www/contents_cp/ -type d -exec chmod 0755 {} \;
#   find /var/www/contents_cp/ -type f -exec chmod 0644 {} \;
#   find /var/www/contents_cp/ -type f -name *.cgi -exec chmod 0755 {} \;
#   rm -fr /var/www/html
#   ln -s /var/www/contents_cp /var/www/html
# else
#   rm -fr /var/www/html
#   ln -s /var/www/contents /var/www/html
# fi

# # -- Apache
# passenv_string=`set | grep -i '^LAMP' | perl -pe 'while(<>){ chomp; $_=~ /([^\=]+)/; print "$1 "; }'`
# sed -i "/<__PASSENV__>/,/<\/__PASSENV__>/c\
# \ \ # <__PASSENV__>\n\
#   PassEnv $passenv_string\n\
#   # </__PASSENV__>" /etc/httpd/conf/httpd.conf
# service httpd start

# # -- Postfix
# if [[ $LAMP_FORCE_ENVELOPE != '' ]]; then
#   echo "canonical_classes = envelope_sender, envelope_recipient" >> /etc/postfix/main.cf
#   echo "canonical_maps = regexp:/etc/postfix/canonical.regexp" >> /etc/postfix/main.cf
#   echo "/^.+$/ $LAMP_FORCE_ENVELOPE" >> /etc/postfix/canonical.regexp
# fi
# service postfix start

# # -- PostgreSQL
# if [[ $LAMP_PGSQL == 1 ]]; then
#   # port set
#   echo "PGPORT=$LAMP_PGSQL_PORT_INNER" > /etc/sysconfig/pgsql/postgresql

#   # service start
#   service postgresql start

#   # database and user set up
#   sleep 5
#   su - postgres -c "echo CREATE USER $LAMP_PGSQL_USER WITH SUPERUSER PASSWORD \'${LAMP_PGSQL_PASS}\' | psql -p $LAMP_PGSQL_PORT_INNER"
#   su - postgres -c "echo CREATE DATABASE $LAMP_PGSQL_DB WITH ENCODING \'${LAMP_PGSQL_ENCODING}\' LC_COLLATE \'${LAMP_PGSQL_LC_COLLATE}\' LC_CTYPE \'${LAMP_PGSQL_LC_CTYPE}\' TEMPLATE template0 OWNER $LAMP_PGSQL_USER | psql -p $LAMP_PGSQL_PORT_INNER"

#   # add local hosts
#   if [[ $LAMP_PGSQL_HOSTNAME_TO_LOCAL != '' ]]; then
#     echo "127.0.0.1 $LAMP_PGSQL_HOSTNAME_TO_LOCAL" >> /etc/hosts
#   fi
# fi

# # -- MySQL
# if [[ $LAMP_MYSQL == 1 ]]; then
#   # port set
#   mkdir /etc/mysql
#   echo "[mysqld]" >> /etc/mysql/my.cnf
#   echo "port=$LAMP_MYSQL_PORT_INNER" >> /etc/mysql/my.cnf

#   # service start
#   service mysqld start

#   # database and user set up
#   echo "CREATE DATABASE \`${LAMP_MYSQL_DB}\` DEFAULT CHARACTER SET ${LAMP_MYSQL_DEFAULT_CHARACTER_SET}" | mysql
#   echo "CREATE USER '${LAMP_MYSQL_USER}'@'%' IDENTIFIED BY '${LAMP_MYSQL_PASS}'" | mysql
#   echo "GRANT ALL PRIVILEGES ON \`${LAMP_MYSQL_DB}\`.* TO '${LAMP_MYSQL_USER}'@localhost IDENTIFIED BY '${LAMP_MYSQL_PASS}'" | mysql
#   echo "FLUSH PRIVILEGES" | mysql

#   # add local hosts
#   if [[ $LAMP_MYSQL_HOSTNAME_TO_LOCAL != '' ]]; then
#     echo "127.0.0.1 $LAMP_MYSQL_HOSTNAME_TO_LOCAL" >> /etc/hosts
#   fi
# fi

# # -- Mojolicious Web App
# if [[ $LAMP_NO_SYNC == 1 ]]; then
#   # for rspec no sync test
#   sh -c 'cd /app && /usr/local/bin/start_server --port=5000 --interval=3 --pid-file=/var/run/kantaro_web.pid --status-file=/var/run/kantaro_web.status -- /usr/local/bin/plackup -E development -s Starlet -l 0:5000 --max-workers=5 --max-keepalive-reqs=5 --max-reqs-per-child=1000 script/kantaro_web' &
# else
#   # for develop
#   sh -c 'cd /app && /usr/local/bin/morbo -v -l http://*:5000 script/kantaro_web' &
# fi
# #sh -c 'cd /app && /usr/local/bin/start_server --port=5000 --interval=3 --pid-file=/var/run/kantaro_web.pid --status-file=/var/run/kantaro_web.status -- /usr/local/bin/plackup -E production -s Starlet -l 0:5000 --max-workers=5 --max-keepalive-reqs=5 --max-reqs-per-child=1000 script/kantaro_web' &


# # -- Mojolicious System App
# if [[ $LAMP_NO_SYNC == 1 ]]; then
#   # for rspec no sync test
#   sh -c 'cd /app && /usr/local/bin/start_server --port=4433 --interval=3 --pid-file=/var/run/kantaro_system.pid --status-file=/var/run/kantaro_system.status -- /usr/local/bin/plackup -E development -s Starlet -l 0:4433 --max-workers=5 --max-keepalive-reqs=5 --max-reqs-per-child=1000 script/kantaro_system' &
# else
#   # for develop
#   sh -c 'cd /app && /usr/local/bin/morbo -v -l https://*:4433 script/kantaro_system' &
# fi
# #sh -c 'cd /app && /usr/local/bin/start_server --port=4433 --interval=3 --pid-file=/var/run/kantaro_system.pid --status-file=/var/run/kantaro_system.status -- /usr/local/bin/plackup -E production -s Starlet -l 0:4433 --max-workers=5 --max-keepalive-reqs=5 --max-reqs-per-child=1000 script/kantaro_system' &

# # -- Nginx
# service nginx start

# -- entry finished
# echo 'finished' >> /var/log/entry.log

# -- daemon loop start
while true
do
    sleep 60
done
