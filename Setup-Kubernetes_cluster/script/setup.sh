#!/bin/bash
hostname=$(hostname -s)
user=$(whoami)

cat <<- _EOF_ | sudo tee /etc/modules-load.d/modules.conf
overlay
br_netfilter
_EOF_

modprobe overlay
modprobe br_netfilter

cat <<- _EOF_ | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
_EOF_

sysctl --system

apt-get update
apt-get install ca-certificates curl gnupg lsb-release -y

mkdir -m 0755 -p /etc/apt/keyrings
cmd=$(curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg)
mkdir -m 0755 -p /etc/apt/sources.list.d
cmd=$(echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null)

apt-get update
apt-get install containerd.io
cmd=$(sed -i 's/disabled_plugins/#disabled_plugins/g' /etc/containerd/config.toml)

#edit containerd configuration
cat <<- _EOF_ | tee /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
_EOF_

systemctl restart containerd
systemctl enable containerd

