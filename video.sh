#!/bin/bash
# See https://wiki.matthiasbock.net/index.php/Logitech_C920,_streaming_H.264
# and https://stackoverflow.com/questions/49846400/raspberry-pi-use-vlc-to-stream-webcam-logitech-c920-h264-video-without-tran

TIMEOUT=600

while true
do
	DT=$( /usr/bin/date +%Y-%m-%d-%H-%M-%S )
	df -h /
	echo Recording video to ${DT}.mp4
	echo long press Ctrl+C to abort.
	echo Do vlc http://localhost:8099 to watch stream. Restarts every $TIMEOUT seconds

	( echo Will kill in $TIMEOUT seconds ; sleep $TIMEOUT ; killall vlc ) &
	#( sleep 10 ; nice vlc http://localhost:8099 ) &
	# cvlc v4l2:///dev/video0:chroma=h264 :input-slave=alsa://hw:1,0 --sout '#transcode{acodec=mpga,ab=128,channels=2,samplerate=44100,threads=4,audio-sync=1}:standard{access=file,mux=mp4,dst="'$DT'.mp4"}'
	cvlc --run-time=10 v4l2:///dev/video0:chroma=h264 :input-slave=alsa://hw:1,0 --sout '#transcode{acodec=mpga,ab=128,channels=2,samplerate=44100,threads=4,audio-sync=1}:duplicate{dst=standard{access=file,mux=mp4,dst="'$DT'.mp4"},dst=standard{access=http,mux=ts,mime=video/ts,dst=:8099}}' 
	echo ----------------------------------------------------------
done

