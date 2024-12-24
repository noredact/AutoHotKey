#Requires AutoHotkey v2+
; Yet another translator GUI
; Easy switching back and forth between 2 languages
; Made by DitDah (@WandererTheFriend on the discord)
;-----------------------------------------------------
;Translate Functions
;https://www.autohotkey.com/boards/viewtopic.php?t=63835
;credit: teadrinker
;-----------------------------------------------------
/* Common Language abbreviations for google URL:
*******
 Use the 2 letter abbreviations to adjust what languages are used in the program
    "ar" = "Arabic"
    "zh" = "Chinese"
    "cs" = "Czech"
    "da" = "Danish"
    "nl" = "Dutch"
    "en" = "English"
    "fi" = "Finnish"
    "fr" = "French"
    "de" = "German"
    "el" = "Greek"
    "he" = "Hebrew"
    "hi" = "Hindi"
    "hu" = "Hungarian"
    "id" = "Indonesian"
    "it" = "Italian"
    "ja" = "Japanese"
    "ko" = "Korean"
    "no" = "Norwegian"
    "pl" = "Polish"
    "pt" = "Portuguese"
    "ro" = "Romanian"
    "ru" = "Russian"
    "es" = "Spanish"
    "sv" = "Swedish"
    "th" = "Thai"
    "tr" = "Turkish"
    "uk" = "Ukrainian"
    "vi" = "Vietnamese"

*******
*/


; Main function call to initialize the translation GUI
quickTranslateGUI

