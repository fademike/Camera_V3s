# Camera_V3s
Webcam based on allwinner V3s and ESP8089

Simple 2 side board with Allwinner V3s, ov2640 and esp8089! 
(I didn't check the sound)

The project has not been completed yet. But worked as: 
ov2640->allwinner->ffmpeg->esp8089->network. Only video.

v1.4 changed scheme and pcb. didn't check <br>
v1.2 in the previous commit. it works but there are errors errataSheet.txt in kicad

top             |  bottom
:-------------------------:|:-------------------------:
![Image alt](https://github.com/fademike/Camera_V3s/blob/main/top.jpg)  |  ![Image alt](https://github.com/fademike/Camera_V3s/blob/main/bottom.jpg)

In repository:
- KiCad project
- v3s3_ch.zip - original:https://github.com/Unturned3/v3s3 (I added):
  1) driver esp8089
  2) gst1-plugin-cedar
-  home_dir - /home/ dir for embedded linux with init script

# How to build

How to build it is described:
https://github.com/Unturned3/v3s3

You can use archive v3s3_ch.zip with addins.


