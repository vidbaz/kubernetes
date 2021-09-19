#!/bin/bash

echo "[TASK: Pull required containers]"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK: Initialize Kubernetes Cluster]"
kubeadm init --apiserver-advertise-address=172.28.128.20 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null

echo "[TASK: Set kubeconfig configuration]"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[TASK: Deploy Calico network cni plugin]" #https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises
kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml >/dev/null 2>&1
# echo "[TASK: Deploy Calico network with tigera operator]" #https://docs.projectcalico.org/getting-started/kubernetes/quickstart
# kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml > /dev/null 2>&1
# kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml > /dev/null 2>&1

# echo "[TASK: Deploy Weave network cni plugin]"
# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" >/dev/null 2>&1

echo "[TASK: Generate and save cluster join command to /root/joincluster.sh]"
kubeadm token create --print-join-command > /root/joincluster.sh 2>/dev/null

