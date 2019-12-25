#!/system/bin/sh
# Created By : ZyCromerZ
# tweak gpu
# you can try on off my feature
# prepare function for initialize file if clean install / re create some config file
# thanks for donation to @Mellinio :D
# MODDIR=${0%/*}
# for service.sh
magisk=$(ls /data/adb/magisk/magisk || ls /sbin/magisk) 2>/dev/null;
GetVersion=$($magisk -c | grep -Eo '[0-9]{2}\.[0-9]+')
case "$GetVersion" in
'15.'[1-9]*) # Version 15.1 - 15.9
	ModulPath=/sbin/.core/img
;;
'16.'[1-9]*) # Version 16.1 - 16.9
	ModulPath=/sbin/.core/img
;;
'17.'[1-3]*) # Version 17.1 - 17.3
	ModulPath=/sbin/.core/img
;;
'17.'[4-9]*) # Version 17.4 - 17.9
	ModulPath=/sbin/.magisk/img
;;
'18.'[0-9]*) # Version 18.x
	ModulPath=/sbin/.magisk/img
;;
'19.'[0-9a-zA-Z]*) # Version 19.x
	ModulPath=/data/adb/modules
;;
'20.'[0-9a-zA-Z]*) # Version 20.x
	ModulPath=/data/adb/modules
;;
*)
    echo "unsupported magisk version detected,fail"
    exit
;;
esac
GetVersion="$(cat "$ModulPath/ZyC_Turbo/module.prop" | grep "version=Version" | sed 's/version=Version*//g')"
if [ -d "/sys/class/kgsl/kgsl-3d0" ]; then
    NyariGPU="/sys/class/kgsl/kgsl-3d0"
elif [ -d "/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0" ]; then
    NyariGPU="/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0"
elif [ -d "/sys/devices/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0" ]; then
    NyariGPU="/sys/devices/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0"
elif [ -d "/sys/devices/soc.0/*.qcom,kgsl-3d0/kgsl/kgsl-3d0" ]; then
    NyariGPU="/sys/devices/soc.0/*.qcom,kgsl-3d0/kgsl/kgsl-3d0"
elif [ -d "/sys/devices/platform/*.gpu/devfreq/*.gpu" ]; then
    NyariGPU="/sys/devices/platform/*.gpu/devfreq/*.gpu"
else
    NyariGPU='';
fi
FromTerminal="tidak";
GenerateApp="tidak";
ketemuInternal="kaga"
if [ ! -z "$1" ];then
    if [ "$1" == "boot" ];then
        if [ -e /data/mod_path.txt ];then
            if [ "$(cat /data/mod_path.txt)" == "/data" ];then
                GetPath="none"
                for cariInternal in /data/media/0 /storage/emulated/0 /storage/emulated/legacy /storage/sdcard0 /sdcard /data
                do
                    if [ "$GetPath" == "none" ] && [ -d $cariInternal/android ];then
                        GetPath=$cariInternal
                    fi
                    if [ "$GetPath" == "none" ] && [ -d $cariInternal/Android ];then
                        GetPath=$cariInternal

                    fi
                    if [ "$cariInternal" == "/data" ] && [ "$GetPath" == "none" ];then
                        GetPath=$cariInternal
                    fi
                done
                if [ $GetPath != "none" ];then
                    if [ $GetPath != "/data" ];then
                        mv $(cat /data/mod_path.txt) $GetPath
                        echo "$cariInternal" > /data/mod_path.txt
                    fi
                fi
            fi
        fi
    fi
fi
# Path=/sdcard/modul_mantul/ZyC_mod
if [ ! -e /data/mod_path.txt ]; then
    for cariInternal in /data/media/0 /storage/emulated/0 /storage/emulated/legacy /storage/sdcard0 /sdcard /data
    do
        if [ "$ketemuInternal" == "kaga" ] && [ -d $cariInternal/android ];then
            ketemuInternal="udah"
            echo "$cariInternal" > /data/mod_path.txt
            break
        fi
        if [ "$ketemuInternal" == "kaga" ] && [ -d $cariInternal/Android ];then
            ketemuInternal="udah"
            echo "$cariInternal" > /data/mod_path.txt
            break
        fi
        if [ "$cariInternal" == "/data" ] && [ "$ketemuInternal" == "kaga" ];then
            ketemuInternal="udah"
            echo "$cariInternal" > /data/mod_path.txt
        fi
    done
fi
if [ ! -z "$1" ];then
    if [ "$1" == "Terminal" ];then
        FromTerminal="ya";
    fi
    if [ "$1" == "App" ];then
        GenerateApp="ya";
        FromTerminal="skip"
    fi
    if [ "$1" == "boot" ];then
        sleep 20
        ModPath=$(cat /data/mod_path.txt)
        if [ "$ModPath" != "" ];then
            Path=$ModPath/modul_mantul/ZyC_mod
            if [ ! -d $Path/ZyC_Ai ]; then
                mkdir -p $Path/ZyC_Ai
                echo '1' > "$Path/ZyC_Ai/ai_status.txt"
            fi
            PathModulConfigAi=$Path/ZyC_Ai
            if [ ! -d $Path/ZyC_Turbo_config ]; then
                mkdir -p $Path/ZyC_Turbo_config
            fi
            PathModulConfig=$Path/ZyC_Turbo_config
            echo 'system' > $PathModulConfig/mode_render.txt
            echo 'system' > $PathModulConfig/fsync_mode.txt
            setprop zyc.change.rm "belom"
            setprop zyc.change.zrm "belom"
            setprop zyc.change.prop "belom"
            setprop zyc.change.dns "belom"
            setprop zyc.change.render "belom"
            setprop zyc.status.fstrim "belom"
            setprop zyc.status.fastcharge "belom"
            setprop zram.disksize "0"
            # dns
            # echo "system" > $PathModulConfig/dns.txt
        fi
    fi
fi;
ModPath=$(cat /data/mod_path.txt)
Path=$ModPath/modul_mantul/ZyC_mod
if [ ! -d $Path/ZyC_Ai ]; then
    mkdir -p $Path/ZyC_Ai
    echo '1' > "$Path/ZyC_Ai/ai_status.txt"
