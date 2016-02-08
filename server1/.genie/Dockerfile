FROM centos:7
MAINTAINER kazaoki lab.

# Set timezone
# ------------
RUN cp /etc/localtime /etc/localtime.org \
    && ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && echo 'LANG="ja_JP.UTF-8"' > /etc/locale.conf \
    && . /etc/locale.conf

# Add packages
# ------------
RUN yum update -y && \
    yum install epel-release -y && \
    yum install -y \
        gcc make perl perl-core openssl openssl-libs openssl-devel htop \
        git bzip2 tar patch wget \
        readline readline-devel \
        zlib zlib-devel \
        curl curl-devel \
        bison bison-devel re2c libxml2-devel \
        libjpeg-devel libpng-devel readline-devel libtidy-devel \
        libxslt-devel libmcrypt libmcrypt-devel php-mcrypt \
        php php-mbstring php-pdo php-mysql php-pgsql php-gd php-xml \
        php-soap php-Smarty re2c libxml2-devel bison bison-devel \
        perl-libwww-perl perl-Crypt-SSLeay \
        ImageMagick ImageMagick-perl \
        postfix \
        libffi-devel \
        mysql mysql-server mysql-devel \
        postgresql postgresql-server postgresql-devel \
        httpd httpd-devel mod_php mod_ssl \
        net-tools sudo multitail zip tar bzip2 patch git \
        nginx \
        ruby \
    && yum clean all

# Install anyenv
# --------------
RUN git clone https://github.com/riywo/anyenv ~/.anyenv \
    && echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(anyenv init -)"' >> ~/.bashrc
ENV PATH /root/.anyenv/bin:$PATH
RUN . ~/.bashrc

# Install Ruby by rbenv
# ---------------------
RUN anyenv install rbenv \
    && . ~/.bashrc

# Install Perl by plenv
# ---------------------
RUN anyenv install plenv \
    && . ~/.bashrc

# Install PHP by phpenv
# ---------------------
RUN anyenv install phpenv \
    && . ~/.bashrc

# Install PhantomJS
RUN cd /root/ \
    && wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && tar jxvf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin \
    && rm -fr phantomjs-2.1.1-linux-x86_64* \
    && cd

# Entry point
# -----------
ENTRYPOINT /genie/entry.sh
