ffmpeg -f video4linux2 -s 800x600 -r 30 -i /dev/video0 -b 1M -f avi udp://192.168.12.221:333
