#!/usr/bin/env bash

sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v${1}/config/manifests/metallb-native.yaml

sudo kubectl get configmap kube-proxy -n kube-system -o yaml | \
    sed -e "s/mode: \"\"/mode: \"ipvs\"/" | \
sudo kubectl apply -f - -n kube-system

sudo kubectl get configmap kube-proxy -n kube-system -o yaml | \
    sed -e "s/strictARP: false/strictARP: true/" | \
sudo kubectl apply -f - -n kube-system

sudo kubectl delete validatingwebhookconfigurations metallb-webhook-configuration

sleep 600

cat <<EOF | sudo kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
    name: first-pool
    namespace: metallb-system
spec:
    addresses:
    - ${2}.11-${2}.31
    autoAssign: true
EOF

sleep 540

cat <<EOF | sudo kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
    name: layer2-mode
    namespace: metallb-system
spec:
    ipAddressPools:
    - first-pool
EOF
