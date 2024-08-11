#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y kubelet=$1 kubectl=$1 kubeadm=$1 containerd.io=$2

sudo apt-mark hold kubelet kubectl kubeadm

sudo containerd config default > /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

sudo crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock --set image-endpoint=unix:///run/containerd/containerd.sock

cat <<EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS=--node-ip=${3}
EOF

sudo systemctl daemon-reload

sudo systemctl restart containerd
sudo systemctl enable containerd

sudo systemctl restart kubelet
sudo systemctl enable kubelet