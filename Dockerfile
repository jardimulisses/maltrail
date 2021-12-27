FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \ 
    && apt-get upgrade -y \
    && apt-get install -y git python3 python3-dev python3-pip python-is-python3 libpcap-dev build-essential procps schedtool cron \
    && pip3 install pcapy-ng \
    && git clone --depth=1 https://github.com/stamparm/maltrail.git /opt/maltrail \
    && python /opt/maltrail/core/update.py

RUN apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/Araguaina /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN touch /var/log/cron.log
COPY ./maltrail.conf /opt/maltrail/maltrail.conf

RUN (echo '*/1 * * * * if [ -n "$(ps -ef | grep -v grep | grep server.py)" ]; then : ; else python /opt/maltrail/server.py -c /opt/maltrail/maltrail.conf; fi >> /var/log/cron.log') | crontab
RUN (crontab -l ; echo '*/1 * * * * if [ -n "$(ps -ef | grep -v grep | grep sensor.py)" ]; then : ; else python /opt/maltrail/sensor.py -c /opt/maltrail/maltrail.conf; fi >> /var/log/cron.log') | crontab
RUN (crontab -l ; echo '0 1 * * * cd /opt/maltrail && git pull') | crontab
RUN (crontab -l ; echo '2 1 * * * /usr/bin/pkill -f maltrail') | crontab

EXPOSE 8337/udp
EXPOSE 8338/tcp

CMD bash -c "python /opt/maltrail/server.py &" && bash -c "python /opt/maltrail/sensor.py &" && cron && tail -f /var/log/cron.log
