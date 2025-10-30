@echo off
set SCRIPT_PATH=D:\Kanata\kanata-tray.ps1
set PS_ARGS=-ExecutionPolicy Bypass -File "%SCRIPT_PATH%"
set CMD=powershell %PS_ARGS%
wscript.exe //e:vbscript //b //nologo "D:\Kanata\launch_hidden.vbs" "%CMD%"
exit
