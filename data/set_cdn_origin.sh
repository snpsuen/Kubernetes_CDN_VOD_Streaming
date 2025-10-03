#!/bin/bash
set -e
echo "kubectl create -f https://raw.githubusercontent.com/snpsuen/Deep_Learning_Data/refs/heads/main/script/nginx-hls.yaml"
kubectl create -f https://raw.githubusercontent.com/snpsuen/Deep_Learning_Data/refs/heads/main/script/nginx-hls.yaml
sleep 1
kubectl get pods
pod=`kubectl get pod -o jsonpath='{.items[0].metadata.name}'`

echo "kubectl exec $pod -- mkdir /var/www/html/hls/v0001"
kubectl exec $pod -- mkdir /var/www/html/hls/v0001
echo "kubectl cp Istio_ingessgateway_virtualservice_part01.mp4 $pod:/var/www/html/hls/v0001"
kubectl cp Istio_ingessgateway_virtualservice_part01.mp4 $pod:/var/www/html/hls/v0001

echo "kubectl exec $pod -- ffmpeg -i /var/www/html/hls/v0001/Istio_ingessgateway_virtualservice_part01.mp4 ..."
kubectl exec $pod -- ffmpeg -i /var/www/html/hls/v0001/Istio_ingessgateway_virtualservice_part01.mp4 \
-codec:v libx264 -profile:v baseline -level 3.0 -s 640x360 -start_number 0 \
-hls_time 6 -hls_list_size 0 -f hls /var/www/html/hls/v0001/playlist.m3u8
kubectl exec $pod -- ls -al /var/www/html/hls/v0001

echo "kubectl cp v0001.html $pod:/var/www/html"
kubectl cp v0001.html $pod:/var/www/html

