#!/bin/bash

cmd=$(swapoff -a)
cmd=$(sed -i '/ swap / s/^(.*)$/#1/g' /etc/fstab)

cmd=$(apt-get update)
cmd=$(apt-get install -y apt-transport-https ca-certificates curl)

cmd=$(mkdir -m 0755 -p /etc/apt/keyrings)
cmd=$(curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg)
cmd=$(echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list)

cmd=$(curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl")

cmd=$(chmod +x ./kubectl)
cmd=$(mv ./kubectl /usr/local/bin/kubectl)

cmd=$(apt-get update)
cmd=$(apt-get install -y kubelet kubeadm kubectl)
cmd=$(systemctl enable kubelet)

#join cluster
cmd=$(bash /home/script/join.sh)