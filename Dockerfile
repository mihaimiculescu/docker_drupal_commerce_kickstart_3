FROM php:8.1-apache-bullseye

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	apt-get update; \
	apt-get install git -y; \
	apt-get install nano -y; \
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libwebp-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg=/usr \
		--with-webp \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
		bcmath \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

COPY --from=composer /usr/bin/composer /usr/local/bin/

# https://www.drupal.org/node/3060/release

RUN set -eux; \
	chown www-data:www-data /opt; \
	cd /opt; \
	rm -rf *
USER www-data:www-data
RUN	cd /opt; \
	export COMPOSER_HOME="$(mktemp -d)"; \
	composer create-project -s dev centarro/commerce-kickstart-project drupal; \
	cd drupal; \
	composer require drupal/commerce_demo:^3.0; \
	composer require drupal/jsonapi_resources ;\
	composer require drupal/jsonapi_menu_items;\
	composer require drupal/jsonapi_extras;\
	composer require drupal/jsonapi_hypermedia
USER root
RUN	rmdir /var/www/html; \
	ln -sf /opt/drupal/web /var/www/html; \
	rm -rf "$COMPOSER_HOME"
WORKDIR /opt/drupal
ENV PATH=${PATH}:/opt/drupal/bin:/opt/drupal/vendor/bin
