#!/bin/sh

# --------------------------------------------------------------------
# general
# --------------------------------------------------------------------
echo ". /etc/bashrc" >> /root/.bashrc

# --------------------------------------------------------------------
# init mode
# --------------------------------------------------------------------
if [[ $GENIE_PROC == 'init' ]]; then
  cd /work
  mkdir .genie
  cd .genie
  url=https://github.com/kazaoki/genie/tarball/$GENIE_INIT_BRANCH
  echo "Downloading $url"
  echo ""
  curl -s -f -L $url | tar xvz */dist/.genie
  if [ $? -ne 0 ]; then
    exit 1
  fi
  dir=`ls`
  mv ${dir}/dist/.genie/* ./
  rm -fr ${dir}
  exit 0
fi

# --------------------------------------------------------------------
# update mode
# --------------------------------------------------------------------
if [[ $GENIE_PROC == 'update' ]]; then
  cd /work
  mkdir .genie_update
  cd .genie_update
  url=https://github.com/kazaoki/genie/tarball/$GENIE_UPDATE_BRANCH
  echo "Downloading $url"
  echo ""
  curl -s -f -L $url | tar xvz */dist/.genie
  if [ $? -ne 0 ]; then
    exit 1
  fi
  dir=`ls`
  \cp -fr ${dir}/dist/.genie/* ../.genie
  cd ..
  rm -fr .genie_update
  exit 0
fi

# --------------------------------------------------------------------
# httpd mode
# --------------------------------------------------------------------
if [[ $GENIE_PROC == 'httpd' ]]; then
  /usr/sbin/httpd
  /loop.sh
  exit 0
fi

# --------------------------------------------------------------------
# spec|zap mode
# --------------------------------------------------------------------
if [[ $GENIE_PROC == 'spec' ]] || [[ $GENIE_PROC == 'zap' ]]; then
  # -- dir copy
  \cp -rpdfL /_/* /
  # -- mount prefix
  prefix_mount=/_
fi

# --------------------------------------------------------------------
# dlsync mode
# --------------------------------------------------------------------
if [[ $GENIE_PROC == 'dlsync' ]]; then
  rm -f /tmp/mirror.cmd
  if [[ $GENIE_DLSYNC_REMOTE_CHARSET ]]; then
    echo "set ftp:charset $GENIE_DLSYNC_REMOTE_CHARSET" >> /tmp/mirror.cmd
  fi
  if [[ $GENIE_DLSYNC_LOCAL_CHARSET ]]; then
    echo "set file:charset $GENIE_DLSYNC_LOCAL_CHARSET" >> /tmp/mirror.cmd
  fi
  echo "set ftp:list-options -a" >> /tmp/mirror.cmd
  echo "set ssl:verify-certificate no" >> /tmp/mirror.cmd
  echo "open -u $GENIE_DLSYNC_REMOTE_USER,$GENIE_DLSYNC_REMOTE_PASS $GENIE_DLSYNC_REMOTE_HOST" >> /tmp/mirror.cmd
  echo "mirror $GENIE_DLSYNC_LFTP_OPTION $GENIE_DLSYNC_REMOTE_DIR /sync" >> /tmp/mirror.cmd
  echo "close" >> /tmp/mirror.cmd
  echo "quit" >> /tmp/mirror.cmd
  echo "--------------------------------------------------------------"
  cat /tmp/mirror.cmd
  echo "--------------------------------------------------------------"
  lftp -f /tmp/mirror.cmd
  exit 0;
fi

# --------------------------------------------------------------------
# entrypoint.sh started
# --------------------------------------------------------------------
echo 'entrypoint.sh setup start.' >> /var/log/entrypoint.log

# --------------------------------------------------------------------
# perl setup
# --------------------------------------------------------------------
if [[ $GENIE_PERL_VERSION != '' ]]; then
  mkdir -p $prefix_mount/genie/opt/perl
  # -- tar restore
  mkdir -p /perl/versions
  tarfile="/genie/opt/perl/versions.tar"
  if [ -e $tarfile ]; then
    tar xf $tarfile -C /perl/versions
  fi
  # -- install
  install_path="/perl/versions/$GENIE_PERL_VERSION"
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
    cd /perl/versions
    tar cf $prefix_mount/genie/opt/perl/versions.tar ./
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
  echo 'Perl setup done.' >> /var/log/entrypoint.log
fi

# --------------------------------------------------------------------
# Install perl modules from cpanfile
# --------------------------------------------------------------------
if [[ $GENIE_PERL_CPANFILE_ENABLED && -e /genie/opt/perl/cpanfile ]]; then
  mkdir -p $prefix_mount/genie/opt/perl
  # -- tar restore
  mkdir -p /perl/cpanfile-modules
  tarfile="/genie/opt/perl/cpanfile-modules.tar"
  if [ -e $tarfile ]; then
    tar xf $tarfile -C /perl/cpanfile-modules
  fi
  # -- install
  cpanm -nq --installdeps -L /perl/cpanfile-modules/ /genie/opt/perl/
  cd /perl/cpanfile-modules
  tar cf $prefix_mount$tarfile ./
  echo 'cpanfile setup done.' >> /var/log/entrypoint.log
fi

# --------------------------------------------------------------------
# php setup
# --------------------------------------------------------------------
if [[ $GENIE_PHP_VERSION != '' ]]; then
  mkdir -p $prefix_mount/genie/opt/php
  # -- tar restore
  mkdir -p /php/versions
  tarfile="/genie/opt/php/versions.tar"
  if [ -e $tarfile ]; then
    tar xf $tarfile -C /php/versions
  fi
  # -- install
  install_path="/php/versions/$GENIE_PHP_VERSION/"
  link_to="/root/.anyenv/envs/phpenv/versions/$GENIE_PHP_VERSION"
  if [[ ! -e ${install_path} ]]; then
    # -- php install
    sed -i -e '1i configure_option "--with-apxs2" "/usr/bin/apxs"' /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/definitions/$GENIE_PHP_VERSION
    /root/.anyenv/envs/phpenv/plugins/php-build/bin/php-build $GENIE_PHP_VERSION ${install_path}
    ln -s ${install_path} ${link_to}
    \cp -f /etc/httpd/modules/libphp5.so ${link_to}/
    source ~/.bashrc && /root/.anyenv/envs/phpenv/bin/phpenv global $GENIE_PHP_VERSION
    source ~/.bashrc && /root/.anyenv/envs/phpenv/bin/phpenv rehash
    echo '[Date]' >> /php/versions/$GENIE_PHP_VERSION/etc/php.ini
    echo 'date.timezone = "Asia/Tokyo"' >> /php/versions/$GENIE_PHP_VERSION/etc/php.ini
    cd /php/versions
    tar cf $prefix_mount/genie/opt/php/versions.tar ./
  else
    # -- php relink
    ln -s ${install_path} ${link_to}
    \cp -f ${link_to}/libphp5.so /etc/httpd/modules/
    source ~/.bashrc && /root/.anyenv/envs/phpenv/bin/phpenv global $GENIE_PHP_VERSION
    source ~/.bashrc && /root/.anyenv/envs/phpenv/bin/phpenv rehash
  fi
  echo 'PHP setup done.' >> /var/log/entrypoint.log
fi

# --------------------------------------------------------------------
# ruby setup
# --------------------------------------------------------------------
if [[ $GENIE_RUBY_VERSION != '' ]]; then
  mkdir -p $prefix_mount/genie/opt/ruby
  # -- tar restore
  mkdir -p /ruby/versions
  tarfile="/genie/opt/ruby/versions.tar"
  if [ -e $tarfile ]; then
    tar xf $tarfile -C /ruby/versions
  fi
  # -- install
  install_path="/ruby/versions/$GENIE_RUBY_VERSION/"
  link_to="/root/.anyenv/envs/rbenv/versions/$GENIE_RUBY_VERSION"
  if [[ ! -e ${install_path} ]]; then
    # -- ruby install
    /root/.anyenv/envs/rbenv/plugins/ruby-build/bin/ruby-build $GENIE_RUBY_VERSION ${install_path}
    ln -s ${install_path} ${link_to}
    source ~/.bashrc && /root/.anyenv/envs/rbenv/bin/rbenv global $GENIE_RUBY_VERSION
    source ~/.bashrc && /root/.anyenv/envs/rbenv/bin/rbenv rehash
    cd /ruby/versions
    tar cf $prefix_mount/genie/opt/ruby/versions.tar ./
  else
    # -- ruby relink
    ln -s ${install_path} ${link_to}
    source ~/.bashrc && /root/.anyenv/envs/rbenv/bin/rbenv global $GENIE_RUBY_VERSION
    source ~/.bashrc && /root/.anyenv/envs/rbenv/bin/rbenv rehash
  fi
  echo 'Ruby setup done.' >> /var/log/entrypoint.log
fi

# --------------------------------------------------------------------
# Apache
# --------------------------------------------------------------------
if [[ $GENIE_APACHE_ENABLED ]]; then
  if [[ $GENIE_APACHE_HTTP_PORT ]]; then
    sed -i "s/Listen 80$/Listen $GENIE_APACHE_HTTP_PORT/" /etc/httpd/conf/httpd.conf
  fi
  if [[ $GENIE_APACHE_HTTPS_PORT ]]; then
    sed -i "s/Listen 443 /Listen $GENIE_APACHE_HTTPS_PORT /" /etc/httpd/conf.d/ssl.conf
    sed -i "s/_default_:443>/_default_:$GENIE_APACHE_HTTPS_PORT>/" /etc/httpd/conf.d/ssl.conf
  fi
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
  if [[ $GENIE_APACHE_NO_LOG_REGEX ]]; then
    sed -i "s/CustomLog\ \"logs\/access_log\"\ combined/CustomLog\ \"logs\/access_log\"\ combined\ env\=\!nolog/" /etc/httpd/conf/httpd.conf
    echo "SetEnvIfNoCase Request_URI \"$GENIE_APACHE_NO_LOG_REGEX\" nolog" >> /etc/httpd/conf/httpd.conf
  fi
  /usr/sbin/httpd
  echo 'Apache setup done.' >> /var/log/entrypoint.log
fi

# --------------------------------------------------------------------
# Nginx
# --------------------------------------------------------------------
if [[ $GENIE_NGINX_ENABLED ]]; then
  if [[ $GENIE_NGINX_HTTP_PORT ]]; then
    sed -i "s/80 default_server/$GENIE_NGINX_HTTP_PORT default_server/" /etc/nginx/nginx.conf
  fi
  /usr/sbin/nginx
  echo 'Nginx setup done.' >> /var/log/entrypoint.log
fi

# --------------------------------------------------------------------
# Postfix
# --------------------------------------------------------------------
if [[ $GENIE_POSTFIX_ENABLED ]]; then
  if [[ $GENIE_POSTFIX_FORCE_ENVELOPE != '' ]]; then
    echo "canonical_classes = envelope_sender, envelope_recipient" >> /etc/postfix/main.cf
    echo "canonical_maps = regexp:/etc/postfix/canonical.regexp" >> /etc/postfix/main.cf
    echo "/^.+$/ $GENIE_POSTFIX_FORCE_ENVELOPE" >> /etc/postfix/canonical.regexp
  fi
  /usr/sbin/postfix start
  echo 'Postfix setup done.' >> /var/log/entrypoint.log
fi

# --------------------------------------------------------------------
# Copy directories other than /opt/
# --------------------------------------------------------------------
rsync -rltD --exclude /opt /genie/* /
if [[ -d /genie/etc/httpd ]]; then
  if [[ $GENIE_APACHE_ENABLED ]]; then
    /usr/sbin/httpd -k restart
  fi
fi
if [[ -d /genie/etc/postfix ]]; then
  if [[ $GENIE_POSTFIX_ENABLED ]]; then
    /usr/sbin/postfix reload
  fi
fi
if [[ -d /genie/etc/nginx ]]; then
  if [[ $GENIE_NGINX_ENABLED ]]; then
    /usr/sbin/nginx -s reload
  fi
fi

# --------------------------------------------------------------------
# entrypoint.sh finished
# --------------------------------------------------------------------
echo 'entrypoint.sh setup done.' >> /var/log/entrypoint.log

# --------------------------------------------------------------------
# run init.sh
# --------------------------------------------------------------------
/genie/opt/init.sh
echo 'init.sh setup done.' >> /var/log/entrypoint.log

# --------------------------------------------------------------------
# daemon loop start
# --------------------------------------------------------------------
/loop.sh
