FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto \
    JDK_HOME=/usr/lib/jvm/java-11-amazon-corretto \
    JAVA_VERSION=11
RUN set -eux; \
    apt-get update -q; \
    apt-get dist-upgrade -y && \
    apt-get install -y \
        gnupg \
        curl \
        netcat \
        net-tools \
        dnsutils \
        iputils-ping \
        traceroute && \
    curl -sSL https://apt.corretto.aws/corretto.key | apt-key add - && \
    echo 'deb https://apt.corretto.aws stable main' > /etc/apt/sources.list.d/corretto.list && \
    apt-get update -q; \
    apt-get install -y java-11-amazon-corretto-jdk && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*;