fi
PathModulConfigAi=$Path/ZyC_Ai
if [ ! -d $Path/ZyC_Turbo_config ]; then
    mkdir -p $Path/ZyC_Turbo_config
fi
PathModulConfig=$Path/ZyC_Turbo_config
changeSE="tidak"
if [ "$(getenforce)" == "Enforcing" ];then
    changeSE="ya"
    setenforce 0
fi
GetAppAndGames(){
    # auto add to game list start
    GameList=$PathModulConfigAi/list_app_auto_turbo.txt
    if [ ! -e $PathModulConfigAi/list_app_auto_turbo.txt ]; then
        echo "---->> List game installed start <<----"  | tee -a $GameList >/dev/null 2>&1 ;
        echo "<<---- List game installed end ---->>"  | tee -a $GameList >/dev/null 2>&1 ;
    fi
    # Moba Analog
    if [ ! -z $(pm list packages -f com.mobile.legends | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "com.mobile.legends" "$GameList" ) ];then
        sed -i "1a  com.mobile.legends" $GameList;
    fi
    if [ ! -z $(pm list packages -f com.pubg.krmobile | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "com.pubg.krmobile" "$GameList" ) ];then
        sed -i "1a  com.pubg.krmobile" $GameList;
    fi
    if [ ! -z $(pm list packages -f com.pwrd.pwm | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "com.pwrd.pwm" "$GameList" ) ];then
        sed -i "1a  com.pwrd.pwm" $GameList;
    fi
    # if [ ! -z $(pm list packages -f jp.konami | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "jp.konami" "$GameList" ) ];then
    #     sed -i "1a  jp.konami" $GameList;
    # fi
    # if [ ! -z $(pm list packages -f org.gamesamba | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "org.gamesamba" "$GameList" ) ];then
    #     sed -i "1a  org.gamesamba" $GameList;
    # fi
    # if [ ! -z $(pm list packages -f com.skizze | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "com.skizze" "$GameList" ) ];then
    #     sed -i "1a  com.skizze" $GameList;
    # fi
    # if [ ! -z $(pm list packages -f com.vitotechnology | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "com.vitotechnology" "$GameList" ) ];then
    #     sed -i "1a  com.vitotechnology" $GameList;
    # fi
    # if [ ! -z $(pm list packages -f com.mohjang | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "com.mohjang" "$GameList" ) ];then
    #     sed -i "1a  com.mohjang" $GameList;
    # fi
    # if [ ! -z $(pm list packages -f com.dmi | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "com.dmi" "$GameList" ) ];then
    #     sed -i "1a  com.dmi" $GameList;
    # fi
    # if [ ! -z $(pm list packages -f com.herogames | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "com.herogames" "$GameList" ) ];then
    #     sed -i "1a  com.herogames" $GameList;
    # fi
    # if [ ! -z $(pm list packages -f com. | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "com." "$GameList" ) ];then
    #     sed -i "1a  com." $GameList;
    # fi
    # new method add game
    # dts

    for dtsGame in `pm list packages -3 | grep 'com.dts' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$dtsGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$dtsGame" "$GameList" ) ];then
            sed -i "1a  $dtsGame" $GameList;
        fi
    done 
    # gamedreamer
    for gamedreamerGame in `pm list packages -3 | grep 'com.gamedreamer' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$gamedreamerGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$gamedreamerGame" "$GameList" ) ];then
            sed -i "1a  $gamedreamerGame" $GameList;
        fi
    done 
    # nekki
    for nekkiGame in `pm list packages -3 | grep 'com.nekki' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$nekkiGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$nekkiGame" "$GameList" ) ];then
            sed -i "1a  $nekkiGame" $GameList;
        fi
    done 
    # rekoo
    for rekooGame in `pm list packages -3 | grep 'com.rekoo' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$rekooGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$rekooGame" "$GameList" ) ];then
            sed -i "1a  $rekooGame" $GameList;
        fi
    done 
    # tencent
    for tencentGame in `pm list packages -3 | grep 'com.tencent' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$tencentGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$tencentGame" "$GameList" ) ];then
            sed -i "1a  $tencentGame" $GameList;
        fi
    done 
    # garena
    for garenaGame in `pm list packages -3 | grep 'com.garena' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$garenaGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$garenaGame" "$GameList" ) ];then
            sed -i "1a  $garenaGame" $GameList;
        fi
    done 
    # netease
    for neteaseGame in `pm list packages -3 | grep 'com.netease' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$neteaseGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$neteaseGame" "$GameList" ) ];then
            sed -i "1a  $neteaseGame" $GameList;
        fi
    done 
    # ea
    for eaGame in `pm list packages -3 | grep 'com.ea' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$eaGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$eaGame" "$GameList" ) ];then
            sed -i "1a  $eaGame" $GameList;
        fi
    done 
    # gameloft
    for gameloftGame in `pm list packages -3 | grep 'com.gameloft' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$gameloftGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$gameloftGame" "$GameList" ) ];then
            sed -i "1a  $gameloftGame" $GameList;
        fi
    done 
    # nermarble
    for netmarbleGame in `pm list packages -3 | grep 'com.netmarble' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$netmarbleGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$netmarbleGame" "$GameList" ) ];then
            sed -i "1a  $netmarbleGame" $GameList;
        fi
    done 
    # activision
    for activisionGame in `pm list packages -3 | grep 'com.activision' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$activisionGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$activisionGame" "$GameList" ) ];then
            sed -i "1a  $activisionGame" $GameList;
        fi
    done 
    # miHoYo
    for miHoYoGame in `pm list packages -3 | grep 'com.miHoYo' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$miHoYoGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$miHoYoGame" "$GameList" ) ];then
            sed -i "1a  $miHoYoGame" $GameList;
        fi
    done 
    # theonegames
    for theonegamesGame in `pm list packages -3 | grep 'com.theonegames' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$theonegamesGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$theonegamesGame" "$GameList" ) ];then
            sed -i "1a  $theonegamesGame" $GameList;
        fi
    done 
    # squareenixmontreal
    for squareenixmontrealGame in `pm list packages -3 | grep 'com.squareenixmontreal' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$squareenixmontrealGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$squareenixmontrealGame" "$GameList" ) ];then
            sed -i "1a  $squareenixmontrealGame" $GameList;
        fi
    done 
    # jp.konami
    for konamiGame in `pm list packages -3 | grep 'jp.konami' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$konamiGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$konamiGame" "$GameList" ) ];then
            sed -i "1a  $konamiGame" $GameList;
        fi
    done 
    # org.gamesamba
    for gamesambaGame in `pm list packages -3 | grep 'org.gamesamba' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$gamesambaGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$gamesambaGame" "$GameList" ) ];then
            sed -i "1a  $gamesambaGame" $GameList;
        fi
    done 
    # skizze
    for skizzeGame in `pm list packages -3 | grep 'com.skizze' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$skizzeGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$skizzeGame" "$GameList" ) ];then
            sed -i "1a  $skizzeGame" $GameList;
        fi
    done 
    # vitotechnology
    for vitotechnologyGame in `pm list packages -3 | grep 'com.vitotechnology' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$vitotechnologyGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$vitotechnologyGame" "$GameList" ) ];then
            sed -i "1a  $vitotechnologyGame" $GameList;
        fi
    done 
    # mohjang
    for mohjangGame in `pm list packages -3 | grep 'com.mohjang' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$mohjangGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$mohjangGame" "$GameList" ) ];then
            sed -i "1a  $mohjangGame" $GameList;
        fi
    done 
    # dmi
    for dmiGame in `pm list packages -3 | grep 'com.dmi' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$dmiGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$dmiGame" "$GameList" ) ];then
            sed -i "1a  $dmiGame" $GameList;
        fi
    done 
    # herogames
    for herogamesGame in `pm list packages -3 | grep 'com.herogames' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$herogamesGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$herogamesGame" "$GameList" ) ];then
            sed -i "1a  $herogamesGame" $GameList;
        fi
    done 
    # playfungame
    for playfungameGame in `pm list packages -3 | grep 'com.playfungame' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$playfungameGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$playfungameGame" "$GameList" ) ];then
            sed -i "1a  $playfungameGame" $GameList;
        fi
    done 
    # supercell
    for supercellGame in `pm list packages -3 | grep 'com.supercell' | awk -F= '{sub("package:","");print $1}'`
    do
        if [ ! -z $(pm list packages -f "$supercellGame" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ] && [ -z $( grep "$supercellGame" "$GameList" ) ];then
            sed -i "1a  $supercellGame" $GameList;
        fi
    done 


    # auto add to game list end 
    # Get App list start
    listAppPath=$PathModulConfigAi/list_app_package_detected.txt
    if [ ! -e $PathModulConfigAi/list_app_package_detected.txt ]; then
        echo "---->> List app installed start <<----"  | tee -a $listAppPath >/dev/null 2>&1 ;
        echo "<<---- List app installed end ---->>"  | tee -a $listAppPath >/dev/null 2>&1 ;
    fi

    for listApp in ` pm list packages -3 | awk -F= '{sub("package:","");print $1}'` 
        do 
            if [ -z "$( grep "$listApp" "$listAppPath" )" ];then
                checkApp=$(pm list packages -f "$listApp" | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g')
                # nameApp=$(aapt d badging "$checkApp" | awk -F: ' $1 == "application-label" {print $2}' | sed "s/'*//g")
                # adb shell /data/local/tmp/aapt-arm-pie d badging $pkg | awk -F: ' $1 == "application-label" {print $2}' 
                sed -i "1a  $listApp"  "$listAppPath"  ;

            fi
    done
    # Get App list end
}
if [ "$FromTerminal" == "tidak" ];then
    # status modul
    if [ ! -e $PathModulConfig/status_modul.txt ]; then
        echo 'turbo' > $PathModulConfig/status_modul.txt
    fi
    # mode render
    if [ ! -e $PathModulConfig/mode_render.txt ]; then
        echo 'system' > $PathModulConfig/mode_render.txt
    fi
    # max fps nya
    if [ ! -e $PathModulConfig/total_fps.txt ]; then
        echo '0' > $PathModulConfig/total_fps.txt
    fi
    # Status Log nya
    if [ ! -e $PathModulConfig/disable_log_system.txt ]; then
        echo '1' > $PathModulConfig/disable_log_system.txt
    fi
    # fast charging
    if [ ! -e $PathModulConfig/fastcharge.txt ]; then
        echo 'system' > $PathModulConfig/fastcharge.txt
    fi
    # setting adrenoboost
    if [ ! -e $PathModulConfig/GpuBooster.txt ] && [ -e "$NyariGPU/devfreq"/adrenoboost ]; then
        echo 's' > $PathModulConfig/GpuBooster.txt
    fi
    # setting fsync
    if [ ! -e $PathModulConfig/fsync_mode.txt ]; then
        echo 'system' > $PathModulConfig/fsync_mode.txt
    fi
    # setting custom Ram Management
    if [ ! -e $PathModulConfig/custom_ram_management.txt ]; then
        echo '0' > $PathModulConfig/custom_ram_management.txt
    fi
    if [ ! -e $PathModulConfig/custom_ram_management_adj.txt ]; then
        echo 'stock' > $PathModulConfig/custom_ram_management_adj.txt
    fi
    # GMS DOZE
    if [ ! -e $PathModulConfig/gms_doze.txt ]; then
        echo '0' > $PathModulConfig/gms_doze.txt
    fi
    # vram
    if [ ! -e $PathModulConfig/zram.txt ]; then
        echo 'system' > $PathModulConfig/zram.txt
    fi
    # swappiness
    if [ ! -e $PathModulConfig/swapinnes.txt ]; then
        echo '90' > $PathModulConfig/swapinnes.txt
    fi
    # optimize zram
    if [ ! -e $PathModulConfig/zram_optimizer.txt ]; then
        echo '0' > $PathModulConfig/zram_optimizer.txt
    fi
    # dns
    if [ ! -e $PathModulConfig/dns.txt ]; then
        echo "system" > $PathModulConfig/dns.txt
    fi
    # Check notes version
    # SetModulVersion="3.36-71 BETA"
    SetModulVersion="$GetVersion"
    if [ -e $PathModulConfig/notes_en.txt ];then
        if [ "$(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed 's/Version:*//g'  )" != "$SetModulVersion" ];then
            rm $PathModulConfig/notes_en.txt
            echo 'delete notes_en';
            # echo 'auto' > "$PathModulConfig/fsync_mode.txt"
            # echo '3' > "$PathModulConfigAi/wait_time_off.txt"
            # echo '10' > "$PathModulConfigAi/wait_time_on.txt" # Wait time
        fi
    fi
    if [ -e $PathModulConfig/notes_id.txt ];then
        if [ "$(cat "$PathModulConfig/notes_id.txt" | grep 'Version:' | sed 's/Version:*//g'  )" != "$SetModulVersion" ];then
            rm $PathModulConfig/notes_id.txt
            echo 'delete notes_id';
        fi
    fi
    if [ ! -e $PathModulConfig/notes_en.txt ]; then
        # echo "please read this xD \nyou can set mode.txt to:\n- off \n- on \n- turbo \nvalue must same as above without'-'\n\nchange mode_render.txt to:\n-  opengl \n-  skiagl \n-  skiavk \n\n note:\n-skiavk = Vulkan \n-skiagl = OpenGL (SKIA)\ndont edit total_fps.txt still not tested" > $PathModulConfig/notes.txt
        SetNotes=$PathModulConfig/notes_en.txt;
    echo "Version:$SetModulVersion
This module functions to disable thermal GPU and setting some other parts in the GPU for get better performance, 
provided additional features to make it more better performance :p

There are 2 versions, v3 and v2

For v3:

How to use v3
Just flash via magisk and enjoy
if you want setting some config for my module use terminal and type su -> zyc_setting,then type the code
example after zyc_setting :
rm3 <-- using ram management 3
s <-- save changes
y <--- y mean for exit after save changes

How to install v3
1.) Download the latest v3 version
2.) Flash via magisk
3.) Reboot
4.) Done


