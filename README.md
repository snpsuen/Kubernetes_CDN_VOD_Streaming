![Kubernetes_VOD_Streaming](kubernetes_vod_streaming.png)

In this hands on exercise, we ilustrate how to set up a CDN building block on Kubenetes in a nifty use case of provisioning and delivering a vod stream from a sample media file.
1. Deploy a CDN origin based on Kubernetes on cloud
2. Provision video contents for streaming from the CDN origin
3. Deploy a CDN edge based on Kubernetes on premises

### 1. CDN origin on Kubernetes on cloud

We uses a Killercoda Kubernetes playground to simiate a Kubernetes cluster running on cloud.
Apply the manifest file nginx-hls.yaml from this repo to create the nginx pods and service for the CDN origin.
```
kubectl create -f https://raw.githubusercontent.com/snpsuen/Kubernetes_CDN_VOD_Streaming/refs/heads/main/artifact/nginx-hls.yaml
```

The pods run on a customised nginx docker image, snpsuen/nginx-hls:v01 with two specific features or "toppings" baked in.

First, the ffmeg package is installed in order to provision the streaming contents of a given video media file.
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

### 2. Provision VOD streaming contents at the CDN origin

Imperative actions need to be taken in this step to inject the VOD data to the nginx servers. 
Suppose you have uploaded a given video media file to the Killercoda playgound. For example, let's refer to a mp4 file called Istio_ingessgateway_virtualservice_part01.mp4. Copy the file from a Kubernetes node to the web directory shared between the nginx-hls pods to store HLS streaming contents.
```
pod=`kubectl get pods -o jsonpath='{.items[?(@.metadata.labels.app=="nginx-hls")].metadata.name}' | head -1`
kubectl exec $pod -- mkdir /var/www/html/hls/v0001
kubectl cp Istio_ingessgateway_virtualservice_part01.mp4 $pod:/var/www/html/hls/v0001
```





