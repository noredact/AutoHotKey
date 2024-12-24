#Requires AutoHotkey v2.0
#SingleInstance

; Heavily borrowed from Mouse Tool Tip Script Showcase
; https://www.autohotkey.com/docs/v2/scripts/index.htm#TooltipMouseMenu
; Made by DitDah (Discord @WandererTheFriend) 
; https://pastebin.pl/view/f52e099b

/* Table of contents
*******
Comment header for the main parts of the script:
	Script Variable Declarations
	User Variable Declarations
		Edit the menu & what scripts get called here
	tool tip menu writer
	Main function
	Script Trigger function
	Hotkey Section
*******
*/


/* Room for improvement:
*******
Add new functions:
	I want to add a means of adding things to the list
	Off the top of my head I'm thinking have the menu titles
	at the bottom of this file and just append the output of an input box
	and add a function to the function list of that name
	with a "No script added yet! Open A_ScriptFullPath and search for 
	OutputVar to add a script." Msgbox
Less intrusive hotkey
	In an earlier version, the hotkey was ctrl + numpadDot
	I wanted to use the mouse to cycle through but
	ctrl+wheel is used in a lot of programs
	so I added the alt key here, Haven't used this much
	As I write this (1734741401.:|:.:.:|:|:.:.:|:.19:36)
	So I'm not sure how intrusive it really is.
-Dit
*******
*/


; Script Variable Declarations
;--------------------------------------------------------------------------------------
; 
; makes sure function wont get called 
; unless the intial hotkey is pressed
global scriptIsCycling := 0


; User Variable Declarations
;-------------------------------------------------------------------------------------
; names of the scripts/functions that will get triggered below
tt_items := "once/twice/three times"

; the functions that will get called (names must match,
; spaces will get stripped if they exist in the name above)
; punctuation is probably a bad idea

once()
{
MsgBox "yepper1"
}

twice()
{
MsgBox "yepper2"
}

threetimes()
{
MsgBox "yepper3"
}

; End
;--------------------------------------------------------------------------------------


; tool tip menu writer
;--------------------------------------------------------------------------------------
; Adjusts the selector indicator

; make the menu in the order it was written above
ttMenu := StrSplit(tt_items, "/")
; Adds the 'abort' Option, used in the 'cycle end' function
ttMenu.Push("Abort")

ttMenuWriter(curSelection){
	if !curSelection
		return
		
	counter := {}
	toolTipMenu := ""
	curScript := ""
	for cItems, item in ttMenu
		{
			if (A_Index == curSelection) ;add a '>' to the currently selected script
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



; Main function
;--------------------------------------------------------------------------------------
;
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
; Script Trigger function
;--------------------------------------------------------------------------------------
;
; Triggers selected script (or aborts) when ctrl is released
~Alt Up::
{
global scriptIsCycling, triggerScript
	; The initial hotkey wasn't pressed, do nothing
	if scriptIsCycling = 0
		return
	; ---------------------------
	scriptIsCycling := 0 ; reset global variable 
	ToolTip ,,,5 ;hide tooltip
	if triggerScript == "Abort" || "null"
		return
	%triggerScript%()
}

; Hotkey Section
;--------------------------------------------------------------------------------------
; Press & Hold alt + ctrl (alt must be first) 
; Mouse wheel moves the selector, pressing wheel to start 
; will select the first script on the list

#HotIf GetKeyState("Alt", "P")

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
; End
;--------------------------------------------------------------------------------------