How to update 
1.) turn off ai,wait 3s
2.) delete folder modul_mantul
3.) flash new version
4.) reboot


How to reset module config
1.) Set to off mode,and wait 3s
2.) Delete the modul_mantul or zyc_turbo_config folder (just check it inside internal memory)
3.) reboot
4.) Done


How to set a special module version 3.33 and above:
1.) The first way, module settings
Open a terminal type
su
zyc_setting
type the code (example aix,anmx dll)
type e or 0 and then y for exit

2.) Only to run auto / ai mode (do this if folder zyc_ai not available inside internal/modul_mantul/zyc_mod/)
zyc_auto

For module config files in the zyc_turbo_config folder (ignore if file does not exist)

- custom_ram_management.txt
  for custom your ram management
  Value = 0 ( use system default ) / 1 (method 1) / 2 (method 2) / 3 (method 3)


- disable_log_system.txt
  disable the cellphone log, is believed to improve the performance of the cellphone
  Value = 0 (disable) [recommendation] / 1 (enable)


- fsync_mode.txt
  Disable fsync can improve game fps, if you find a bug in the launcher, enable it!
  Values ​​= 0 (disable) / 1 (enable) / system ( use default system setting ) / auto( disable when modules use turbo mode )


- GpuBooster.txt
  For the adrenoboost value setting, if the kernel supports adrenoboost, though.
  Value = 0 (disable) / 1 (low) / 2 (medium) / 3 (high) / tweak (set automatically) [recommendation]


