FROM centos:6.7
MAINTAINER kazaoki lab.

# Set timezone
# ------------
RUN cp /etc/localtime /etc/localtime.org \
    && ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && cp /etc/sysconfig/clock /etc/sysconfig/clock.org \
    && echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock

# Add packages
# ------------
RUN yum update -y && \
    yum install epel-release -y && \
    yum install -y \
        gcc make perl perl-core openssl openssl-libs openssl-devel htop \
        git bzip2 tar patch \
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
        mysql mysql-server mysql-devel \
        postgresql postgresql-server postgresql-devel \
        httpd httpd-devel mod_php mod_ssl \
        net-tools sudo multitail zip tar bzip2 patch git \
        nginx \
    && yum clean all

# RUN echo ">>>>> $SHELL <<<<<"

# RUN echo 1
# ENV PATH $HOME/.anyenv/bin:$PATH

# Install anyenv
# --------------
RUN git clone https://github.com/riywo/anyenv ~/.anyenv \
    && echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(anyenv init -)"' >> ~/.bashrc
ENV PATH /root/.anyenv/bin:$PATH
RUN source ~/.bashrc
# RUN anyenv install plenv
# RUN source ~/.bashrc
# RUN anyenv install phpenv

# Install Ruby by rbenv
# ---------------------
RUN anyenv install rbenv \
    source ~/.bashrc \
    rbenv install 2.2.0 \
    rbenv global 2.2.0

# Install Perl by plenv
# ---------------------
RUN anyenv install plenv \
    source ~/.bashrc \
    plenv install 5.20.0 \
    plenv global 5.20.0

# Install PHP by phpenv
# ---------------------
RUN anyenv install phpenv \
    source ~/.bashrc \
    phpenv install 5.6.0 \
    phpenv global 5.6.0

# Entry point
# -----------
ENTRYPOINT /genie/entry.sh
