
echo 'insmod modules...'

find /lib/modules/ -iname 'esp8089.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'ov2640.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'mux-core.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'videobuf2-common.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'videobuf2-memops.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'videobuf2-v4l2.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'videobuf2-vmalloc.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'videobuf2-dma-contig.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'uvcvideo.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'v4l2-fwnode.ko' -exec insmod "{}" \;
find /lib/modules/ -iname 'sun6i-csi.ko' -exec insmod "{}" \;

