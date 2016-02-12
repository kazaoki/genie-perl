#!/bin/sh

# -- general
echo ". /etc/bashrc" >> /root/.bashrc

# -- Apache
if [[ $GENIE_APACHE_BANDWIDTH ]]; then
  sed -i "/<__BANDWIDTH__>/,/<\/__BANDWIDTH__>/c\
\ \ # <__BANDWIDTH__>\n\
    <IfModule mod_bw.c>\n\
      BandWidthModule On\n\
      ForceBandWidthModule On\n\
      BandWidth all ${GENIE_APACHE_BANDWIDTH}\n\
    </IfModule>\n\
  # </__BANDWIDTH__>" /etc/httpd/conf/httpd.conf
else
  sed -i '/<__BANDWIDTH__>/,/<\/__BANDWIDTH__>/c\
  # <__BANDWIDTH__>\
  # </__BANDWIDTH__>' /etc/httpd/conf/httpd.conf
fi
if [[ $GENIE_APACHE_NO_CACHE ]]; then
  sed -i '/<__NO_CACHE__>/,/<\/__NO_CACHE__>/c\
  # <__NO_CACHE__>\
    FileEtag None\
    RequestHeader unset If-Modified-Since\
    Header set Cache-Control no-store\
  # </__NO_CACHE__>' /etc/httpd/conf/httpd.conf
else
  sed -i '/<__NO_CACHE__>/,/<\/__NO_CACHE__>/c\
  # <__NO_CACHE__>\
  # </__NO_CACHE__>' /etc/httpd/conf/httpd.conf
fi
passenv_string=`set | grep -i '^GENIE_' | perl -pe 'while(<>){ chomp; $_=~ /([^\=]+)/; print "$1 "; }'`
sed -i "/<__PASSENV__>/,/<\/__PASSENV__>/c\
\ \ # <__PASSENV__>\n\
  PassEnv $passenv_string\n\
  # </__PASSENV__>" /etc/httpd/conf/httpd.conf
/usr/sbin/httpd
echo 'Apache started' >> /var/log/entry.log

# -- Postfix
if [[ $GENIE_POSTFIX_ENABLED ]]; then
  if [[ $GENIE_POSTFIX_FORCE_ENVELOPE != '' ]]; then
    echo "canonical_classes = envelope_sender, envelope_recipient" >> /etc/postfix/main.cf
    echo "canonical_maps = regexp:/etc/postfix/canonical.regexp" >> /etc/postfix/main.cf
    echo "/^.+$/ $GENIE_POSTFIX_FORCE_ENVELOPE" >> /etc/postfix/canonical.regexp
  fi
  /usr/sbin/postfix start
  echo 'Postfix started' >> /var/log/entry.log
fi

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


# # -- Nginx
# service nginx start

# -- entry finished
echo 'entry.sh finished' >> /var/log/entry.log

# -- run after.sh
sh -c after.sh
echo 'after.sh finished' >> /var/log/after.log

# -- daemon loop start
while true
do
    sleep 60
done
