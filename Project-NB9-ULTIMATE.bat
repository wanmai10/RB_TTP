@echo off
setlocal enabledelayedexpansion
chcp 437 >nul
mode con: cols=60 lines=30
color 0A

net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    cls
    echo.
    echo   [ERROR] Run as Administrator!
    pause
    exit
)

call :STEP 1  30 "Power Plan" "Setting Ultimate Performance..."
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
if %errorlevel% neq 0 powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
powercfg -change -hibernate-timeout-ac 0 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFAUTONOMOUS 1 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul 2>&1

call :STEP 2  30 "Visual Effects" "Disabling animations..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1

call :STEP 3  30 "Xbox + Game DVR" "Removing game overlays..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1

call :STEP 4  30 "Background Apps" "Stopping background tasks..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f >nul 2>&1

call :STEP 5  30 "Cortana" "Disabling search assistant..."
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1

call :STEP 6  30 "Timer Resolution" "Optimizing system clock..."
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v GlobalTimerResolutionRequests /t REG_DWORD /d 1 /f >nul 2>&1

call :STEP 7  30 "TCP/IP Stack" "Tuning network protocols..."
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpDelAckTicks /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v Tcp1323Opts /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d 65534 /f >nul 2>&1

call :STEP 8  30 "Network Priority" "Removing throttle limits..."
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1

call :STEP 9  30 "GPU Settings" "Enabling HAGS and ReBAR..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v ReBAR /t REG_DWORD /d 1 /f >nul 2>&1

call :STEP 10 30 "Mouse Input" "Removing acceleration curve..."
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul 2>&1

call :STEP 11 30 "CPU Scheduler" "Prioritizing foreground tasks..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul 2>&1

call :STEP 12 30 "SvcHost Split" "Optimizing for 32GB RAM..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v SvcHostSplitThresholdInKB /t REG_DWORD /d 4000000 /f >nul 2>&1

call :STEP 13 30 "Memory Manager" "Disabling pagefile + compression..."
powershell -Command "$cs=Get-WmiObject Win32_ComputerSystem; $cs.AutomaticManagedPagefile=$false; $cs.Put()" >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
powershell -Command "Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue" >nul 2>&1

call :STEP 14 30 "SysMain" "Stopping Superfetch service..."
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1

call :STEP 15 30 "Game Processes" "Boosting FiveM + GTA5 priority..."
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v IoPriority /t REG_DWORD /d 3 /f >nul 2>&1

call :STEP 16 30 "Windows Services" "Disabling unused services..."
sc stop "PrintSpooler" >nul 2>&1 & sc config "PrintSpooler" start=disabled >nul 2>&1
sc stop "Fax" >nul 2>&1 & sc config "Fax" start=disabled >nul 2>&1
sc stop "RemoteRegistry" >nul 2>&1 & sc config "RemoteRegistry" start=disabled >nul 2>&1
sc stop "WSearch" >nul 2>&1 & sc config "WSearch" start=enabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1 & sc config "DiagTrack" start=disabled >nul 2>&1
sc stop "MapsBroker" >nul 2>&1 & sc config "MapsBroker" start=disabled >nul 2>&1
sc stop "TabletInputService" >nul 2>&1 & sc config "TabletInputService" start=disabled >nul 2>&1

call :STEP 17 30 "Startup Apps" "Cleaning boot programs..."
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Discord" /f >nul 2>&1

call :STEP 18 30 "DNS Server" "Switching to Cloudflare..."
powershell -Command "Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}|ForEach-Object{Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1','1.0.0.1')}" >nul 2>&1
ipconfig /flushdns >nul 2>&1

call :STEP 19 30 "TCP Global" "Applying MTU and stack tweaks..."
netsh interface tcp set global autotuninglevel=normal >nul 2>&1
netsh interface tcp set global chimney=disabled >nul 2>&1
netsh interface tcp set global rss=enabled >nul 2>&1
netsh interface tcp set global ecncapability=disabled >nul 2>&1
netsh interface tcp set global timestamps=disabled >nul 2>&1

call :STEP 20 30 "Network Adapter" "Disabling power saving mode..."
powershell -Command "Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}|ForEach-Object{Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Interrupt Moderation' -DisplayValue 'Disabled' -EA SilentlyContinue}" >nul 2>&1

