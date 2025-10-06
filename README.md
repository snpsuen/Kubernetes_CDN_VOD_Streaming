![Kubernetes_VOD_Streaming](kubernetes_vod_streaming.png)

In this hands on exercise, we ilustrate how to set up a CDN building block on Kubenetes in a handy use case of provisioing and delivering a vod stream from a sample media file.
1. Deploy a CDN origin based on Kubernetes on cloud
2. Provision video contents for streaming from CDN origin
3. Deploy a CDN edge based on Kubernetes on premises

### 1 CDN origin based on Kubernetes on cloud

We uses a Killercoda Kubernetes playground to simiate a Kubernetes cluster running on cloud.
Apply the manifest file nginx-hls.yaml from this repo to create the nginx pods and service for the CDN origin.
```
kubectl create -f https://raw.githubusercontent.com/snpsuen/Kubernetes_CDN_VOD_Streaming/refs/heads/main/artifact/nginx-hls.yaml
```
