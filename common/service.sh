# Created By : ZyCromerZ
# tweak gpu
# you can try on off my feature
# prepare function
# sleep 2s
FromTerminal="tidak";
if [ ! -z "$1" ];then
    if [ "$1" == "Terminal" ];then
        FromTerminal="ya";
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
# echo $NyariGPU
# Path=/sdcard/modul_mantul/ZyC_mod
if [ ! -e /data/mod_path.txt ]; then
    echo "/data/media/0" > /data/mod_path.txt
fi
ModPath=$(cat /data/mod_path.txt)
Path=$ModPath/modul_mantul/ZyC_mod
PathModulConfigAi=$Path/ZyC_Ai
if [ ! -d $Path/ZyC_Turbo_config ]; then
    mkdir -p $Path/ZyC_Turbo_config
fi
PathModulConfig=$Path/ZyC_Turbo_config
if [ ! -d $Path/ZyC_Turbo_config ]; then
    mkdir -p $Path/ZyC_Turbo_config
fi

if [ -e $Path/ZyC_Turbo.log ]; then
    rm $Path/ZyC_Turbo.log
fi
saveLog=$Path/ZyC_Turbo.log
echo "this module created by : ZyCromerZ " | tee -a $saveLog;
echo "to increase your GPU performance " | tee -a $saveLog;
echo "check note_en.txt/note_id.txt for detail :D" | tee -a $saveLog;
if [ $FromTerminal == "tidak" ];then
    echo "running with boot detected" | tee -a $saveLog;
else
    echo "running without boot detected" | tee -a $saveLog;
fi
# status modul
if [ ! -e $PathModulConfig/status_modul.txt ]; then
    echo 'turbo' > $PathModulConfig/status_modul.txt
fi
GetMode=$(cat $PathModulConfig/status_modul.txt)
# mode render
if [ ! -e $PathModulConfig/mode_render.txt ]; then
    echo 'skiagl' > $PathModulConfig/mode_render.txt
fi
RenderMode=$(cat $PathModulConfig/mode_render.txt)
# max fps nya
if [ ! -e $PathModulConfig/total_fps.txt ]; then
    echo '0' > $PathModulConfig/total_fps.txt
fi
SetRefreshRate=$(cat $PathModulConfig/total_fps.txt)
# Status Log nya
if [ ! -e $PathModulConfig/disable_log_system.txt ]; then
    echo '1' > $PathModulConfig/disable_log_system.txt
fi
LogStatus=$(cat $PathModulConfig/disable_log_system.txt)
# fast charging
if [ ! -e $PathModulConfig/fastcharge.txt ]; then
    echo '1' > $PathModulConfig/fastcharge.txt
fi
FastCharge=$(cat $PathModulConfig/fastcharge.txt)
# setting adrenoboost
if [ ! -e $PathModulConfig/GpuBooster.txt ]; then
    echo '4' > $PathModulConfig/GpuBooster.txt
fi
GpuBooster=$(cat $PathModulConfig/GpuBooster.txt)
# setting fsync
if [ ! -e $PathModulConfig/fsync_mode.txt ]; then
    echo '0' > $PathModulConfig/fsync_mode.txt
