@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
mode con: cols=96 lines=42
color 0A
set "LOGFILE=%TEMP%\NB9_EXTREME_runtime.log"
set "BACKUP=%~dp0nb9-ultimate-max.backup.bat"
copy /y "%~f0" "%BACKUP%" >nul 2>&1
> "%LOGFILE%" echo NB9 EXTREME started at %DATE% %TIME%

net session >nul 2>&1
if errorlevel 1 (
    color 0C
    cls
    echo.
    echo   [ERROR] Run as Administrator!
    pause
    exit /b 1
)

call :STEP 1 15 "Power Plan" "Ultimate Performance + max CPU boost"
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
if errorlevel 1 powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
powercfg -change -hibernate-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFAUTONOMOUS 1 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul 2>&1

call :STEP 2 15 "Visuals" "Remove every UI and animation tax"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90 00 00 00 /f >nul 2>&1

call :STEP 3 15 "Overlays" "Kill game overlays and capture"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1

call :STEP 4 15 "Background Apps" "Shut down background process spam"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>&1

call :STEP 5 15 "Boot / Timer" "Low-latency boot and timer behavior"
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set bootmenupolicy standard >nul 2>&1
bcdedit /set quietboot no >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v GlobalTimerResolutionRequests /t REG_DWORD /d 1 /f >nul 2>&1

call :STEP 6 15 "Network" "Cloudflare DNS + hard TCP stack tuning"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' } | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses ('1.1.1.1','1.0.0.1','8.8.8.8','8.8.4.4') }" >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh interface tcp set global autotuninglevel=normal >nul 2>&1
netsh interface tcp set global chimney=disabled >nul 2>&1
netsh interface tcp set global rss=enabled >nul 2>&1
netsh interface tcp set global ecncapability=disabled >nul 2>&1
netsh interface tcp set global timestamps=disabled >nul 2>&1
netsh interface tcp set global rsc=disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpDelAckTicks /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d 65534 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1

call :STEP 7 15 "GPU" "HAGS / ReBAR / TDR off + GPU priority"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v ReBAR /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrLevel /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

call :STEP 8 15 "CPU Scheduler" "Foreground tasks first"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v SvcHostSplitThresholdInKB /t REG_DWORD /d 4000000 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v EnableLargePages /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v HeapDeCommitFreeBlockThreshold /t REG_DWORD /d 262144 /f >nul 2>&1

call :STEP 9 15 "FiveM / GTA" "Force high priority and full core use"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v IoPriority /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v CpuAffinityMask /t REG_DWORD /d 0xFFFFFFFF /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v DisableFullscreenOptimizations /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions" /v IoPriority /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions" /v CpuAffinityMask /t REG_DWORD /d 0xFFFFFFFF /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions" /v DisableFullscreenOptimizations /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM_GTAProcess.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM_GTAProcess.exe\PerfOptions" /v IoPriority /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM_GTAProcess.exe\PerfOptions" /v CpuAffinityMask /t REG_DWORD /d 0xFFFFFFFF /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM_GTAProcess.exe\PerfOptions" /v DisableFullscreenOptimizations /t REG_DWORD /d 1 /f >nul 2>&1

call :STEP 10 15 "Services" "Disable background services aggressively"
sc stop SysMain >nul 2>&1 & sc config SysMain start=disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1 & sc config DiagTrack start=disabled >nul 2>&1
sc stop MapsBroker >nul 2>&1 & sc config MapsBroker start=disabled >nul 2>&1
sc stop WSearch >nul 2>&1 & sc config WSearch start=disabled >nul 2>&1
sc stop PrintSpooler >nul 2>&1 & sc config PrintSpooler start=disabled >nul 2>&1
sc stop Fax >nul 2>&1 & sc config Fax start=disabled >nul 2>&1
sc stop RemoteRegistry >nul 2>&1 & sc config RemoteRegistry start=disabled >nul 2>&1
sc stop TabletInputService >nul 2>&1 & sc config TabletInputService start=disabled >nul 2>&1
sc stop wuauserv >nul 2>&1 & sc config wuauserv start=disabled >nul 2>&1
sc stop BITS >nul 2>&1 & sc config BITS start=disabled >nul 2>&1
sc stop XboxGipSvc >nul 2>&1 & sc config XboxGipSvc start=disabled >nul 2>&1
sc stop XblAuthManager >nul 2>&1 & sc config XblAuthManager start=disabled >nul 2>&1
sc stop XblGameSave >nul 2>&1 & sc config XblGameSave start=disabled >nul 2>&1
sc stop GamingServices >nul 2>&1 & sc config GamingServices start=disabled >nul 2>&1

