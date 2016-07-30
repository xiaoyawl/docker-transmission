FROM benyoo/centos-core:7.2.1511.20160706

MAINTAINER from www.dwhd.org by lookback (mondeolove@gmail.com)

ARG VERSION=${VERSION:-2.92}

ENV DATA_DIR=/data/ \
	CONF_DIR=/etc/transmission-daemon \
	TEMP_DIR=/tmp/transmission \
	TR_WEB_DIR=/usr/local/share/transmission \
	WEB_FILE_URL="https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz"

RUN set -x && \
	mkdir -p ${TEMP_DIR} ${DATA_DIR} ${CONF_DIR} && \
	cd ${TEMP_DIR} && \
	yum install gcc gcc-c++ make libcurl-devel libevent-devel zlib-devel openssl openssl-devel intltool -y && \
	curl -Lk https://download.transmissionbt.com/files/transmission-${VERSION}.tar.xz|xz -d| tar x -C ./ && \
	cd transmission-${VERSION}/ && \
	./configure && \
	make -j $(awk '/processor/{i++}END{print i}' /proc/cpuinfo) && make install && cd .. && \
	mv ${TR_WEB_DIR}/web/{index.html,index.original.html} && \
	curl -Lk ${WEB_FILE_URL} | gunzip | tar x -C ${TR_WEB_DIR} && \
	yum remove gcc gcc-c++ make libcurl-devel libevent-devel zlib-devel openssl openssl-devel intltool -y && \
	yum clean all && \
	rm -rf ${TEMP_DIR} /var/cache/{yum,ldconfig} && \
	mkdir -pv --mode=0755 /var/cache/{yum,ldconfig}

EXPOSE 9091 51413/tcp 51413/udp

ADD entrypoint.sh /entrypoint.sh
ADD settings.json ${CONF_DIR}/settings.json
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
#CMD ["transmission-daemon"]