fi
fsyncMode=$(cat $PathModulConfig/fsync_mode.txt)
# # setting thermal
# if [ ! -e $PathModulConfig/mode_thermal.txt ]; then
#     echo '1' > $PathModulConfig/mode_thermal.txt
# fi
# ThermalMode=$(cat $PathModulConfig/mode_thermal.txt)
# setting custom Ram Management
# if [ ! -e $PathModulConfig/custom_ram_management.txt ]; then
#     echo '0' > $PathModulConfig/custom_ram_management.txt
# fi
# CustomRam=$(cat $PathModulConfig/custom_ram_management.txt)
# notes
if [ ! -e $PathModulConfig/notes_en.txt ]; then
    # echo "please read this xD \nyou can set mode.txt to:\n- off \n- on \n- turbo \nvalue must same as above without'-'\n\nchange mode_render.txt to:\n-  opengl \n-  skiagl \n-  skiavk \n\n note:\n-skiavk = Vulkan \n-skiagl = OpenGL (SKIA)\ndont edit total_fps.txt still not tested" > $PathModulConfig/notes.txt
    SetNotes=$PathModulConfig/notes_en.txt;
    echo "this is note from me to you xD" | tee -a $SetNotes > /dev/null 2>&1;
    echo "tested using Aegis OC & non OC kernel" | tee -a $SetNotes > /dev/null 2>&1;
    echo "first things you can edit status_modul.txt, mode_render.txt, disable_log_system.txt, fastcharge.txt" | tee -a $SetNotes > /dev/null 2>&1;
    echo "leave total_fps.txt value to 0, still not tested" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(dah di tes pake Aegis OC & non OC kernel)" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(lu bisa edit status_modul.txt, mode_render.txt, disable_log_system.txt, fastcharge.txt)" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(biarin total_fps.txt isinya 0, belum di test)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    echo "edit status_modul.txt for change this modul profile,you can set to :" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(ngedit status_modul.txt buat rubah profile modulnya,bisa di set ke :)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- off" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- on" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- turbo" | tee -a $SetNotes > /dev/null 2>&1;
    echo "Note : off to disable module,on to enable,and turbo for increase gpu to maximum,you will get battery drain(not munch) but you can try it" | tee -a $SetNotes > /dev/null 2>&1;
    # # echo "(Note : off buat disable module,on buat nge aktifin lah,ama turbo biar main game asik,tapi battery drain(kaga banyak) coba aja dah)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    echo "edit mode_render.txt for change your gpu render,you can set to :" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(ngedit mode_render.txt buat ubah gpu render,bisa di set ke :)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- opengl" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- skiagl" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- skiavk" | tee -a $SetNotes > /dev/null 2>&1;
    echo "Note :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- opengl = OpenGL (default) -> default android set" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- skiagl = OpenGL (SKIA) -> default value for this tweak " | tee -a $SetNotes > /dev/null 2>&1;
    echo "- skiavk = Vulkan (dont set to this if you dont know anything) " | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    echo "edit disable_log_system.txt to disable log system,but increase little performance(NEED RESTART maybe)[ and maybe xD] you can set to:" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(ngedit disable_log_system.txt buat disable log system,tapi bisa ningkatin dikit performance(WAJIB RESTART mungkin) dan mungkin bisa di set ke :)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1" | tee -a $SetNotes > /dev/null 2>&1;
    echo "Note :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0 = still active [masih aktip]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1 = disable log [ga tau artinya kebangetan lu njirr]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    echo "edit fastcharge.txt for make this module to trying enable fastcharging for your devices" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(ngedit fastcharge.txt buat modul ini nyoba nge jalanin fastcharging di hp lu)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1" | tee -a $SetNotes > /dev/null 2>&1;
    echo "Note :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0 = disable,if your system has enabled fastcharging,you dont need this" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1 = active, this module will trying to enable fastcharging for your devices " | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    echo "edit GpuBooster.txt for edit adrenoboost value,leave it as default option" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(ngedit GpuBooster.txt buat adrenoboost nya,biarin aja default biar enak :D)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 2" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 3" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 4" | tee -a $SetNotes > /dev/null 2>&1;
    echo "Note :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0 = disable" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1 = low " | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 2 = medium " | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 3 = high " | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 4 = let this set this automatic(recomended) " | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    echo "how to run tweak??" | tee -a $SetNotes > /dev/null 2>&1;
    echo "just open terminal and type [su] and enter and then [zyc_turbo] and enter (without '[]') and done" | tee -a $SetNotes > /dev/null 2>&1;
    echo "or use new method" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(cara pake nya?)" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(cuma buka terminal terus ketik [su] dah gitu enter ketik lagi [zyc_turbo] terus enter  (gausah pake '[]') dan beres)" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(ato pale cara baru)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "after type [su]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "type [zyc_start [off/on/turbo]]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "or" | tee -a $SetNotes > /dev/null 2>&1;
    echo "type [zyc_start [off/on/turbo] [opengl/skiagl/skiavk] ]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "and done . . ." | tee -a $SetNotes > /dev/null 2>&1;
    echo "have a good day xD" | tee -a $SetNotes > /dev/null 2>&1;
    echo "and remember type without '[]' and '/' (choose 1)" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(dan ingat kaga pake '[]' ama '/'(pilih 1) terus type itu ketik)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "example :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "$ su" | tee -a $SetNotes > /dev/null 2>&1;
    echo "$ zyc_start off" | tee -a $SetNotes > /dev/null 2>&1;
    echo "or" | tee -a $SetNotes > /dev/null 2>&1;
    echo "$ su" | tee -a $SetNotes > /dev/null 2>&1;
    echo "$ zyc_start on opengl" | tee -a $SetNotes > /dev/null 2>&1;
    echo "NOTE : before you update this module to latest version please set to mode off and delete this note and folder backup, and then flash new modul and reboot" | tee -a $SetNotes > /dev/null 2>&1;
    echo "note again:" | tee -a $SetNotes > /dev/null 2>&1;
    echo "zyc_turbo = for active modul based config inside internal/modul_mantul/ " | tee -a $SetNotes > /dev/null 2>&1;
    echo "zyc_mode = change profil/mode tweak " | tee -a $SetNotes > /dev/null 2>&1;
    echo "zyc_render = change render mode " | tee -a $SetNotes > /dev/null 2>&1;
    echo "zyc_start = start only or start with change mode tweak and  render or mode tweak only :D " | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(NOTE : sebelum lu update ni module ke versi terbaru, set ke mode off dulu terus delete note  ini ama folder backup, terus flash modul baru terus reboot)" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "(emang ada modul note nya pake bahasa indo? ini ada bambang!!)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "create notes_en.txt done . . . :D" | tee -a $saveLog;
