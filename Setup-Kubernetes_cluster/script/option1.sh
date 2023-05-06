#!/bin/bash
swapoff -a
sed -i '/ swap / s/^(.*)$/#1/g' /etc/fstab #for fstab /etc/fstab
apt-get update
apt-get install -y apt-transport-https ca-certificates curl
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s \
https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

apt-get update
apt-get install -y kubelet kubeadm kubectl
systemctl enable kubelet

#join cluster
bash /home/script/join.sh