- mode_render.txt
  For the cell phone rendering mode settings, there are some ROMs that don't support the rendering mode settings, you can set them here
  Value = opengl (OpenGL) / skiagl (OpenGL SKIA) / skiavk (VULKAN)/system(use menggunakan settingan awal)


- status_modul.txt
  for the module mode settings, there are 3 settings
  Value = off (on) / on / turbo (fastest mode) / lag (slow mode,automatic on if screen state off + use ai doze)


- total_fps.txt
  For the set fps, but i tested it but does not work , leave 0 

- gms_doze.txt
  Setting for fix google play service battery drain
  Value = 0( off )/1( on )

- swapinnes.txt
  Setting swappiness for using swap/zram memory (kalau pakai zram/swap)
  Value = max : 100,min : 1,disable : 0

- zram.txt
  Setting total swap/zram memory (kalau pakai zram/swap)
  Value = 0 : disable, 1 (1gb) - 4 (4 gb)

- zram_optimizer.txt
  Setting optimize config swap/zram memory (kalau pakai zram/swap)
  Value = 0 ( use default system ), 1 ( use tweak )


- fastcharge.txt
  Fastcharge setting if the cellphone supports it
  Value = 0 (using system settings) / 1 (tweaked I tried to activate fastcharge on his cellphone)



For module config files in the zyc_ai folder (ignore the missing files)
- ai_status.txt
  For setting the AI ​​status
  Value = 0 (off) / 1 (can be turned on) / 2 (currently running) / 3 (currently shutting down)
  Note: do not edit ai_status.txt if value 2 or 3


- list_app_turbo.txt
  List app to enter turbo mode quickly


- list_app_package_detected.txt
  The app list can be added into the turbo list


- status_end_gpu.txt
  Trigger for the module to change the status to off mode based on the gpu usage based inside this value to lowest (for example, the value is 5, if the usage is 5% to down automatically change to off mode)


- status_start_gpu.txt
  Trigger for the module to change the status to turbo mode based on the gpu usage based inside this value to lowest (for example, the value is 70, if the usage is 70% to up automatically change to turbo mode)


- wait_time_off.txt
  Time to check the running app or GPU usage when off mode


- wait_time_on.txt
  Time to check the app that is running or GPU usage when in turbo mode

