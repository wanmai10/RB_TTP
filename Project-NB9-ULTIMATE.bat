@echo off
setlocal enabledelayedexpansion
chcp 437 >nul
mode con: cols=60 lines=40
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

call :STEP 1  45 "Power Plan" "Setting Ultimate Performance..."
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
if %errorlevel% neq 0 powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
powercfg -change -hibernate-timeout-ac 0 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFAUTONOMOUS 1 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul 2>&1

call :STEP 2  45 "Visual Effects" "Disabling animations..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul 2>&1

call :STEP 3  45 "Xbox + Game DVR" "Removing game overlays..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1

call :STEP 4  45 "Background Apps" "Stopping background tasks..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f >nul 2>&1

call :STEP 5  45 "Cortana" "Disabling search assistant..."
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1

call :STEP 6  45 "Timer Resolution" "Optimizing system clock..."
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v GlobalTimerResolutionRequests /t REG_DWORD /d 1 /f >nul 2>&1

call :STEP 7  45 "TCP/IP Stack" "Tuning network protocols..."
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpDelAckTicks /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v Tcp1323Opts /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d 65534 /f >nul 2>&1

call :STEP 8  45 "Network Priority" "Removing throttle limits..."
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1

call :STEP 9  45 "GPU Settings" "Enabling HAGS and ReBAR..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v ReBAR /t REG_DWORD /d 1 /f >nul 2>&1

call :STEP 10 45 "Mouse Input" "Removing acceleration curve..."
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul 2>&1

call :STEP 11 45 "CPU Scheduler" "Prioritizing foreground tasks..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul 2>&1

call :STEP 12 45 "SvcHost Split" "Optimizing for 32GB RAM..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v SvcHostSplitThresholdInKB /t REG_DWORD /d 4000000 /f >nul 2>&1

call :STEP 13 45 "Memory Manager" "Disabling pagefile + compression..."
powershell -Command "$cs=Get-WmiObject Win32_ComputerSystem; $cs.AutomaticManagedPagefile=$false; $cs.Put()" >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
powershell -Command "Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue" >nul 2>&1

call :STEP 14 45 "SysMain" "Stopping Superfetch service..."
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1

call :STEP 15 45 "Game Processes" "Boosting FiveM + GTA5 priority..."
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v IoPriority /t REG_DWORD /d 3 /f >nul 2>&1

call :STEP 16 45 "Windows Services" "Disabling unused services..."
sc stop "PrintSpooler" >nul 2>&1 & sc config "PrintSpooler" start=disabled >nul 2>&1
sc stop "Fax" >nul 2>&1 & sc config "Fax" start=disabled >nul 2>&1
sc stop "RemoteRegistry" >nul 2>&1 & sc config "RemoteRegistry" start=disabled >nul 2>&1
sc stop "WSearch" >nul 2>&1 & sc config "WSearch" start=enabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1 & sc config "DiagTrack" start=disabled >nul 2>&1
sc stop "MapsBroker" >nul 2>&1 & sc config "MapsBroker" start=disabled >nul 2>&1
sc stop "TabletInputService" >nul 2>&1 & sc config "TabletInputService" start=disabled >nul 2>&1

call :STEP 17 45 "Startup Apps" "Cleaning boot programs..."
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Discord" /f >nul 2>&1

call :STEP 18 45 "DNS Server" "Switching to Cloudflare..."
powershell -Command "Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}|ForEach-Object{Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1','1.0.0.1')}" >nul 2>&1
ipconfig /flushdns >nul 2>&1

call :STEP 19 45 "TCP Global" "Applying MTU and stack tweaks..."
netsh interface tcp set global autotuninglevel=normal >nul 2>&1
netsh interface tcp set global chimney=disabled >nul 2>&1
netsh interface tcp set global rss=enabled >nul 2>&1
netsh interface tcp set global ecncapability=disabled >nul 2>&1
netsh interface tcp set global timestamps=disabled >nul 2>&1

