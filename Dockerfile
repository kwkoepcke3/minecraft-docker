FROM docker.io/fedora:40 AS builder

WORKDIR /opt/minecraft/build

RUN dnf update -y
RUN dnf install -y make gcc

COPY ./mcrcon/ ./mcrcon/
WORKDIR /opt/minecraft/build/mcrcon
RUN make clean
RUN make

FROM docker.io/fedora:40

ARG JRE_VERSION="21"

RUN groupadd --non-unique --gid 988 minecraft
RUN useradd minecraft -u 990 -g 988 --system -s /bin/bash

RUN dnf install -y adoptium-temurin-java-repository
RUN sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/adoptium-temurin-java-repository.repo
RUN dnf install -y cronie python3 python3-pip temurin-${JRE_VERSION}-jre supervisor procps-ng
RUN dnf clean all
RUN pip install dotenv

# ASSUME MINECRAFT SERVER IS AT /opt/minecraft/run/server
WORKDIR /opt/minecraft/run

COPY --from=builder /opt/minecraft/build/mcrcon/mcrcon /bin/mcrcon
COPY ./backup ./backup
COPY ./sendmail ./sendmail
COPY ./systemd ./systemd
COPY ./supervisord.conf /etc/supervisord.conf

RUN echo "0 3,15 * * * root /opt/minecraft/run/backup/backup.sh" > /etc/cron.d/mycron
RUN chmod 0644 /etc/cron.d/mycron
RUN crontab /etc/cron.d/mycron
RUN touch /var/log/cron.log

RUN chown root:minecraft -R /opt/minecraft

# server, rcon
EXPOSE 25565 25575

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
