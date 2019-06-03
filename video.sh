#!/bin/bash
# See https://wiki.matthiasbock.net/index.php/Logitech_C920,_streaming_H.264

DT=$( /usr/bin/date +%Y-%m-%d-%H-%M-%S )

echo Recording video to ${DT}.mp4

cvlc v4l2:///dev/video0:chroma=h264:width=1920:height=1080 --sout="#std{access=file,dst=${DT}.mp4}"