fi
if [ ! -e $PathModulConfig/notes_id.txt ]; then
    # echo "please read this xD \nyou can set mode.txt to:\n- off \n- on \n- turbo \nvalue must same as above without'-'\n\nchange mode_render.txt to:\n-  opengl \n-  skiagl \n-  skiavk \n\n note:\n-skiavk = Vulkan \n-skiagl = OpenGL (SKIA)\ndont edit total_fps.txt still not tested" > $PathModulConfig/notes.txt
    SetNotes=$PathModulConfig/notes_id.txt;
    # echo "this is note from me to you xD" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "tested using Aegis OC & non OC kernel" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "first things you can edit status_modul.txt, mode_render.txt, disable_log_system.txt, fastcharge.txt" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "leave total_fps.txt value to 0, still not tested" | tee -a $SetNotes > /dev/null 2>&1;
    echo "dah di tes pake Aegis OC & non OC kernel" | tee -a $SetNotes > /dev/null 2>&1;
    echo "lu bisa edit status_modul.txt, mode_render.txt, disable_log_system.txt, fastcharge.txt" | tee -a $SetNotes > /dev/null 2>&1;
    echo "biarin total_fps.txt isinya 0, belum di test" | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "edit status_modul.txt for change this modul profile,you can set to :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "(ngedit status_modul.txt buat rubah profile modulnya,bisa di set ke :)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- off" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- on" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- turbo" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "Note : off to disable module,on to enable,and turbo for increase gpu to maximum,you will get battery drain(not munch) but you can try it" | tee -a $SetNotes > /dev/null 2>&1;
    echo "(Note : off buat disable module,on buat nge aktifin lah,ama turbo biar main game asik,tapi battery drain(kaga banyak) coba aja dah)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "edit mode_render.txt for change your gpu render,you can set to :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "ngedit mode_render.txt buat ubah gpu render,bisa di set ke :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- opengl" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- skiagl" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- skiavk" | tee -a $SetNotes > /dev/null 2>&1;
    echo "Note :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- opengl = OpenGL (default) -> default android set [setingan awal dari sono nya]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- skiagl = OpenGL (SKIA) -> default value for this tweak [setingan ni tweak]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- skiavk = Vulkan (SKIA) -> coba aja ndiri, resiko tanggung lu aja :v ]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "edit disable_log_system.txt to disable log system,but increase little performance(NEED RESTART maybe)[ and maybe xD] you can set to:" | tee -a $SetNotes > /dev/null 2>&1;
    echo "ngedit disable_log_system.txt buat disable log system,tapi bisa ningkatin dikit performance(WAJIB RESTART mungkin) dan mungkin bisa di set ke :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1" | tee -a $SetNotes > /dev/null 2>&1;
    echo "Note :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0 = masih aktip" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1 = di matikan log nya" | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "edit fastcharge.txt for make this module to trying enable fastcharging for your devices" | tee -a $SetNotes > /dev/null 2>&1;
    echo "ngedit fastcharge.txt buat modul ini nyoba nge jalanin fastcharging di hp lu" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1" | tee -a $SetNotes > /dev/null 2>&1;
    echo "Note :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0 = disable, pengaturan di serahin ke default" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1 = active,ni modul bakal nyoba nyalain fastcharging di hp lu" | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "edit GpuBooster.txt for edit adrenoboost value,leave it as default option" | tee -a $SetNotes > /dev/null 2>&1;
    echo "ngedit GpuBooster.txt buat adrenoboost nya,biarin aja default biar enak :D" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 2" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 3" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 4" | tee -a $SetNotes > /dev/null 2>&1;
    echo "Note :" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 0 = disable" | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 1 = low " | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 2 = medium " | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 3 = high " | tee -a $SetNotes > /dev/null 2>&1;
    echo "- 4 = mending pake ini biarkan modul yg menyesuaikannya" | tee -a $SetNotes > /dev/null 2>&1;
    echo "" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "how to run tweak??" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "just open terminal and type [su] and enter and then [zyc_turbo] and enter (without '[]') and done" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "or use new method" | tee -a $SetNotes > /dev/null 2>&1;
    echo "cara pake nya?" | tee -a $SetNotes > /dev/null 2>&1;
    echo "cuma buka terminal terus ketik [su] dah gitu enter ketik lagi [zyc_turbo] terus enter  (gausah pake '[]') dan beres" | tee -a $SetNotes > /dev/null 2>&1;
    echo "ato pale cara baru" | tee -a $SetNotes > /dev/null 2>&1;
    echo "after type [su]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "type [zyc_start [off/on/turbo]]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "or" | tee -a $SetNotes > /dev/null 2>&1;
    echo "type [zyc_start [off/on/turbo] [opengl/skiagl/skiavk] ]" | tee -a $SetNotes > /dev/null 2>&1;
    echo "and done . . ." | tee -a $SetNotes > /dev/null 2>&1;
    # echo "have a good day xD" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "and remember type without '[]' and '/' (choose 1)" | tee -a $SetNotes > /dev/null 2>&1;
    echo "dan ingat kaga pake '[]' ama '/'(pilih 1) terus type itu ketik" | tee -a $SetNotes > /dev/null 2>&1;
    echo "contoh:" | tee -a $SetNotes > /dev/null 2>&1;
    echo "$ su" | tee -a $SetNotes > /dev/null 2>&1;
    echo "$ zyc_start off" | tee -a $SetNotes > /dev/null 2>&1;
    echo "or" | tee -a $SetNotes > /dev/null 2>&1;
    echo "$ su" | tee -a $SetNotes > /dev/null 2>&1;
    echo "$ zyc_start on opengl" | tee -a $SetNotes > /dev/null 2>&1;
    # echo "NOTE : before you update this module to latest version please set to mode off and delete this note and folder backup, and then flash new modul and reboot" | tee -a $SetNotes > /dev/null 2>&1;
    echo "NOTE : sebelum lu update ni module ke versi terbaru, set ke mode off dulu terus delete note  ini ama folder backup, terus flash modul baru terus reboot" | tee -a $SetNotes > /dev/null 2>&1;
    echo "emang ada modul note nya pake bahasa indo? ini ada bambang!!" | tee -a $SetNotes > /dev/null 2>&1;
    echo "note again:" | tee -a $SetNotes > /dev/null 2>&1;
    echo "zyc_turbo = for active modul based config inside internal/modul_mantul/ " | tee -a $SetNotes > /dev/null 2>&1;
    echo "zyc_mode = change profil/mode tweak " | tee -a $SetNotes > /dev/null 2>&1;
    echo "zyc_render = change render mode " | tee -a $SetNotes > /dev/null 2>&1;
    echo "zyc_start = start only or start with change mode tweak and  render or mode tweak only :D " | tee -a $SetNotes > /dev/null 2>&1;
    echo "buat notes_en.txt done . . . :D" | tee -a $saveLog;
