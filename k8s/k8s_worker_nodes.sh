#!/usr/bin/env bash

sudo kubeadm join --token abcdef.1234567890abcdef $1:6443 \
    --discovery-token-unsafe-skip-ca-verification