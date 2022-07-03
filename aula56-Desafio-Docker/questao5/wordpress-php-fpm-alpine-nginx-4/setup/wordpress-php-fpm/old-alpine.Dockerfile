FROM alpine:3.16.0

RUN apk update && apk upgrade
RUN apk add bash
#RUN apk add nginx
RUN apk add php8 php8-fpm php8-opcache
RUN apk add php8-gd php8-zlib php8-curl

#COPY server/etc/nginx /etc/nginx
#COPY server/etc/php /etc/php8
#COPY src /usr/share/nginx/html
RUN mkdir /var/run/php
#EXPOSE 80
#EXPOSE 443
#STOPSIGNAL SIGTERM
EXPOSE 9000
#CMD ["/bin/bash", "-c", "php-fpm8 && chmod 777 /var/run/php/php8-fpm.sock && chmod 755 /usr/share/nginx/html/* && nginx -g 'daemon off;'"]

RUN apk add php8-common php8-session php8-iconv php8-json php8-gd php8-curl php8-xml php8-mysqli php8-imap php8-cgi fcgi php8-pdo php8-pdo_mysql php8-soap php8-posix php8-gettext php8-ldap php8-ctype php8-dom php8-simplexml
RUN mkdir -p /var/www/html
RUN mkdir -p /usr/src/wordpress/
RUN apk add less vim git mysql-client libssh2 curl libpng freetype libjpeg-turbo libgcc libxml2 libstdc++ icu-libs libltdl libmcrypt
COPY --from=base /usr/src/wordpress/ /usr/src/wordpress/
WORKDIR /var/www/html
COPY --from=base /var/www/html /var/www/html
CMD ["php-fpm8"]