fi
backupDolo(){
  # backup data dolo boss start
  backup="kaga";
  if [ ! -d $PathModulConfig/backup ]; then
      mkdir -p $PathModulConfig/backup
  fi
  #val gpu nya
  if [ ! -e $PathModulConfig/backup/gpu_throttling.txt ]; then
      if [ -e $NyariGPU/throttling ]; then
        echo $(cat "$NyariGPU/throttling") > "$PathModulConfig/backup/gpu_throttling.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/gpu_force_no_nap.txt ]; then
      if [ -e $NyariGPU/force_no_nap ]; then
        echo $(cat "$NyariGPU/force_no_nap") > "$PathModulConfig/backup/gpu_force_no_nap.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/gpu_force_bus_on.txt ]; then
      if [ -e $NyariGPU/force_bus_on ]; then
        echo $(cat "$NyariGPU/force_bus_on") > "$PathModulConfig/backup/gpu_force_bus_on.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/gpu_force_clk_on.txt ]; then
      if [ -e $NyariGPU/force_clk_on ]; then
        echo $(cat "$NyariGPU/force_clk_on") > "$PathModulConfig/backup/gpu_force_clk_on.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/gpu_force_rail_on.txt ]; then
      if [ -e $NyariGPU/force_rail_on ]; then
        echo $(cat "$NyariGPU/force_rail_on") > "$PathModulConfig/backup/gpu_force_rail_on.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/gpu_bus_split.txt ]; then
      if [ -e $NyariGPU/bus_split ]; then
        echo $(cat "$NyariGPU/bus_split") > "$PathModulConfig/backup/gpu_bus_split.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/gpu_max_pwrlevel.txt ]; then
      if [ -e $NyariGPU/max_pwrlevel ]; then
        echo $(cat "$NyariGPU/max_pwrlevel") > "$PathModulConfig/backup/gpu_max_pwrlevel.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/gpu_adrenoboost.txt ]; then
      if [ -e $NyariGPU/devfreq/adrenoboost ]; then
        echo $(cat "$NyariGPU/devfreq/adrenoboost") > "$PathModulConfig/backup/gpu_adrenoboost.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/gpu_thermal_pwrlevel.txt ]; then
      if [ -e $NyariGPU/devfreq/thermal_pwrlevel ]; then
        echo $(cat "$NyariGPU/devfreq/thermal_pwrlevel") > "$PathModulConfig/backup/gpu_thermal_pwrlevel.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  # fsync backup
  if [ ! -e $PathModulConfig/backup/misc_Dyn_fsync_active.txt ]; then
      if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
        echo $(cat  "/sys/kernel/dyn_fsync/Dyn_fsync_active") > "$PathModulConfig/backup/misc_Dyn_fsync_active.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/misc_class_fsync_enabled.txt ]; then
      if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
        echo $(cat  "/sys/class/misc/fsynccontrol/fsync_enabled") > "$PathModulConfig/backup/misc_class_fsync_enabled.txt"
        backup="pake"
        sleep 0.1s
      fi 
  fi

  if [ ! -e $PathModulConfig/backup/misc_fsync.txt ]; then
      if [ -e /sys/module/sync/parameters/fsync ]; then
        echo $(cat  "/sys/module/sync/parameters/fsync") > "$PathModulConfig/backup/misc_fsync.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi

  if [ ! -e $PathModulConfig/backup/misc_module_fsync_enabled.txt ]; then
      if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
        echo $(cat  "/sys/module/sync/parameters/fsync_enabled") > "$PathModulConfig/backup/misc_module_fsync_enabled.txt"
        backup="pake"
        sleep 0.1s
      fi
  fi
  # log prop bakcup :D
  # Disable stats logging & monitoring
  # debug.atrace.tags.enableflags=0
  if [ ! -e $PathModulConfig/backup/prop_debug.atrace.tags.enableflags.txt ]; then
      echo $(getprop  debug.atrace.tags.enableflags) > "$PathModulConfig/backup/prop_debug.atrace.tags.enableflags.txt"
      backup="pake"
      sleep 0.1s
  fi

  # profiler.force_disable_ulog=true
  if [ ! -e $PathModulConfig/backup/prop_profiler.force_disable_ulog.txt ]; then
      echo $(getprop  profiler.force_disable_ulog) > "$PathModulConfig/backup/prop_profiler.force_disable_ulog.txt"
      backup="pake"
      sleep 0.1s
  fi

  # profiler.force_disable_err_rpt=true
  if [ ! -e $PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt ]; then
      echo $(getprop  profiler.force_disable_err_rpt) > "$PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt"
      backup="pake"
      sleep 0.1s
  fi
  
  # profiler.force_disable_err_rpt=1
  if [ ! -e $PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt ]; then
      echo $(getprop  profiler.force_disable_err_rpt) > "$PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt"
      backup="pake"
      sleep 0.1s
  fi

  # ro.config.nocheckin=1
  if [ ! -e $PathModulConfig/backup/prop_ro.config.nocheckin.txt ]; then
      echo $(getprop  ro.config.nocheckin) > "$PathModulConfig/backup/prop_ro.config.nocheckin.txt"
      backup="pake"
      sleep 0.1s
  fi

  # debugtool.anrhistory=0
  if [ ! -e $PathModulConfig/backup/prop_debugtool.anrhistory.txt ]; then
      echo $(getprop  debugtool.anrhistory) > "$PathModulConfig/backup/prop_debugtool.anrhistory.txt"
      backup="pake"
      sleep 0.1s
  fi
  # disable log
  if [ $LogStatus == '1' ];then
      # ro.com.google.locationfeatures=0
      if [ ! -e $PathModulConfig/backup/prop_ro.com.google.locationfeatures.txt ]; then
          echo $(getprop  ro.com.google.locationfeatures) > "$PathModulConfig/backup/prop_ro.com.google.locationfeatures.txt"
          backup="pake"
          sleep 0.1s
      fi

      # ro.com.google.networklocation=0
      if [ ! -e $PathModulConfig/backup/prop_ro.com.google.networklocation.txt ]; then
          echo $(getprop  ro.com.google.networklocation) > "$PathModulConfig/backup/prop_ro.com.google.networklocation.txt"
          backup="pake"
          sleep 0.1s
      fi

      # profiler.debugmonitor=false
      if [ ! -e $PathModulConfig/backup/prop_profiler.debugmonitor.txt ]; then
          echo $(getprop  profiler.debugmonitor) > "$PathModulConfig/backup/prop_profiler.debugmonitor.txt"
          backup="pake"
          sleep 0.1s
      fi

      # profiler.launch=false
      if [ ! -e $PathModulConfig/backup/prop_profiler.launch.txt ]; then
          echo $(getprop  profiler.launch) > "$PathModulConfig/backup/prop_profiler.launch.txt"
          backup="pake"
          sleep 0.1s
      fi

      # profiler.hung.dumpdobugreport=false
      if [ ! -e $PathModulConfig/backup/prop_profiler.hung.dumpdobugreport.txt ]; then
          echo $(getprop  profiler.hung.dumpdobugreport) > "$PathModulConfig/backup/prop_profiler.hung.dumpdobugreport.txt"
          backup="pake"
          sleep 0.1s
      fi

      # persist.service.pcsync.enable=0
      if [ ! -e $PathModulConfig/backup/prop_persist.service.pcsync.enable.txt ]; then
          echo $(getprop  persist.service.pcsync.enable) > "$PathModulConfig/backup/prop_persist.service.pcsync.enable.txt"
          backup="pake"
          sleep 0.1s
      fi

      # persist.service.lgospd.enable=0
      if [ ! -e $PathModulConfig/backup/prop_persist.service.lgospd.enable.txt ]; then
          echo $(getprop  persist.service.lgospd.enable) > "$PathModulConfig/backup/prop_persist.service.lgospd.enable.txt"
          backup="pake"
          sleep 0.1s
      fi

      # persist.sys.purgeable_assets=1
      if [ ! -e $PathModulConfig/backup/prop_persist.sys.purgeable_assets.txt ]; then
          echo $(getprop  persist.sys.purgeable_assets) > "$PathModulConfig/backup/prop_persist.sys.purgeable_assets.txt"
          backup="pake"
          sleep 0.1s
      fi
  fi
# backup data dolo boss end
}

