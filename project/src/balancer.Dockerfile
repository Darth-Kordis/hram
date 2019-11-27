FROM nginx:latest

RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Samara /etc/localtime
RUN mkdir /opt/front-end/
COPY ./app/front-end/ /opt/front-end/
RUN chmod -R 775 /opt/front-end/
RUN rm -r /etc/nginx/*
COPY ./balancer/nginx/. /etc/nginx/
RUN chmod -R 775 /etc/nginx/

RUN apt-get update --fix-missing && \
    apt-get install -y mc && \
    apt-get install -y net-tools









COPY ./balancer/nginx.sh /etc/nginx/
RUN chmod +x /etc/nginx/nginx.sh
EXPOSE 80
#ENTRYPOINT ["/etc/nginx/nginx.sh"]