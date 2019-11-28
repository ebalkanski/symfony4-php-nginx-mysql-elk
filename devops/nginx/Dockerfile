FROM nginx:stable

EXPOSE 80
EXPOSE 443

COPY ./config/nginx.conf /etc/nginx/
COPY ./config/upstream.conf /etc/nginx/conf.d/
COPY ./config/server.conf /etc/nginx/conf.d/