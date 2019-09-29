# Created By : ZyCromerZ
# tweak gpu
# this is for notification type :p
# prepare function
# $1 for type and $2 for method 
if [ ! -z "$1" ];then
    getType=$1
    getMethod=$2
    getMethodLed=$3
    if [ "$getType" == "getar" ];then
        if [ $getMethod == "off" ];then
            echo 600 > /sys/class/timed_output/vibrator/enable
            sleep 1s
            echo 300 > /sys/class/timed_output/vibrator/enable
        elif [ $getMethod == "on" ];then
            echo 800 > /sys/class/timed_output/vibrator/enable
        fi
    elif [ "$getType" == "notif" ];then
        GetLedPath="none"

        if [ -d /sys/class/leds ];then 
            if  [ -e /sys/class/leds/red/brightness ] && [ -e /sys/class/leds/green/brightness ];then
                GetLedPath=/sys/class/leds
            fi
        fi
        if [ "$GetLedPath" != "none" ];then
            GetRed=$(cat "/sys/class/leds/red/brightness")
            GetGreen=$(cat "/sys/class/leds/green/brightness")
            if [ "$getMethodLed" == "2" ];then
                if [ "$getMethod" == "on" ];then
                    echo "255" > $GetLedPath/red/brightness
                    for NumberLed in 0 10 20 40 60 80 100 120 150 255
                    do
                        echo "$NumberLed" > $GetLedPath/green/brightness;
                        sleep 0.2s
                    done
                    echo "0" > $GetLedPath/red/brightness
                    sleep 1s
                    echo "0" > $GetLedPath/green/brightness
                    sleep 1s
                    echo "255" > $GetLedPath/green/brightness
                elif [ "$getMethod" == "off" ];then
                    echo "255" > $GetLedPath/red/brightness
                    for NumberLed in 255 150 120 100 80 60 40 20 10 0
                    do
                        echo "$NumberLed" > $GetLedPath/green/brightness;
                        sleep 0.2s
                    done
                    sleep 1s
                    echo "0" > $GetLedPath/red/brightness
                    sleep 1s
                    echo "255" > $GetLedPath/red/brightness
                fi
            else
                if [ "$getMethod" == "on" ];then
                    echo "0" > $GetLedPath/red/brightness
                    echo "255" > $GetLedPath/green/brightness
                    sleep 2s
                    echo "0" > $GetLedPath/green/brightness
                    sleep 1s
                    echo "255" > $GetLedPath/green/brightness
                elif [ "$getMethod" == "off" ];then
                    echo "0" > $GetLedPath/green/brightness
                    echo "255" > $GetLedPath/red/brightness
                    sleep 2s
                    echo "0" > $GetLedPath/red/brightness
                    sleep 1s
                    echo "255" > $GetLedPath/red/brightness
                fi
            fi
            NoNotif="yes"
            if [ "$GetRed" != "0" ] && [ "$GetGreen" != "0" ];then
                NoNotif="no"
            fi
            if [ $NoNotif == "no" ];then
                sleep 1s
                echo "0" > $GetLedPath/red/brightness
                echo "0" > $GetLedPath/green/brightness
            fi
            sleep 1s
            echo "$GetRed" > $GetLedPath/red/brightness
            echo "$GetGreen" > $GetLedPath/green/brightness
        fi;
    fi;
fi;