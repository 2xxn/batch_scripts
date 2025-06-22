@REM 2xxn 2025 batch scripting language brainfuck interpreter, semi working, unfinished
@echo off
setlocal enabledelayedexpansion
set "input_file=%~1"
set "shouldShowCells=%~2"
if "!input_file!"=="" (
    echo Usage: brainfuck.bat input_file.bf
    exit /b 1
)
if not exist "!input_file!" (
    echo File not found: !input_file!
    exit /b 1
)
call :execute "!input_file!" "!shouldShowCells!"
endlocal
goto :eof

:: Convert an ASCII value to a character
:chr ret arg1
setlocal enabledelayedexpansion
set /a "asciiValue=%~2"
if %asciiValue% == 32 (
    set char=SPACE
    goto :endOfChr
) 

:: Very lazy approach to convert ASCII value to character, I skipped a lot of characters that would have to be escaped and replaced with dots
set "chars=..#$.&'()*+,-./0123456789.;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]._`abcdefghijklmnopqrstuvwxyz.|.~"
set /a correspondingValue=!asciiValue!-33

for %%i in (!correspondingValue!) do (
    set "char=!chars:~%%i,1!"
)

:endOfChr
@REM echo %~1 %char%
endlocal & set "%~1=%char%"
goto :eof

:: Execute the Brainfuck code from the input file
:execute arg1 arg2
setlocal enabledelayedexpansion

set /a sscells=0
if "%~2"=="true" (
    set /a sscells=1
)

:: Merge lines into a single line
set continousCode=
for /f "usebackq delims=" %%A in ("%~1") do (
    set continousCode=!continousCode!%%A
)

:: Count up the code length and store characters in a pseudo array
set /a codeLength=0
:charloop
set "char=!continousCode:~%codeLength%,1!"
if defined char (
    set code[!codeLength!]=!char!
    @REM echo !char!
    set /a codeLength+=1
    goto :charloop
)

:: Initialize cells and pointers
set /a codePointer=0
set /a dataPointer=0
set /a highestCell=0

:: Build a brace map for matching brackets
set /a tempBraceMapLen=0
set /a pos=0
:: !pos! is the position of the current character
:braceMapLoop
    if "!code[%pos%]!"=="[" (
        set tempBraceMap[!tempBraceMapLen!]=!pos!
        set /a tempBraceMapLen+=1
    ) else if "!code[%pos%]!"=="]" (
        set /a tempBraceMapLen-=1

        for %%i in (!tempBraceMapLen!) do (
            set start=!tempBraceMap[%%i]!
        )
        set bracemap[!start!]=!pos!
        set bracemap[!pos!]=!start!
    )

    set /a pos+=1
    if !pos! lss !codeLength! (
        goto :braceMapLoop
    )


@REM echo Brace map created. Temp length: !tempBraceMapLen!

:: Begin code loop
:codeLoop
:: Get the current command
set "command=!code[%codePointer%]!"
if not defined command (
    echo Program finished.
    exit /b 0
)

:: Invoke commands
if "!command!"==">" (
    set /a cellPointer+=1
    if not defined cells[!cellPointer!] (
        set /a cells[!cellPointer!]=0
        set /a highestCell=!cellPointer!
    )
)

if "!command!"=="<" (
    if !cellPointer! lss 1 (
        set /a cellPointer=0
    ) else (
        set /a cellPointer-=1
    )
)

if "!command!"=="+" (
    set /a cells[!cellPointer!]+=1
    if !cells[%cellPointer%]! gtr 255 (
        set /a cells[!cellPointer!]=0
    )
)

if "!command!"=="-" (
    set /a cells[!cellPointer!]-=1
    if !cells[%cellPointer%]! lss 0 (
        set /a cells[!cellPointer!]=255
    )
)

if "!command!"=="[" (
    if !cells[%cellPointer%]! equ 0 (
        set /a codePointer=bracemap[!codePointer!]
    )
)

if "!command!"=="]" (
    if !cells[%cellPointer%]! neq 0 (
        set /a codePointer=bracemap[!codePointer!]
    )
)

if "!command!"=="." (
    call :chr found !cells[%cellPointer%]!
    if defined found (
        if "!found!"=="SPACE" (
            :: Print a _ character (can't print space directly)
            echo | set /p="_"
        ) else (
            :: Print the character without a newline
            echo | set /p="!found!"
        )
    )
)

@REM TODO: yeah maybe another time :)
@REM if "!command!"=="," (
@REM     set /p input=: 
@REM     if defined input (
@REM         set /a cells[!cellPointer!]=!input:~0,1!
@REM     ) else (
@REM         set /a cells[!cellPointer!]=0
@REM     )
@REM )


set /a codePointer+=1
if !codePointer! geq !codeLength! (
    if !sscells! equ 1 (
        echo.
        echo Cells:
        for /l %%i in (0,1,!highestCell!) do (
            if defined cells[%%i] (
               echo Cell [%%i]: !cells[%%i]!
            ) else (
               echo Cell [%%i]: 0
            )
        )
    )
    goto :eof
)
goto :codeLoop

endlocal
goto :eof