call :STEP 20 45 "Network Adapter" "Disabling power saving mode..."
powershell -Command "Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}|ForEach-Object{Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName 'Interrupt Moderation' -DisplayValue 'Disabled' -EA SilentlyContinue}" >nul 2>&1

call :STEP 21 45 "Telemetry" "Blocking data collection..."
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1

call :STEP 22 45 "Windows Update" "Setting manual update mode..."
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f >nul 2>&1
sc config "wuauserv" start=demand >nul 2>&1

call :STEP 23 45 "Discord" "Disabling hardware acceleration..."
set DISCORD_SETTINGS=%APPDATA%\discord\settings.json
if exist "%DISCORD_SETTINGS%" powershell -Command "(Get-Content '%DISCORD_SETTINGS%') -replace '\"enableHardwareAcceleration\": true','\"enableHardwareAcceleration\": false' | Set-Content '%DISCORD_SETTINGS%'" >nul 2>&1

call :STEP 24 45 "FiveM Config" "Writing CitizenFX settings..."
if not exist "%APPDATA%\CitizenFX" mkdir "%APPDATA%\CitizenFX" >nul 2>&1
set CITIZENCFG=%APPDATA%\CitizenFX\CitizenFX.ini
if not exist "%CITIZENCFG%" (echo [Game]> "%CITIZENCFG%" & echo SkipBenchmark=true>> "%CITIZENCFG%")

call :STEP 25 45 "Boot Config" "Applying BCDEdit tweaks..."
bcdedit /set bootmenupolicy standard >nul 2>&1
bcdedit /set quietboot yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1

call :STEP 26 45 "CPU Cores" "Locking all cores to 100%%..."
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFAUTONOMOUS 1 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul 2>&1

call :STEP 27 45 "IRQ Priority" "Boosting GPU + NIC priority..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQ8Priority /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQ16Priority /t REG_DWORD /d 2 /f >nul 2>&1

call :STEP 28 45 "Large Pages" "Enabling heap optimizations..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v EnableLargePages /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v HeapDeCommitFreeBlockThreshold /t REG_DWORD /d 262144 /f >nul 2>&1

call :STEP 29 45 "PCI-E Power" "Disabling link state management..."
powercfg -setacvalueindex SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul 2>&1

call :STEP 30 45 "Final Cleanup" "Flushing DNS + Winsock reset..."
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
call :STEP 31 45 "Mouse Curve" "Removing smooth curve keys..."
reg delete "HKCU\Control Panel\Mouse" /v SmoothMouseXCurve /f >nul 2>&1
reg delete "HKCU\Control Panel\Mouse" /v SmoothMouseYCurve /f >nul 2>&1

call :STEP 32 45 "Defender Exclusions" "Whitelisting FiveM from scan..."
powershell -Command "Add-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FiveM' -EA SilentlyContinue" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'FiveM.exe','GTA5.exe','FiveM_GTAProcess.exe' -EA SilentlyContinue" >nul 2>&1

call :STEP 33 45 "NVMe + FiveM Cache" "Optimizing filesystem and streaming..."
fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
if exist "%APPDATA%\CitizenFX\CitizenFX.ini" (
  findstr /i "StreamingMemory" "%APPDATA%\CitizenFX\CitizenFX.ini" >nul 2>&1 || echo StreamingMemory=1024>> "%APPDATA%\CitizenFX\CitizenFX.ini"
)

call :STEP 34 45 "LSO Offload" "Disabling Large Send Offload..."
powershell -Command "$nic=(Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}).Name; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Large Send Offload V2 (IPv4)' -DisplayValue 'Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Large Send Offload V2 (IPv6)' -DisplayValue 'Disabled' -EA SilentlyContinue" >nul 2>&1

call :STEP 35 45 "Checksum Offload" "Disabling TCP/UDP checksum offload..."
powershell -Command "$nic=(Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}).Name; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'TCP Checksum Offload (IPv4)' -DisplayValue '0 - Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'UDP Checksum Offload (IPv4)' -DisplayValue '0 - Disabled' -EA SilentlyContinue" >nul 2>&1