backupDolo
# echo 'aelah';
sleep 0.5s
# log backup nya
  if [ $backup == "pake" ]; then
      echo "backup setting done" | tee -a $saveLog;
  fi
# end log backup
SetOff(){
    echo 'revert setting . . .' | tee -a $saveLog;
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
    echo 'revert done . . .' | tee -a $saveLog;
}
SetOn(){
    echo 'use "on" setting. . .' | tee -a $saveLog;
    #fps limit ke 90
    setprop persist.sys.NV_FPSLIMIT 90
    setprop persist.sys.NV_POWERMODE 1
    setprop persist.sys.NV_PROFVER 15
    setprop persist.sys.NV_STEREOCTRL 0
    setprop persist.sys.NV_STEREOSEPCHG 0
    setprop persist.sys.NV_STEREOSEP 20
    # GPU TWEAK wajib lah biar kaga drop fps xD
    if [ $NyariGPU != '' ];then
        if [ -e $NyariGPU/max_pwrlevel ]; then
          echo "0" > "$NyariGPU/max_pwrlevel"
          echo "0" > "$NyariGPU/max_pwrlevel"
        fi
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
          echo "3" > "$NyariGPU/devfreq/adrenoboost"
        fi
    fi
    echo 'use "on" done. . .' | tee -a $saveLog;

}
SetTurbo(){
    #fps limit ke 120
    echo 'use "turbo" setting. . .' | tee -a $saveLog;
    setprop persist.sys.NV_FPSLIMIT 120
    if  [ $NyariGPU != '' ];then
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
    echo 'use "turbo" done .' | tee -a $saveLog;
}
fstrimDulu(){
    echo "fstrim data cache & system, please wait" | tee -a $saveLog;
    fstrim -v /cache | tee -a $saveLog;
    fstrim -v /data | tee -a $saveLog;
    fstrim -v /system | tee -a $saveLog;
    echo "done ." | tee -a $saveLog;
}
disableFsync(){
    # disable fsync biar ui smooth :D
    echo 'disable fsync . . .' | tee -a $saveLog;
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
    echo 'disable done .' | tee -a $saveLog;
}
enableFsync(){
    # enable fsync
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
}
disableLogSystem(){
# Disable stats logging & monitoring
    echo 'disable log and monitoring . . .' | tee -a $saveLog;
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
    
    echo 'disable log and monitoring done .' | tee -a $saveLog;
}
enableLogSystem(){
# Disable stats logging & monitoring
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
}

