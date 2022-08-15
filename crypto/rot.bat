@echo off
call :isInteger %1 isint
if %isint% == true goto :main
echo Correct use: call rot places returnVar str
goto :eof

:main
setlocal enableDelayedexpansion
set returnString=
set pos=0
set str=%~3
set uppercase=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
set lowercase=a b c d e f g h i j k l m n o p q r s t u v w x y z
set uppercaseNoSpace=ABCDEFGHIJKLMNOPQRSTUVWXYZ
set lowercaseNoSpace=abcdefghijklmnopqrstuvwxyz
:rotNextChar
    call :shouldRot shR "!str:~%pos%,1!"
    if "!shR!" EQU "1" (
        call :rotChar rt "!str:~%pos%,1!" %1 
    ) else (
        set rt=!str:~%pos%,1!
    )
    set returnString=!returnString!!rt!
    set /a pos=pos+1
    if "!str:~%pos%,1!" NEQ "" goto :rotNextChar
endlocal & set %2=%returnString%
goto :eof



:rotChar rotatedVar toRotate places
setlocal enableDelayedexpansion
set rotated=%2
set /a places=%3
call :isInteger %2 isintz
if !isintz! == true goto :rotCharEnd
call :isUppercase isupz %2
if !isupz! == true goto :rotCharUppercase
goto :rotCharLowerCase

:rotCharUpperCase
	call :getpos pos %2 !uppercaseNoSpace!
	set i=0
	set /a newPlace=pos+places
	if !newPlace! gtr 26 set /a newPlace-=26
	for %%a in (!uppercase!) do ( 
		if "!i!" EQU "!newPlace!" set rotated=%%a
		set /a i+=1
	)
	goto :rotCharEnd
:rotCharLowerCase
	call :getpos pos %2 !lowercaseNoSpace!
	set i=0
	set /a newPlace=pos+places
	if !newPlace! gtr 26 set /a newPlace-=26
	for %%a in (!lowercase!) do ( 
		if "!i!" EQU "!newPlace!" set rotated=%%a
		set /a i+=1
	)
	goto :rotCharEnd
:rotCharEnd
endlocal & set %1=%rotated%
goto :eof

:getpos returnVar needle haystack
setlocal enableDelayedexpansion
set pos=0
set mytext=%3
set /a retrn=0
:getposNextChar    
    if "!mytext:~%pos%,1!" == "%~2" set retrn=%pos%
    set /a pos=pos+1
    if "!mytext:~%pos%,1!" NEQ "" goto :getposNextChar
endlocal & set %1=%retrn%
goto :eof

:isUppercase returnVar char
setlocal enabledelayedexpansion
set uppercase=false
set up=Q W E R T Y U I O P A S D F G H J K L Z X C V B N M
for %%a in (%up%) do ( 
	if %2=="%%a" set uppercase=true
)
endlocal & set %1=%uppercase%
goto :eof

:shouldRot returnVar char
setlocal enabledelayedexpansion
set shRot=0
for %%x in (!uppercase!) do if "%%x" EQU "%~2" set shRot=1
for %%x in (!lowercase!) do if "%%x" EQU "%~2" set shRot=1
endlocal & set %1=%shRot%
goto :eof

REM Taken from https://github.com/npocmaka/batch.scripts
:isInteger  input [returnVar] 
setlocal enableDelayedexpansion 
set "input=%~1" 

if "!input:~0,1!" equ "-" (
	set "input=!input:~1!"
) else (
	if "!input:~0,1!" equ "+" set "input=!input:~1!"
)

for %%# in (1 2 3 4 5 6 7 8 9 0) do ( 
        if not "!input!" == "" ( 
                set "input=!input:%%#=!" 
    )         
) 

if "!input!" equ "" ( 
        set result=true 
) else ( 
        set result=false 
) 

endlocal & if "%~2" neq "" (set %~2=%result%) else echo %result% 
