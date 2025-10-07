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
kubectl cp Istio_ingressgateway_virtualservice_part01.mp4 $pod:/var/www/html/hls/v0001
```

Now we come to the important part of creating an HLS package of video streaming contents from the media file. To this end, the ffmeg command is invoked to break down the media file into HLS streaming segments.
```
kubectl exec $pod -- ffmpeg -i /var/www/html/hls/v0001/Istio_ingressgateway_virtualservice_part01.mp4 \
-codec:v libx264 -profile:v baseline -level 3.0 -s 640x360 -start_number 0 \
-hls_time 6 -hls_list_size 0 -f hls /var/www/html/hls/v0001/playlist.m3u8
```

Each segment is identified ordinally by a ts file, playlist<N>.ts, which contains 6 seconds of video contents. The segment files are summarised in a list in the text file playlist.m3u8.
```
kubectl exec $pod -- ls -al /var/www/html/hls/v0001                                                  
total 16060
drwxr-xr-x 2 root root     4096 Oct  7 00:17 .
drwxrwxrwx 3 root root     4096 Oct  7 00:15 ..
-rw-r--r-- 1 root root     1101 Oct  7 00:17 playlist.m3u8
-rw-r--r-- 1 root root   203604 Oct  7 00:16 playlist0.ts
-rw-r--r-- 1 root root   194204 Oct  7 00:16 playlist1.ts
:::
-rw-r--r-- 1 root root   194392 Oct  7 00:17 playlist29.ts
-rw-r--r-- 1 root root   123140 Oct  7 00:17 playlist30.ts
:::
kubectl exec $pod -- ls -al /var/www/html/hls/v0001 -- cat /var/www/html/hls/v0001/playlist.m3u8
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:10
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:10.000000,
playlist0.ts
#EXTINF:10.000000,
playlist1.ts
#EXTINF:10.000000,
:::
playlist30.ts
#EXT-X-ENDLIST
```

It is these ts files together with the m3u8 metadata that are instrumental in the implementation of video streaming as they are pulled continuously in sequence by the client video player via standard HTTP GET requests. Henceforth, they will be served out as static, read-only files by the nginx web server in response to any on-demand requests for the media item concerned.

What we are going to do next is specific to this example of using a Killercoda playground to similate a kubernetes cluster running on cloud. Unlike 



