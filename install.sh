##########################################################################################
#
# Magisk Module Installer Script
# template by @topjohnwu
# edited by ZyCromerZ
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false
# AUTOMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=true

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=true

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################

# Set what you want to display when installing your module

print_modname() {
  ui_print "*******************************"
  ui_print "        ZyC GPU Turbo          "
  ui_print "and special thanks to @nowaydev"
  ui_print "       for channel logo :D     "
  ui_print "≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠"
  ui_print "  _______          ____        "
  ui_print "  \___  /ɢᴘᴜ ᴛᴜʀʙᴏ/  ___\      "
  ui_print "     / /  __   __| /           "
  ui_print "    / /__ \ \ / /| \____       "
  ui_print "   /_____\ \ \ /  \____/       "
  ui_print "            / /                "
  ui_print "           /_/                 "
  ui_print "                               "
  ui_print "≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠"
  ui_print "ᴅᴇsɪɢɴᴇᴅ ʙʏ ɴᴏᴡᴀʏᴅᴇᴠ           "
  ui_print "-------------------------------"
  ui_print "Thx to people for trying this  "
  ui_print "module . . .                   "
  ui_print ""
  ui_print "after reboot check log inside  "
  ui_print "internal/modul_mantul/         "
  ui_print "ZyC_Turbo.log, after reboot    "
  ui_print "find notes_en.txt/notes_en.id  "
  ui_print "and read it xD                 "
  ui_print ""
  ui_print "enjoy . . ."
}

# Copy/extract your module files into $MODPATH in on_install.

on_install() {
  # The following is the default implementation: extract $ZIPFILE/system to $MODPATH
  # Extend/change the logic to whatever you want
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
}

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  # set_perm_recursive $MODPATH 0 0 0755 0644
  bin=xbin
  if [ ! -d system/xbin ]; then
    bin=bin
    mkdir $MODPATH/system/$bin
    mv $MODPATH/system/xbin/* $MODPATH/system/$bin
    rm -rf $MODPATH/system/xbin/*
    rmdir $MODPATH/system/xbin
  else
    rm -rf $MODPATH/system/bin/*
    rmdir $MODPATH/system/bin
  fi
  if [ ! -e  /system/etc/sysconfig/google.xml ]; then
    rm -rf $MODPATH/system/etc/sysconfig/*
    rmdir $MODPATH/system/etc/sysconfig
  else
    # mkdir /system/etc/sysconfig
    if [ -e /system/etc/sysconfig/google.xml.ori ];then
      cp -af /system/etc/sysconfig/google.xml.ori $MODPATH/system/etc/sysconfig/google.xml.ori
      cp -af /system/etc/sysconfig/google.xml.ori $MODPATH/system/etc/sysconfig/google.xml
    else 
      cp -af /system/etc/sysconfig/google.xml $MODPATH/system/etc/sysconfig/google.xml.ori
      cp -af /system/etc/sysconfig/google.xml $MODPATH/system/etc/sysconfig/google.xml 
    fi
    # rm -rf $MODPATH/system/etc/sysconfig/*
  fi
  if [ ! -e  /system/product/etc/sysconfig/google.xml ]; then
    rm -rf $MODPATH/system/product/*
    rmdir $MODPATH/system/product
  else
    if [ -e /system/product/etc/sysconfig/google.xml.ori ];then
      cp -af /system/product/etc/sysconfig/google.xml.ori $MODPATH/system/product/etc/sysconfig/google.xml.ori
      cp -af /system/product/etc/sysconfig/google.xml.ori $MODPATH/system/product/etc/sysconfig/google.xml 
    else
      cp -af /system/product/etc/sysconfig/google.xml $MODPATH/system/product/etc/sysconfig/google.xml.ori
      cp -af /system/product/etc/sysconfig/google.xml $MODPATH/system/product/etc/sysconfig/google.xml 
    fi
    # rm -rf $MODPATH/system/product/*
  fi
  if [ ! -e  /system/system/product/etc/sysconfig/google.xml ]; then
    rm -rf $MODPATH/system/system/*
    rmdir $MODPATH/system/system
  else
    if [ -e /system/system/product/etc/sysconfig/google.xml.ori ];then
      cp -af /system/system/product/etc/sysconfig/google.xml.ori $MODPATH/system/system/product/etc/sysconfig/google.xml.ori
      cp -af /system/system/product/etc/sysconfig/google.xml.ori $MODPATH/system/system/product/etc/sysconfig/google.xml
    else
      cp -af /system/system/product/etc/sysconfig/google.xml $MODPATH/system/system/product/etc/sysconfig/google.xml.ori
      cp -af /system/system/product/etc/sysconfig/google.xml $MODPATH/system/system/product/etc/sysconfig/google.xml
    fi
    # rm -rf $MODPATH/system/system/*
  fi
  set_perm_recursive $MODPATH                   0 0 0755 0777
  set_perm_recursive $MODPATH/system/$bin       0 0 0755 0777
  set_perm_recursive $MODPATH/system/etc/ZyC_Ai 0 0 0755 0777
  if [ -e  /system/etc/sysconfig/google.xml ]; then
     set_perm_recursive $MODPATH/system/etc/sysconfig 0 0 0755 0644
  fi
  if [ -e  /system/product/etc/sysconfig/google.xml ]; then
     set_perm_recursive $MODPATH/system/product 0 0 0755 0644
  fi
  if [ -e  /system/system/product/etc/sysconfig/google.xml ]; then
     set_perm_recursive $MODPATH/system/system 0 0 0755 0644
  fi
  # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}

# You can add more functions to assist your custom script code
