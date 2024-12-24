#Requires AutoHotkey v2.0
#SingleInstance Force
; Set a script icon
TraySetIcon "E:\AHK\resources\icons\AutoAccentIcon.png"

; ttWindow := WinExist("ahk_class tooltips_class32")

global ttWindow := "", exitWarningTimeout := 0 , exitDetected := 0, warningActive := 0
; User defined timer settings
;--------------------------------------------------------------------------------------
; Set delay in milliseconds
; Ex: -3000000 = 300 seconds = 5 minutes

; Auto timeout Timer
autoTimeout := 300000

; Startup message timer
; Set to 0 to skip startup message
startupMsgTimeout := 7500

; Exit warning timer
exitWarningTimeout := 5000

; End user defined timer settings
;--------------------------------------------------------------------------------------

; ensure timer numbers are negative (so setTimer doesn't loop)
if autoTimeout > 0
	autoTimeout *= -1

if startupMsgTimeout > 0
	startupMsgTimeout *= -1	
	
if exitWarningTimeout > 0
	exitWarningTimeout *= -1	

; Function to start the program
startingToolTip(startupMsgTimeout?)

; Hotstring section
;--------------------------------------------------------------------------------------
; Modify/Add hotstrings here, following the established convention:
	; global warningActive := 0 - cancel the time out if warning is active
	; SetTimer(accentTimeOutWarn, autoTimeout) - reset the timer


; ñ, á, é, í, ó, ú, ý, ü, ¿, ¡
:?C*:NNN::
:?C*:Nnn::
:?*:nnn::
case_conform_n(hs) ; hs will hold the name of the hotstring which triggered the function.
{
{
	if (hs == ":?C*:NNN")
		Send "Ñ"
	else if (hs == ":?C*:Nnn")
		Send "Ñ"
	else
		Send "ñ"
}
global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}

:?C*:AAA::
:?C*:Aaa::
:?C*:aaa::
case_conform_a(hs) ; hs will hold the name of the hotstring which triggered the function.
{
{
	if (hs == ":?C*:AAA")
		Send "Á"
	else if (hs == ":?C*:Aaa")
		Send "Á"
	else
		Send "á"
}
global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}
:?C*:EEE::
:?C*:Eee::
:?*:eee::
case_conform_e(hs) ; hs will hold the name of the hotstring which triggered the function.
{
{
	if (hs == ":?C*:EEE")
		Send "É"
	else if (hs == ":?C*:Eee")
		Send "É"
	else
		Send "é"
}
	global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}
:?C*:III::
:?C*:Iii::
:?*:iii::
case_conform_i(hs) ; hs will hold the name of the hotstring which triggered the function.
{
{
	if (hs == ":?C*:III")
		Send "Í"
	else if (hs == ":?C*:Iii")
		Send "Í"
	else
		Send "í"
}
global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}
:?C*:OOO::
:?C*:Ooo::
:?*:ooo::
case_conform_o(hs) ; hs will hold the name of the hotstring which triggered the function.
{{
	if (hs == ":?C*:OOO")
		Send "Ó"
	else if (hs == ":?C*:Ooo")
		Send "Ó"
	else
		Send "ó"
}
global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}
:?C*:UUU::
:?C*:Uuu::
:?*:uuu::
case_couform_u(hs) ; hs will hold the name of the hotstring which triggered the function.
{
{
	if (hs == ":?C*:UUU")
		Send "Ú"
	else if (hs == ":?C*:Uuu")
		Send "Ú"
	else
		Send "ú"
}
global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}
:?C*:YYY::
:?C*:Yyy::
:?*:yyy::
case_conform_y(hs) ; hs will hold the name of the hotstring which triggered the function.
{
{
	if (hs == ":?C*:YYY")
		Send "Ý"
	else if (hs == ":?C*:Yyy")
		Send "Ý"
	else
		Send "ý"
}
global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}
:?C*:MMM::
:?C*:Mmm::
:?*:mmm::
case_conform_ue(hs) ; hs will hold the name of the hotstring which triggered the function.
{
{
	if (hs == ":?C*:MMM")
		Send "Ü"
	else if (hs == ":?C*:Mmm")
		Send "Ü"
	else
		Send "ü"
}
global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}
:?*:??????::
{
KeyWait "Shift"
send "¿"
global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}
:?*:!!!!!!::
{
KeyWait "Shift"
send "¡"
global warningActive := 0
SetTimer(accentTimeOutWarn, autoTimeout)
}

; End
;--------------------------------------------------------------------------------------


startingToolTip(startupMsgTimeout := 0){
	if startupMsgTimeout >= 0
		goto skipStartup
	readableTimeout := Round(- autoTimeout / 60 / 1000, 2)
	SetTimer(runningToolTip, startupMsgTimeout)
	ToolTip("Accent Hotstrings Activated`nThis program will exit if`nno accents detected after:`n" . readableTimeout . " minutes`nx3: n:ñ, a:á, e:é`ni:í, o:ó, u:ú, y:ý, m:ü`nx6: ¿, ¡"
	, A_ScreenWidth-2, A_ScreenHeight-4,14 )
	goto endStartupMsg
	skipStartup:
	runningToolTip
	endStartupMsg:
}
runningToolTip(*){
	global warningActive, ttWindow, exitDetected
	ToolTip("Accent Hotstrings Running`nx3: n:ñ, a:á, e:é`ni:í, o:ó, u:ú, y:ý, m:ü`nx6: ¿, ¡"
	, A_ScreenWidth-2, A_ScreenHeight-4,14 )
	ttWindow := WinExist("ahk_class tooltips_class32")
	; MsgBox WinGetTitle(,ttWindow)
	SetTimer(accentTimeOutWarn, autoTimeout)
	warningActive := 0
	exitDetected := 0
}
; confirmExitToolTip(*){
; 	ToolTip("`n        Click again`n          to exit.`n`nDisregarding click in 5 seconds."
; 	, A_ScreenWidth-2, A_ScreenHeight-4,14 )
; 	ttExitWindow := WinExist("ahk_class tooltips_class32")
; }

; Click tooltip twice to exit
;--------------------------------------------------------------------------------------
;
~LButton Up::
{
	global ttWindow, exitWarningTimeout, exitDetected
	readableTimeout := Round(-exitWarningTimeout / 1000, 2)
	MouseGetPos &x,&y,&detectedWindow
	; msgbox ttExitWindow
	If exitDetected > 0
		ExitApp
	If detectedWindow == ttWindow
	{
	ToolTip("_____________Exit?_____________`n`n                Click again                `n                    to exit.                `n`n       Disregarding click in:`n                " . readableTimeout . " seconds."
	, A_ScreenWidth-2, A_ScreenHeight-4,14 )
	SetTimer(runningToolTip, exitWarningTimeout)
	exitDetected := 1
	}
}
; End
;--------------------------------------------------------------------------------------



accentTimeOutWarn(){
	global warningActive
	warningActive := 1
	ToolTip("Accent Hotstring Is..."
	, A_ScreenWidth-2, A_ScreenHeight-4,14 )
	sleep 3000
	if warningActive ==  0
		goto resetRunningTimer
	ToolTip("Accent Hotstring Is...Timing..."
	, A_ScreenWidth-2, A_ScreenHeight-4,14 )
	sleep 2000
	if warningActive ==  0
		goto resetRunningTimer
	ToolTip("Accent Hotstring Is...Timing...Out..."
	, A_ScreenWidth-2, A_ScreenHeight-4,14 )
	Sleep 1000
	if warningActive ==  0
		goto resetRunningTimer
	ToolTip("Now!"
	, A_ScreenWidth-2, A_ScreenHeight-4,14 )
	sleep 1500
	if warningActive ==  0
		goto resetRunningTimer
	ExitApp
	resetRunningTimer: 
	runningToolTip
}


