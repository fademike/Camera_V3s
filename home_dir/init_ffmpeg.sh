
#wait network connection...
LIMIT_NET=120
a=1
net=0
while [ "$a" -le $LIMIT_NET ]
do
  if ip a | grep -q '192.168.12.'; then echo "connected"; net=1; break; else echo "wait connection ${a}/$LIMIT_NET"; fi
  sleep 1;
  let "a+=1";
done

echo 0 > /sys/class/leds/led2/brightness

if [ $net -eq 0 ]; then reboot; fi

#ffmpeg run
LIMIT_FF=5
a=1
while [ "$a" -le $LIMIT_FF ]
do
  /root/ffrun.sh &
  sleep 10;
  if ps aux | grep ffmpeg | grep -v grep; then 
    echo 0 > /sys/class/leds/led3/brightness
    break; 
  fi
  let "a+=1";
#  if [ $a -eq $LIMIT_FF ]; then reboot; fi
done

echo end