# ngator mode start
  if [ $GetMode == 'off' ];then
      SetOff
      echo "turn off tweak" | tee -a $saveLog;
  elif [ $GetMode == 'on' ];then
      SetOff
      SetOn
      # disableFsync
      echo "setting to mode on" | tee -a $saveLog;
  elif [ $GetMode == 'turbo' ];then
      SetOn
      SetTurbo
      # disableFsync
      # disableThermal
      echo "swith to turbo mode" | tee -a $saveLog;
  else
      SetOff
      SetOn
      # disableFsync
      echo "please read guide, mode $GetMode,not found autmatic set to mode on " | tee -a $saveLog;
      echo 'on' > $PathModulConfig/status_modul.txt
  fi
# ngator mode end

# enable fastcharge start
  if [ $FastCharge == "1" ]; then
      if [ -e /sys/kernel/fast_charge/force_fast_charge ]; then
          echo "tying to enable fastcharging using first method" | tee -a $saveLog;
          echo "2" > /sys/kernel/fast_charge/force_fast_charge
          if [ $(cat /sys/kernel/fast_charge/force_fast_charge) -eq "0" ]; then
              echo "tying to enable fastcharging using second method" | tee -a $saveLog;
              echo "1" > /sys/kernel/fast_charge/force_fast_charge
          fi
          echo "tying to enable fastcharging using third method,... \neh no third method just kidding xD" | tee -a $saveLog;
          if [ $(cat /sys/kernel/fast_charge/force_fast_charge) -eq "0" ]; then
              echo "fastcharge off,maybe your kernel/phone not support it" | tee -a $saveLog;
          else
              echo "fastcharge on" | tee -a $saveLog;
          fi

      fi
    
  fi  