- ai_notif_mode.txt
  For setting ai notification led
  Value=0 (off) / 1 (vibration mode) / 2 (notification method 1) / 3 (notification metode 2)

- ai_notif_mode_running.txt
  For setting ai notification led when module on turbo mode + ai mode on (lights up based on wait_time_on.txt)
  Value=0 (off) / 1 (vibration method 1) / 2 (notification method 2) / 3 (notification metode 3) / 4 (notification metode 4)

- ai_notif_mode_running_status.txt
  for setting notif led ai turned on based game / status module when mode turbo
  Value=0 ( off ) / 1 ( turned on when module on mode turbo ) / 2 ( turned on when playing game )

- ai_change.txt
  for setting ai for ai change mode based game ony, gpu usage only, or both
  Value=1( based gpu usage ) / 2 ( based game ) / 3 ( both )

- ai_doze.txt
  for setting ai to force device deepsleep faster,but notidication was late
  Value=off/on

- doze_state.txt
  for see doze ai status
  do not modify this,just for ai doze status

and i cannot explain for another (new) configs,i dont have a time to explain it sorry ,please open zyc_setting in your terminal app for modify some config 

For V2, just flash it via magisk, it will automatically activates after rebooted


Note:
mode = off / on / turbo
namarender = opengl / skiagl / skiavk" | tee -a $SetNotes >/dev/null 2>&1
    fi
    if [ ! -e $PathModulConfig/notes_id.txt ]; then
        SetNotes=$PathModulConfig/notes_id.txt;
    echo "Version:$SetModulVersion
    
Oke . . .
Jadi gini . . .



Gw mo ngejelasin dikit apa itu modul yg gw bikin
Jadi baca,teros pahami.



Ni modul fungsinya buat disable thermal gpu ama setting beberapa bagian lainnya di bagian gpu biar performa nya makin mantap,di sediakan fitur tambahan biar makin enak & ini mungkin terakhir gw bikin note dengan deskripsi kaya gini :p



Dah lanjut cara install dah . . .
Ada 2 versi,v3 ama v2

cara menggunakan v3
cuma flash via magisk doang beres
kalo mau di utak atik lagi configurasinya masuk terminal terus ketik su -> zyc_setting,lalu ketik kode nya
contoh setelah zyc_setting :
rm3 <-- pake ram management 3
s <-- simpan perubahan
y <--- y itu maksudnya untuk keluar setelah menyimpan perubahan

Untuk v3 :
Cara install v3
1.) download versi v3 yg terbaru
2.) Flash via magisk
3.) Reboot
4.) Done


Cara update 
1.) turn off ai,tunggu 3 detik
2.) delete folder modul_mantul
3.) flash modul terbaru
4.) reboot


Cara reset module
1.) Set ke mode off,dan tunggu 3s
2.) Delete folder modul_mantul ato zyc_turbo_config (ada di internal cek aja)
3.) reboot
4.) Done


Cara setting modul :
1.) Cara pertama,setting modul
Buka terminal ketik
su
zyc_setting
ketik kodenya yg muncul (kaya aix,anmx dll)
ketik e atau 0 terus y untuk keluar


2.) Hanya untuk menjalankan mode auto/ai (lakukan cara ini kalo folder zyc_ai kaga ada dalem internal/modul_mantul/zyc_mod/)
zyc_auto


Untuk file config modul dalam folder zyc_turbo_config (abaikan kalo file ada tidak ada)
- custom_ram_management.txt  
  buat setting ram management nya
  Valuenya = 0(pake default)/1(cara 1)/2(cara 2)/3(cara 3)



- disable_log_system.txt
  disable log hp nya,dipercaya bisa meningkatkan performa hp nya
  Valuenya = 0(disable)[rekomendasi]/1(enable)


- fsync_mode.txt
  Disable fsync bisa meningkatkan fps game,kalo nemu bug di launchernya enable ini !
  Valuenya = 0(disable)/1(enable)/system(use menggunakan settingan awal)/auto(disable ketika masuk mode turbo)



- GpuBooster.txt
  Buat setting value adrenoboost nya,kalo kernel support adrenoboost sih.
  Value = 0(disable)/1(low)/2(medium)/3(high)/tweak(di atur otomatis)[rekomendasi]



- mode_render.txt
  Buat setting mode render hp nya,ada beberapa rom yg gak support buat setting mode render,bisa setting di sini
  Value = opengl(OpenGL)/skiagl(OpenGL SKIA)/skiavk(VULKAN)/system(use menggunakan settingan awal)



- status_modul.txt
  buat setting mode modul,ada 3 pengaturan
  Value = off(mati)/on(hidup)/turbo(mode paling cepat)/lag(mode lambat,auto on kalau layar hp mati + pakai ai doze)



- total_fps.txt
  Buat set fps gitu,tapi gw test ga ngaruh apa apa,biarkan 0 ae



- fastcharge.txt
  Setting fastcharge kalo hp situ support
  Value = 0(menggunakan settingan system)/1(tweak gw mencoba untuk mengaktifkan fastcharge di hp nya)
 
- gms_doze.txt
  Setting untuk fix google play service yg bikin boros battery
  Value = 0( ga pake ni fitur )/1( pake ni fitur)

- swapinnes.txt
  Setting swappiness untuk memakan swap/zram memory (kalau pakai zram/swap)
  Value = max : 100,min : 1,disable : 0

- zram.txt
  Setting total swap/zram memory (kalau pakai zram/swap)
  Value = 0 : disable, 1 (1gb) - 4 (4 gb)

- zram_optimizer.txt
  Setting mengoptimalkan configs swap/zram memory (kalau pakai zram/swap)
  Value = 0 ( pake default system ), 1 ( pake tweak )



Untuk file config modul dalam folder zyc_ai ( abaikan kalo file tidak ada )
- ai_status.txt
  Untuk setting status ai
  Value=0(mati)/1(bisa di hidupkan)/2(sedang berjalan)/3(sedang mematikan)
  Note:kalau status 2/3 jangan di edit


