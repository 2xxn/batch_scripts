@echo off
call isInteger %1 isint
if %isint% == true goto :main
echo Correct use: call rot places returnVar str
goto :eof

:main
setlocal enableDelayedexpansion
set returnString=
set pos=0
set str=%~3
:rotNextChar    
    call :rotChar rt !str:~%pos%,1! %1 
    set returnString=!returnString!!rt!
    set /a pos=pos+1
    if "!str:~%pos%,1!" NEQ "" goto rotNextChar
endlocal & set %2=%returnString%
goto :eof



:rotChar rotatedVar toRotate places
setlocal enableDelayedexpansion
set rotated=%2
set uppercase=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
set lowercase=a b c d e f g h i j k l m n o p q r s t u v w x y z
set uppercaseNoSpace=ABCDEFGHIJKLMNOPQRSTUVWXYZ
set lowercaseNoSpace=abcdefghijklmnopqrstuvwxyz
set /a places=%3
call isInteger %2 isintz
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
		if !i! == !newPlace! set rotated=%%a
		set /a i+=1
	)
	goto :rotCharEnd
:rotCharLowerCase
	call :getpos pos %2 !lowercaseNoSpace!
	set i=0
	set /a newPlace=pos+places
	if !newPlace! gtr 26 set /a newPlace-=26
	for %%a in (!lowercase!) do ( 
		if !i! == !newPlace! set rotated=%%a
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
    if "!mytext:~%pos%,1!" == "%2" set retrn=%pos%
    set /a pos=pos+1
    if "!mytext:~%pos%,1!" NEQ "" goto getposNextChar
endlocal & set %1=%retrn%
goto :eof

:isUppercase returnVar char
setlocal enabledelayedexpansion
set uppercase=false
set up=Q W E R T Y U I O P A S D F G H J K L Z X C V B N M
for %%a in (%up%) do ( 
	if %2==%%a set uppercase=true
)
endlocal & set %1=%uppercase%
goto :eof
