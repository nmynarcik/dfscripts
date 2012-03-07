/*
----------------------------------------------------------------------------

 AutoHotKey transition from AutoIt
 Author:         RedSeal

 Script Function:
	Darkfall Scripts converted from AutoIt script.

----------------------------------------------------------------------------- 
*/

isMouseShown()
{
StructSize := A_PtrSize + 16
VarSetCapacity(InfoStruct, StructSize)
NumPut(StructSize, InfoStruct)
DllCall("GetCursorInfo", UInt, &InfoStruct)
Result := NumGet(InfoStruct, 8)

if Result
return 1
else
return 0
}  

destination = %A_WorkingDir%\images\splash.jpg

SplashImage, %destination%, , , , DFScripts
SoundPlay, %A_WorkingDir%\audio\WATER.WAV
Sleep, 3000
SplashImage, Off

;Variables
Global $Potted = False
Global $Paused = False
Global $UserPaused = False

Global $ClickerOn = False
Global $gotPoint = False
Global $clickPoint
Global $timeInt
Global $clickTimer = 0

Global $PM = 0, $IM = 0, $IS = 0, $UC = 0, $DB = 0, $FB = 0, $LB = 0
Global $PMTime, $IMTime, $ISTime, $UCTime, $DBTime, $FBTime, $LBTime
Global $RayCasted = 0, $RayCastTime

; Quick Loot Setup
IniRead, xdest, %iniFile%, Loot, 1425   ; x destination used for quick looter
IniRead, ydest, %iniFile%, Loot, 627    ; y destination

;****************************************
; Quick loot
; Alt+Right Click - sets the location
; Alt+Left Click - moves item under cursor to set location
;
$!Lbutton:: 
	MouseGetPos, x1, y1
	MouseClickDrag, left, x1, y1, xdest, ydest, 0 	;0 is mouse speed, 0 is instant
	MouseMove, x1, y1, 0 							;0 is mouse speed, 0 is instant
Return

;Loot destination setup
$!Rbutton:: 
	MouseGetPos, xdest, ydest
	IniWrite, %xdest%, %iniFile%, Loot, xdest
	IniWrite, %ydest%, %iniFile%, Loot, ydest
Return

;hotkey to kill script
End::terminate()

#If !isMouseShown() and #If WinActive("Darkfall Online")

Pause::MsgBox You paused the script
1::whirlwind()
2::powerAttack()
3::knockback()
4::disableParry()
~*v::sword_board()

/*
6::pot1()
7::pot2()
8::pot3()
HotKeySet("{NUMPAD4}", "RayCast")
*/



; Sprint Toggle
~*w::
 send {f12 down}
 keywait w
 send {f12 up}
return

;Functions

whirlwind()
{
    Send 1
	Send +q ;gsword ww
	Send +d ;disable shot
	Send +e ;knives ww
	Send !^+q ;pole ww
}   ;==>whirlwind


powerAttack()
{
	Send 2
	Send ^+q ;gsword power
	Send ^+e ;knives power
	Send !^+e ;pole power
}   ;==>powerAttack

knockback()
{
	Send 3
	Send !+q ;sword knockback
	Send !+e ;knives knockback
	Send !^+d ;pole knockback
}   ;==>knockback

disableParry()
{
	Send 4
	Send !^+l
}   ;==>disableParry

sword_board()
{
	Send N
	Sleep, 500
	Send O
	TrayTip, DF Scripts, Sword/Board Ready!, 3, 1
}  ;==>sword_board