- list_app_turbo.txt
  List app agar masuk ke mode turbo dengan cepat


- list_app_package_detected.txt
  List app yg bisa di masukan ke mode auto ke list turbo 


- status_end_gpu.txt
  Trigger untuk modul agar mengubah status ke mode off berdasarkan usage gpu dari value yang ada di dalam ini ke terbawah (misalkan isinya 5, kalau usage nya 5% ke bawah otomatis ganti ke mode off)


- status_start_gpu.txt
  Trigger untuk modul agar mengubah status ke mode turbo berdasarkan usage gpu dari value yang ada di dalam ini ke terbawah (misalkan isinya 70,kalau usage nya 70% ke bawah otomatis ganti ke mode turbo)


- wait_time_off.txt
  Waktu untuk ai mengecek app yg di jalankan atau gpu usage hp ketika di mode off


- wait_time_on.txt
  Waktu untuk ai mengecek app yg di jalankan atau gpu usage hp ketika di mode turbo


- ai_notif_mode.txt
  Untuk setting notif led ai
  Value=0(mati)/1(mode getaran)/2(notif metode 1)/3(notif metode 2)

- ai_notif_mode_running.txt
  Untuk setting notif led ai ketika modul di mode turbo + ai menyala (menyala berdasarkan wait_time_on.txt)
  Value=0(mati)/1(mode metode 1)/2(notif metode 2)/3(notif metode 3)/4(notif metode 4)

- ai_notif_mode_running_status.txt
  Untuk setting notif led ai mau menyala berdasarkan game / status modul di mode turbo
  Value=0( mati )/1( menyala pada saat mode turbo )/2( menyala pada saat main game )

- ai_change.txt
  Untuk setting ai untuk merubah mode berdasarkan game,penggunakan gpu, atau dua duanya
  Value=1( berdasarkan penggunaan gpu )/2( berdasarkan penggunaan game )/3( bersarkan game & penggunaan gpu )

- ai_doze.txt
  Untuk setting ai untuk memaksa device agar masuk mode deepsleep lebih cepat,tapi notif bakal telat masuk
  Value=off/on

- doze_state.txt
  Untuk melihat status doze ai
  ga usah di edit,biar ai ga broken

maap,gw ga bisa menjelaskan fungsi dari file config yg baru,ga ada waktu buat buat nya 

Untuk V2 cukup flash teros biarkan,udah otomatis aktif kalo udah reboot


