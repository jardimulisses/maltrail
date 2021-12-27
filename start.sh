#!/bin/sh
docker kill maltrail-docker
docker rm maltrail-docker
docker run -d -e TZ=America/Araguaina --name maltrail-docker --privileged -p 8337:8337 -p 8338:8338 -v /var/log/maltrail/:/var/log/maltrail/ maltrail
