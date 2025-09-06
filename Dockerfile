FROM nginx:1.25-alpine

COPY nginx/nginx.conf /etc/nginx/nginx.conf

COPY public /usr/share/nginx/html/public
COPY admin /usr/share/nginx/html/admin
COPY files/      /usr/share/nginx/html/files
COPY morefiles/ /usr/share/nginx/html/morefiles
COPY js/    /usr/share/nginx/html/js
COPY index.html /usr/share/nginx/html
COPY submit.html /usr/share/nginx/html
COPY 403.html /usr/share/nginx/html


RUN chmod -R 755 /usr/share/nginx/html
RUN ln -s /var/log/nginx/http_intercept.log /usr/share/nginx/html/logs.txt

EXPOSE 80 443

