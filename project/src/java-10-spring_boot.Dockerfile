FROM adoptopenjdk/openjdk10:latest

RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Samara /etc/localtime

RUN mkdir /opt/front-end/
RUN mkdir /opt/back-end/
RUN mkdir /opt/back-end/logs/

COPY ./app/back-end/business-logic-0.0.1-SNAPSHOT.jar /opt/back-end/
COPY ./app/front-end/ /opt/front-end/

RUN chmod -R 775 /opt/back-end/
RUN chmod -R 775 /opt/front-end/

RUN apt-get update --fix-missing && \
    apt-get install -y nginx && \
    apt-get install -y supervisor
	
	
RUN rm /etc/supervisor/supervisord.conf
COPY ./app/supervisord.conf /etc/supervisor/
RUN chmod -R 775 /etc/supervisor/

RUN rm -r /etc/nginx/*
COPY ./nginx/. /etc/nginx/
RUN chmod -R 775 /etc/nginx/
RUN useradd --no-create-home nginx

COPY ./ssh /tmp/.ssh
RUN mv /tmp/.ssh/sshd_start /usr/local/bin/sshd_start && chmod +x /usr/local/bin/sshd_start

EXPOSE 22
EXPOSE 80
EXPOSE 8080
#RUN sh -c 'touch /opt/back-end/business-logic-0.0.1-SNAPSHOT_external.jar'

CMD ["/usr/bin/supervisord"]