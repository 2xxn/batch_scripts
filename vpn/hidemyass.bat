@echo off
title HMA Batch VPN
set baseURL=.hma.rocks
set countries=ad ae af ag ai al am ao ar as at au aw ax az ba bb bd be bf bg bh bi bj bm bn bo br bs bt bw by bz ca cc cd cf cg ch ci ck cl cm cn co cr cu cv cx cy cz de dj dk dm do dz ec ee eg er es et fi fj fk fo fr ga gb gd ge gh gi gl gm gn gp gq gr gt gu gw gy hk hn hr ht hu id ie il in iq ir is it jm jo jp ke kg kh ki km kn kp kr kw ky kz la lb lc li lk lr ls lt lu lv ly ma mc md me mg mk ml mm mn mo ms mt mu mv mw mx my mz na nc ne nf ng ni nl no np nr nu nz om pa pe pg ph pk pl pm pn pr ps pt pw py qa ro rs ru rw sa sb sd se sg sh si sj sk sm sn so sr st sv sy sz tc td tg th tj tk tm tn to tr tt tv tw tz ua ug us uy uz va vc ve vg vn vu ws ye za zm zw
set debug=0
goto :vpn

:vpn
setlocal enableDelayedExpansion
cls
set /p ctr=Country code (2 letter): 
set /p username=Username: 
set /p password=Password: 
call :connect !ctr! "!username!" "!password!"
endlocal
goto :eof

:connect countrycode username password
setlocal enableDelayedExpansion
call :countryExists exists %1
if !exists! equ 0 (
    echo VPN doesn't support this country.. Try again
    pause
) else (
    call :vpnProfileExists exists "%1hma"
    if !exists! equ 0 call :createVPNprofile %1
    echo Connecting to the VPN... 
    if !debug! equ 1 (
        rasdial "%~1hma" "%~2" "%~3"
    ) else (
        rasdial "%~1hma" "%~2" "%~3" >nul
    )
    if !errorlevel! equ 691 (
        echo Username/Password provided was invalid.
        goto :eof
    )
    echo -----------------------------
    echo Successfully connected to %~1
    echo To disconnect press any key
    echo -----------------------------
    pause >nul
    if !debug! equ 1 (
        rasdial "%~1hma" /disconnect
    ) else (
        rasdial "%~1hma" /disconnect >nul
    )
    call :deleteVPNprofile %~1
    echo VPN has been disconnected
)
endlocal
goto :eof


:deleteVPNprofile countrycode
setlocal enableDelayedExpansion
powershell Remove-VpnConnection -Name "%~1hma" -Force
echo Deleted VPN profile
endlocal
goto :eof

:createVPNprofile countrycode
setlocal enableDelayedExpansion
powershell Add-VpnConnection -Name "%~1hma" -ServerAddress "%~1!baseURL!" >nul
echo VPN profile has been created
endlocal
goto :eof

:vpnProfileExists ret name
setlocal enableDelayedExpansion
set /a return=0
powershell Get-VpnConnection -Name "%~2" >nul
if !errorlevel! equ 0 (
    set /a return=1
) else (
    set /a return=0
)
endlocal & set /a %1=%return%
goto :eof

:countryExists ret countrycode
setlocal enableDelayedExpansion
set /a return=0
for %%l in (!countries!) do (
    if "%2"=="%%l" (
        set /a return=1
    )
)
endlocal & set /a %1=%return%
goto :eof