Note :
namamode = off/on/turbo
namarender = opengl/skiagl/skiavk" | tee -a $SetNotes >/dev/null 2>&1
    
    fi

    # backup data dolo boss start
    if [ ! -d $PathModulConfig/backup ]; then
        mkdir -p $PathModulConfig/backup
    fi
    #gpu render backup
    if [ ! -e $PathModulConfig/backup/gpu_render.txt ]; then
        echo $(getprop debug.hwui.renderer) > "$PathModulConfig/backup/gpu_render.txt"
    fi
    #val gpu nya
    if [ ! -e $PathModulConfig/backup/gpu_throttling.txt ]; then
        if [ -e "$NyariGPU/throttling" ]; then
            echo $(cat "$NyariGPU/throttling") > "$PathModulConfig/backup/gpu_throttling.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_force_no_nap.txt ]; then
        if [ -e "$NyariGPU/force_no_nap" ]; then
            echo $(cat "$NyariGPU/force_no_nap") > "$PathModulConfig/backup/gpu_force_no_nap.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_force_bus_on.txt ]; then
        if [ -e "$NyariGPU/force_bus_on" ]; then
            echo $(cat "$NyariGPU/force_bus_on") > "$PathModulConfig/backup/gpu_force_bus_on.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_force_clk_on.txt ]; then
        if [ -e "$NyariGPU/force_clk_on" ]; then
            echo $(cat "$NyariGPU/force_clk_on") > "$PathModulConfig/backup/gpu_force_clk_on.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_force_rail_on.txt ]; then
        if [ -e "$NyariGPU/force_rail_on" ]; then
            echo $(cat "$NyariGPU/force_rail_on") > "$PathModulConfig/backup/gpu_force_rail_on.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_bus_split.txt ]; then
        if [ -e "$NyariGPU/bus_split" ]; then
            echo $(cat "$NyariGPU/bus_split") > "$PathModulConfig/backup/gpu_bus_split.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_max_pwrlevel.txt ]; then
        if [ -e "$NyariGPU/max_pwrlevel" ]; then
            echo $(cat "$NyariGPU/max_pwrlevel") > "$PathModulConfig/backup/gpu_max_pwrlevel.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_adrenoboost.txt ]; then
        if [ -e "$NyariGPU/devfreq"/adrenoboost ]; then
            echo $(cat "$NyariGPU/devfreq/adrenoboost") > "$PathModulConfig/backup/gpu_adrenoboost.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_thermal_pwrlevel.txt ]; then
        if [ -e "$NyariGPU/devfreq"/thermal_pwrlevel ]; then
            echo $(cat "$NyariGPU/devfreq/thermal_pwrlevel") > "$PathModulConfig/backup/gpu_thermal_pwrlevel.txt"
        fi
    fi

    # fsync backup
    if [ ! -e $PathModulConfig/backup/misc_Dyn_fsync_active.txt ]; then
        if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
            echo $(cat  "/sys/kernel/dyn_fsync/Dyn_fsync_active") > "$PathModulConfig/backup/misc_Dyn_fsync_active.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/misc_class_fsync_enabled.txt ]; then
        if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
            echo $(cat  "/sys/class/misc/fsynccontrol/fsync_enabled") > "$PathModulConfig/backup/misc_class_fsync_enabled.txt"
        fi 
    fi

    if [ ! -e $PathModulConfig/backup/misc_fsync.txt ]; then
        if [ -e /sys/module/sync/parameters/fsync ]; then
            echo $(cat  "/sys/module/sync/parameters/fsync") > "$PathModulConfig/backup/misc_fsync.txt"
        fi
    fi

    if [ ! -e $PathModulConfig/backup/misc_module_fsync_enabled.txt ]; then
        if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
            echo $(cat  "/sys/module/sync/parameters/fsync_enabled") > "$PathModulConfig/backup/misc_module_fsync_enabled.txt"
        fi
    fi
    # log prop bakcup :D
    # Disable stats logging & monitoring
    # debug.atrace.tags.enableflags=0
    if [ ! -e $PathModulConfig/backup/prop_debug.atrace.tags.enableflags.txt ]; then
        echo $(getprop  debug.atrace.tags.enableflags) > "$PathModulConfig/backup/prop_debug.atrace.tags.enableflags.txt"
    fi

    # profiler.force_disable_ulog=true
    if [ ! -e $PathModulConfig/backup/prop_profiler.force_disable_ulog.txt ]; then
        echo $(getprop  profiler.force_disable_ulog) > "$PathModulConfig/backup/prop_profiler.force_disable_ulog.txt"
    fi

    # profiler.force_disable_err_rpt=true
    if [ ! -e $PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt ]; then
        echo $(getprop  profiler.force_disable_err_rpt) > "$PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt"
    fi

    # profiler.force_disable_err_rpt=1
    if [ ! -e $PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt ]; then
        echo $(getprop  profiler.force_disable_err_rpt) > "$PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt"
    fi

    # ro.config.nocheckin=1
    if [ ! -e $PathModulConfig/backup/prop_ro.config.nocheckin.txt ]; then
        echo $(getprop  ro.config.nocheckin) > "$PathModulConfig/backup/prop_ro.config.nocheckin.txt"
    fi

    # debugtool.anrhistory=0
    if [ ! -e $PathModulConfig/backup/prop_debugtool.anrhistory.txt ]; then
        echo $(getprop  debugtool.anrhistory) > "$PathModulConfig/backup/prop_debugtool.anrhistory.txt"
    fi

    # sys.display-size
    if [ ! -e $PathModulConfig/backup/prop_sys.display-size.txt ]; then
        echo $(getprop  sys.display-size) > "$PathModulConfig/backup/prop_sys.display-size.txt"
    fi

    # media.stagefright.enable-http
    if [ ! -e $PathModulConfig/backup/prop_media.stagefright.enable-http.txt ]; then
        echo $(getprop  media.stagefright.enable-http) > "$PathModulConfig/backup/prop_media.stagefright.enable-http.txt"
    fi

    # media.stagefright.enable-player
    if [ ! -e $PathModulConfig/backup/prop_media.stagefright.enable-player.txt ]; then
        echo $(getprop  media.stagefright.enable-player) > "$PathModulConfig/backup/prop_media.stagefright.enable-player.txt"
    fi

    # media.stagefright.enable-meta
    if [ ! -e $PathModulConfig/backup/prop_media.stagefright.enable-meta.txt ]; then
        echo $(getprop  media.stagefright.enable-meta) > "$PathModulConfig/backup/prop_media.stagefright.enable-meta.txt"
    fi

    # media.stagefright.enable-aac
    if [ ! -e $PathModulConfig/backup/prop_media.stagefright.enable-aac.txt ]; then
        echo $(getprop  media.stagefright.enable-aac) > "$PathModulConfig/backup/prop_media.stagefright.enable-aac.txt"
    fi

    # media.stagefright.enable-qcp
    if [ ! -e $PathModulConfig/backup/prop_media.stagefright.enable-qcp.txt ]; then
        echo $(getprop  media.stagefright.enable-qcp) > "$PathModulConfig/backup/prop_media.stagefright.enable-qcp.txt"
    fi

    # media.stagefright.enable-scan
    if [ ! -e $PathModulConfig/backup/prop_media.stagefright.enable-scan.txt ]; then
        echo $(getprop  media.stagefright.enable-scan) > "$PathModulConfig/backup/prop_media.stagefright.enable-scan.txt"
    fi

    # media.stagefright.enable-record
    if [ ! -e $PathModulConfig/backup/prop_media.stagefright.enable-record.txt ]; then
        echo $(getprop  media.stagefright.enable-record) > "$PathModulConfig/backup/prop_media.stagefright.enable-record.txt"
    fi
    
    # backup data dolo boss end
    # zram config stock :p
    stop perfd
    for ZramConf in vm.dirty_ratio vm.dirty_background_ratio vm.swappiness vm.drop_caches vm.vfs_cache_pressure vm.min_free_kbytes
    do
        if [ -z $(echo $ZramConf | grep "compact_memory") ];then
            GetPath="$(echo "$PathModulConfig/backup/zram_$ZramConf" | awk '{ print $1".txt" }')"
            GetData="$(sysctl $ZramConf | awk '{ print $3 }')"
            if [ ! -e $GetPath ]; then
                echo "$GetData" > "$GetPath"

            fi
        fi 
    done
    if [ -e $PathModulConfig/backup/zram_disksize.txt ];then
        if [ "$(cat "$PathModulConfig/backup/zram_disksize.txt")" == "0" ];then
            rm $PathModulConfig/backup/zram_disksize.txt
        fi
    fi
    if [ ! -e $PathModulConfig/backup/zram_disksize.txt ]; then
        echo $( free | grep 'wap'| awk '{print $2}' ) > $PathModulConfig/backup/zram_disksize.txt
    fi
    start perfd

    # For ai_mode.sh
    if [ ! -e $PathModulConfigAi/list_app_auto_turbo.txt ];then
        GetAppAndGames
    fi
    # Gpu trigger start
    if [ ! -e $PathModulConfigAi/status_start_gpu.txt ]; then
        echo '80' > "$PathModulConfigAi/status_start_gpu.txt"
    fi
    if [ ! -e $PathModulConfigAi/status_end_gpu.txt ]; then
        echo '5' > "$PathModulConfigAi/status_end_gpu.txt"
    fi
    # Wait time when off
    if [ ! -e $PathModulConfigAi/wait_time_off.txt ]; then
        echo '3' > "$PathModulConfigAi/wait_time_off.txt"
    fi
    # Wait time when on
    if [ ! -e $PathModulConfigAi/wait_time_on.txt ]; then
        echo '10' > "$PathModulConfigAi/wait_time_on.txt" # Wait time
    fi
    # Status 0=tidak aktif,1=aktif,2=sedang berjalan
    if [ ! -e $PathModulConfigAi/ai_status.txt ]; then
        echo '1' > "$PathModulConfigAi/ai_status.txt"
    fi
    # run when gaming only or based gpu sage or both
    if [ ! -e $PathModulConfigAi/ai_change.txt ]; then
        echo '3' > "$PathModulConfigAi/ai_change.txt"
    fi
    # Set Ai Notif Mode Start
    if [ ! -e $PathModulConfigAi/ai_notif_mode.txt ]; then
        echo '3' > "$PathModulConfigAi/ai_notif_mode.txt"
    fi
    if [ ! -e $PathModulConfigAi/ai_notif_mode_running.txt ]; then
        echo '0' > "$PathModulConfigAi/ai_notif_mode_running.txt"
    fi
    if [ ! -e $PathModulConfigAi/ai_notif_mode_running_status.txt ]; then
        echo '0' > "$PathModulConfigAi/ai_notif_mode_running_status.txt"
    fi
    if [ ! -e $PathModulConfigAi/doze_state.txt ]; then
        echo 'off' > "$PathModulConfigAi/doze_state.txt"
    fi
    if [ ! -e $PathModulConfigAi/ai_doze.txt ]; then
        echo 'off' > "$PathModulConfigAi/ai_doze.txt"
    fi
    if [ ! -e $PathModulConfigAi/ai_doze_notif.txt ]; then
        echo 'off' > "$PathModulConfigAi/ai_doze_notif.txt"
    fi
    if [ "$(getprop spectrum.support)" == "1" ];then
        if [ ! -e $PathModulConfigAi/mode_off.txt ]; then
            echo '0' > "$PathModulConfigAi/mode_off.txt"
        fi
        if [ ! -e $PathModulConfigAi/mode_on.txt ]; then
            echo '3' > "$PathModulConfigAi/mode_on.txt"
        fi
        if [ ! -e $PathModulConfigAi/spectrum_status.txt ]; then
            echo '0' > "$PathModulConfigAi/spectrum_status.txt"
        fi
    fi
