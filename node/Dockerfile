FROM node:18-alpine

RUN apk update --no-cache && apk --no-cache add git perl
RUN apk add g++ make py3-pip
RUN apk --no-cache add tzdata
ENV TZ Europe/Paris
RUN apk --update add --no-cache openssh bash \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:password" | chpasswd \
  && rm -rf /var/cache/apk/*
# Defining the Port 22 for service
RUN sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

#CMD ["/bin/sh","/etc/start.sh"] 