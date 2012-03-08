#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=_assets\darkfall_icon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <resources.au3>

;-----------------------------------------
;Created by Nathan Mynarcik aka RedSeal
;-----------------------------------------
Global $Rev = '2.1'
Global $Width = @DesktopWidth

$destination = "images\splash.jpg"

SplashImageOn("Splash Screen", $destination, 600, 317, -1, -1, 1)
SoundPlay('audio/WATER.WAV', 0)
TrayTip("DF Scripts", "Welcome to DF Scripts 2.0", 5, 1)
TraySetToolTip("DF Scripts " & $Rev)
Sleep(3000)
SplashOff()

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#Region ### START Koda GUI section ### Form=
$DFScriptsConfig = GUICreate("DFScripts " & $Rev, 105, 170, $Width - 112, 50)
GUISetCursor(2)
GUISetBkColor(0xC0C0C0)
$SwordBoard = GUICtrlCreateCheckbox("Sword/Board", 8, 8, 89, 18)
GUICtrlSetState(-1, $GUI_CHECKED)
$Pots = GUICtrlCreateCheckbox("Pots", 8, 32, 57, 18)
GUICtrlSetState(-1, $GUI_CHECKED)
$Rays = GUICtrlCreateCheckbox("Rays", 8, 56, 57, 18)
GUICtrlSetState(-1, $GUI_CHECKED)
$Loot = GUICtrlCreateCheckbox("Loot", 8, 80, 57, 18)
GUICtrlSetState(-1, $GUI_CHECKED)
$ClickerBtn = GUICtrlCreateButton('Set Clicker', 8, 105, 57, 20)

GUICtrlSetCursor(-1, 0)
$StatusBar = _GUICtrlStatusBar_Create($DFScriptsConfig)
_GUICtrlStatusBar_SetSimple($StatusBar)
_GUICtrlStatusBar_SetText($StatusBar, "Scripts Running")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

WinSetOnTop("DFScripts " & $Rev, "", 1)

Global $Potted = False
Global $Paused = False
Global $UserPaused = False

Global $PotsChecked = True
Global $SBChecked = True
Global $LootChecked = True
Global $RaysChecked = True
Global $ClickerOn = False
Global $gotPoint = False
Global $clickPoint
Global $timeInt
Global $clickTimer = 0

Global $PM = 0, $IM = 0, $IS = 0, $UC = 0, $DB = 0, $FB = 0, $LB = 0
Global $PMTime, $IMTime, $ISTime, $UCTime, $DBTime, $FBTime, $LBTime
Global $RayCasted = 0, $RayCastTime

;Setup Binds to Keys
HotKeySet("{PAUSE}", "userPaused")
HotKeySet("6", "pot1")
HotKeySet("7", "pot2")
HotKeySet("8", "pot3")
HotKeySet("v", "sword_board")
HotKeySet("^l", "loot")
HotKeySet("1", "whirlwind")
HotKeySet("2", "powerAttack")
HotKeySet("3", "knockback")
HotKeySet("4", "disableParry")
HotKeySet("{NUMPAD4}", "RayCast")
;HotKeySet("^.", "silentRecall")

$dll = DllOpen("user32.dll")

_WinWaitActivate("Darkfall Online", "", 0)

;keeps script running constant
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			terminate()
		Case $Rays
			RaysToggle()

		Case $SwordBoard
			SwordBoardToggle()

		Case $Loot
			LootToggle()

		Case $Pots
			PotsToggle()

		Case $ClickerBtn
			toggleClicker()
	EndSwitch
	Call("RayReset")
	If Not WinActive("Darkfall Online", "") Then
		If ($Paused == False) Then togglePause()
	Else
		If($Paused == True And $UserPaused == False) Then togglePause()
	EndIf
WEnd

Func silentRecall()
	MouseClick("left")
	Sleep(10)
	Send("{c Down}")
	Sleep(40)
	Send("{c up}")
EndFunc

Func toggleClicker()
	If $ClickerOn == False Then
		GUICtrlSetData($ClickerBtn, 'Clicker Off')
		$ClickerOn = True
		MsgBox(1, 'Set Clicker', "Click 'OK' and then click where you want to set clicker", 15)
		While $gotPoint = False
			If _IsPressed(01, $dll) Then
				$gotPoint = True
				$clickPoint = MouseGetPos()
				$timeInt = InputBox("Time Interval", "How often do you want to click? (in secs)", '20')
				setUpClicker($clickPoint, $timeInt)
				ExitLoop
			EndIf
		WEnd
	Else
		GUICtrlSetData($ClickerBtn, 'Set Clicker')
		$ClickerOn = False
		$gotPoint = False
		$clickPoint = 0
		$timeInt = 0
	EndIf
EndFunc   ;==>toggleClicker

Func setUpClicker($point, $timer)
	togglePause()
	$clickTimer = TimerInit()
	_GUICtrlStatusBar_SetText($StatusBar, "Clicker Running")
	While $ClickerOn = True
		If (TimerDiff($clickTimer) > $timer * 1000) Then
			MouseClick('left', $point[0], $point[1])
			$clickTimer = 0
			$clickTimer = TimerInit()
		EndIf
		If _IsPressed(02, $dll) Then
			$ClickerOn = False
			$gotPoint = False
			$clickPoint = 0
			$timeInt = 0
			$clickTimer = 0
			GUICtrlSetData($ClickerBtn, 'Set Clicker')
			If $Paused == True Then
				_GUICtrlStatusBar_SetText($StatusBar, "PAUSED")
			Else
				_GUICtrlStatusBar_SetText($StatusBar, "Scripts Running")
			EndIf
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>setUpClicker

