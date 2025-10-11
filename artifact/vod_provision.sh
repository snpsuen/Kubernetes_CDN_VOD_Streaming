#!/bin/bash

vid=`awk -F: '{print $1}' /vod/new/summary.txt`
file=`awk -F: '{print $2}' /vod/new/summary.txt`

if [ -n "$vid" ]
then
  echo "mkdir /var/www/html/hls/$vid"
  mkdir /var/www/html/hls/$vid
fi

if [ -f "/vod/new/$file" ] 
then
  echo "cp /vod/new/$file /var/www/html/hls/$vid"
  cp /vod/new/$file /var/www/html/hls/$vid
  echo "ffmpeg -i /var/www/html/hls/v0001/$vid/$file ..."
  ffmpeg -i /var/www/html/hls/v0001/$vid/$file -codec:v libx264 -profile:v baseline -level 3.0 -s 640x360 \
  -start_number 0 -hls_time 6 -hls_list_size 0 -f hls /var/www/html/hls/v0001/playlist.m3u8
  ls -al /var/www/html/hls/v0001/$vid
fi

if [ -f "/vod/new/$vid.html" ] 
then
  echo "cp /vod/new/$vid.html /var/www/html"
  cp /vod/new/$vid.html /var/www/html
fi
