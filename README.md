# Camera_V3s
Webcam based on allwinner V3s and ESP8089

Simple 2 side board with Allwinner V3s, ov2640 and esp8089! 
(I didn't check the sound)

# How it works
Change wifi settings in file CONFIG_FILE <br>
Find ip in network by name. For example fing app: ![Image alt](https://github.com/fademike/Camera_V3s/blob/main/fing.jpg)
<br>
Watch the video on the MXPlayer(rtsp://192.168.10.22:8554/test), ffmpeg (ffplay -i rtsp://192.168.10.22:8554/test).. <br>
Watch the video on the Gstreamer: gst-launch-1.0 rtspsrc location="rtsp://192.168.10.22:8554/test" latency=0 ! rtph264depay ! decodebin ! videoconvert ! ximagesink <br>

# for QGroundControl:
TX: gst-launch-1.0 -v v4l2src device=/dev/video0 ! "video/x-raw,format=UYVY,width=800,height=600,framerate=10/1" ! videoconvert ! cedar_h264enc bitrate=2000 qp=15 keyint=10 ! rtph264pay pt=96 ! udpsink host=192.168.10.14 port=5600 <br>
RX on QGC or gstreamer: gst-launch-1.0 -v udpsrc port=5600 ! "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! autovideosink <br>

v1.4 changed scheme and pcb. didn't check <br>
v1.2 in the previous commit. it works but there are errors errataSheet.txt in kicad

top             |  bottom
:-------------------------:|:-------------------------:
![Image alt](https://github.com/fademike/Camera_V3s/blob/main/top.jpg)  |  ![Image alt](https://github.com/fademike/Camera_V3s/blob/main/bottom.jpg)

# How to build

git clone https://github.com/fademike/buildroot_v3s.git <br>
tar xf ~/Downloads/buildroot-2023.08.tar.xz <br>
cd buildroot-2023.08 <br>
ln -s ~/Downloads/buildroot/dl ./dl  # if you want <br>
make BR2_EXTERNAL=../buildroot_v3s licheepi_zero_defconfig (in dts you can change size of NOR flash) <br>
make <br>
make esp-rebuild && make <br>

# How to install

insert sd card.. <br>
./make_sd.sh <br>
run board camera_v3s from flash <br>
mount /dev/mmcblk0p1 /mnt <br>
flashcp /mnt/uboot_spi.bin /dev/mtd0 -v <br>
flashcp /mnt/zImage /dev/mtd1 -v <br>
flashcp /mnt/uboot_spi.bin /dev/mtd2 -v <br>
flashcp /mnt/rootfs.squashfs /dev/mtd3 -v <br>
flash_erase /dev/mtd4 0 1000.. <br>
add to mtd4 CONFIG_FILE to wifi settings, and init/deinit script of system <br>
init.sh script for example: <br>
test-launch  --gst-debug=3 '( v4l2src device=/dev/video0 ! video/x-raw,format=UYVY,width=800,height=600,framerate=10/1 ! videoconvert ! cedar_h264enc bitrate=2000 qp=15 keyint=10 ! rtph264pay name=pay0 pt=96 )' &

# note

The wi-fi is crashes after 30-50min. It was discussed on the forum (https://whycan.com/t_4326.html). I would like to change it to XR819, 88W8801 or others. 
You can connect usb wifi adapter (such as MT7601U) or solder a USB wifi module on bottom side.
I didn't notice any problems with the usb wifi adapter.