; Main GUI function that handles the translation interface
; @param translateString - Optional parameter for text to translate. If not provided, uses clipboard
quickTranslateGUI(translateString := 0){
    ; Store the current clipboard content to restore it later
    clipSaved := A_Clipboard

    ; If no string is provided, copy selected text from active window
    if !translateString {
        clipSaved := A_Clipboard
        sleep 150
        Send "^c"
        sleep 330
        translateString := A_Clipboard
    }
    
    ; Create copies of the string for both translation directions
    topClip := translateString
    bottomClip := translateString

    ; Perform initial translations (Spanish to English and English to Spanish)
    tText1 := GoogleTranslate(topClip,'es','en')
    sleep 150
    tText2 := GoogleTranslate(bottomClip,'en', 'es')
    sleep 150

    ; Initialize the GUI window
    qtGUI := Gui()
    qtGUI.BackColor := "0xabb8d9" ; Light blue-gray background color

    ; Add GUI elements: Group boxes for organizing the layout
    qtGUI.Add("GroupBox", "x72 y40 w478 h130", "Translation/Input 1")
    qtGUI.Add("GroupBox", "x72 y248 w478 h130", "Translation/Input 2")
    qtGUI.Add("GroupBox", "x16 y192 w552 h47")

    ; Add edit fields for both translations
    topLanguageEdit := qtGUI.Add("Edit", "vText1 x80 y56 w461 h103 -WantReturn",tText1)
    bottomLanguageEdit := qtGUI.Add("Edit", "vText2 x80 y264 w461 h103 -WantReturn",tText2)

    ; Add control buttons
    ButtonCopyTop := qtGUI.Add("Button", "x8 y98 w53 h30", "&Copy1")
    ButtonCopyBottom := qtGUI.Add("Button", "x8 y306 w53 h30", "Cop&y2")
    ButtonTranslate1 := qtGUI.Add("Button", "x460 y160 w80 h23 -Tabstop", "Translate&1")
    ButtonTranslate2 := qtGUI.Add("Button", "x460 y368 w80 h23 -Tabstop", "Translate&2")

    ; Set up event handlers for GUI elements
    topLanguageEdit.OnEvent("Focus", setDefault)
    bottomLanguageEdit.OnEvent("Focus", setDefault)
    ButtonCopyTop.OnEvent("Click", CopyTop)
    ButtonCopyBottom.OnEvent("Click", CopyBottom)
    ButtonTranslate1.OnEvent("Click", translateTop)
    ButtonTranslate2.OnEvent("Click", translateBottom)

    ; Add clipboard history display
    clipText := qtGUI.Add("Text","x20 y202", "Saved Clipboard Text:`n    (Click to restore)")
    clipText.OnEvent("Click", restoreClipboard)
    clipSavedText := qtGUI.Add("Text","x132 y203 w415 h31 -Tabstop -Wrap",clipSaved)
    clipSavedText.OnEvent("Click", restoreClipboard)
    

	
/* Swap these if using this as part of another script
*******
	qtGUI.OnEvent('Close', (*) => qtGUI.Destroy)
	qtGUI.OnEvent('Escape', (*) => qtGUI.Destroy)
*******
*/
	; Set up window close events
	qtGUI.OnEvent('Close', (*) => ExitApp(0))
	qtGUI.OnEvent('Escape', (*) => ExitApp(0))


 ; Show the GUI
 qtGUI.Title := "Quick Translate GUI"
 qtGUI.Show("w580 h423")

 ; Function to handle focus changes and set default buttons
 setDefault(*){
	 currentFocus := qtGUI.FocusedCtrl.name
	 
	 ; Update default button based on focused text field
	 if currentFocus == "Text2" {
		 qtGUI["Translate&1"].Opt("-Default")
		 qtGUI["Translate&2"].Opt("+Default")
	 }
	 if currentFocus == "Text1" {
		 qtGUI["Translate&2"].Opt("-Default")
		 qtGUI["Translate&1"].Opt("+Default")
	 }
 }

; Send text to translator function
;--------------------------------------------------------------------------------------
; These functions send the text to the google translate service
; Change the 2 letter language options to translate to a different language
; This was posted to translate between English/Spanish

; Abbreviation reference:
; "ar", "zh", "cs", "da", "nl", "en", "fi", "fr", "de"
; "el", "he", "hi", "hu", "id", "it", "ja", "ko", "no"
; "pl", "pt", "ro", "ru", "es", "sv", "th", "tr", "uk", "vi"

 ; Translation function for top text field (English to Spanish)
 translateTop(*){
	 strText1 := topLanguageEdit.Text 
	 newText2 := GoogleTranslate(strText1,'en', to := 'es') 
	 bottomLanguageEdit.Value := ''
	 bottomLanguageEdit.Value := newText2 
 }

 ; Translation function for bottom text field  (Spanish to English)
 translateBottom(*){
	 strText2 := bottomLanguageEdit.Text
	 newText1 := GoogleTranslate(strText2,'es', to := 'en')
	 topLanguageEdit.Value := ''
	 topLanguageEdit.Value := newText1
 }

 ; Clipboard handling functions
 CopyTop(*){
	 A_Clipboard := topLanguageEdit.Text
 }
 CopyBottom(*){
	 A_Clipboard := bottomLanguageEdit.Text
 }
 restoreClipboard(*){
	 A_Clipboard := clipSavedText.Text
 }
}







