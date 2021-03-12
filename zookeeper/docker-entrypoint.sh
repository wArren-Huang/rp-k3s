#!/bin/bash
set -e;

zk_config_file="$ZK_CONF_DIR/zoo.cfg"
zk_id_file="$ZK_DATA_DIR/myid"

function generate_config_file_from_env() {
  if [[ -z "$ZK_CONF_DIR" ]]; then
    echo "ZK_CONF_DIR is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$ZK_DATA_DIR" ]]; then
    echo "ZK_DATA_DIR is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$ZK_DATA_LOG_DIR" ]]; then
    echo "ZK_DATA_LOG_DIR is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$ZK_TICK_TIME" ]]; then
    echo "ZK_TICK_TIME is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$ZK_INIT_LIMIT" ]]; then
    echo "ZK_INIT_LIMIT is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$ZK_SYNC_LIMIT" ]]; then
    echo "ZK_SYNC_LIMIT is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$ZK_AUTOPURGE_PURGEINTERVAL" ]]; then
    echo "ZK_AUTOPURGE_PURGEINTERVAL is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$ZK_AUTOPURGE_SNAPRETAINCOUNT" ]]; then
    echo "ZK_AUTOPURGE_SNAPRETAINCOUNT is a mandatory environment variable"
    exit 1
  fi
  if [[ -z "$ZK_SERVERS" ]] || [[ ${#ZK_SERVERS[@]} == 0 ]]; then
    if [[ -z "$ZK_REPLICAS" ]]; then
      echo "ZK_REPLICAS is a mandatory environment variable when ZK_SERVERS does not contain valid server list"
      exit 1
    fi
    host_name=$(hostname -s)
    domain_name=$(hostname -d)
    if [[ $host_name =~ (.*)-([0-9]+)$ ]]; then
      hostname_prefix=${BASH_REMATCH[1]}
      ordinal=${BASH_REMATCH[2]}
      if [[ ! -f $zk_id_file ]]; then        
        id=$(($ordinal+1))
        echo $id > $zk_id_file
        echo ""
        echo "Generated $zk_id_file file"
        echo "=================================================="
        cat $zk_id_file
        echo "=================================================="
        echo ""
      else
        echo ""
        echo "$zk_id_file already exist as below"
        echo "=================================================="
        cat $zk_id_file
        echo "=================================================="
      fi
      if [[ ! -z $domain_name ]]; then
        domain_name=".$domain_name"
      fi
      ZK_SERVERS=()
      for (( i=0; i<$ZK_REPLICAS; i++ )) do
        ZK_SERVERS+=("server.$((i+1))=$hostname_prefix-$i$domain_name:2888:3888")
      done
    else
        echo "Environment variable ZK_SERVERS does not contain valid server list and failed to extract ordinal from hostname $host_name"
        exit 1
    fi
  fi

  rm -f $zk_config_file
  echo "# This is an auto generated file by [${BASH_SOURCE-$0}], modification may not persist across reboots" >> $zk_config_file
  echo "clientPort=2181" >> $zk_config_file
  echo "dataDir=$ZK_DATA_DIR" >> $zk_config_file
  echo "dataLogDir=$ZK_DATA_LOG_DIR" >> $zk_config_file
  echo "tickTime=$ZK_TICK_TIME" >> $zk_config_file
  echo "initLimit=$ZK_INIT_LIMIT" >> $zk_config_file
  echo "syncLimit=$ZK_SYNC_LIMIT" >> $zk_config_file
  echo "4lw.commands.whitelist=stat, ruok, mntr" >> $zk_config_file
  echo "autopurge.snapRetainCount=$ZK_AUTOPURGE_SNAPRETAINCOUNT" >> $zk_config_file
  echo "autopurge.purgeInterval=$ZK_AUTOPURGE_PURGEINTERVAL" >> $zk_config_file
  for server in ${ZK_SERVERS[@]}; do
    echo "$server" >> "$zk_config_file"
  done
  echo ""
  echo "Generated $zk_config_file file"
  echo "=================================================="
  cat $zk_config_file
  echo "=================================================="
  echo ""
}

generate_config_file_from_env
exec "$@"