elif [ "$FromTerminal" == "ya" ];then
    # disable log
    if [ "$(cat "$PathModulConfig/disable_log_system.txt")" == '1' ];then
        # ro.com.google.locationfeatures=0
        if [ ! -e $PathModulConfig/backup/prop_ro.com.google.locationfeatures.txt ]; then
            echo $(getprop  ro.com.google.locationfeatures) > "$PathModulConfig/backup/prop_ro.com.google.locationfeatures.txt"
        fi

        # ro.com.google.networklocation=0
        if [ ! -e $PathModulConfig/backup/prop_ro.com.google.networklocation.txt ]; then
            echo $(getprop  ro.com.google.networklocation) > "$PathModulConfig/backup/prop_ro.com.google.networklocation.txt"
        fi

        # profiler.debugmonitor=false
        if [ ! -e $PathModulConfig/backup/prop_profiler.debugmonitor.txt ]; then
            echo $(getprop  profiler.debugmonitor) > "$PathModulConfig/backup/prop_profiler.debugmonitor.txt"
        fi

        # profiler.launch=false
        if [ ! -e $PathModulConfig/backup/prop_profiler.launch.txt ]; then
            echo $(getprop  profiler.launch) > "$PathModulConfig/backup/prop_profiler.launch.txt"
        fi

        # profiler.hung.dumpdobugreport=false
        if [ ! -e $PathModulConfig/backup/prop_profiler.hung.dumpdobugreport.txt ]; then
            echo $(getprop  profiler.hung.dumpdobugreport) > "$PathModulConfig/backup/prop_profiler.hung.dumpdobugreport.txt"
        fi

        # persist.service.pcsync.enable=0
        if [ ! -e $PathModulConfig/backup/prop_persist.service.pcsync.enable.txt ]; then
            echo $(getprop  persist.service.pcsync.enable) > "$PathModulConfig/backup/prop_persist.service.pcsync.enable.txt"
        fi

        # persist.service.lgospd.enable=0
        if [ ! -e $PathModulConfig/backup/prop_persist.service.lgospd.enable.txt ]; then
            echo $(getprop  persist.service.lgospd.enable) > "$PathModulConfig/backup/prop_persist.service.lgospd.enable.txt"
        fi

        # persist.sys.purgeable_assets=1
        if [ ! -e $PathModulConfig/backup/prop_persist.sys.purgeable_assets.txt ]; then
            echo $(getprop  persist.sys.purgeable_assets) > "$PathModulConfig/backup/prop_persist.sys.purgeable_assets.txt"
        fi
    fi
    # ram management 
    if [ "$(cat "$PathModulConfig/custom_ram_management.txt")" != "0" ];then
        if [ ! -e $PathModulConfig/backup/ram_debug_level.txt ];then
            if [ -e /sys/module/lowmemorykiller/parameters/debug_level ];then
                echo $(cat "/sys/module/lowmemorykiller/parameters/debug_level") > "$PathModulConfig/backup/ram_debug_level.txt"  
            fi
        fi
        if [ ! -e $PathModulConfig/backup/ram_adj.txt ];then
            if [ -e /sys/module/lowmemorykiller/parameters/adj ];then
                echo $(cat "/sys/module/lowmemorykiller/parameters/adj") > "$PathModulConfig/backup/ram_adj.txt"  
            fi
        fi
        if [ ! -e $PathModulConfig/backup/ram_minfree.txt ];then
            if [ -e /sys/module/lowmemorykiller/parameters/minfree ];then
                echo $(cat "/sys/module/lowmemorykiller/parameters/minfree") > "$PathModulConfig/backup/ram_minfree.txt"  
            fi
        fi
    fi
fi
if [ $GenerateApp == "ya" ];then
    GetAppAndGames
fi
if [ "$changeSE" == "ya" ];then
    setenforce 1
fi
