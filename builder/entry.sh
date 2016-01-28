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
# if [[ $LAMP_BANDWIDTH ]]; then
#   sed -i "/<__BANDWIDTH__>/,/<\/__BANDWIDTH__>/c\
# \ \ # <__BANDWIDTH__>\n\
#     <IfModule mod_bw.c>\n\
#       BandWidthModule On\n\
#       ForceBandWidthModule On\n\
#       BandWidth all ${LAMP_BANDWIDTH}\n\
#     </IfModule>\n\
#   # </__BANDWIDTH__>" /etc/httpd/conf/httpd.conf
# else
#   sed -i '/<__BANDWIDTH__>/,/<\/__BANDWIDTH__>/c\
#   # <__BANDWIDTH__>\
#   # </__BANDWIDTH__>' /etc/httpd/conf/httpd.conf
# fi
# if [[ $LAMP_NO_CACHE ]]; then
#   sed -i '/<__NO_CACHE__>/,/<\/__NO_CACHE__>/c\
#   # <__NO_CACHE__>\
#     FileEtag None\
#     RequestHeader unset If-Modified-Since\
#     Header set Cache-Control no-store\
#   # </__NO_CACHE__>' /etc/httpd/conf/httpd.conf
# else
#   sed -i '/<__NO_CACHE__>/,/<\/__NO_CACHE__>/c\
#   # <__NO_CACHE__>\
#   # </__NO_CACHE__>' /etc/httpd/conf/httpd.conf
# fi
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
#   echo "GRANT ALL PRIVILEGES ON \`${LAMP_MYSQL_DB}\`.* TO '${LAMP_MYSQL_USER}'@'%' IDENTIFIED BY '${LAMP_MYSQL_PASS}'" | mysql
#   echo "FLUSH PRIVILEGES" | mysql

#   # add local hosts
#   if [[ $LAMP_MYSQL_HOSTNAME_TO_LOCAL != '' ]]; then
#     echo "127.0.0.1 $LAMP_MYSQL_HOSTNAME_TO_LOCAL" >> /etc/hosts
#   fi
# fi

# # -- perl install
# if [[ $LAMP_PERL_VERSION != '' ]]; then
#   perl_install_path="/opt/perl$LAMP_PERL_VERSION/"
#   if [[ ! -e $perl_install_path ]]; then
#     curl -L https://raw.github.com/tokuhirom/Perl-Build/master/perl-build | perl - $LAMP_PERL_VERSION $perl_install_path --noman
#   fi
#   if [[ ! -L /usr/bin/perl ]]; then
#     unlink /usr/bin/perl
#     ln -s $perl_install_path/bin/perl /usr/bin/perl
#   fi
# fi

# # -- php install
# if [[ $LAMP_PHP_VERSION != '' ]]; then
#   service httpd stop
#   php_install_path="/opt/php-$LAMP_PHP_VERSION/"
#   if [[ ! -e $php_install_path ]]; then
#     sed -i -e '1i configure_option "--with-apxs2" "/usr/sbin/apxs"' /usr/local/share/php-build/definitions/$LAMP_PHP_VERSION
#     php-build $LAMP_PHP_VERSION /opt/php-$LAMP_PHP_VERSION
#     ln -s /opt/php-$LAMP_PHP_VERSION /root/.phpenv/versions/$LAMP_PHP_VERSION
#     phpenv global $LAMP_PHP_VERSION
#     phpenv rehash
#     cp /etc/httpd/modules/libphp5.so /root/.phpenv/versions/$LAMP_PHP_VERSION/
#   else
#     ln -s /opt/php-$LAMP_PHP_VERSION /root/.phpenv/versions/$LAMP_PHP_VERSION
#     cp /root/.phpenv/versions/$LAMP_PHP_VERSION/libphp5.so /etc/httpd/modules/
#   fi
#   service httpd start
# fi

# # -- entry finished
# echo 'finished' >> /var/log/entry.log

# -- daemon loop start
while true
do
    sleep 60
done
