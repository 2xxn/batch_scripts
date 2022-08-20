@echo off
:: Use either all uppercase or all lowercase, no mixing
:logic gate retVar input1 [input2]
setlocal enableDelayedExpansion
set gates=AND NAND OR NOR NOT XOR XNOR and nand or nor not xor xnor
set gate=:%1
set input1=%~3
set input2=%~4
set /a flag=0
for %%x in (!gates!) do if ":%%x"=="!gate!" set /a flag=1
if !flag!==0 goto :eof
if "!input1!" == "" set input1=0
if "!input2!" == "" set input2=0
call !gate! opt !input1! !input2!
endlocal & set %2=%opt%
goto :eof

:not
:NOT ret num1
setlocal enableDelayedexpansion
set /a return=0
if "%2"=="0" (
    set /a return=1
) else (
    set /a return=0
)
endlocal & set /a %1=%return%
goto :eof

:and
:AND ret num1 num2
setlocal enableDelayedexpansion
set /a flag=1
if "%2"=="0" set /a flag=0
if "%3"=="0" set /a flag=0
endlocal & set /a %1=%flag%
goto :eof

:or
:OR ret num1 num2
setlocal enableDelayedexpansion
set /a return=0
if "%2"=="1" set /a return=1
if "%3"=="1" set /a return=1
endlocal & set /a %1=%return%
goto :eof

:xor
:XOR ret num1 num2
setlocal enableDelayedexpansion
set /a return=1
if "%2"=="%3" set /a return=0
endlocal & set /a %1=%return%
goto :eof

:nand
:NAND ret num1 num2
setlocal enableDelayedexpansion
set /a return=1
if "%2"=="1" if "%2"=="%3" set /a return=0
endlocal & set /a %1=%return%
goto :eof

:nor
:NOR ret num1 num2
setlocal enableDelayedexpansion
set /a return=0
if "%2"=="0" if "%2"=="%3" set /a return=1
endlocal & set /a %1=%return%
goto :eof

:xnor
:XNOR ret num1 num2
setlocal enableDelayedexpansion
set /a return=0
if "%2"=="%3" set /a return=1
endlocal & set /a %1=%return%
goto :eof
