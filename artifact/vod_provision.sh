#!/bin/bash

vodnew=$1
if [ -z "$vodnew" ]
then
  vodnew="/vod/new"
fi

vidpath=`echo $vodnew/*.html`
vidfile=`basename $vidpath`
vid=${vidfile%%.*}
mp4path=`echo $vodnew/*.mp4`
mp4file=`basename $mp4path`

if [ -n "$vid" ]
then
  echo "mkdir /var/www/html/hls/$vid"
  mkdir /var/www/html/hls/$vid
fi

if [ -f "$mp4path" ] 
then
  echo "cp $mp4path /var/www/html/hls/$vid"
  cp $mp4path /var/www/html/hls/$vid
  echo "ffmpeg -i /var/www/html/hls/v0001/$vid/$mp4file ..."
  ffmpeg -i /var/www/html/hls/$vid/$mp4file -codec:v libx264 -profile:v baseline -level 3.0 -s 640x360 \
  -start_number 0 -hls_time 6 -hls_list_size 0 -f hls /var/www/html/hls/$vid/playlist.m3u8
  ls -al /var/www/html/hls/$vid
fi

if [ -f "$vodnew/$vid.html" ] 
then
  echo "cp $vodnew/$vid.html /var/www/html/hls"
  cp /vod/new/$vid.html /var/www/html/hls
fi
