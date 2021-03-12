FROM ubuntu:20.04 AS downloader
ARG ZK_VERSION=3.6.2
ARG ZK_USER=zookeeper
ARG ZK_GROUP=zookeeper
COPY KEYS .
RUN set -eux; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install -y \
      curl \
      gnupg;
RUN set -eux; \
    curl -sSOL "https://archive.apache.org/dist/zookeeper/zookeeper-${ZK_VERSION}/apache-zookeeper-${ZK_VERSION}-bin.tar.gz"; \
    curl -sSOL "https://archive.apache.org/dist/zookeeper/zookeeper-${ZK_VERSION}/apache-zookeeper-${ZK_VERSION}-bin.tar.gz.asc"; \
    gpg --import KEYS; \
    gpg --batch --verify "apache-zookeeper-${ZK_VERSION}-bin.tar.gz.asc" "apache-zookeeper-${ZK_VERSION}-bin.tar.gz"; \
    tar -zxf "apache-zookeeper-${ZK_VERSION}-bin.tar.gz";
RUN set -eux; \
    groupadd -r ${ZK_GROUP} --gid=1000; \
    useradd -r -g ${ZK_GROUP} --uid=1000 ${ZK_USER}; \
    chown -R ${ZK_USER}:${ZK_GROUP} apache-zookeeper-${ZK_VERSION}-bin;

FROM warrenhuang/corretto:ubuntu2004-jdk11.0.10
ARG ZK_DIR=/opt/zookeeper
ARG ZK_USER=zookeeper
ARG ZK_GROUP=zookeeper
ENV ZK_CONF_DIR=/conf \
    ZK_DATA_DIR=/data \
    ZK_DATA_LOG_DIR=/datalog \
    ZK_LOG_DIR=/log \
    ZK_TICK_TIME=2000 \
    ZK_INIT_LIMIT=5 \
    ZK_SYNC_LIMIT=2 \
    ZK_AUTOPURGE_PURGEINTERVAL=0 \
    ZK_AUTOPURGE_SNAPRETAINCOUNT=3
COPY --from=downloader /apache-zookeeper-*-bin ${ZK_DIR}
COPY *.sh "${ZK_DIR}/bin/"
RUN set -eux; \
    groupadd -r ${ZK_GROUP} --gid=1000; \
    useradd -r -g ${ZK_GROUP} --uid=1000 ${ZK_USER}; \
    mkdir -p "$ZK_DATA_LOG_DIR" "$ZK_DATA_DIR" "$ZK_CONF_DIR" "$ZK_LOG_DIR"; \
    chown ${ZK_USER}:${ZK_GROUP} "$ZK_DATA_LOG_DIR" "$ZK_DATA_DIR" "$ZK_CONF_DIR" "$ZK_LOG_DIR"; \
    mv "${ZK_DIR}/conf/"* "$ZK_CONF_DIR";
WORKDIR ${ZK_DIR}
USER zookeeper
VOLUME ["$ZK_DATA_DIR", "$ZK_DATA_LOG_DIR", "$ZK_LOG_DIR"]
EXPOSE 2181 2888 3888
ENV PATH=${ZK_DIR}/bin:$PATH \
    ZOOCFGDIR=$ZK_CONF_DIR \
    ZOO_LOG_DIR=$ZK_LOG_DIR
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["zkServer.sh", "start-foreground"]
HEALTHCHECK --interval=5s --timeout=5s --start-period=5s --retries=3 CMD [ "healthcheck.sh" ]