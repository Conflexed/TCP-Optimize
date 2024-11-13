@echo off
title TCP Settings Editor

:admin
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

reg add HKLM /F >nul 2>&1
if %errorlevel% neq 0 ( set "admin=false" ) else ( set "admin=true" )

set "c=[93m[CHECK][0m"                                                                                                                               &:: [check] to show that a check is running
set "i=[96m[INFO][0m"                                                                                                                                &:: [info] to show that something is info
set "e=[91m[ERROR][0m"                                                                                                                               &:: [error] to display errors
set "a=[92m[ACTION][0m"                                                                                                                              &:: [action] to display when the user has to interract without full UI
set "my_path=%~dp0"

:menu
echo Admin = %admin%
echo. 
echo %a% Make sure you have made a backup of your [96mRegistry[0m in case of an error. You can do it right now.
set /p choice="                 %a% Type Yes if you want to continue or [96mReg[0m to create a [96mRegistry[0m backup > "
if /i "%choice%" equ "0" (
    set runparam=0
    goto start
)

if /i "%choice%" equ "yes" goto start
if /i "%choice%" equ "y" goto start (
) else (
    echo [91mInvalid choice. Please try again.[0m
    echo [91mYou may press any key to skip the countdown.[0m
    timeout 4 >nul
    goto menu
)

:regBCKP
start /wait reg export HKLM "%my_path%RegistryBackup.reg"
if %errorlevel% equ 0 (
    echo %i% Backup created. Can be found in the same folder as this .bat file.
    echo %i% %mypath%
    timeout 4 >nul
    goto menu
) else (
    echo %e% An error has occured whilst creating a registry backup.
    pause
    exit
)


:start
if exist "%my_path%TCPeditor.ps1" (
    echo %i% TCPeditor.ps1 exists. Deleting
    del TCPeditor.ps1
    goto start
) else (
    REM Write TCPeditor.ps1
    start /wait powershell -WindowStyle hidden -Command "[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('ZnVuY3Rpb24gU2V0LVRDUFNldHRpbmdzIHsNCiAgICBwYXJhbSAoDQogICAgICAgIFtzdHJpbmddJFJlZ2lzdHJ5UGF0aCA9ICdIS0xNOlxTWVNURU1cQ3VycmVudENvbnRyb2xTZXRcU2VydmljZXNcVGNwaXBcUGFyYW1ldGVycycNCiAgICApDQogICAgDQogICAgIyBUQ1AgU2V0dGluZ3MgdG8gb3B0aW1pemUgbGF0ZW5jeSwgcmVsaWFiaWxpdHksIGFuZCBidWZmZXIgbWFuYWdlbWVudA0KICAgICR0Y3BTZXR0aW5ncyA9IEB7DQogICAgICAgICdUQ1BOb0RlbGF5JyAgICAgICAgICAgICAgICAgICAgICA9IDENCiAgICAgICAgJ1RDUEFja0ZyZXF1ZW5jeScgICAgICAgICAgICAgICAgID0gMg0KICAgICAgICAnVENQRGVsQWNrVGlja3MnICAgICAgICAgICAgICAgICAgPSAyDQogICAgICAgICdUQ1BNYXhDb25uZWN0UmV0cmFuc21pc3Npb25zJyAgICA9IDMNCiAgICAgICAgJ1RDUFRpbWVkV2FpdERlbGF5JyAgICAgICAgICAgICAgID0gNDUNCiAgICAgICAgJ01heFVzZXJQb3J0JyAgICAgICAgICAgICAgICAgICAgID0gNjU1MzQNCiAgICAgICAgJ01heEZyZWVUQ0JzJyAgICAgICAgICAgICAgICAgICAgID0gNjU1MzYNCiAgICAgICAgIyBUaGlzIGd1eSBjYXVzZXMgaXNzdWVzIGJlY2F1c2UgRkZGRkZGRkYgY2FudCBiZSBjb252ZXJ0ZWQgdG8gaW50DQogICAgICAgICMgJ05ldHdvcmtUaHJvdHRsaW5nSW5kZXgnICAgICAgICAgID0gJ0ZGRkZGRkZGJw0KICAgICAgICAnRGlzYWJsZVRhc2tPZmZsb2FkJyAgICAgICAgICAgICAgPSAxDQogICAgICAgICdEZWZhdWx0VFRMJyAgICAgICAgICAgICAgICAgICAgICA9IDY0DQogICAgICAgICdTYWNrT3B0cycgICAgICAgICAgICAgICAgICAgICAgICA9IDENCiAgICAgICAgJ1RDUFdpbmRvd1NpemUnICAgICAgICAgICAgICAgICAgID0gNjU1MzUNCiAgICAgICAgJ0dsb2JhbE1heFRDUFdpbmRvd1NpemUnICAgICAgICAgID0gNjU1MzUNCiAgICAgICAgJ0VuYWJsZVBNVFVCSERldGVjdCcgICAgICAgICAgICAgID0gMQ0KICAgICAgICAnRW5hYmxlVENQQScgICAgICAgICAgICAgICAgICAgICAgPSAxDQogICAgICAgICdFbmFibGVSU1MnICAgICAgICAgICAgICAgICAgICAgICA9IDENCiAgICAgICAgJ05lZ2F0aXZlQ2FjaGVUaW1lJyAgICAgICAgICAgICAgID0gNQ0KICAgICAgICAnTmV0RmFpbHVyZUNhY2hlVGltZScgICAgICAgICAgICAgPSA1DQogICAgICAgICdOZXRJbmZvQ2FjaGVUaW1lJyAgICAgICAgICAgICAgICA9IDUNCiAgICAgICAgJ0Zhc3RTZW5kRGF0YWdyYW1UaHJlc2hvbGQnICAgICAgID0gNjQwMDANCiAgICAgICAgJ0R5bmFtaWNTZW5kQnVmZmVyRGlzYWJsZScgICAgICAgID0gMA0KICAgICAgICAnTm9uQmxvY2tpbmdTZW5kU3BlY2lhbEJ1ZmZlcmluZycgPSAxDQogICAgICAgICdJZ25vcmVQdXNoQml0b25SZWNlaXZlcycgICAgICAgICA9IDENCiAgICAgICAgJ0VuYWJsZUZhc3RSb3V0ZUxvb2t1cCcgICAgICAgICAgID0gMQ0KICAgICAgICAnRG9Ob3RVc2VOTEEnICAgICAgICAgICAgICAgICAgICAgPSAwDQogICAgICAgICdUQ1BNYXhEYXRhUmV0cmFuc21pc3Npb25zJyAgICAgICA9IDQNCiAgICAgICAgJ1RDUEluaXRpYWxSVFQnICAgICAgICAgICAgICAgICAgID0gMjAwDQogICAgICAgICdFbmFibGVEQ0EnICAgICAgICAgICAgICAgICAgICAgICA9IDENCiAgICAgICAgJ1VzZVplcm9Ccm9hZGNhc3QnICAgICAgICAgICAgICAgID0gMA0KICAgICAgICAnRGVhZEdXRGV0ZWN0RGVmYXVsdCcgICAgICAgICAgICAgPSAxDQogICAgICAgICdUQ1AxMzIzT3B0cycgICAgICAgICAgICAgICAgICAgICA9IDENCiAgICAgICAgJ0RlbGF5ZWRBY2tGcmVxdWVuY3knICAgICAgICAgICAgID0gMQ0KICAgICAgICAnQ29uZ2VzdGlvbkFsZ29yaXRobScgICAgICAgICAgICAgPSAyDQogICAgICAgICdTaXpSZXFCdWYnICAgICAgICAgICAgICAgICAgICAgICA9IDE3NDI0DQogICAgICAgICdUaW1lclJlc29sdXRpb24nICAgICAgICAgICAgICAgICA9IDENCiAgICAgICAgJ0Rpc2FibGVkQ29tcG9uZW50cycgICAgICAgICAgICAgID0gMA0KICAgIH0NCiAgICAjIEFwcGx5IGVhY2ggc2V0dGluZyB0byB0aGUgcmVnaXN0cnkNCiAgICBmb3JlYWNoICgkc2V0dGluZyBpbiAkdGNwU2V0dGluZ3MuS2V5cykgew0KICAgICAgICBOZXctSXRlbVByb3BlcnR5IC1QYXRoICRSZWdpc3RyeVBhdGggLU5hbWUgJHNldHRpbmcgLVZhbHVlICR0Y3BTZXR0aW5nc1skc2V0dGluZ10gLVByb3BlcnR5VHlwZSBEV29yZCAtRm9yY2UNCiAgICB9DQogICAgTmV3LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAkUmVnaXN0cnlQYXRoIC1OYW1lIE5ldHdvcmtUaHJvdHRsaW5nSW5kZXggLVZhbHVlIDB4ZmZmZmZmZmYgLVByb3BlcnR5VHlwZSBEV29yZCAtRm9yY2UgDQogICAgV3JpdGUtSG9zdCAnVENQIHNldHRpbmdzIGFwcGxpZWQgc3VjY2Vzc2Z1bGx5LicgLUZvcmVncm91bmRDb2xvciBHcmVlbg0KfQ0KDQojIEZ1bmN0aW9uIHRvIGdldCB0aGUgYWN0aXZlIG5ldHdvcmsgYWRhcHRlciBhbmQgcmVzdGFydCBpdA0KZnVuY3Rpb24gUmVzdGFydC1OZXR3b3JrQWRhcHRlciB7DQogICAgJGFkYXB0ZXIgPSBHZXQtTmV0QWRhcHRlciB8IFdoZXJlLU9iamVjdCB7ICRfLlN0YXR1cyAtZXEgJ1VwJyB9DQogICAgaWYgKCRhZGFwdGVyKSB7DQogICAgICAgIFdyaXRlLUhvc3QgJ1Jlc3RhcnRpbmcgbmV0d29yayBhZGFwdGVyOicgJGFkYXB0ZXIuTmFtZSAtRm9yZWdyb3VuZENvbG9yIFllbGxvdw0KICAgICAgICBEaXNhYmxlLU5ldEFkYXB0ZXIgLU5hbWUgJGFkYXB0ZXIuTmFtZSAtQ29uZmlybTokZmFsc2UNCiAgICAgICAgU3RhcnQtU2xlZXAgLVNlY29uZHMgMw0KICAgICAgICBFbmFibGUtTmV0QWRhcHRlciAtTmFtZSAkYWRhcHRlci5OYW1lIC1Db25maXJtOiRmYWxzZQ0KICAgICAgICBXcml0ZS1Ib3N0ICdOZXR3b3JrIGFkYXB0ZXIgcmVzdGFydGVkIHN1Y2Nlc3NmdWxseS4nIC1Gb3JlZ3JvdW5kQ29sb3IgR3JlZW4NCiAgICB9IGVsc2Ugew0KICAgICAgICBXcml0ZS1Ib3N0ICdObyBhY3RpdmUgbmV0d29yayBhZGFwdGVyIGZvdW5kLicgLUZvcmVncm91bmRDb2xvciBSZWQNCiAgICB9DQp9DQoNCiMgQXBwbHkgVENQIHNldHRpbmdzIGFuZCByZXN0YXJ0IG5ldHdvcmsgYWRhcHRlcg0KU2V0LVRDUFNldHRpbmdzDQpSZXN0YXJ0LU5ldHdvcmtBZGFwdGVyDQo=')) | Out-File %my_path%TCPeditor.ps1 -Encoding ASCII"
    if defined runparam (
        notepad.exe TCPeditor.ps1
    ) else (
        powershell.exe -NoLogo -NoProfile -executionpolicy bypass -File TCPeditor.ps1
        pause
        del TCPeditor.ps1
    )
)
exit /b
