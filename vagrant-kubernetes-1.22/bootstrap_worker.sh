#!/bin/bash

echo "[TASK 1] Join node to Kubernetes Cluster"
apt install -qq -y sshpass >/dev/null 2>&1
sshpass -p "kube" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no controlplane-22:/root/joincluster.sh /root/joincluster.sh 2>/dev/null
bash /root/joincluster.sh >/dev/null 2>&1