call :STEP 36 45 "Flow Control" "Disabling flow control..."
powershell -Command "$nic=(Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}).Name; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Flow Control' -DisplayValue 'Disabled' -EA SilentlyContinue" >nul 2>&1

call :STEP 37 45 "PM ARP/NS Offload" "Disabling power management offload..."
powershell -Command "$nic=(Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}).Name; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName '*PMARPOffload' -DisplayValue '0 - Disabled' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName '*PMNSOffload' -DisplayValue '0 - Disabled' -EA SilentlyContinue" >nul 2>&1

call :STEP 38 45 "Receive Buffers" "Setting receive/transmit buffers to 512..."
powershell -Command "$nic=(Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}).Name; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName '*ReceiveBuffers' -DisplayValue '512' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName '*TransmitBuffers' -DisplayValue '512' -EA SilentlyContinue" >nul 2>&1

call :STEP 39 45 "Global RSS+RSC" "Disabling RSC, enabling RSS globally..."
netsh int tcp set global rsc=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1

call :STEP 40 45 "Interrupt Moderation Rate" "Setting ITR to 0 (Disabled)..."
powershell -Command "$nic=(Get-NetAdapter -Physical|Where-Object{$_.Status -eq 'Up'}).Name; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'Interrupt Moderation Rate' -DisplayValue '0' -EA SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $nic -DisplayName 'ITR' -DisplayValue '0' -EA SilentlyContinue" >nul 2>&1




set LOGICAL=0
set PCORES_PHYSICAL=0
set IS_HYBRID=0
set PMAX=0
set EMIN=0
set EMAX=0
set PHEX=FFFFFFFF

for /f "skip=1 tokens=*" %%i in ('wmic cpu get NumberOfLogicalProcessors') do (
    if not "%%i"=="" if "!LOGICAL!"=="0" set LOGICAL=%%i
)
for /f "skip=1 tokens=*" %%i in ('wmic cpu get NumberOfCores') do (
    if not "%%i"=="" if "!PCORES_PHYSICAL!"=="0" set PCORES_PHYSICAL=%%i
)

set /a PLOGICAL=PCORES_PHYSICAL*2
set /a ELOGICAL=LOGICAL-PLOGICAL
set /a MAXPROC=LOGICAL-1
set /a PMAX=PLOGICAL-1
set /a EMIN=PLOGICAL
set /a EMAX=MAXPROC

if !ELOGICAL! GTR 0 set IS_HYBRID=1

set /a AFFINITY_P=0
for /l %%i in (0,1,%PMAX%) do (
    set /a AFFINITY_P+=1<<%%i
)
call :ToHex !AFFINITY_P! PHEX

set /a AFFINITY_E=0
if !IS_HYBRID!==1 (
    for /l %%i in (!EMIN!,1,!EMAX!) do (
        set /a AFFINITY_E+=1<<%%i
    )
)
call :ToHex !AFFINITY_E! EHEX

echo.
echo  NB9 - No Lasso CPU Optimizer
echo  ==============================
echo  Logical cores : %LOGICAL%
echo  P-core range  : 0 - %PMAX%
if !IS_HYBRID!==1 (
    echo  E-core range  : !EMIN! - !EMAX!
    echo  P-core mask   : 0x%PHEX%
    echo  E-core mask   : 0x!EHEX!
) else (
    echo  Hybrid CPU    : NO ^(all cores = P-core^)
)
echo  ==============================
echo.

call :STEP 41 45 "CPU Priority" "Setting permanent process priority..."

for %%p in (FiveM.exe GTA5.exe FiveM_GTAProcess.exe) do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%p\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%p\PerfOptions" /v IoPriority /t REG_DWORD /d 3 /f >nul 2>&1
)
for %%p in (chrome.exe Discord.exe OneDrive.exe SearchIndexer.exe MsMpEng.exe svchost.exe) do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%p\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 1 /f >nul 2>&1
)
echo    Done.