;--------------------------------------------------------------------------------------
  ;Translate Functions
  ;https://www.autohotkey.com/boards/viewtopic.php?t=63835
  ;credit: teadrinker
  GoogleTranslate(str, from := 'auto', to := 'en', &variants := '') {
    static JS := ObjBindMethod(GetJsObject(), 'eval'), _ := JS(GetJScript())
    
    json := SendRequest(str, Type(from) = 'VarRef' ? %from% : from, to)
    return ExtractTranslation(json, from, &variants)
  
    GetJsObject() {
        static document := '', JS
        if !document {
            document := ComObject('HTMLFILE')
            document.write('<meta http-equiv="X-UA-Compatible" content="IE=9">')
            JS := document.parentWindow
            (document.documentMode < 9 && JS.execScript())
        }
        return JS
    }
  
    GetJScript() {
        return '
        ( Join
            var TKK="406398.2087938574";function b(r,_){for(var t=0;t<_.length-2;t+=3){var $=_.charAt(t+2),$="a"<=$?$
            .charCodeAt(0)-87:Number($),$="+"==_.charAt(t+1)?r>>>$:r<<$;r="+"==_.charAt(t)?r+$&4294967295:r^$}return r}
            function tk(r){for(var _=TKK.split("."),t=Number(_[0])||0,$=[],a=0,h=0;h<r.length;h++){var n=r.charCodeAt(h);
            128>n?$[a++]=n:(2048>n?$[a++]=n>>6|192:(55296==(64512&n)&&h+1<r.length&&56320==(64512&r.charCodeAt(h+1))?
            (n=65536+((1023&n)<<10)+(1023&r.charCodeAt(++h)),$[a++]=n>>18|240,$[a++]=n>>12&63|128):$[a++]=n>>12|224,$
            [a++]=n>>6&63|128),$[a++]=63&n|128)}for(a=0,r=t;a<$.length;a++)r+=$[a],r=b(r,"+-a^+6");return r=b(r,
            "+-3^+b+-f"),0>(r^=Number(_[1])||0)&&(r=(2147483647&r)+2147483648),(r%=1e6).toString()+"."+(r^t)}
        )'
    }
  
    SendRequest(str, sl, tl) {
        static WR := ''
             , headers := Map('Content-Type', 'application/x-www-form-urlencoded;charset=utf-8',
                              'User-Agent'  , 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0')
        if !WR {
            WR := WebRequest()
            WR.Fetch('https://translate.google.com',, headers)
        }
        url := 'https://translate.googleapis.com/translate_a/single?client=gtx'
             . '&sl=' . sl . '&tl=' . tl . '&hl=' . tl
             . '&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=0&ssel=0&tsel=0&pc=1&kc=1'
             . '&tk=' . JS('tk')(str)
        return WR.Fetch(url, 'POST', headers, 'q=' . JS('encodeURIComponent')(str))
    }
  
    ExtractTranslation(json, from, &variants) {
        jsObj := JS('(' . json . ')')
        if !IsObject(jsObj.1) {
            Loop jsObj.0.length {
                variants .= jsObj.0.%A_Index - 1%.0
            }
        } else {
            mainTrans := jsObj.0.0.0
            Loop jsObj.1.length {
                variants .= '`n+'
                obj := jsObj.1.%A_Index - 1%.1
                Loop obj.length {
                    txt := obj.%A_Index - 1%
                    variants .= (mainTrans = txt ? '' : '`n' . txt)
                }
            }
        }
        if !IsObject(jsObj.1)
            mainTrans := variants := Trim(variants, ',+`n ')
        else
            variants := mainTrans . '`n+`n' . Trim(variants, ',+`n ')
  
        (Type(from) = 'VarRef' && %from% := jsObj.8.3.0)
        return mainTrans
    }
  }
  
  class WebRequest
  {
    __New() {
        this.whr := ComObject('WinHttp.WinHttpRequest.5.1')
    }
  
    __Delete() {
        this.whr := ''
    }
  
    Fetch(url, method := 'GET', HeadersMap := '', body := '', getRawData := false) {
        this.whr.Open(method, url, true)
        for name, value in HeadersMap
            this.whr.SetRequestHeader(name, value)
        this.error := ''
        this.whr.Send(body)
        this.whr.WaitForResponse()
        status := this.whr.status
        if (status != 200)
            this.error := 'HttpRequest error, status: ' . status . ' — ' . this.whr.StatusText
        SafeArray := this.whr.responseBody
        pData := NumGet(ComObjValue(SafeArray) + 8 + A_PtrSize, 'Ptr')
        length := SafeArray.MaxIndex() + 1
        if !getRawData
            res := StrGet(pData, length, 'UTF-8')
        else {
            outData := Buffer(length, 0)
            DllCall('RtlMoveMemory', 'Ptr', outData, 'Ptr', pData, 'Ptr', length)
            res := outData
        }
        return res
    }
  }
  ;--------------------------------------------------------------------------------------
  ;End Translate Functions