call :STEP 11 15 "Discord / CitizenFX" "Cut extra overhead"
set DISCORD_SETTINGS=%APPDATA%\discord\settings.json
if exist "%DISCORD_SETTINGS%" powershell -Command "(Get-Content '%DISCORD_SETTINGS%') -replace '\"enableHardwareAcceleration\": true','\"enableHardwareAcceleration\": false' | Set-Content '%DISCORD_SETTINGS%'" >nul 2>&1
if not exist "%APPDATA%\CitizenFX" mkdir "%APPDATA%\CitizenFX" >nul 2>&1
set CITIZENCFG=%APPDATA%\CitizenFX\CitizenFX.ini
if not exist "%CITIZENCFG%" (
    > "%CITIZENCFG%" echo [Game]
    >> "%CITIZENCFG%" echo SkipBenchmark=true
    >> "%CITIZENCFG%" echo StreamingMemory=2048
) else (
    findstr /i "StreamingMemory" "%CITIZENCFG%" >nul 2>&1 || echo StreamingMemory=2048>> "%CITIZENCFG%"
)

call :STEP 12 15 "NIC" "Disable all power-saving and offload tricks"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$nic = (Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1 -ExpandProperty Name); if ($nic) { Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Interrupt Moderation' -DisplayValue 'Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Large Send Offload V2 (IPv4)' -DisplayValue 'Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Large Send Offload V2 (IPv6)' -DisplayValue 'Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'TCP Checksum Offload (IPv4)' -DisplayValue '0 - Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'UDP Checksum Offload (IPv4)' -DisplayValue '0 - Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Flow Control' -DisplayValue 'Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Interrupt Moderation Rate' -DisplayValue '0' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'ITR' -DisplayValue '0' -EA SilentlyContinue }" >nul 2>&1

call :STEP 13 15 "Telemetry / Defender" "Block background interference hard"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f >nul 2>&1
sc config wuauserv start=demand >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FiveM' -EA SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'FiveM.exe','GTA5.exe','FiveM_GTAProcess.exe' -EA SilentlyContinue" >nul 2>&1

call :STEP 14 15 "Storage / FS" "Disable extra filesystem noise"
fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1

call :STEP 15 15 "Cleanup" "Flush DNS, reset winsock, reboot"
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
call :DONE
exit /b

:STEP
set /a CUR=%1
set /a TOT=%2
set TITLE=%~3
set DETAIL=%~4
set /a PCT=CUR*100/TOT
set /a FILLED=CUR*44/TOT
set /a EMPTY=44-FILLED
set BAR=
for /l %%i in (1,1,%FILLED%) do set BAR=!BAR!#
for /l %%i in (1,1,%EMPTY%) do set BAR=!BAR!-
>> "%LOGFILE%" echo [STEP] %CUR%/%TOT% - %TITLE% - %DETAIL%
cls
echo.
echo.
echo    NB9 EXTREME
echo.
echo    No-Safety Performance Build
echo.
echo    [!BAR!]
echo.
echo    Loading...  %PCT%%%
echo.
echo    Step %CUR%/%TOT%  ^|  %TITLE%
echo    %DETAIL%
echo.
echo.
echo    powered by NB9
exit /b

:DONE
cls
echo.
echo.
echo    NB9 EXTREME
echo.
echo    No-Safety Performance Build
echo.
echo    Complete!  100%%
echo.
echo    Rebooting in 15 seconds...
echo.
timeout /t 15 >nul
shutdown /r /f /t 0 /c "NB9 EXTREME - Applying extreme performance tweaks..." >nul 2>&1
if errorlevel 1 powershell -NoProfile -Command "Restart-Computer -Force" >nul 2>&1
exit /b