call :STEP 42 45 "CPU Scheduler" "Tuning CPU scheduler..."
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo    Done.

call :STEP 43 45 "CPU Affinity" "Setting permanent CPU affinity for FiveM..."
if !IS_HYBRID!==1 (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM.exe\PerfOptions" /v CpuAffinityMask /t REG_DWORD /d !AFFINITY_P! /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions" /v CpuAffinityMask /t REG_DWORD /d !AFFINITY_P! /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM_GTAProcess.exe\PerfOptions" /v CpuAffinityMask /t REG_DWORD /d !AFFINITY_P! /f >nul 2>&1
    for %%p in (chrome.exe Discord.exe OneDrive.exe SearchIndexer.exe) do (
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%p\PerfOptions" /v CpuAffinityMask /t REG_DWORD /d !AFFINITY_E! /f >nul 2>&1
    )
    echo    Hybrid CPU: FiveM pinned to P-cores ^(0x%PHEX%^) 
    echo    Background pinned to E-cores ^(0x!EHEX!^)
) else (
    echo    Non-hybrid CPU: all cores are P-cores, affinity not restricted.
)

call :STEP 44 45 "Power Mode" "Creating auto power plan switcher..."


set PS_ON=%APPDATA%\NB9_GameStart.ps1
set PS_OFF=%APPDATA%\NB9_GameStop.ps1

echo $proc = 'FiveM.exe','GTA5.exe','FiveM_GTAProcess.exe' > "%PS_ON%"
echo $plan = (powercfg -list ^| Select-String 'Ultimate').Line >> "%PS_ON%"
echo if ($plan) { $guid = ($plan -split '\s+')[3]; powercfg -setactive $guid } >> "%PS_ON%"

echo $plan = (powercfg -list ^| Select-String 'Balanced').Line > "%PS_OFF%"
echo if ($plan) { $guid = ($plan -split '\s+')[3]; powercfg -setactive $guid } >> "%PS_OFF%"


schtasks /delete /tn "NB9_GameStart" /f >nul 2>&1
schtasks /delete /tn "NB9_GameStop" /f >nul 2>&1

schtasks /create /tn "NB9_GameStart" /tr "powershell -WindowStyle Hidden -File \"%PS_ON%\"" /sc ONEVENT /ec System /mo "*[System[EventID=4688]]" /ru SYSTEM /f >nul 2>&1
schtasks /create /tn "NB9_GameStop" /tr "powershell -WindowStyle Hidden -File \"%PS_OFF%\"" /sc ONEVENT /ec System /mo "*[System[EventID=4689]]" /ru SYSTEM /f >nul 2>&1

echo    Auto power switcher created.


call :STEP 45 45 "Affinity Apply" "Applying affinity to running processes now..."
if !IS_HYBRID!==1 (
    for %%p in (FiveM GTA5 FiveM_GTAProcess) do (
        powershell -Command "Get-Process '%%p' -EA SilentlyContinue | ForEach-Object { $_.ProcessorAffinity = [IntPtr]!AFFINITY_P! }" >nul 2>&1
    )
    for %%p in (chrome Discord OneDrive SearchIndexer) do (
        powershell -Command "Get-Process '%%p' -EA SilentlyContinue | ForEach-Object { $_.ProcessorAffinity = [IntPtr]!AFFINITY_E! }" >nul 2>&1
    )
    echo    Applied to running processes.
)
echo.

call :DONE
exit /b

:ToHex
set /a _n=%1
set _h=
set _c=0123456789ABCDEF
:_loop
set /a _r=_n%%16
set /a _n=_n/16
for /f %%d in ('powershell "[char]((0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46)[%_r%])"') do set _h=%%d!_h!
if !_n! GTR 0 goto _loop
set %2=!_h!
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
