#!/bin/bash

# Change index first
node_index="7"
# Change index first

node_hostname="node-${node_index}"
node_ip_address="192.168.11.20${node_index}/23"
node_gateway="192.168.11.2"
node_nameserver="192.168.11.12"

sudo sed -i "s/ports.ubuntu.com/192.168.11.16/g" /etc/apt/sources.list
sudo apt update && \
sudo apt full-upgrade -y && \
sudo apt autoremove -y && \
sudo apt clean

sudo hostnamectl set-hostname "${node_hostname}" && \
sudo sed -i "s/preserve_hostname: false/preserve_hostname: true/g" /etc/cloud/cloud.cfg && \
sudo sed -i "s/127.0.0.1 localhost/127.0.0.1 localhost ${node_hostname}/g" /etc/hosts && \
hostnamectl | grep "Static hostname:"
cat /etc/cloud/cloud.cfg | grep "preserve_hostname: true"
cat /etc/hosts | grep "127.0.0.1 localhost "

cat <<EOF > ./99-disable-network-config.cfg
network: {config: disabled}
EOF
cat <<EOF > ./00-installer-config.yaml
network:
    ethernets:
        eth0:
            dhcp4: false
            optional: false
            addresses: [node_ip_address_to_be_changed]
            gateway4: node_gateway_to_be_changed
            nameservers:
              addresses: [node_nameserver_to_be_changed]
    version: 2
EOF
sudo mv ./99-disable-network-config.cfg /etc/cloud/cloud.cfg.d/
sudo mv ./00-installer-config.yaml /etc/netplan/
sudo sed -i "s|node_ip_address_to_be_changed|${node_ip_address}|g" /etc/netplan/00-installer-config.yaml && \
sudo sed -i "s|node_gateway_to_be_changed|${node_gateway}|g" /etc/netplan/00-installer-config.yaml && \
sudo sed -i "s|node_nameserver_to_be_changed|${node_nameserver}|g" /etc/netplan/00-installer-config.yaml
cat /etc/netplan/00-installer-config.yaml | grep "addresses:"
cat /etc/netplan/00-installer-config.yaml | grep "gateway4:"





# sudo sed -i "s/192.168.11.16/mirrors.aliyun.com/g" /etc/apt/sources.list
# sudo sed -i "s/mirrors.aliyun.com/192.168.11.16/g" /etc/apt/sources.list