/*
*******
My thought process;
User presses/holds ctrl, then on each press of numpadDot, 
cycle through a list of scrpits in a tooltip
Something like:
First . press:
	>1st script
	2nd script
	3rd scrpit
Second . press:
	1st script
	>2nd script
	3rd script
Release ctrl - run 2nd script
*******
*/
; Heavily borrowed from Mouse Tool Tip Script Showcase
; https://www.autohotkey.com/docs/v2/scripts/index.htm#TooltipMouseMenu
#Requires AutoHotkey v2.0
#SingleInstance
#Include my-functions.ahk

; Variable Declarations
;--------------------------------------------------------------------------------------
;

; makes sure function wont get called 
; unless the intial hotkey is pressed
global scriptIsCycling := 0

; names of the scripts/functions that will get triggered below
tt_items := loadTTitems()

; the functions that will get called (names must match,
; spaces will get stripped if they exist in the name above)
; punctuation is probably a bad idea


; End
;--------------------------------------------------------------------------------------


; make the menu in the order it was written above
ttMenu := StrSplit(tt_items, "/")
ttMenu.Push("Abort")

; tool tip menu writer
;--------------------------------------------------------------------------------------
; There was a time I felt like making this a function
; was a good idea.. now... ¯\_(ツ)_/¯
ttMenuWriter(curPress){
curCount := curPress
	counter := {}
	toolTipMenu := ""
	curScript := ""
	for cItems, item in ttMenu
		{
			if (A_Index == curCount) ;add a '>' to the currently selected script
				{

					toolTipMenu .= ">" item . "`n" 
					curScript := item
					continue
				}
			toolTipMenu .= item . "`n" 
		}
		counter.cur := StrReplace(curScript, "`s") ; remove spaces from Menu name
		counter.ttm := toolTipMenu
		return counter
}
; End
;--------------------------------------------------------------------------------------





; hotkey
;--------------------------------------------------------------------------------------
;Press & Hold ctrl then each press of NumpadDot will advance the selector

#hotif !GetKeyState("Alt", "P")
~Ctrl & RButton::
{
cycVar := 1
cycleShift(cycVar)
}


~Ctrl & MButton::cycleShift(0)

~Ctrl & WheelDown::
{
	cycVar := 1
	cycleShift(cycVar)
}

~Ctrl & WheelUp::	
{
	cycVar := -1
	cycleShift(cycVar)
}

cycleShift(cycVar)
{
	static pressedCount := 1
	global triggerScript, scriptIsCycling
	; The script was triggered at somepoint, reset pressed count 
	; otherwise the selector will start where it left off instead
	; of the top of the list 
	curOb := {}
	if (scriptIsCycling = 0){ ;otherwise sript 'misses' the first script in the line everytime
		pressedCount := 1
		scriptIsCycling := 1
		goto('make_the_menu')
	}
	;-----------------------
	pressedCount += cycVar
	if pressedCount > ttMenu.Length
		pressedCount := 1
	if pressedCount < 1
		pressedCount := ttMenu.Length
	make_the_menu:
	curOb := ttMenuWriter(pressedCount) ;Function to draw the tooltip
	curMenu := curOb.ttm
	ToolTip curMenu ,,,5
	triggerScript := curOb.cur
	}
	; {
	; 	static pressedCount := 1
	; 	global triggerScript, scriptIsCycling
	; 	; The script was triggered at somepoint, reset pressed count 
	; 	; otherwise the selector will start where it left off instead
	; 	; of the top of the list 
	; 	if (scriptIsCycling = 0) 
	; 		pressedCount := 1
	; 	;-----------------------
	; 	scriptIsCycling := 1
	; 	curOb := {}
	; 	curOb := ttMenuWriter(pressedCount) ;Function to draw the tooltip
	; 	curMenu := curOb.ttm
	; 	ToolTip curMenu ,,,5
	; 	pressedCount -= 1
	; 	if pressedCount < 1
	; 		pressedCount := ttMenu.Length
	; 	triggerScript := curOb.cur
	; 	}
		
; Triggers selected script (or aborts) when ctrl is released
~Ctrl Up::
	{
	global scriptIsCycling, triggerScript
	; The initial hotkey wasn't pressed, do nothing
	if scriptIsCycling = 0
		return
	; ---------------------------
	scriptIsCycling := 0 ; reset cycle variable
	ToolTip ,,,5 ;hide tooltip
	if triggerScript == "Abort" 
		return
	%triggerScript%()
	}
	
	
#HotIf