# enable fastcharge end

# set fps ? start
  if [ $SetRefreshRate != "0" ];then
      setprop persist.sys.NV_FPSLIMIT $SetRefreshRate
      echo "custom fps detected, set to $SetRefreshRate" | tee -a $saveLog;
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
  if [ $GpuBooster == "0" ];then
      echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
      echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
  elif [ $GpuBooster == "1" ];then
      echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
      echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
  elif [ $GpuBooster == "2" ];then
      echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
      echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
  elif [ $GpuBooster == "3" ];then
      echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
      echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
  else
      echo "nice,use default this tweak GpuBoost" | tee -a $saveLog;
      echo '4' > $PathModulConfig/GpuBooster.txt
  fi
# gpu turbo end

# echo "ok beres dah . . .\n" | tee -a $saveLog;
# gpu render start
  if [ $RenderMode == 'skiagl' ];then
      setprop debug.hwui.renderer skiagl
      echo "set render gpu to OpenGL (SKIA) done" | tee -a $saveLog;
  elif [ $RenderMode == 'skiavk' ];then
      setprop debug.hwui.renderer skiavk
      echo "set render gpu to Vulkan (SKIA) done" | tee -a $saveLog;
  elif [ $RenderMode == 'opengl' ];then
      setprop debug.hwui.renderer opengl
      echo "set render gpu to OpenGL default done" | tee -a $saveLog;
  else
      setprop debug.hwui.renderer skiagl
      echo "mode not found,set to OpenGL (skia) " | tee -a $saveLog;
      echo 'skiagl' > $PathModulConfig/mode_render.txt
  fi
