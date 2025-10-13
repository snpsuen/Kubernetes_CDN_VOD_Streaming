#!/bin/bash
set -e
echo "kubectl create -f https://raw.githubusercontent.com/snpsuen/Kubernetes_CDN_VOD_Streaming/refs/heads/main/artifact02/nginx-hls.yaml"
kubectl create -f https://raw.githubusercontent.com/snpsuen/Kubernetes_CDN_VOD_Streaming/refs/heads/main/artifact02/nginx-hls.yaml

mkdir -p /root/vod/new
ssh node01 mkdir -p /root/vod/new
git clone https://github.com/snpsuen/Kubernetes_CDN_VOD_Streaming
cp Kubernetes_CDN_VOD_Streaming/artifact/*.mp4 /root/vod/new
cp Kubernetes_CDN_VOD_Streaming/artifact02/*.html /root/vod/new
scp Kubernetes_CDN_VOD_Streaming/artifact/*.mp4 node01:/root/vod/new
scp Kubernetes_CDN_VOD_Streaming/artifact02/*.html node01:/root/vod/new

echo "kubectl create -f https://raw.githubusercontent.com/snpsuen/Kubernetes_CDN_VOD_Streaming/refs/heads/main/artifact02/vod_provision_job.yaml"
kubectl create -f https://raw.githubusercontent.com/snpsuen/Kubernetes_CDN_VOD_Streaming/refs/heads/main/artifact02/vod_provision_job.yaml
