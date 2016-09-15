docker-transmission
===================

Transmission Daemon Docker Container

Application container, don't forget to specify a password for `transmission` account and local directory for the downloads:

```
    docker run -d --name transmission \
    -p 51413:51413 -p 51413:51413/udp -p 9091:9091 \
    -e ADMIN_PASS=password \
    -e ADMIN_USER=lookback
    -v /data/transmission:/data \
    benyoo/transmission
```
