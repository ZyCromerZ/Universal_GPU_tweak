# Created By : ZyCromerZ
# tweak gpu
# you can try on off my feature
# prepare function
# sleep 2s
magisk=$(ls /data/adb/magisk/magisk || ls /sbin/magisk) 2>/dev/null;
GetVersion=$($magisk -c | grep -Eo '[1-9]{2}\.[0-9]+')
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
*)
    echo "unsupported magisk version detected,fail"
    exit -1;
;;
esac
FromTerminal="tidak";
FromAi="tidak"
if [ ! -z "$1" ];then
    if [ "$1" == "Terminal" ];then
        FromTerminal="ya";
    fi
fi
if [ $FromTerminal == "tidak" ];then
    sh $ModulPath/ZyC_Turbo/initialize.sh "boot" & wait > /dev/null 2>&1
    usleep 5000000
    sh $ModulPath/ZyC_Turbo/initialize.sh "FromTerminal" & wait > /dev/null 2>&1
fi;
if [ ! -z "$2" ];then
    if [ "$2" == "Ai" ];then
        FromAi="ya";
    fi
fi;
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
MissingFile="kaga"
# Path=/sdcard/modul_mantul/ZyC_mod
if [ ! -e /data/mod_path.txt ]; then
    echo "/data/media/0" > /data/mod_path.txt
fi
ModPath=$(cat /data/mod_path.txt)

Path=$ModPath/modul_mantul/ZyC_mod
if [ ! -d $Path/ZyC_Ai ]; then
    MissingFile="iya"
fi
PathModulConfigAi=$Path/ZyC_Ai
if [ ! -d $Path/ZyC_Turbo_config ]; then
    MissingFile="iya"
fi
PathModulConfig=$Path/ZyC_Turbo_config

if [ -e $Path/ZyC_Turbo.log ]; then
    rm $Path/ZyC_Turbo.log
