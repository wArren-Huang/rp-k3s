#!/bin/bash
set -e;

kafka_config_file="$KAFKA_CONFIGDIR/server.properties"

function generate_config_file_from_env() {
  if [[ -z "$KAFKA_CONFIGDIR" ]]; then
    echo "KAFKA_CONFIGDIR is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$KAFKA_LOGDIR" ]]; then
    echo "KAFKA_LOGDIR is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
    echo "KAFKA_ZOOKEEPER_CONNECT is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$KAFKA_LOG_RETENTION_MS" ]]; then
    echo "KAFKA_LOG_RETENTION_MS is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$KAFKA_LOG_RETENTION_BYTES" ]]; then
    echo "KAFKA_LOG_RETENTION_BYTES is a mandatory environment variable"
    exit 1
  fi
}

broker.id=0
log.dirs=/tmp/kafka-logs
log.retention.ms=-1
log.retention.bytes=-1
advertised.listeners=