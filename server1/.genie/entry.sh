#!/bin/sh

# -- general
echo ". /etc/bashrc" >> /root/.bashrc

# -- entry.sh started
echo 'entry.sh setup start.' >> /var/log/entry.log

# -- storages restore
[ ! -e /storages ] && mkdir /storages
[ ! -e /genie/storages ] && mkdir /genie/storages
if [[ `find /genie/storages -type f | wc -l` != '0' ]]; then
  find /genie/storages -maxdepth 1 -type f -exec perl -e '$_=shift;if(~/([^\/]+).tar$/){mkdir "/storages/$1";`tar xf $_ -C /storages/$1`}' {} \;
  echo "Storages restore done." >> /var/log/entry.log
fi

# -- perl setup
if [[ $GENIE_PERL_VERSION != '' ]]; then
  storage_name='perl-versions'
  install_path="/storages/${storage_name}/$GENIE_PERL_VERSION"
  link_to="/root/.anyenv/envs/plenv/versions/$GENIE_PERL_VERSION"
  if [[ ! -e $install_path ]]; then
    # -- perl install
    /root/.anyenv/envs/plenv/plugins/perl-build/bin/perl-build $GENIE_PERL_VERSION ${install_path}
    if [[ ! -e $install_path ]]; then
      exit 1
    fi
    ln -s ${install_path} ${link_to}
    source ~/.bashrc && /root/.anyenv/envs/plenv/bin/plenv global $GENIE_PERL_VERSION
    source ~/.bashrc && /root/.anyenv/envs/plenv/bin/plenv rehash
    cd /storages/${storage_name}
    tar cf /genie/storages/${storage_name}.tar ./
  else
    # -- perl relink
    ln -s ${install_path} ${link_to}
    source ~/.bashrc && /root/.anyenv/envs/plenv/bin/plenv global $GENIE_PERL_VERSION
    source ~/.bashrc && /root/.anyenv/envs/plenv/bin/plenv rehash
  fi
  if [[ ! -L /usr/bin/perl ]]; then
    unlink /usr/bin/perl
    ln -s $install_path/bin/perl /usr/bin/perl
  fi
  echo 'Perl setup done.' >> /var/log/entry.log
fi

# -- Install perl modules from cpanfile
if [[ $GENIE_PERL_CPANFILE_ENABLED && -e /genie/cpanfile ]]; then
  storage_name='perl-cpanfile-modules'
  cpanm -nq --installdeps -L /storages/${storage_name}/ /genie/
  cd /storages/${storage_name}
  tar cf /genie/storages/${storage_name}.tar ./
  echo 'cpanfile setup done.' >> /var/log/entry.log
fi

# -- php setup
if [[ $GENIE_PHP_VERSION != '' ]]; then
  storage_name='php-versions'
  install_path="/storages/${storage_name}/$GENIE_PHP_VERSION/"
  link_to="/root/.anyenv/envs/phpenv/versions/$GENIE_PHP_VERSION"
  if [[ ! -e ${install_path} ]]; then
    # -- php install
    sed -i -e '1i configure_option "--with-apxs2" "/usr/bin/apxs"' /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/definitions/$GENIE_PHP_VERSION
    /root/.anyenv/envs/phpenv/plugins/php-build/bin/php-build $GENIE_PHP_VERSION ${install_path}
    ln -s ${install_path} ${link_to}
    \cp -f /etc/httpd/modules/libphp5.so ${link_to}/
    source ~/.bashrc && /root/.anyenv/envs/phpenv/bin/phpenv global $GENIE_PHP_VERSION
    source ~/.bashrc && /root/.anyenv/envs/phpenv/bin/phpenv rehash
    cd /storages/${storage_name}
    tar cf /genie/storages/${storage_name}.tar ./
  else
    # -- php relink
    ln -s ${install_path} ${link_to}
    \cp -f ${link_to}/libphp5.so /etc/httpd/modules/
    source ~/.bashrc && /root/.anyenv/envs/phpenv/bin/phpenv global $GENIE_PHP_VERSION
    source ~/.bashrc && /root/.anyenv/envs/phpenv/bin/phpenv rehash
  fi
  echo 'PHP setup done.' >> /var/log/entry.log
fi

# -- ruby setup
if [[ $GENIE_RUBY_VERSION != '' ]]; then
  storage_name='ruby-versions'
  install_path="/storages/${storage_name}/$GENIE_RUBY_VERSION/"
  link_to="/root/.anyenv/envs/rbenv/versions/$GENIE_RUBY_VERSION"
  if [[ ! -e ${install_path} ]]; then
    # -- ruby install
    /root/.anyenv/envs/rbenv/plugins/ruby-build/bin/ruby-build $GENIE_RUBY_VERSION ${install_path}
    ln -s ${install_path} ${link_to}
    source ~/.bashrc && /root/.anyenv/envs/rbenv/bin/rbenv global $GENIE_RUBY_VERSION
    source ~/.bashrc && /root/.anyenv/envs/rbenv/bin/rbenv rehash
    cd /storages/${storage_name}
    tar cf /genie/storages/${storage_name}.tar ./
  else
    # -- ruby relink
    ln -s ${install_path} ${link_to}
    source ~/.bashrc && /root/.anyenv/envs/rbenv/bin/rbenv global $GENIE_RUBY_VERSION
    source ~/.bashrc && /root/.anyenv/envs/rbenv/bin/rbenv rehash
  fi
  echo 'Ruby setup done.' >> /var/log/entry.log
fi

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
echo 'Apache setup done.' >> /var/log/entry.log

# -- Postfix
if [[ $GENIE_POSTFIX_ENABLED ]]; then
  if [[ $GENIE_POSTFIX_FORCE_ENVELOPE != '' ]]; then
    echo "canonical_classes = envelope_sender, envelope_recipient" >> /etc/postfix/main.cf
    echo "canonical_maps = regexp:/etc/postfix/canonical.regexp" >> /etc/postfix/main.cf
    echo "/^.+$/ $GENIE_POSTFIX_FORCE_ENVELOPE" >> /etc/postfix/canonical.regexp
  fi
  /usr/sbin/postfix start
  echo 'Postfix setup done.' >> /var/log/entry.log
fi

# # -- Nginx
# service nginx start

# -- entry.sh finished
echo 'entry.sh setup done.' >> /var/log/entry.log

# -- run after.sh
/genie/after.sh

# -- daemon loop start
while true
do
    sleep 60
done
