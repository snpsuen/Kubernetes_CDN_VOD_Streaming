![Kubernetes_VOD_Streaming](kubernetes_vod_streaming.png)

In this hands on exercise, we ilustrate how to set up a CDN building block on Kubenetes in a nifty use case of provisioning and delivering a vod stream from a sample media file.
1. Deploy a CDN origin based on Kubernetes on cloud
2. Provision video contents for streaming from CDN origin
3. Deploy a CDN edge based on Kubernetes on premises

### 1 CDN origin based on Kubernetes on cloud

We uses a Killercoda Kubernetes playground to simiate a Kubernetes cluster running on cloud.
Apply the manifest file nginx-hls.yaml from this repo to create the nginx pods and service for the CDN origin.
```
kubectl create -f https://raw.githubusercontent.com/snpsuen/Kubernetes_CDN_VOD_Streaming/refs/heads/main/artifact/nginx-hls.yaml
```

The pods run on a customised nginx docker image, snpsuen/nginx-hls:v01 with two specific features or "toppings" baked in.

First, the ffmeg package is required to provision the streaming contents of a given video media file.
```
apt intstall ffmeg
```

Furthermore a user defined nginx config file is put in place to specify how the nginx web server should run at the CDN origin. In parituclar, the server is configured to support the hosting of the MIME types for HLS streaming contents.
```
server {
    listen 8000;
    root /var/www/html;

    location /hls {
        add_header 'Access-Control-Allow-Origin' '*' always;
        root /var/www/html;   # put your HLS files in /var/www/html/hls
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
        add_header 'Cache-Control' 'no-cache';
    }
}
```

