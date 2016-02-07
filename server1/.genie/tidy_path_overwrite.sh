#!/bin/bash

sed -i 's/"buffio.h"/"tidybuffio.h"/' /tmp/php-build/source/*/ext/tidy/*.c
sed -i '/\-\-with\-tidy/d' /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/default_configure_options
sed -i '/\-\-with\-apxs2/d' /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/default_configure_options
echo '--with-tidy=/usr/local' >> /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/default_configure_options
echo '--with-apxs2=/usr/bin/apxs' >> /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/default_configure_options