# gpu render end

# disable fsync start
  if [ $fsyncMode == "0" ];then
      disableFsync
      echo "custom fsync detected, set to disable" | tee -a $saveLog;
  elif [ $fsyncMode == "1" ];then
      enableFsync
      echo "custom fsync detected, set to enable" | tee -a $saveLog;
  else
      disableFsync
      echo "fsync value error,set to disable" | tee -a $saveLog;
      echo '0' > $PathModulConfig/fsync_mode.txt
  fi
# disable fsync end

# costum ram managent start
  # if [ $CustomRam == '1' ];then
  #     echo "coming_soon :D"| tee -a $saveLog;
  #     # echo "udah mati broo,selamat battery lu aman :V" | tee -a $saveLog;
  # else
  #     echo "not use custom ram management,good cause still not available :p" | tee -a $saveLog;
  #     # echo "done,selamat menikmati.. eh merasakan modul ini\ncuma makanan yg bisa di nikmati" | tee -a $saveLog;
  # fi;
# costum ram managent end

if [ $GetMode == 'off' ];then
    echo "turn off tweak succeess :D"| tee -a $saveLog;
else
    echo "done,tweak has been turned on" | tee -a $saveLog;
fi;
if [ $GetMode == 'turbo' ];then
    echo "NOTE: just tell you if you use this mode your battery will litle drain" | tee -a $saveLog;
fi;
if [ $LogStatus == '1' ];then
    # enableLogSystem
    disableLogSystem
else
    # disableLogSystem
    enableLogSystem
fi
if [ $FromTerminal == "tidak" ];then
    if [ -e "/system/etc/ZyC_Ai/ai_mode.sh" ];then
        BASEDIR=/system/etc/ZyC_Ai
        if [ -e $PathModulConfigAi/ai_status.txt ]; then
            AiStatus=$(cat "$PathModulConfigAi/ai_status.txt")
            if [ $AiStatus == "1" ];then
                sh $BASEDIR/ai_mode.sh & disown > /dev/null 2>&1
            elif [ $AiStatus == "2" ];then
                sh $BASEDIR/ai_mode.sh & disown > /dev/null 2>&1
            elif [ $AiStatus == "3" ];then
                sh $BASEDIR/ai_mode.sh & disown > /dev/null 2>&1
            elif [ $AiStatus == "0" ];then
                echo "ai status off"| tee -a $saveLog;
            else
                echo "ai status error,set to 0"| tee -a $saveLog;
                echo '0' > "$PathModulConfigAi/ai_status.txt"
            fi
        fi
    fi
fi
echo "finished at $(date +"%d-%m-%Y %r")"| tee -a $saveLog;

exit 0;