fi
saveLog=$Path/ZyC_Turbo.log
runScript(){
    echo "<<--- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1
    echo "starting modules . . ." | tee -a $saveLog > /dev/null 2>&1
    echo "Version : $(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed "s/Version:*//g" )" > /dev/null 2>&1
    if [ $FromTerminal == "tidak" ];then
        echo "running with boot detected" | tee -a $saveLog > /dev/null 2>&1
    elif [ $FromAi == "ya" ];then
        echo "running with ai detected" | tee -a $saveLog > /dev/null 2>&1
    else
        echo "running without boot detected" | tee -a $saveLog > /dev/null 2>&1
    fi
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1
    # status modul
    if [ ! -e $PathModulConfig/status_modul.txt ]; then
        MissingFile="iya"
    fi
    GetMode=$(cat $PathModulConfig/status_modul.txt)

    # mode render
    if [ ! -e $PathModulConfig/mode_render.txt ]; then
        MissingFile="iya"
    fi
    RenderMode=$(cat $PathModulConfig/mode_render.txt)

    # max fps nya
    if [ ! -e $PathModulConfig/total_fps.txt ]; then
        MissingFile="iya"
    fi
    SetRefreshRate=$(cat $PathModulConfig/total_fps.txt)

    # Status Log nya
    if [ ! -e $PathModulConfig/disable_log_system.txt ]; then
        MissingFile="iya"
    fi
    LogStatus=$(cat $PathModulConfig/disable_log_system.txt)

    # fast charging
    if [ ! -e $PathModulConfig/fastcharge.txt ]; then
        MissingFile="iya"
    fi
    FastCharge=$(cat $PathModulConfig/fastcharge.txt)

    # setting adrenoboost
    GpuBooster="not found"
    if [ -e $NyariGPU/devfreq/adrenoboost ];then
        if [ ! -e $PathModulConfig/GpuBooster.txt ]; then
            MissingFile="iya"
        fi
        GpuBooster=$(cat $PathModulConfig/GpuBooster.txt)
    fi

    # setting fsync
    if [ ! -e $PathModulConfig/fsync_mode.txt ]; then
        MissingFile="iya"
    fi
    fsyncMode=$(cat $PathModulConfig/fsync_mode.txt)

    # setting custom Ram Management
    if [ ! -e $PathModulConfig/custom_ram_management.txt ]; then
        MissingFile="iya"
    fi
    CustomRam=$(cat $PathModulConfig/custom_ram_management.txt)

    # GMS DOZE
    if [ ! -e $PathModulConfig/gms_doze.txt ]; then
        MissingFile="iya"
    fi
    GMSDoze=$(cat $PathModulConfig/gms_doze.txt)

    # Zram
    if [ ! -e $PathModulConfig/zram.txt ]; then
        MissingFile="iya"
    fi
    CustomZram=$(cat $PathModulConfig/zram.txt)
    # swappiness
    if [ ! -e $PathModulConfig/swapinnes.txt ]; then
        MissingFile="iya"
    fi
    Swapinnes=$(cat $PathModulConfig/swapinnes.txt)

    # optimize zram
    if [ ! -e $PathModulConfig/zram_optimizer.txt ]; then
        MissingFile="iya"
    fi
    ZramOptimizer=$(cat $PathModulConfig/zram_optimizer.txt)

    # dns
    if [ ! -e $PathModulConfig/dns.txt ]; then
        MissingFile="iya"
    fi
    GetDnsType=$(cat $PathModulConfig/dns.txt)

    if [ ! -e $PathModulConfig/notes_en.txt ]; then
        # echo "please read this xD \nyou can set mode.txt to:\n- off \n- on \n- turbo \nvalue must same as above without'-'\n\nchange mode_render.txt to:\n-  opengl \n-  skiagl \n-  skiavk \n\n note:\n-skiavk = Vulkan \n-skiagl = OpenGL (SKIA)\ndont edit total_fps.txt still not tested" > $PathModulConfig/notes.txt
        MissingFile="iya"
    fi
    if [ ! -e $PathModulConfig/notes_id.txt ]; then
        MissingFile="iya"
    fi
    # log backup nya
        if [ "$MissingFile" == "iya" ]; then
            sh $ModulPath/ZyC_Turbo/initialize.sh & wait > /dev/null 2>&1
            if [ "$FromAi" == "ya" ];then
                exit 0;
            else
                nohup sh $ModulPath/ZyC_Turbo/service.sh 
            fi
            exit 0;
        fi
    # end log backup
    SetOff(){
        echo 'revert setting . . .' | tee -a $saveLog > /dev/null 2>&1 ;
        #mengembalikan settingan ke asal :D
        setprop persist.sys.NV_FPSLIMIT 35 > /dev/null 2>&1
        resetprop --delete persist.sys.NV_FPSLIMIT > /dev/null 2>&1
        resetprop --delete persist.sys.NV_POWERMODE > /dev/null 2>&1
        resetprop --delete persist.sys.NV_PROFVER > /dev/null 2>&1
        resetprop --delete persist.sys.NV_STEREOCTRL > /dev/null 2>&1
        resetprop --delete persist.sys.NV_STEREOSEPCHG > /dev/null 2>&1
        resetprop --delete persist.sys.NV_STEREOSEP > /dev/null 2>&1
        if [ -e $NyariGPU/throttling ]; then
            echo $(cat "$PathModulConfig/backup/gpu_throttling.txt") > "$NyariGPU/throttling"
        fi
        if [ -e $NyariGPU/force_no_nap ]; then
            echo $(cat "$PathModulConfig/backup/gpu_force_no_nap.txt") > "$NyariGPU/force_no_nap"
        fi
        if [ -e $NyariGPU/force_bus_on ]; then
            echo $(cat "$PathModulConfig/backup/gpu_force_bus_on.txt") > "$NyariGPU/force_bus_on"
        fi
        if [ -e $NyariGPU/force_clk_on ]; then
            echo $(cat "$PathModulConfig/backup/gpu_force_clk_on.txt") > "$NyariGPU/force_clk_on"
        fi
        if [ -e $NyariGPU/force_rail_on ]; then
            echo $(cat "$PathModulConfig/backup/gpu_force_rail_on.txt") > "$NyariGPU/force_rail_on"
        fi
        if [ -e $NyariGPU/bus_split ]; then
            echo $(cat "$PathModulConfig/backup/gpu_bus_split.txt") > "$NyariGPU/bus_split"
        fi
        if [ -e $NyariGPU/max_pwrlevel ]; then
            echo $(cat "$PathModulConfig/backup/gpu_max_pwrlevel.txt") > "$NyariGPU/max_pwrlevel"
        fi
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
            echo $(cat "$PathModulConfig/backup/gpu_adrenoboost.txt") > "$NyariGPU/devfreq/adrenoboost"
        fi
        if [ -e $NyariGPU/devfreq/thermal_pwrlevel ]; then
            echo $(cat "$PathModulConfig/backup/gpu_thermal_pwrlevel.txt") > "$NyariGPU/devfreq/thermal_pwrlevel"
        fi
        if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
            echo $(cat  "$PathModulConfig/backup/misc_Dyn_fsync_active.txt") > "/sys/kernel/dyn_fsync/Dyn_fsync_active"
        fi
        if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
            echo $(cat  "$PathModulConfig/backup/misc_class_fsync_enabled.txt") > "/sys/class/misc/fsynccontrol/fsync_enabled"
        fi 
        if [ -e /sys/module/sync/parameters/fsync ]; then
            echo $(cat  "$PathModulConfig/backup/misc_fsync.txt") > "/sys/module/sync/parameters/fsync"
        fi
        if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
            echo $(cat  "$PathModulConfig/backup/misc_module_fsync_enabled.txt") > "/sys/module/sync/parameters/fsync_enabled"
        fi
        echo 'revert done . . .' | tee -a $saveLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
    }
    SetOn(){
        echo 'use "on" setting. . .' | tee -a $saveLog > /dev/null 2>&1 ;
        #fps limit ke 90
        setprop persist.sys.NV_FPSLIMIT 90
        setprop persist.sys.NV_POWERMODE 1
        setprop persist.sys.NV_PROFVER 15
        setprop persist.sys.NV_STEREOCTRL 0
        setprop persist.sys.NV_STEREOSEPCHG 0
        setprop persist.sys.NV_STEREOSEP 20
        # GPU TWEAK wajib lah biar kaga drop fps xD
        if [ "$NyariGPU" != '' ];then
            if [ -e $NyariGPU/max_pwrlevel ]; then
                echo "0" > "$NyariGPU/max_pwrlevel"
                echo "0" > "$NyariGPU/max_pwrlevel"
            fi
            if [ -e $NyariGPU/devfreq/adrenoboost ]; then
                echo "2" > "$NyariGPU/devfreq/adrenoboost"
            fi
        fi
        echo 'use "on" done. . .' | tee -a $saveLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 

    }
    SetTurbo(){
        #fps limit ke 120
        echo 'use "turbo" setting. . .' | tee -a $saveLog > /dev/null 2>&1 ;
        setprop persist.sys.NV_FPSLIMIT 120
        if  [ $NyariGPU != '' ];then
            if [ -e $NyariGPU/devfreq/adrenoboost ]; then
                echo "3" > "$NyariGPU/devfreq/adrenoboost"
            fi
            if [ -e "$NyariGPU/throttling" ]; then
                echo "0" > $NyariGPU/throttling
            fi
            if [ -e "$NyariGPU/force_no_nap" ]; then
                echo "0" > $NyariGPU/force_no_nap
            fi
            if [ -e "$NyariGPU/force_bus_on" ]; then
                echo "0" > $NyariGPU/force_bus_on
            fi
            if [ -e "$NyariGPU/force_clk_on" ]; then
                echo "0" > $NyariGPU/force_clk_on
            fi
            if [ -e "$NyariGPU/force_rail_on" ]; then
                echo "0" > $NyariGPU/force_rail_on
            fi
            if [ -e "$NyariGPU/bus_split" ]; then
                echo "1" > $NyariGPU/bus_split
            fi
        fi
        echo 'use "turbo" done .' | tee -a $saveLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
    }
    fstrimDulu(){
        echo "fstrim data cache & system, please wait" | tee -a $saveLog > /dev/null 2>&1 ;
        fstrim -v /cache | tee -a $saveLog > /dev/null 2>&1 ;
        fstrim -v /data | tee -a $saveLog > /dev/null 2>&1 ;
        fstrim -v /system | tee -a $saveLog > /dev/null 2>&1 ;
        echo "done ." | tee -a $saveLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
    }
    disableFsync(){
        # disable fsync 
        echo 'disable fsync . . .' | tee -a $saveLog > /dev/null 2>&1 ;
        if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
            echo "0" > /sys/kernel/dyn_fsync/Dyn_fsync_active
        fi
        if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
            echo "0" > /sys/class/misc/fsynccontrol/fsync_enabled
        fi 
        if [ -e /sys/module/sync/parameters/fsync ]; then
            echo "0" > /sys/module/sync/parameters/fsync
        fi
        if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
            echo "N" > /sys/module/sync/parameters/fsync_enabled
        fi
        echo 'disable done .' | tee -a $saveLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
    }
    enableFsync(){
        # enable fsync
        echo 'enable fsync . . .' | tee -a $saveLog > /dev/null 2>&1 ;
        if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
            echo "1" > /sys/kernel/dyn_fsync/Dyn_fsync_active
        fi
        if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
            echo "1" > /sys/class/misc/fsynccontrol/fsync_enabled
        fi 
        if [ -e /sys/module/sync/parameters/fsync ]; then
            echo "1" > /sys/module/sync/parameters/fsync
        fi
        if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
            echo "Y" > /sys/module/sync/parameters/fsync_enabled
        fi
        echo 'enable done .' | tee -a $saveLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
    }
    LagMode(){
        if [ "$NyariGPU" != '' ];then
            if [ -e $NyariGPU/devfreq/adrenoboost ]; then
                echo "0" > "$NyariGPU/devfreq/adrenoboost"
            fi
            if [ -e "$NyariGPU/throttling" ]; then
                echo "1" > $NyariGPU/throttling
            fi
            if [ -e "$NyariGPU/force_no_nap" ]; then
                echo "1" > $NyariGPU/force_no_nap
            fi
            if [ -e "$NyariGPU/force_bus_on" ]; then
                echo "1" > $NyariGPU/force_bus_on
            fi
            if [ -e "$NyariGPU/force_clk_on" ]; then
                echo "1" > $NyariGPU/force_clk_on
            fi
            if [ -e "$NyariGPU/force_rail_on" ]; then
                echo "1" > $NyariGPU/force_rail_on
            fi
            if [ -e "$NyariGPU/bus_split" ]; then
                echo "0" > $NyariGPU/bus_split
            fi
        fi
    }
    systemFsync(){
        echo 'use fsync system setting . . .' | tee -a $saveLog > /dev/null 2>&1 ;
        if [ ! -e $PathModulConfig/backup/misc_Dyn_fsync_active.txt ]; then
            if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
                echo $(cat  "$PathModulConfig/backup/misc_Dyn_fsync_active.txt") > /sys/kernel/dyn_fsync/Dyn_fsync_active
            fi
        fi

        if [ ! -e $PathModulConfig/backup/misc_class_fsync_enabled.txt ]; then
            if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
                echo $(cat  "$PathModulConfig/backup/misc_class_fsync_enabled.txt") > /sys/class/misc/fsynccontrol/fsync_enabled
            fi 
        fi

        if [ ! -e $PathModulConfig/backup/misc_fsync.txt ]; then
            if [ -e /sys/module/sync/parameters/fsync ]; then
                echo $(cat  "$PathModulConfig/backup/misc_fsync.txt") > /sys/module/sync/parameters/fsync
            fi
        fi

        if [ ! -e $PathModulConfig/backup/misc_module_fsync_enabled.txt ]; then
            if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
                echo $(cat  "$PathModulConfig/backup/misc_module_fsync_enabled.txt") > /sys/module/sync/parameters/fsync_enabled
            fi
        fi
        echo 'use fsync system setting done .' | tee -a $saveLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
    }
    disableLogSystem(){
    # Disable stats logging & monitoring
        echo 'disable log and monitoring . . .' | tee -a $saveLog > /dev/null 2>&1 ;
        setprop debug.atrace.tags.enableflags 0 > /dev/null 2>&1
        setprop profiler.force_disable_ulog true > /dev/null 2>&1
        setprop profiler.force_disable_err_rpt true > /dev/null 2>&1
        setprop profiler.force_disable_ulog 1 > /dev/null 2>&1
        setprop profiler.force_disable_err_rpt 1 > /dev/null 2>&1
        setprop ro.config.nocheckin 1 > /dev/null 2>&1
        setprop debugtool.anrhistory 0 > /dev/null 2>&1
        setprop ro.com.google.locationfeatures 0 > /dev/null 2>&1
        setprop ro.com.google.networklocation 0 > /dev/null 2>&1
        setprop profiler.debugmonitor false > /dev/null 2>&1
        setprop profiler.launch false > /dev/null 2>&1
        setprop profiler.hung.dumpdobugreport false > /dev/null 2>&1
        setprop persist.service.pcsync.enable 0 > /dev/null 2>&1
        setprop persist.service.lgospd.enable 0 > /dev/null 2>&1
        setprop persist.sys.purgeable_assets 1 > /dev/null 2>&1
        echo 'disable log and monitoring done .' | tee -a $saveLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1
    }
    enableLogSystem(){
    # Enable stats logging & monitoring
        echo 'enable log and monitoring . . .' | tee -a $saveLog > /dev/null 2>&1 ;
        setprop debug.atrace.tags.enableflags 1 > /dev/null 2>&1
        setprop profiler.force_disable_ulog false > /dev/null 2>&1
        setprop profiler.force_disable_err_rpt false > /dev/null 2>&1
        setprop profiler.force_disable_ulog 0 > /dev/null 2>&1
        setprop profiler.force_disable_err_rpt 0 > /dev/null 2>&1
        setprop ro.config.nocheckin 0 > /dev/null 2>&1
        setprop debugtool.anrhistory 1 > /dev/null 2>&1
        setprop ro.com.google.locationfeatures 1 > /dev/null 2>&1
        setprop ro.com.google.networklocation 1 > /dev/null 2>&1
        setprop profiler.debugmonitor true > /dev/null 2>&1
        setprop profiler.launch true > /dev/null 2>&1
        setprop profiler.hung.dumpdobugreport true > /dev/null 2>&1
        setprop persist.service.pcsync.enable 1 > /dev/null 2>&1
        setprop persist.service.lgospd.enable 1 > /dev/null 2>&1
        setprop persist.sys.purgeable_assets 0 > /dev/null 2>&1
        echo 'enable log and monitoring done .' | tee -a $saveLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
    }

    # ngator mode start
        if [ "$GetMode" == 'off' ];then
            SetOff
            echo "turn off tweak" | tee -a $saveLog > /dev/null 2>&1 ;
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
        elif [ "$GetMode" == 'on' ];then
            SetOff
            SetOn
            # disableFsync
            echo "setting to mode on" | tee -a $saveLog > /dev/null 2>&1 ;
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
        elif [ "$GetMode" == 'turbo' ];then
            SetOn
            SetTurbo
            # disableFsync
            # disableThermal
            if [ "$fsyncMode" == "auto" ];then
                disableFsync
                echo "disable fysnc" | tee -a $saveLog > /dev/null 2>&1 ;
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
            fi
            echo "swith to turbo mode" | tee -a $saveLog > /dev/null 2>&1 ;
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
        elif [ "$GetMode" == 'lag' ];then
            # SetOff
            LagMode
            # disableFsync
            echo "setting to mode lag" | tee -a $saveLog > /dev/null 2>&1 ;
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
        else
            SetOff
            # SetOn
            # disableFsync
            echo "please read guide, mode $GetMode,not found autmatic set to mode off " | tee -a $saveLog > /dev/null 2>&1 ;
            echo 'off' > $PathModulConfig/status_modul.txt
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
        fi
    # ngator mode end

    # enable fastcharge start
        if [ "$FastCharge" == "1" ]; then
            if [ -e /sys/kernel/fast_charge/force_fast_charge ]; then
                fcMethod="one";
                echo "tying to enable fastcharging using first method" | tee -a $saveLog > /dev/null 2>&1 ;
                echo "2" > /sys/kernel/fast_charge/force_fast_charge
                if [ "$(cat /sys/kernel/fast_charge/force_fast_charge)" == "0" ]; then
                    fcMethod="two";
                    echo "tying to enable fastcharging using second method" | tee -a $saveLog > /dev/null 2>&1 ;
                    echo "1" > /sys/kernel/fast_charge/force_fast_charge
                fi
                if [ "$(cat /sys/kernel/fast_charge/force_fast_charge)" == "0" ]; then
                    echo "fastcharge off,maybe your kernel/phone not support it" | tee -a $saveLog > /dev/null 2>&1 ;
                else
                    echo "fastcharge on after use method $fcMethod" | tee -a $saveLog > /dev/null 2>&1 ;
                fi
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
            fi
        fi  
    # enable fastcharge end

    # set fps ? start
        if [ "$SetRefreshRate" != "0" ];then
            setprop persist.sys.NV_FPSLIMIT $SetRefreshRate
            echo "custom fps detected, set to $SetRefreshRate" | tee -a $saveLog > /dev/null 2>&1 ;
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
        fi
    # set fps ? end

    # fstrim start
        if [ -e system/bin/fstrim ]; then
            fstrimDulu
        elif [ -e system/xbin/fstrim ]; then
            fstrimDulu
        fi;
    # fstrim end

    # gpu turbo start
        if [ "$GpuBooster" != "not found" ];then
            if [ "$GpuBooster" == "0" ];then
                echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
                echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog > /dev/null 2>&1 ;
            elif [ "$GpuBooster" == "1" ];then
                echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
                echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog > /dev/null 2>&1 ;
            elif [ "$GpuBooster" == "2" ];then
                echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
                echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog > /dev/null 2>&1 ;
            elif [ "$GpuBooster" == "3" ];then
                echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
                echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog > /dev/null 2>&1 ;
            else
                if [ "$GpuBooster" != "tweak" ];then
                    echo 'tweak' > $PathModulConfig/GpuBooster.txt
                fi
                echo "nice,use default this tweak GpuBoost" | tee -a $saveLog > /dev/null 2>&1 ;
            fi
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
        fi
    # gpu turbo end

    # echo "ok beres dah . . .\n" | tee -a $saveLog > /dev/null 2>&1 ;
    # gpu render start
        if [ "$FromTerminal" == "ya" ];then
            if [ "$RenderMode" == 'skiagl' ];then
                setprop debug.hwui.renderer skiagl
                echo "set render gpu to OpenGL (SKIA) done" | tee -a $saveLog > /dev/null 2>&1 ;
            elif [ "$RenderMode" == 'skiavk' ];then
                setprop debug.hwui.renderer skiavk
                echo "set render gpu to Vulkan (SKIA) done" | tee -a $saveLog > /dev/null 2>&1 ;
            elif [ "$RenderMode" == 'opengl' ];then
                setprop debug.hwui.renderer opengl
                echo "set render gpu to OpenGL default done" | tee -a $saveLog > /dev/null 2>&1 ;
            else
                GetBackupGPU=$(cat "$PathModulConfig/backup/gpu_render.txt")
                if [ -z "$GetBackupGPU" ];then
                    echo "system" > $PathModulConfig/mode_render.txt
                    setprop debug.hwui.renderer "$GetBackupGPU"
                    echo "set render gpu to system setting" | tee -a $saveLog > /dev/null 2>&1 ;
                fi
            fi
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1  
        fi
    # gpu render end

    # disable fsync start
        if [ "$FromTerminal" == "ya" ];then
            if [ "$fsyncMode" == "0" ];then
                disableFsync
                echo "custom fsync detected, set to disable" | tee -a $saveLog > /dev/null 2>&1 ;
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
            elif [ "$fsyncMode" == "1" ];then
                enableFsync
                echo "custom fsync detected, set to enable" | tee -a $saveLog > /dev/null 2>&1 ;
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
            elif [ "$fsyncMode" == "system" ];then
                systemFsync
                echo "use system fsync setting" | tee -a $saveLog > /dev/null 2>&1 ;
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
            else
                if [ "$fsyncMode" != "auto" ];then
                    systemFsync
                    echo "fsync value error,set to by system" | tee -a $saveLog > /dev/null 2>&1 ;
                    echo 'system' > $PathModulConfig/fsync_mode.txt
                    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
                fi
                # disableFsync
            fi
        fi
    # disable fsync end

    # custom ram managent start
        if [ "$FromTerminal" == "ya" ];then
            if [ "$(getprop zyc.change.rm)" == "belom" ];then
                if [ "$CustomRam" == '0' ];then
                        # echo "coming_soon :D"| tee -a $saveLog > /dev/null 2>&1 ;
                        echo "not use custom ram management,using stock ram management" | tee -a $saveLog > /dev/null 2>&1 ;
                        if [ -e $PathModulConfig/backup/ram_enable_adaptive_lmk.txt ];then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                            echo $(cat "$PathModulConfig/backup/ram_enable_adaptive_lmk.txt") > "/sys/module/lowmemorykiller/parameters/enable_adaptive_lmk"
                            chmod 0644 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                            setprop lmk.autocalc false
                            if [ "$(cat "$PathModulConfig/backup/ram_enable_adaptive_lmk.txt")" == "1" ];then
                                setprop lmk.autocalc true
                            else
                                setprop lmk.autocalc false
                            fi
                            rm $PathModulConfig/backup/ram_enable_adaptive_lmk.txt
                        fi
                        if [ -e $PathModulConfig/backup/ram_debug_level.txt ];then
                            echo $(cat "$PathModulConfig/backup/ram_debug_level.txt") > "/sys/module/lowmemorykiller/parameters/debug_level"
                            chmod 0666 /sys/module/lowmemorykiller/parameters/debug_level;
                            chmod 0644 /sys/module/lowmemorykiller/parameters/debug_level;
                            rm $PathModulConfig/backup/ram_debug_level.txt
                        fi
                        if [ -e $PathModulConfig/backup/ram_adj.txt ];then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/adj;
                            echo $(cat "$PathModulConfig/backup/ram_adj.txt") > "/sys/module/lowmemorykiller/parameters/adj"
                            chmod 0644 /sys/module/lowmemorykiller/parameters/adj;
                            rm $PathModulConfig/backup/ram_adj.txt
                        fi
                        if [ -e $PathModulConfig/backup/ram_minfree.txt ];then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/minfree;
                            echo $(cat "$PathModulConfig/backup/ram_minfree.txt") > "/sys/module/lowmemorykiller/parameters/minfree"
                            chmod 0644 /sys/module/lowmemorykiller/parameters/minfree;
                            rm $PathModulConfig/backup/ram_minfree.txt
                        fi
                        # echo "udah mati broo,selamat battery lu aman :V" | tee -a $saveLog > /dev/null 2>&1 ;
                else
                    sh $ModulPath/ZyC_Turbo/initialize.sh & wait > /dev/null 2>&1
                    echo "using custom ram management method $CustomRam" | tee -a $saveLog > /dev/null 2>&1 ;
                    StopModify="no"
                    GetTotalRam=$(free -m | awk '/Mem:/{print $2}');
                    if [ "$CustomRam" == "1" ]; then # Method 1
                        ForegroundApp=$((((GetTotalRam*2/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*3/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*5/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*6/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*10/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*12/100)*1024)/4))
                    elif [ "$CustomRam" == "2" ]; then # Method 2
                        ForegroundApp=$((((GetTotalRam*3/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*4/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*5/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*7/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*11/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*15/100)*1024)/4))
                    elif [ "$CustomRam" == "3" ]; then # Method 3
                        ForegroundApp=$((((GetTotalRam*4/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*5/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*6/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*7/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*12/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*15/100)*1024)/4))
                    elif [ "$CustomRam" == "4" ]; then # Method 4 (for 3gb ram variant)
                        ForegroundApp=$((((GetTotalRam*6/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*7/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*8/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*10/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*15/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*19/100)*1024)/4))         
                    else   
                        echo "method not found" | tee -a $saveLog > /dev/null 2>&1 ;
                        StopModify="yes"
                    fi;
                    if [ $StopModify == "no" ];then
                        if [ -e /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk ]; then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                            echo "0" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
                            chmod 0644 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                            setprop lmk.autocalc false
                            #  echo "* Adaptive LMK = Disabled *" |  tee -a $LOG;
                        fi;
                        if [ -e /sys/module/lowmemorykiller/parameters/debug_level ]; then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/debug_level;
                            echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
                            chmod 0644 /sys/module/lowmemorykiller/parameters/debug_level;
                            #  echo "* LMK Debug Level = Disabled *" |  tee -a $LOG;
                        fi;

                        chmod 0666 /sys/module/lowmemorykiller/parameters/adj;
                        chmod 0666 /sys/module/lowmemorykiller/parameters/minfree;
                        echo "0,120,230,415,910,1000" > /sys/module/lowmemorykiller/parameters/adj
                        echo "$ForegroundApp,$VisibleApp,$SecondaryServer,$HiddenApp,$ContentProvider,$EmptyApp" > /sys/module/lowmemorykiller/parameters/minfree
                        chmod 0644 /sys/module/lowmemorykiller/parameters/minfree;
                        chmod 0644 /sys/module/lowmemorykiller/parameters/adj;

                        minFreeSet=$(($GetTotalRam*4))

                        sysctl -e -w vm.min_free_kbytes=$minFreeSet > /dev/null 2>&1 ;
                        if [ -e /proc/sys/vm/extra_free_kbytes ]; then
                            setprop sys.sysctl.extra_free_kbytes $minFreeSet > /dev/null 2>&1 ;
                        fi;
                    fi;
                    # echo "done,selamat menikmati.. eh merasakan modul ini\ncuma makanan yg bisa di nikmati" | tee -a $saveLog > /dev/null 2>&1 ;
                fi;
                setprop zyc.change.rm "udah"
            fi
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
        fi
    # custom ram managent end
    # custom zram start
        StopZramSet="iya"
        if [ "$FromTerminal" == "ya" ];then
            StopZramSet="kaga"
        fi
        GetBusyBox="none"
        PathBusyBox="none"
        for i in /system/bin /system/xbin /sbin /su/xbin; do
            if [ "$GetBusyBox" == "none" ]; then
                if [ -f $i/busybox ]; then
                    GetBusyBox=$i/busybox;
                fi;
                PathBusyBox=$i
            fi;
        done;
        if [ "$GetBusyBox" == "none" ];then
            StopZramSet="iya"
            echo "need busybox to set Zram " | tee -a $saveLog > /dev/null 2>&1 
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
        else
            GetTotalRam=$(free -m | awk '/Mem:/{print $2}');
            if [ "$CustomZram" == "1" ];then
                SetZramTo="1073741824"
            elif [ "$CustomZram" == "2" ];then
                SetZramTo="2147483648"
            elif [ "$CustomZram" == "3" ];then
                SetZramTo="3221225472"
            elif [ "$CustomZram" == "4" ];then
                SetZramTo="4294967296"
            elif [ "$CustomZram" == "5" ];then
                SetZramTo="5368709120‬"
            elif [ "$CustomZram" == "6" ];then
                SetZramTo="6442450944‬"
            elif [ "$CustomZram" == "7" ];then
                SetZramTo="7516192768"
            elif [ "$CustomZram" == "8" ];then
                SetZramTo="8589934592‬"
            elif [ "$CustomZram" == "0" ];then
            #  disable zram 
                if [ "$(getprop zyc.change.zrm)" == "belom" ];then
                    if [ -e /dev/block/zram0 ]; then
                        setprop zyc.change.zrm "udah"
                        StopZramSet="iya"
                        echo 'disable Zram done .' | tee -a $saveLog > /dev/null 2>&1 ;
                        $GetBusyBox swapoff /dev/block/zram0  > /dev/null 2>&1 
                        $GetBusyBox setprop zram.disksize 0  > /dev/null 2>&1 
                        echo 'disable Zram done .' | tee -a $saveLog > /dev/null 2>&1 ;
                        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
                    fi;
                fi
                StopZramSet="iya"
            elif [ "$CustomZram" == "system" ];then
                SetZramTo=$(cat "$PathModulConfig/backup/zram_disksize.txt")
                echo "use Zram default system setting" | tee -a $saveLog > /dev/null 2>&1 
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
            fi
            if [ "$SetZramTo" == "0" ];then
                setprop zyc.change.zrm == "udah"
                StopZramSet="iya"
            fi
            if [ "$(getprop zyc.change.zrm)" == "belom" ];then
                if [ "$StopZramSet" == "kaga" ];then
                    if [ -e /dev/block/zram0 ]; then
                        setprop zyc.change.zrm "udah"  > /dev/null 2>&1 
                        FixSize=$(echo $SetZramTo |  sed "s/-*//g" )
                        GetSwapNow=$(getprop zram.disksize |  sed "s/-*//g" )
                        if [ "$FixSize" != "$GetSwapNow" ];then
                            stop perfd
                            # echo "use Zram default system setting" | tee -a $saveLog > /dev/null 2>&1 
                            echo "enable Zram & use $CustomZram Gb done ." | tee -a $saveLog > /dev/null 2>&1 ;
                            echo "Set Zram to $SetZramTo Bytes . . ." | tee -a $saveLog > /dev/null 2>&1 ;
                            echo "and Swapinnes to $Swapinnes . . ." | tee -a $saveLog > /dev/null 2>&1 ;
                            $PathBusyBox/swapoff "/dev/block/zram0"  > /dev/null 2>&1 
                            usleep 100000
                            echo "1" > /sys/block/zram0/reset
                            echo "$FixSize" > /sys/block/zram0/disksize | tee -a $saveLog > /dev/null 2>&1 ;
                            $PathBusyBox/mkswap "/dev/block/zram0"  > /dev/null 2>&1 
                            usleep 100000
                            # setprop ro.config.zram true
                            # setprop ro.config.zram.support true
                            setprop zram.disksize $SetZramTo
                            if [ "$ZramOptimizer" == "1" ];then
                                echo "echo optimize zram setting . . ." | tee -a $saveLog > /dev/null 2>&1 ;
                                sysctl -e -w vm.swappiness=$Swapinnes  > /dev/null 2>&1 
                                sysctl -e -w vm.dirty_ratio=5  > /dev/null 2>&1 
                                sysctl -e -w vm.dirty_background_ratio=1  > /dev/null 2>&1 
                                sysctl -e -w vm.drop_caches=3  > /dev/null 2>&1 
                                sysctl -e -w vm.vfs_cache_pressure=100  > /dev/null 2>&1 
                            else
                                echo "use stock zram setting . . ." | tee -a $saveLog > /dev/null 2>&1 ;
                                sysctl -e -w vm.dirty_ratio=$(cat "$PathModulConfig/backup/zram_vm.dirty_ratio.txt")  > /dev/null 2>&1 
                                sysctl -e -w vm.dirty_background_ratio=$(cat "$PathModulConfig/backup/zram_vm.dirty_background_ratio.txt")  > /dev/null 2>&1 
                                sysctl -e -w vm.drop_caches=$(cat "$PathModulConfig/backup/zram_vm.drop_caches.txt")  > /dev/null 2>&1 
                                sysctl -e -w vm.vfs_cache_pressure=$(cat "$PathModulConfig/backup/zram_vm.vfs_cache_pressure.txt")  > /dev/null 2>&1 
                            fi
                            $PathBusyBox/swapon "/dev/block/zram0"  > /dev/null 2>&1 
                            usleep 100000
                            echo "enable Zram & use $CustomZram Gb done ." | tee -a $saveLog > /dev/null 2>&1 ;
                            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
                            start perfd
                        fi
                        
                    fi;
                fi
            fi
        fi
        
    # custom zram end

    if [ "$LogStatus" == '1' ];then
        # enableLogSystem
        disableLogSystem
    elif [ "$LogStatus" == '2' ];then
        # disableLogSystem
        enableLogSystem
    fi
    if [ "$GetMode" == 'off' ];then
        echo "turn off tweak succeess :D"| tee -a $saveLog > /dev/null 2>&1 ;
    else
        echo "done,tweak has been turned on" | tee -a $saveLog > /dev/null 2>&1 ;
    fi;
    if [ "$GetMode" == 'turbo' ];then
        echo "NOTE: just tell you if you use this mode your battery will litle drain" | tee -a $saveLog > /dev/null 2>&1 ;
    fi;
    if [ "$FromTerminal" == "tidak" ];then
        #fix gms :p
        if [ "$GMSDoze" == "1" ];then
            GetBusyBox="none"
            if [ -e $Path/ZyC_GmsDoze.log ];then
                rm $Path/ZyC_GmsDoze.log
            fi
            for i in /system/bin /system/xbin /sbin /su/xbin; do
                if [ "$GetBusyBox" == "none" ]; then
                    if [ -f $i/busybox ]; then
                        GetBusyBox=$i/busybox;
                    fi;
                fi;
            done;
            if [ "$GetBusyBox" == "none " ];then
                echo "GMS Doze fail . . ." | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
            else
                echo "Note : better to use universal gms doze :D" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                # source script from gms doze universal 1.7.3
                pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                cmd appops set com.google.android.gms BOOT_COMPLETED ignore | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                cmd appops set com.google.android.gms AUTO_START ignore | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                cmd appops set com.google.android.ims BOOT_COMPLETED ignore | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                cmd appops set com.google.android.ims WAKE_LOCK ignore | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                cmd appops set com.google.android.ims AUTO_START ignore | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                cmd appops set com.google.android.ims WAKE_LOCK ignore | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                # Stop unnecessary GMS and restart it on boot (dorimanx)
                if [ "$($GetBusyBox pidof com.google.android.gms | wc -l)" -eq "1" ]; then
                    $GetBusyBox kill $($GetBusyBox pidof com.google.android.gms) | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                fi;
                if [ "$($GetBusyBox pidof com.google.android.gms.wearable | wc -l)" -eq "1" ]; then
                    $GetBusyBox kill $($GetBusyBox pidof com.google.android.gms.wearable) | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                fi;
                if [ "$($GetBusyBox pidof com.google.android.gms.persistent | wc -l)" -eq "1" ]; then
                    $GetBusyBox kill $($GetBusyBox pidof com.google.android.gms.persistent) | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                fi;
                if [ "$($GetBusyBox pidof com.google.android.gms.unstable | wc -l)" -eq "1" ]; then
                    $GetBusyBox kill $($GetBusyBox pidof com.google.android.gms.unstable) | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                fi;
                su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/.update.SystemUpdateService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$ActiveReceiver" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$Receiver" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$SecretCodeReceiver" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gsf/.update.SystemUpdateService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$Receiver" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$SecretCodeReceiver" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.AnalyticsReceiver" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.AnalyticsService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.chimera.PersistentIntentOperationService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.clearcut.debug.ClearcutDebugDumpService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.common.stats.GmsCoreStatsService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.AppMeasurementJobService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.AppMeasurementInstallReferrerReceiver" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementReceiver" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.service.MeasurementBrokerService" | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
                echo "GMS Doze done . . ." | tee -a $Path/ZyC_GmsDoze.log > /dev/null 2>&1
            fi
        fi
        if [ -e "/system/etc/ZyC_Ai/ai_mode.sh" ];then
            BASEDIR=/system/etc/ZyC_Ai
            if [ -e $PathModulConfigAi/ai_status.txt ]; then
                AiStatus=$(cat "$PathModulConfigAi/ai_status.txt")
                if [ "$AiStatus" == "1" ];then
                    echo "starting ai mode . . . " | tee -a $saveLog > /dev/null 2>&1 
                    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
                    nohup sh $BASEDIR/ai_mode.sh "fromBoot"
                    exit
                elif [ "$AiStatus" == "2" ];then
                    echo "re - run ai mode . . . " | tee -a $saveLog > /dev/null 2>&1 
                    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
                    nohup sh $BASEDIR/ai_mode.sh "fromBoot"
                    exit
                elif [ "$AiStatus" == "3" ];then
                    echo "deactive ai mode . . . " | tee -a $saveLog > /dev/null 2>&1 
                    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
                    nohup sh $BASEDIR/ai_mode.sh "fromBoot"
                    exit
                elif [ "$AiStatus" == "0" ];then
                    echo "ai status off"| tee -a $saveLog > /dev/null 2>&1 ;
                    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
                else
                    echo "ai status error,set to 0"| tee -a $saveLog > /dev/null 2>&1 ;
                    echo '0' > "$PathModulConfigAi/ai_status.txt"
                    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1 
                fi
            fi
        fi
    fi
    if [ "$(getprop zyc.change.prop)" == "belom" ];then
        setprop zyc.change.prop "udah" 
        echo "adding youtube 4k,suggested by @WhySakura"  | tee -a $saveLog 
        setprop sys.display-size '3840x2160' | tee -a $saveLog > /dev/null 2>&1 ;
        echo "done . . ."  | tee -a $saveLog 
        echo "  --- --- --- --- --- " | tee -a $saveLog 
        echo "add video optimizer,suggested by @WhySakura" | tee -a $saveLog > /dev/null 2>&1 ;
        setprop media.stagefright.enable-http 'true' > /dev/null 2>&1 ;
        setprop media.stagefright.enable-player 'true' > /dev/null 2>&1 ;
        setprop media.stagefright.enable-meta 'true' > /dev/null 2>&1 ;
        setprop media.stagefright.enable-aac 'true' > /dev/null 2>&1 ;
        setprop media.stagefright.enable-qcp 'true' > /dev/null 2>&1 ;
        setprop media.stagefright.enable-scan 'true' > /dev/null 2>&1 ;
        setprop media.stagefright.enable-record 'true' > /dev/null 2>&1 ;
        echo "done . . ."  | tee -a $saveLog 
        echo "  --- --- --- --- --- " | tee -a $saveLog 
        echo "tweak smooth ui" | tee -a $saveLog 
        setprop debug.sf.latch_unsignaled 1  > /dev/null 2>&1 ;
        setprop debug.sf.disable_backpressure 1  > /dev/null 2>&1 ;
        setprop ro.sys.fw.dex2oat_thread_count 4  > /dev/null 2>&1 ;
        setprop dalvik.vm.boot-dex2oat-threads 8  > /dev/null 2>&1 ;
        setprop dalvik.vm.dex2oat-threads 4  > /dev/null 2>&1 ;
        setprop dalvik.vm.image-dex2oat-threads 4  > /dev/null 2>&1 ;
        setprop dalvik.vm.dex2oat-filter speed  > /dev/null 2>&1 ;
        setprop dalvik.vm.image-dex2oat-filter speed  > /dev/null 2>&1 ;
        setprop dalvik.vm.heapgrowthlimit 256m  > /dev/null 2>&1 ;
        setprop dalvik.vm.heapstartsize 8m  > /dev/null 2>&1 ;
        setprop dalvik.vm.heapsize 512m  > /dev/null 2>&1 ;
        setprop dalvik.vm.heaptargetutilization 0.75  > /dev/null 2>&1 ;
        setprop dalvik.vm.heapminfree 512k  > /dev/null 2>&1 ;
        setprop dalvik.vm.heapmaxfree 8m  > /dev/null 2>&1 ;
        echo "done . . ." | tee -a $saveLog 
        echo "  --- --- --- --- --- " | tee -a $saveLog 
        echo "something request from @WhySakura"| tee -a $saveLog 
        setprop debug.egl.swapinterval 120  > /dev/null 2>&1 ;
        setprop sys.use_fifo_ui 1  > /dev/null 2>&1 ;
        echo "done . . ." | tee -a $saveLog 
        echo "  --- --- --- --- --- " | tee -a $saveLog 
        echo "add responsive touch " | tee -a $saveLog 
        setprop touch.deviceType touchScreen > /dev/null 2>&1 ;
        setprop touch.orientationAware 1 > /dev/null 2>&1 ;
        setprop touch.size.calibration diameter > /dev/null 2>&1 ;
        setprop touch.size.scale 1 > /dev/null 2>&1 ;
        setprop touch.size.bias 0 > /dev/null 2>&1 ;
        setprop touch.size.isSummed 0 > /dev/null 2>&1 ;
        setprop touch.pressure.calibration amplitude > /dev/null 2>&1 ;
        setprop touch.pressure.scale 0.001 > /dev/null 2>&1 ;
        setprop touch.orientation.calibration none > /dev/null 2>&1 ;
        setprop touch.distance.calibration none > /dev/null 2>&1 ;
        setprop touch.distance.scale 0
        setprop touch.coverage.calibration box > /dev/null 2>&1 ;
        setprop touch.gestureMode spots > /dev/null 2>&1 ;
        setprop MultitouchSettleInterval 1ms > /dev/null 2>&1 ;
        setprop MultitouchMinDistance 1px > /dev/null 2>&1 ;
        setprop TapInterval 1ms > /dev/null 2>&1 ;
        setprop TapSlop 1px1 > /dev/null 2>&1 ;
        echo "done . . . " | tee -a $saveLog 
        echo "  --- --- --- --- --- " | tee -a $saveLog 
        echo "add audio . . ." | tee -a $saveLog 
        setprop ro.camcorder.videoModes true  > /dev/null 2>&1
        setprop ro.media.enc.hprof.vid.fps 65  > /dev/null 2>&1
        setprop ro.media.dec.aud.wma.enabled 1  > /dev/null 2>&1
        setprop ro.media.dec.vid.wmv.enabled 1  > /dev/null 2>&1
        setprop ro.media.dec.aud.mp3.enabled 1  > /dev/null 2>&1
        setprop ro.media.dec.vid.mp4.enabled 1  > /dev/null 2>&1
        setprop ro.media.enc.aud.wma.enabled 1  > /dev/null 2>&1
        setprop ro.media.enc.vid.wmv.enabled 1  > /dev/null 2>&1
        setprop ro.media.enc.aud.mp3.enabled 1  > /dev/null 2>&1
        setprop ro.media.enc.vid.mp4.enabled 1  > /dev/null 2>&1
        setprop ro.media.dec.aud.flac.enabled 1  > /dev/null 2>&1
        setprop ro.media.dec.vid.H.264.enabled 1  > /dev/null 2>&1
        setprop ro.media.enc.aud.flac.enabled 1  > /dev/null 2>&1
        setprop ro.media.enc.vid.H.264.enabled 1  > /dev/null 2>&1
        setprop af.fast_track_multiplier 1  > /dev/null 2>&1
        setprop ro.vendor.audio.soundtrigger nuance  > /dev/null 2>&1
        setprop ro.vendor.audio.soundtrigger.lowpower false  > /dev/null 2>&1
        setprop ro.vendor.audio.sdk.fluencetype none  > /dev/null 2>&1
        setprop ro.vendor.audio.sdk.ssr false  > /dev/null 2>&1
        setprop ro.vendor.audio.sos true  > /dev/null 2>&1
        setprop persist.vendor.audio.fluence.voicecall true  > /dev/null 2>&1
        setprop persist.vendor.audio.fluence.voicerec false  > /dev/null 2>&1
        setprop persist.vendor.audio.fluence.speaker true  > /dev/null 2>&1
        setprop persist.vendor.audio.ras.enabled false  > /dev/null 2>&1
        setprop persist.vendor.audio.hifi.int_codec true  > /dev/null 2>&1
        setprop persist.vendor.audio.hw.binder.size_kbyte 1024  > /dev/null 2>&1
        setprop vendor.audio.adm.buffering.ms 2  > /dev/null 2>&1
        setprop vendor.audio_hal.period_size 192  > /dev/null 2>&1
        setprop vendor.audio.tunnel.encode false  > /dev/null 2>&1
        setprop vendor.audio.offload.buffer.size.kb 64  > /dev/null 2>&1
        setprop vendor.audio.offload.track.enable false  > /dev/null 2>&1
        setprop vendor.voice.path.for.pcm.voip true  > /dev/null 2>&1
        setprop vendor.audio.offload.multiaac.enable true  > /dev/null 2>&1
        setprop vendor.audio.dolby.ds2.enabled false  > /dev/null 2>&1
        setprop vendor.audio.dolby.ds2.hardbypass false  > /dev/null 2>&1
        setprop vendor.audio.offload.multiple.enabled false  > /dev/null 2>&1
        setprop vendor.audio.offload.passthrough false  > /dev/null 2>&1
        setprop vendor.audio.offload.gapless.enabled true  > /dev/null 2>&1
        setprop vendor.audio.safx.pbe.enabled true  > /dev/null 2>&1
        setprop vendor.audio.parser.ip.buffer.size 262144  > /dev/null 2>&1
        setprop vendor.audio.flac.sw.decoder.24bit true  > /dev/null 2>&1
        setprop vendor.audio_hal.period_multiplier 3  > /dev/null 2>&1
        setprop vendor.audio.use.sw.alac.decoder true  > /dev/null 2>&1
        setprop vendor.audio.use.sw.ape.decoder true  > /dev/null 2>&1
        setprop vendor.audio.hw.aac.encoder true  > /dev/null 2>&1
        setprop vendor.fm.a2dp.conc.disabled true  > /dev/null 2>&1
        setprop vendor.audio.noisy.broadcast.delay 600  > /dev/null 2>&1
        setprop vendor.audio.offload.pstimeout.secs 3  > /dev/null 2>&1
        setprop ro.audio.soundfx.dirac false  > /dev/null 2>&1
        setprop audio.offload.min.duration.secs 30  > /dev/null 2>&1
        setprop audio.offload.video true  > /dev/null 2>&1
        setprop audio.deep_buffer.media true  > /dev/null 2>&1
        setprop ro.af.client_heap_size_kbyte 7168  > /dev/null 2>&1
        setprop ro.qc.sdk.audio.fluencetype none  > /dev/null 2>&1
        setprop persist.radio.add_power_save 1  > /dev/null 2>&1
        setprop persist.ril.uart.flowctrl 10  > /dev/null 2>&1
        setprop persist.audio.fluence.voicerec true  > /dev/null 2>&1
        setprop persist.audio.fluence.speaker false  > /dev/null 2>&1
        setprop use.voice.path.for.pcm.voip true  > /dev/null 2>&1
        echo "done " | tee -a $saveLog 
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    fi
ResetDns(){
    ip6tables -P INPUT ACCEPT  > /dev/null 2>&1
    ip6tables -P FORWARD ACCEPT  > /dev/null 2>&1
    ip6tables -P OUTPUT ACCEPT  > /dev/null 2>&1
    ip6tables -t nat -F  > /dev/null 2>&1
    ip6tables -t mangle -F  > /dev/null 2>&1
    ip6tables -F  > /dev/null 2>&1
    ip6tables -X  > /dev/null 2>&1
    iptables -P INPUT ACCEPT  > /dev/null 2>&1
    iptables -P FORWARD ACCEPT  > /dev/null 2>&1
    iptables -P OUTPUT ACCEPT  > /dev/null 2>&1
    iptables -t nat -F  > /dev/null 2>&1
    iptables -t mangle -F  > /dev/null 2>&1
    iptables -F  > /dev/null 2>&1
    iptables -X  > /dev/null 2>&1
    resetprop net.eth0.dns1  > /dev/null 2>&1
    resetprop net.eth0.dns2  > /dev/null 2>&1
    resetprop net.dns1  > /dev/null 2>&1
    resetprop net.dns2  > /dev/null 2>&1
    resetprop net.ppp0.dns1  > /dev/null 2>&1
    resetprop net.ppp0.dns2  > /dev/null 2>&1
    resetprop net.rmnet0.dns1  > /dev/null 2>&1
    resetprop net.rmnet0.dns2  > /dev/null 2>&1
    resetprop net.rmnet1.dns1  > /dev/null 2>&1
    resetprop net.rmnet1.dns2  > /dev/null 2>&1
    resetprop net.rmnet2.dns1  > /dev/null 2>&1
    resetprop net.rmnet2.dns2  > /dev/null 2>&1
    resetprop net.pdpbr1.dns1  > /dev/null 2>&1
    resetprop net.pdpbr1.dns2  > /dev/null 2>&1
    resetprop net.wlan0.dns1  > /dev/null 2>&1
    resetprop net.wlan0.dns2  > /dev/null 2>&1
    resetprop 2001:4860:4860::8888 > /dev/null 2>&1 
    resetprop 2001:4860:4860::8844 > /dev/null 2>&1 
    resetprop 2606:4700:4700::1111 > /dev/null 2>&1 
    resetprop 2606:4700:4700::1001 > /dev/null 2>&1 
}
    if [ "$(getprop zyc.change.dns)" == "belom" ];then
        setprop zyc.change.dns 'udah'
        if [ "$GetDnsType" == "cloudflare" ];then
            echo "use cloudflare dns "| tee -a $saveLog
            # reset
            ResetDns
            # reset
            iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 1.1.1.1:53  > /dev/null 2>&1
            iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 1.0.0.1:53  > /dev/null 2>&1
            iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 1.1.1.1:53  > /dev/null 2>&1
            iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 1.0.0.1:53  > /dev/null 2>&1
            ip6tables -t nat -A OUTPUT -p 6 --dport 53 -j DNAT --to-destination  2606:4700:4700::1111  > /dev/null 2>&1
            ip6tables -t nat -I OUTPUT -p 6 --dport 53 -j DNAT --to-destination  2606:4700:4700::1001  > /dev/null 2>&1
            ip6tables -t nat -A OUTPUT -p 17 --dport 53 -j DNAT --to-destination  2606:4700:4700::1111  > /dev/null 2>&1
            ip6tables -t nat -I OUTPUT -p 17 --dport 53 -j DNAT --to-destination  2606:4700:4700::1001  > /dev/null 2>&1
            # SETPROP
            setprop net.eth0.dns1 1.1.1.1  > /dev/null 2>&1
            setprop net.eth0.dns2 1.0.0.1  > /dev/null 2>&1
            setprop net.dns1 1.1.1.1  > /dev/null 2>&1
            setprop net.dns2 1.0.0.1  > /dev/null 2>&1
            setprop net.ppp0.dns1 1.1.1.1  > /dev/null 2>&1
            setprop net.ppp0.dns2 1.0.0.1  > /dev/null 2>&1
            setprop net.rmnet0.dns1 1.1.1.1  > /dev/null 2>&1
            setprop net.rmnet0.dns2 1.0.0.1  > /dev/null 2>&1
            setprop net.rmnet1.dns1 1.1.1.1  > /dev/null 2>&1
            setprop net.rmnet1.dns2 1.0.0.1  > /dev/null 2>&1
            setprop net.rmnet2.dns1 1.1.1.1  > /dev/null 2>&1
            setprop net.rmnet2.dns2 1.0.0.1  > /dev/null 2>&1
            setprop net.pdpbr1.dns1 1.1.1.1  > /dev/null 2>&1
            setprop net.pdpbr1.dns2 1.0.0.1  > /dev/null 2>&1
            setprop net.wlan0.dns1 1.1.1.1  > /dev/null 2>&1
            setprop net.wlan0.dns2 1.0.0.1  > /dev/null 2>&1
            setprop 2606:4700:4700::1111  > /dev/null 2>&1
            setprop 2606:4700:4700::1001  > /dev/null 2>&1
        elif [ "$GetDnsType" == "google" ];then
            echo "use google dns "| tee -a $saveLog 
            # reset
            ResetDns
            # reset
            iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 8.8.8.8:53  > /dev/null 2>&1
            iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 8.8.4.4:53  > /dev/null 2>&1
            iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 8.8.8.8:53  > /dev/null 2>&1
            iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 8.8.4.4:53  > /dev/null 2>&1
            ip6tables -t nat -A OUTPUT -p 6 --dport 53 -j DNAT --to-destination 2001:4860:4860:8888  > /dev/null 2>&1
            ip6tables -t nat -I OUTPUT -p 6 --dport 53 -j DNAT --to-destination 2001:4860:4860:8844  > /dev/null 2>&1
            ip6tables -t nat -A OUTPUT -p 17 --dport 53 -j DNAT --to-destination 2001:4860:4860:8888  > /dev/null 2>&1
            ip6tables -t nat -I OUTPUT -p 17 --dport 53 -j DNAT --to-destination 2001:4860:4860:8844  > /dev/null 2>&1
            # SETPROP
            setprop net.eth0.dns1 8.8.8.8  > /dev/null 2>&1
            setprop net.eth0.dns2 8.8.4.4  > /dev/null 2>&1
            setprop net.dns1 8.8.8.8  > /dev/null 2>&1
            setprop net.dns2 8.8.4.4  > /dev/null 2>&1
            setprop net.ppp0.dns1 8.8.8.8  > /dev/null 2>&1
            setprop net.ppp0.dns2 8.8.4.4  > /dev/null 2>&1
            setprop net.rmnet0.dns1 8.8.8.8  > /dev/null 2>&1
            setprop net.rmnet0.dns2 8.8.4.4  > /dev/null 2>&1
            setprop net.rmnet1.dns1 8.8.8.8  > /dev/null 2>&1
            setprop net.rmnet1.dns2 8.8.4.4  > /dev/null 2>&1
            setprop net.rmnet2.dns1 8.8.8.8  > /dev/null 2>&1
            setprop net.rmnet2.dns2 8.8.4.4  > /dev/null 2>&1
            setprop net.pdpbr1.dns1 8.8.8.8  > /dev/null 2>&1
            setprop net.pdpbr1.dns2 8.8.4.4  > /dev/null 2>&1
            setprop net.wlan0.dns1 8.8.8.8  > /dev/null 2>&1
            setprop net.wlan0.dns2 8.8.4.4  > /dev/null 2>&1
            setprop 2001:4860:4860::8888  > /dev/null 2>&1
            setprop 2001:4860:4860::8844  > /dev/null 2>&1
        else
            if [ "$GetDnsType" != "system" ];then
                echo "system" > "$PathModulConfig/dns.txt" > /dev/null 2>&1 
            fi
            echo "use system dns "| tee -a $saveLog 
            # reset
            ResetDns
            # reset
        fi
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    fi
    echo "finished at $(date +"%d-%m-%Y %r")"| tee -a $saveLog > /dev/null 2>&1 ;
    echo "  --- --- --- --- --->> " | tee -a $saveLog > /dev/null 2>&1 
}
if [ -z "$1" ];then
    if [ -e $Path/ZyC_Turbo.running.log  ];then
        rm $Path/ZyC_Turbo.running.log
    fi
    if [ -e $Path/ZyC_Ai.running.log  ];then
        rm $Path/ZyC_Ai.running.log
    fi
fi
runScript 2>&1 | tee -a $Path/ZyC_Turbo.running.log > /dev/null 2>&1 ;