Func distraction($num)
	Switch $num
		Case 1
			Send("+{F1}")
		Case 2
			Send("+{F2}")
		Case 3
			Send("+{F3}")
		Case 4
			Send("+{F4}")
		Case 5
			Send("+{F5}")
		Case 6
			Send("+{F6}")
		Case 7
			Send("+{F7}")
		Case 8
			Send("+{F8}")
		Case 9
			Send("+{F9}")
		Case Else
			Send("+{F1}")
	EndSwitch
EndFunc   ;==>distraction

Func whirlwind()
	HotKeySet("1")
	Send("1")
	Send("+q") ;gsword ww
	Send("+d") ;disable shot
	Send("+e") ;knives ww
	Send("!^+q") ;swords ww
	HotKeySet("1", "whirlwind")
EndFunc   ;==>whirlwind

Func powerAttack()
	HotKeySet("2")
	Send("2")
	Send("^+q") ;gsword power
	Send("^+e") ;knives power
	Send("!^+e") ;swords power
	HotKeySet("2", "powerAttack")
EndFunc   ;==>powerAttack

Func knockback()
	HotKeySet("3")
	Send("3")
	Send("!+q") ;sword knockback
	Send("!+e") ;knives knockback
	Send("!^+d") ;swords knockback
	HotKeySet("3", "knockback")
EndFunc   ;==>knockback

Func disableParry()
	HotKeySet("4")
	Send("4")
	Send("!^+l")
	HotKeySet("4", "disableParry")
EndFunc   ;==>disableParry

Func loot()
	$pos = MouseGetPos()
	MouseClickDrag("left", $pos[0], $pos[1], 1425, 627, 0)
	MouseMove($pos[0], $pos[1], 0)
EndFunc   ;==>loot

Func sword_board()
	Send("N")
	Sleep(500)
	Send("O")
	TrayTip("DF Scripts", "Sword & Board Ready!", 5, 2)
	;_GUICtrlStatusBar_SetText($StatusBar, "S&B Ready!")
EndFunc   ;==>sword_board

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

Func LootToggle()
	If $LootChecked = False Then
		HotKeySet("^l", "loot")
		$LootChecked = True
	Else
		HotKeySet("^l")
		$LootChecked = False
	EndIf
EndFunc   ;==>LootToggle

Func RaysToggle()
	If $RaysChecked = False Then
		HotKeySet("{NUMPAD4}", "RayCast")
		$RaysChecked = True
	Else
		HotKeySet("{NUMPAD4}")
		$RaysChecked = False
	EndIf
EndFunc   ;==>RaysToggle

Func SwordBoardToggle()
	If $SBChecked = False Then
		HotKeySet("+v", "sword_board")
		$SBChecked = True
	Else
		HotKeySet("+v")
		$SBChecked = False
	EndIf
EndFunc   ;==>SwordBoardToggle

Func PotsToggle()
	If $PotsChecked = False Then
		HotKeySet("6", "pot1")
		HotKeySet("7", "pot2")
		HotKeySet("8", "pot3")
		$PotsChecked = True
	Else
		HotKeySet("6")
		HotKeySet("7")
		HotKeySet("8")
		$PotsChecked = False
		If WinExists("Pot Timer") Then
			ProgressOff()
		EndIf
	EndIf
EndFunc   ;==>PotsToggle

Func userPaused()
	$UserPaused = Not $UserPaused
	togglePause()
EndFunc

Func togglePause()
	$Paused = Not $Paused
	If $Paused Then
		_GUICtrlStatusBar_SetText($StatusBar, "PAUSED")
		HotKeySet("6")
		HotKeySet("7")
		HotKeySet("8")
		HotKeySet("v")
		HotKeySet("^l")
		HotKeySet("1")
		HotKeySet("2")
		HotKeySet("3")
		HotKeySet("4")
		HotKeySet("{NUMPAD4}")
		;HotKeySet("{PGDN}")
;~ 		$SprintChecked = False
		Sleep(100)
	Else
		_GUICtrlStatusBar_SetText($StatusBar, "Scripts Running")
		HotKeySet("6", "pot1")
		HotKeySet("7", "pot2")
		HotKeySet("8", "pot3")
		HotKeySet("v", "sword_board")
		HotKeySet("^l", "loot")
		HotKeySet("1", "whirlwind")
		HotKeySet("2", "powerAttack")
		HotKeySet("3", "knockback")
		HotKeySet("4", "disableParry")
		HotKeySet("{NUMPAD4}", "RayCast")
		;HotKeySet("{PGDN}", "silentRecall")
;~ 		$SprintChecked = True
	EndIf
EndFunc   ;==>togglePause

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

Func _WinWaitActivate($title, $text, $timeout = 0)
	If Not WinExists($title) Then
		MsgBox(0, $title & " Not Found", "Please start up " & $title & " before trying to use this program.")
		Exit
	Else
		;WinWait($title,$text,$timeout)
		If Not WinActive($title, $text) Then WinActivate($title, $text)
		;WinWaitActive($title,$text,$timeout)
	EndIf
EndFunc   ;==>_WinWaitActivate

;end the script
Func terminate()
	_GUICtrlStatusBar_SetText($StatusBar, "Good-Bye!")
	SoundPlay('audio/soft_whoosh10.wav', 0)
	Sleep(300)
	Exit 0
EndFunc   ;==>terminate