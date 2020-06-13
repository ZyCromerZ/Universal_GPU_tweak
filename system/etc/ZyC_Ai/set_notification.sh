#!/system/bin/sh
# Created By : ZyCromerZ
# tweak gpu
# this is for notification type :p
# prepare function
# $1 for type and $2 for method 
GetBusyBox="none"
PathBusyBox="none"
for i in /system/bin /system/xbin /sbin /su/xbin; do
    if [ "$GetBusyBox" == "none" ]; then
        if [ -f $i/busybox ]; then
            GetBusyBox=$i/busybox
        fi
        PathBusyBox=$i
    fi
done
nohup=nohup
if [ -e "$PathBusyBox/busybox" ]; then
    nohup=$PathBusyBox"/busybox nohup"
fi
usleep=usleep
if [ -e "$PathBusyBox/busybox" ]; then
    usleep=$PathBusyBox"/busybox usleep"
fi
sleep=sleep
if [ -e "$PathBusyBox/busybox" ]; then
    sleep=$PathBusyBox"/busybox sleep"
fi
if [ ! -z "$1" ]; then
    getType=$1
    getMethod=$2
    if [ "$getType" == "getar" ]; then
        if [ "$getMethod" == "off" ]; then
            if [ -e /sys/class/timed_output/vibrator/enable ]; then
                echo 200 > /sys/class/timed_output/vibrator/enable
                $usleep 400000
                echo 100 > /sys/class/timed_output/vibrator/enable
            fi
            if [ -e /sys/class/leds/vibrator/duration ] &&  [ -e /sys/class/leds/vibrator/activate ]; then
                echo 200 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
                $usleep 400000
                echo 100 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
            fi
        elif [ "$getMethod" == "on" ]; then
            if [ -e /sys/class/timed_output/vibrator/enable ]; then
                echo 400 > /sys/class/timed_output/vibrator/enable
            fi
            if [ -e /sys/class/leds/vibrator/duration ] &&  [ -e /sys/class/leds/vibrator/activate ]; then
                echo 400 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
            fi
        fi
    elif [ "$getType" == "notif" ]; then
        GetLedPath="none"

        if [ -d /sys/class/leds ]; then 
            if  [ -e /sys/class/leds/red/brightness ] && [ -e /sys/class/leds/green/brightness ]; then
                GetLedPath=/sys/class/leds
            fi
        fi
        if [ "$GetLedPath" != "none" ]; then
            GetRed=$(cat "/sys/class/leds/red/brightness")
            GetGreen=$(cat "/sys/class/leds/green/brightness")
            if [ -e /sys/class/leds/blue/brightness ]; then
                GetBlue=$(cat "/sys/class/leds/blue/brightness")
                $usleep 100
                echo "0" > $GetLedPath/blue/brightness
            fi
            if [ "$getMethod" == "on2" ]; then
                #on perlahan ganti
                echo "255" > $GetLedPath/red/brightness
                for NumberLed in 0 10 20 40 60 80 100 120 150 255
                do
                    echo "$NumberLed" > $GetLedPath/green/brightness
                    $usleep 200000
                done
                echo "0" > $GetLedPath/red/brightness
                $usleep 700000
                echo "0" > $GetLedPath/green/brightness
                $usleep 500000
                echo "255" > $GetLedPath/green/brightness
                $usleep 250000
                echo "0" > $GetLedPath/green/brightness
                $usleep 250000
                echo "255" > $GetLedPath/green/brightness
            elif [ "$getMethod" == "off2" ]; then
                #off perlahan ganti
                echo "255" > $GetLedPath/red/brightness
                for NumberLed in 255 150 120 100 80 60 40 20 10 0
                do
                    echo "$NumberLed" > $GetLedPath/green/brightness
                    $usleep 200000
                done
                $usleep 700000
                echo "0" > $GetLedPath/red/brightness
                $usleep 500000
                echo "255" > $GetLedPath/red/brightness
                $usleep 250000
                echo "0" > $GetLedPath/red/brightness
                $usleep 250000
                echo "255" > $GetLedPath/red/brightness
            elif [ "$getMethod" == "on" ]; then
                #on kedip
                echo "0" > $GetLedPath/red/brightness
                echo "255" > $GetLedPath/green/brightness
                $sleep 2
                echo "0" > $GetLedPath/green/brightness
                $sleep 1
                echo "255" > $GetLedPath/green/brightness
                $usleep 500000
                echo "0" > $GetLedPath/green/brightness
                $usleep 500000
                echo "255" > $GetLedPath/green/brightness
            elif [ "$getMethod" == "off" ]; then
                #off kedip
                echo "0" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $sleep 2
                echo "0" > $GetLedPath/red/brightness
                $sleep 1
                echo "255" > $GetLedPath/red/brightness
                $usleep 500000
                echo "0" > $GetLedPath/red/brightness
                $usleep 500000
                echo "255" > $GetLedPath/red/brightness
            elif [ "$getMethod" == "running" ]; then
                #running kedip kuning
                echo "70" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 400000
                echo "0" > $GetLedPath/red/brightness
                echo "0" > $GetLedPath/green/brightness
                $usleep 150000
                echo "70" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 150000
                echo "0" > $GetLedPath/red/brightness
                echo "0" > $GetLedPath/green/brightness
                $usleep 150000
                echo "70" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
            elif [ "$getMethod" == "running1" ]; then
                #running kedip ijo
                echo "255" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 400000
                echo "0" > $GetLedPath/green/brightness
                $usleep 150000
                echo "255" > $GetLedPath/green/brightness
                $usleep 150000
                echo "0" > $GetLedPath/green/brightness
                $usleep 150000
                echo "255" > $GetLedPath/green/brightness
            elif [ "$getMethod" == "running2" ]; then
                #running perlahan kuning ijo
                echo "255" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 200000
                echo "70" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 400000
                echo "0" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 150000
                echo "70" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 200000
                echo "255" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 150000
                echo "0" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 150000
                echo "255" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 200000
                echo "70" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
            elif [ "$getMethod" == "running3" ]; then
                #running perlahan kuning ijo merah
                echo "0" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 100000
                echo "70" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 100000
                echo "255" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 200000
                echo "0" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 150000
                echo "255" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 100000
                echo "70" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 100000
                echo "0" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 150000
                echo "0" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
                $usleep 150000
                echo "0" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 100000
                echo "70" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 100000
                echo "255" > $GetLedPath/green/brightness
                echo "0" > $GetLedPath/red/brightness
            elif [ "$getMethod" == "dozeoff" ]; then
                #on kedip
                echo "0" > $GetLedPath/green/brightness
                echo "255" > $GetLedPath/red/brightness
                $usleep 500000
                echo "0" > $GetLedPath/red/brightness
                $usleep 500000
                echo "255" > $GetLedPath/green/brightness
            elif [ "$getMethod" == "dozeon" ]; then
                #on kedip
                echo "0" > $GetLedPath/red/brightness
                echo "255" > $GetLedPath/green/brightness
                $usleep 500000
                echo "0" > $GetLedPath/green/brightness
                $usleep 500000
                echo "255" > $GetLedPath/red/brightness
            elif [ "$getMethod" == "onvibrate" ]; then
                #on kedip
                if [ -e /sys/class/timed_output/vibrator/enable ]; then
                    echo 3000 > /sys/class/timed_output/vibrator/enable
                fi
                if [ -e /sys/class/leds/vibrator/duration ] &&  [ -e /sys/class/leds/vibrator/activate ]; then
                    echo 3000 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
                fi
                echo "0" > $GetLedPath/red/brightness
                echo "0" > $GetLedPath/green/brightness
                for CounTotal in 1 2 3 4 5
                do
                    for Ledslight in red yellow green
                    do
                        if [ "$Ledslight" == "red" ]; then
                            echo "255" > $GetLedPath/red/brightness
                            echo "0" > $GetLedPath/green/brightness
                        fi
                        if [ "$Ledslight" == "yellow" ]; then
                            echo "70" > $GetLedPath/green/brightness
                            echo "255" > $GetLedPath/red/brightness
                        fi
                        if [ "$Ledslight" == "green" ]; then
                            echo "0" > $GetLedPath/red/brightness
                            echo "255" > $GetLedPath/green/brightness
                        fi
                        $usleep 200000
                    done
                done
            fi
            NoNotif="yes"
            if [ "$GetRed" != "0" ] && [ "$GetGreen" != "0" ]; then
                NoNotif="no"
            fi
            if [ "$NoNotif" == "no" ]; then
                $usleep 400000
                echo "0" > $GetLedPath/red/brightness
                echo "0" > $GetLedPath/green/brightness
            fi
            $usleep 400000
            if [ "$( acpi -a | grep "on-line" | wc -l)" -gt "0" ]; then
                echo "$GetRed" > $GetLedPath/red/brightness
                echo "$GetGreen" > $GetLedPath/green/brightness
                if [ -e /sys/class/leds/blue/brightness ]; then
                    echo "$GetBlue" > $GetLedPath/blue/brightness
                fi
            else
                echo "0" > $GetLedPath/red/brightness
                echo "0" > $GetLedPath/green/brightness
            fi
        fi
    fi
fi