FROM ubuntu:20.04 AS downloader
ARG KAFKA_VERSION=2.7.0
ARG SCALA_VERSION=2.13
ARG KAFKA_USER=kafka
ARG KAFKA_GROUP=kafka
COPY KEYS .
RUN set -eux; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install -y \
      curl \
      gnupg;
RUN set -eux; \
    curl -sSOL "https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"; \
    curl -sSOL "https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc"; \
    gpg --import KEYS; \
    gpg --batch --verify "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc" "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"; \
    tar -zxf "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz";
RUN set -eux; \
    groupadd -r ${KAFKA_GROUP} --gid=1000; \
    useradd -r -g ${KAFKA_GROUP} --uid=1000 ${KAFKA_USER}; \
    mv kafka_${SCALA_VERSION}-${KAFKA_VERSION} kafka_${SCALA_VERSION}-${KAFKA_VERSION}-bin; \
    chown -R ${KAFKA_USER}:${KAFKA_GROUP} kafka_${SCALA_VERSION}-${KAFKA_VERSION}-bin;

FROM warrenhuang/corretto:ubuntu2004-jdk11.0.10
ARG KAFKA_DIR=/opt/kafka
ARG KAFKA_USER=kafka
ARG KAFKA_GROUP=kafka
ENV KAFKA_LOGDIR=/log
COPY --from=downloader /kafka_*-bin ${KAFKA_DIR}
# COPY *.sh "${KAFKA_DIR}/bin/"
# RUN set -eux; \
#     groupadd -r ${KAFKA_GROUP} --gid=1000; \
#     useradd -r -g ${KAFKA_GROUP} --uid=1000 ${KAFKA_USER}; \
#     mkdir -p "$ZK_DATA_LOG_DIR" "$ZK_DATA_DIR" "$ZK_CONF_DIR" "$ZK_LOG_DIR"; \
#     chown ${KAFKA_USER}:${KAFKA_GROUP} "$ZK_DATA_LOG_DIR" "$ZK_DATA_DIR" "$ZK_CONF_DIR" "$ZK_LOG_DIR"; \
#     mv "${ZK_DIR}/conf/"* "$ZK_CONF_DIR";
# WORKDIR ${ZK_DIR}
# USER zookeeper
# VOLUME ["$ZK_DATA_DIR", "$ZK_DATA_LOG_DIR", "$ZK_LOG_DIR"]
# EXPOSE 2181 2888 3888
# ENV PATH=${ZK_DIR}/bin:$PATH \
#     ZOOCFGDIR=$ZK_CONF_DIR \
#     ZOO_LOG_DIR=$ZK_LOG_DIR
# ENTRYPOINT ["docker-entrypoint.sh"]
# CMD ["zkServer.sh", "start-foreground"]
# HEALTHCHECK --interval=5s --timeout=5s --start-period=5s --retries=3 CMD [ "healthcheck.sh" ]