/*
;Pot functions
Func pot1()
	HotKeySet("6")
	Send("6")
	HotKeySet("6", "pot1")
	If $Potted == False Then
		TrayTip("DF Scripts", "Drinking Pot!", 5, 2)
		;_GUICtrlStatusBar_SetText($StatusBar, "Drinking Pot")
		SoundPlay("audio/drinkingpot.wma", 0)
		$Potted = True
		startPotTimer()
	EndIf
EndFunc   ;==>pot1

Func pot2()
	HotKeySet("7")
	Send("7")
	HotKeySet("7", "pot2")
	If $Potted == False Then
		TrayTip("DF Scripts", "Drinking Pot!", 5, 2)
		;_GUICtrlStatusBar_SetText($StatusBar, "Drinking Pot")
		SoundPlay("audio/drinkingpot.wma", 0)
		$Potted = True
		startPotTimer()
	EndIf
EndFunc   ;==>pot2

Func pot3()
	HotKeySet("8")
	Send("8")
	HotKeySet("8", "pot3")
	If $Potted == False Then
		TrayTip("DF Scripts", "Drinking Pot!", 5, 2)
		;_GUICtrlStatusBar_SetText($StatusBar, "Drinking Pot")
		SoundPlay("audio/drinkingpot.wma", 0)
		$Potted = True
		startPotTimer()
	EndIf
EndFunc   ;==>pot3

Func startPotTimer()
	TrayTip("DF Scripts", "Waiting for Pot Timer...", 5, 2)
	;_GUICtrlStatusBar_SetText($StatusBar, "Waiting for Pot Timer")
	ProgressOn("Pot Timer", "", "0 percent", 0, 0)
	For $i = 2 To 100 Step 1.67
		Sleep(1000)
		ProgressSet(Ceiling($i), Ceiling($i) & "%")
		Call("RayReset")
	Next
	ProgressSet(100, "Done", "Complete")
	Sleep(500)
	ProgressOff()
	potReady()
EndFunc   ;==>startPotTimer


;announce pot is ready
Func potReady()
	If $Potted == True Then
		TrayTip("DF Scripts", "Pot Ready!", 5, 2)
		;_GUICtrlStatusBar_SetText($StatusBar, "Pot Ready!")
		SoundPlay("audio/potready.wma", 0)
	EndIf
	$Potted = False
	;_GUICtrlStatusBar_SetText($StatusBar, "Scripts On")
EndFunc   ;==>potReady

Func RayReset()
	if (TimerDiff($PMTime) > 16000) Then
		$PM = 0
	EndIf
	if (TimerDiff($IMTime) > 6000) Then
		$IM = 0
	EndIf
	if (TimerDiff($ISTime) > 13000) Then
		$IS = 0
	EndIf
	if (TimerDiff($DBTime) > 14000) Then
		$DB = 0
	EndIf
	if (TimerDiff($UCTime) > 14000) Then
		$UC = 0
	EndIf
	if (TimerDiff($FBTime) > 8000) Then
		$FB = 0
	EndIf
	if (TimerDiff($LBTime) > 8000) Then
		$LB = 0
	EndIf
	if (TimerDiff($RayCastTime) > 500) Then
		$RayCasted = 0
	EndIf
EndFunc   ;==>RayReset

Func RayCast()
	;Send("{LSHIFT DOWN}{NUMPAD2}{LSHIFT UP}")
	Sleep(100)
	If ($RayCasted = 0) Then
		If ($PM = 0) Then ;pungent mist
			Send("{RShift Down}7{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$PMTime = TimerInit()
			$PM = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($DB = 0) Then ;dragon breathe
			Send("{RShift Down}1{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$DBTime = TimerInit()
			$DB = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($IM = 0) Then ;impale
			Send("{RShift Down}3{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$IMTime = TimerInit()
			$IM = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($IS = 0) Then ;insect swarm
			Send("{RShift Down}4{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$ISTime = TimerInit()
			$IS = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($UC = 0) Then ;unholy caress
			Send("{RShift Down}2{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$UCTime = TimerInit()
			$UC = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($FB = 0) Then ;frostbite
			Send("{RShift Down}5{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$FBTime = TimerInit()
			$FB = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($LB = 0) Then ;lightning bolt
			Send("{RShift Down}6{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$LBTime = TimerInit()
			$LB = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
	EndIf
EndFunc   ;==>RayCast
*/

;end the script
terminate()
{
	SoundPlay, %A_WorkingDir%\audio\soft_whoosh10.wav, WAIT
	ExitApp
} ;==>terminate