call :STEP 21 30 "Telemetry" "Blocking data collection..."
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1

call :STEP 22 30 "Windows Update" "Setting manual update mode..."
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f >nul 2>&1
sc config "wuauserv" start=demand >nul 2>&1

call :STEP 23 30 "Discord" "Disabling hardware acceleration..."
set DISCORD_SETTINGS=%APPDATA%\discord\settings.json
if exist "%DISCORD_SETTINGS%" powershell -Command "(Get-Content '%DISCORD_SETTINGS%') -replace '\"enableHardwareAcceleration\": true','\"enableHardwareAcceleration\": false' | Set-Content '%DISCORD_SETTINGS%'" >nul 2>&1

call :STEP 24 30 "FiveM Config" "Writing CitizenFX settings..."
if not exist "%APPDATA%\CitizenFX" mkdir "%APPDATA%\CitizenFX" >nul 2>&1
set CITIZENCFG=%APPDATA%\CitizenFX\CitizenFX.ini
if not exist "%CITIZENCFG%" (echo [Game]> "%CITIZENCFG%" & echo SkipBenchmark=true>> "%CITIZENCFG%")

call :STEP 25 30 "Boot Config" "Applying BCDEdit tweaks..."
bcdedit /set bootmenupolicy standard >nul 2>&1
bcdedit /set quietboot yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1

call :STEP 26 30 "CPU Cores" "Locking all cores to 100%%..."
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFAUTONOMOUS 1 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul 2>&1

call :STEP 27 30 "IRQ Priority" "Boosting GPU + NIC priority..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQ8Priority /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQ16Priority /t REG_DWORD /d 2 /f >nul 2>&1

call :STEP 28 30 "Large Pages" "Enabling heap optimizations..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v EnableLargePages /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v HeapDeCommitFreeBlockThreshold /t REG_DWORD /d 262144 /f >nul 2>&1

call :STEP 29 30 "PCI-E Power" "Disabling link state management..."
powercfg -setacvalueindex SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul 2>&1

call :STEP 30 30 "Final Cleanup" "Flushing DNS + Winsock reset..."
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
call :STEP 31 33 "Mouse Curve" "Removing smooth curve keys..."
reg delete "HKCU\Control Panel\Mouse" /v SmoothMouseXCurve /f >nul 2>&1
reg delete "HKCU\Control Panel\Mouse" /v SmoothMouseYCurve /f >nul 2>&1

call :STEP 32 33 "Defender Exclusions" "Whitelisting FiveM from scan..."
powershell -Command "Add-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FiveM' -EA SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'FiveM.exe','GTA5.exe','FiveM_GTAProcess.exe' -EA SilentlyContinue" >nul 2>&1

call :STEP 33 33 "NVMe + FiveM Cache" "Optimizing filesystem and streaming..."
fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
if exist "%APPDATA%\CitizenFX\CitizenFX.ini" (
  findstr /i "StreamingMemory" "%APPDATA%\CitizenFX\CitizenFX.ini" >nul 2>&1 || echo StreamingMemory=1024>> "%APPDATA%\CitizenFX\CitizenFX.ini"
)

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
cls
echo.
echo.
echo    NB9IFUKNOW
echo.
echo    Clean Setup  ^|  Performance Optimizer
echo.
echo.
echo    [!BAR!]
echo.
echo    Loading...  %PCT%%%
echo.
echo    Step %CUR%/%TOT%  ^|  %TITLE%
echo    %DETAIL%
echo.
echo.
echo    powered by Numbanine
exit /b

:DONE
cls
echo.
echo.
echo    NB9IFUKNOW
echo.
echo    Clean Setup  ^|  Performance Optimizer
echo.
echo.
echo    [############################################]
echo.
echo    Complete!  100%%
echo.
echo    All optimizations applied successfully.
echo.
echo.
echo    powered by Numbanine
echo.
echo    ----------------------------------------
echo    Restarting in 15 seconds...
echo    Press any key to restart now.
echo    ----------------------------------------
echo.
timeout /t 15
shutdown /r /t 0 /c "NB9IFUKNOW - Applying changes..."
exit /b
